# Copyright 2019 StarkWare Industries Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.starkware.co/open-source-license/
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions
# and limitations under the License.

load('common.sage')


class GMiMCParams(object):
    def __init__(self, field, r, c, num_rounds, t=None):
        self.field = field
        self.t = t
        self.r = r
        self.c = c
        self.m = r + c
        self.round_constants = [generate_round_constant('GMiMC_erf', field, i)
                                for i in xrange(num_rounds)]
        print("Round const: {}".format(self.round_constants))
        self.rk_generated = None

        self.output_size = c
        self.num_rounds = num_rounds
        assert self.output_size <= r


# Parameter sets.
#S45a = GMiMCParams(field=F91, r=2, c=1, num_rounds=121)
#S45b = GMiMCParams(field=F91, r=10, c=1, num_rounds=137)
#
#S80a = GMiMCParams(field=F81, r=2, c=2, num_rounds=111)
#S80b = GMiMCParams(field=F161, r=2, c=1, num_rounds=210)
#S80c = GMiMCParams(field=F161, r=10, c=1, num_rounds=226)
#
#S128a = GMiMCParams(field=F125, r=2, c=2, num_rounds=166)
#S128b = GMiMCParams(field=F253, r=2, c=1, num_rounds=326)
#S128c = GMiMCParams(field=F125, r=10, c=2, num_rounds=182)
#S128d = GMiMCParams(field=F61, r=8, c=4, num_rounds=101)
#S128e = GMiMCParams(field=F253, r=10, c=1, num_rounds=342)
#
#S256a = GMiMCParams(field=F125, r=4, c=4, num_rounds=174)
#S256b = GMiMCParams(field=F125, r=10, c=4, num_rounds=186)

# PQ GMiMC_erf
#PQ_S256_p5_t86_r261 = GMiMCParams(field=F5, r=0, c=0, t=86, num_rounds=263)

def erf_feistel_permutation(x, params):
    for c_i in params.round_constants:
        mask = (x[0] + c_i) ** 3
        x = [x_j + mask for x_j in x[1:]] + [x[0]]
    return vector(params.field, x)

def erf_feistel_permutation_range(x, params, start=0, end=9):
    rc = params.round_constants
    for r in range(start, end + 1):
        c_i = rc[r]
        mask = (x[0] + c_i) ** 3
        x = [x_j + mask for x_j in x[1:]] + [x[0]]
    return vector(params.field, x)

def erf_feistel_permutation_encrypt(
    x, params, start=1, end=10, dbug=True):
    rc = params.round_constants
    print("RC: {}".format(rc))
    for r in range(start, end + 1):
        print("\nRound: {}".format(r))
        p_i_x = vector(params.field, x)
        print("xin : {}".format(p_i_x))

        c_i = rc[r - 1]
        mask = (x[0] + c_i) ** 3
        print("cube: {}".format(mask))
        x = [x_j + mask for x_j in x[1:]] + [x[0]]

        p_o_x = vector(params.field, x)
        print("xout: {}".format(p_o_x))

    return vector(params.field, x)

def gmimc_erf_enc(
    x, params, start=1, end=10, rk=False):
    rc = params.round_constants
    # print("rc: {}".format(rc))
    for r in range(start, end + 1):
        p_i_x = vector(params.field, x)
        # print("r{}:".format(r))
        # print("p_i_x: {}".format(p_i_x))

        if rk:
            c_i = rc[r - 1] + rk[r - 1]
            # print("rc + rk: {}".format(c_i))
        else:
            c_i = rc[r - 1]
            # print("rc: {}".format(c_i))
        mask = (x[0] + c_i) ** 3
        # print("mask: {}".format(mask))
        # print("-2 * mask: {}".format(-2 * mask))
        x = [x_j + mask for x_j in x[1:]] + [x[0]]

        p_o_x = vector(params.field, x)
        # print("p_o_x: {}".format(p_o_x))

    return vector(params.field, x)

def gmimc_erf_enc_collect(
    x, params, start=1, end=10, rk=False):
    rc = params.round_constants
    # print("rc: {}".format(rc))
    p_i_collect = []
    rk_collect = []
    mask_collect = []
    for r in range(start, end + 1):
        p_i_x = vector(params.field, x)
        p_i_collect.append(p_i_x)
        # print("r{}:".format(r))
        # print("p_i_x: {}".format(p_i_x))

        if rk:
            c_i = rc[r - 1] + rk[r - 1]
            rk_collect.append(rk[r - 1])
            # print("rc + rk: {}".format(c_i))
        else:
            c_i = rc[r - 1]
            # print("rc: {}".format(c_i))
        mask = (x[0] + c_i) ** 3
        mask_collect.append(mask)
        # print("mask: {}".format(mask))
        # print("-2 * mask: {}".format(-2 * mask))
        x = [x_j + mask for x_j in x[1:]] + [x[0]]

        p_o_x = vector(params.field, x)
        # print("p_o_x: {}".format(p_o_x))

    return vector(params.field, x), p_i_collect, rk_collect, mask_collect

def key_schedule(params, rk, M=False):
    t = params.t
    if not M:
        M = identity_matrix(params.field, t, t)
    else:
        M = matrix(params.field, M)
    # print("M, rank: {}, mul_order: {}".format(
    #     M.rank(), M.multiplicative_order()))

    rk_field = vector(params.field, rk)
    # print("rk_field", rk_field)
    if len(rk_field) == 1:
        rk_generated = vector(params.field, rk * params.num_rounds)
    elif len(rk) == t:
        M_times = ceil(params.num_rounds/t)
        temp = rk_field.list()
        for i in range(M_times):
            rk_field = M * rk_field
            temp += rk_field.list()
        rk_generated = vector(params.field, temp)[:params.num_rounds]
    params.rk_generated = rk_generated

    return rk_generated

def GMiMC_erf(inputs, params):
    return sponge(erf_feistel_permutation, inputs, params)


# Example for checking a collision between the inputs [1, 2] and [3, 4]:
# check_collision(
#     hash_func=GMiMC_erf,
#     params=S45a,
#     input1=vector(S45a.field, [1, 2]),
#     input2=vector(S45a.field, [3, 4]))

load('common.sage')


class GMiMC_crf_Params(object):
    def __init__(self, field, r, c, num_rounds, t=None):
        self.field = field
        self.t = t
        self.r = r
        self.c = c
        self.m = r + c
        self.round_constants = [generate_round_constant('GMiMC_crf', field, i)
                                for i in xrange(num_rounds)]
        print("Round const: {}".format(self.round_constants))
        self.rk_generated = None

        self.output_size = c
        self.num_rounds = num_rounds
        assert self.output_size <= r


def crf_feistel_permutation(x, params):
    for c_i in params.round_constants:
        T = 0
        for x_j in x[1:]:
            T += x_j
        mask = (T + c_i) ** 3
        x = list(x[1:]) + [x[0] + mask]
    return vector(params.field, x)

def crf_feistel_permutation_range(x, params, start=0, end=9):
    rc = params.round_constants
    for r in range(start, end + 1):
        c_i = rc[r]
        T = 0
        for x_j in x[1:]:
            T += x_j
        mask = (T + c_i) ** 3
        x = list(x[1:]) + [x[0] + mask]
    return vector(params.field, x)

def crf_feistel_permutation_encrypt(
    x, params, start=1, end=10, dbug=True):
    rc = params.round_constants
    print("RC: {}".format(rc))
    for r in range(start, end + 1):
        print("\nRound: {}".format(r))
        p_i_x = vector(params.field, x)
        print("xin : {}".format(p_i_x))

        c_i = rc[r - 1]
        T = 0
        for x_j in x[1:]:
            T += x_j
        mask = (T + c_i) ** 3
        x = list(x[1:]) + [x[0] + mask]

        print("cube: {}".format(mask))

        p_o_x = vector(params.field, x)
        print("xout: {}".format(p_o_x))

    return vector(params.field, x)

def gmimc_crf_enc(
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
        T = 0
        for x_j in x[1:]:
            T += x_j
        mask = (T + c_i) ** 3
        x = list(x[1:]) + [x[0] + mask]

        # print("mask: {}".format(mask))
        # print("-2 * mask: {}".format(-2 * mask))

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
        T = 0
        for x_j in x[1:]:
            T += x_j
        mask = (T + c_i) ** 3
        x = list(x[1:]) + [x[0] + mask]

        mask_collect.append(mask)
        # print("mask: {}".format(mask))
        # print("-2 * mask: {}".format(-2 * mask))

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

def GMiMC_crf(inputs, params):
    return sponge(crf_feistel_permutation, inputs, params)


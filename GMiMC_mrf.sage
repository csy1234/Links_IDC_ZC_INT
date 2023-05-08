load('common.sage')


class GMiMC_mrf_Params(object):
    def __init__(self, field, r, c, num_rounds, t=None):
        self.field = field
        self.t = t
        assert(t % 2 == 0)
        self.half_t = t // 2
        self.r = r
        self.c = c
        self.m = r + c
        self.round_constants = [generate_round_constant('GMiMC_mrf', field, i)
                                for i in xrange(num_rounds * self.half_t)]
        print("Round const: {}".format(self.round_constants))
        self.rk_generated = None

        self.output_size = c
        self.num_rounds = num_rounds

        self.lambda_t = ceil(RDF(log(self.half_t, 2)))
        self.rs = [2**(i) for i in range(0, self.lambda_t)]
        self.RS = [0 if i % 2 == 0 else self.rs[(i - 1)//2]
                for i in range(0, 2 * self.lambda_t)] * 10
        print("lambda_t: {}, RS: {}".format(
            self.lambda_t, self.RS))

        assert self.output_size <= r

def gmimc_mrf_enc(
    x, params, start=1, end=10, rk=False):
    rc = params.round_constants
    # print("rc: {}".format(rc))
    for r in range(start, end + 1):
        p_i_x = vector(params.field, x)
        # print("r{}:".format(r))
        # print("p_i_x: {}".format(p_i_x))

        for i in range(params.half_t):
            if rk:
                c_i = rc[(r - 1) * params.half_t + i] + rk[r - 1]
                # print("rc + rk: {}".format(c_i))
            else:
                c_i = rc[(r - 1) * params.half_t + i]
                # print("rc: {}".format(c_i))

            mask = (x[i] + c_i) ** 3
            # print("mask: {}".format(mask))
            # print("-2 * mask: {}".format(-2 * mask))
            x[((i - params.RS[r-1] + params.half_t) % params.half_t) + params.half_t] += mask
        x = list(x[params.half_t:]) + list(x[:params.half_t])


        p_o_x = vector(params.field, x)
        # print("p_o_x: {}".format(p_o_x))

    return vector(params.field, x)

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

def gmimc_mrf(inputs, params):
    return sponge(mrf_feistel_permutation, inputs, params)


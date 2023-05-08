load('GMiMC_crf.sage')

import sys
import random

def toy_gmimc_crf_t4_zc2int_9r():
    """
    This INT is from IDC of crf
    (A, ..., A, C) -> (B, 0, ..., 0) with (3t - 3) rounds
    instantiations with t = 4, p = 11
    """

    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_crf_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R)
    r0 = 1
    r1 = R + r0 - 1
    counter = 0
    random.seed()
    rk = vector(FF, [random.randint(0, FF.characteristic())] * R)
    print(rk)

    sum_dict = {}
    sum = 0
    for x0 in FF:
        for x1 in FF:
            for x2 in FF:
                x3 = 1
                x = vector(FF, [x0, x1, x2, x3])
                y = gmimc_crf_enc(x, toy, r0, r1, rk)

                tmp = y[0]
                sum += tmp
                if tmp not in sum_dict:
                    sum_dict[tmp] = 1
                else:
                    sum_dict[tmp] += 1
                counter += 1

    print(counter)
    for i in sum_dict:
        print i, sum_dict[i]
    print("sum: {}".format(sum))
    print("toy_gmimc_crf_t4_zc2int_9r\n")

    return

def toy_gmimc_crf_t4_zc_9r():
    """
    A ZC of crf
    (0, ..., 0, a_1) -> (b_1, 0, ..., 0)
    with (3t -3) rounds
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_crf_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R)
    r0 = 1
    r1 = R + r0 - 1
    counter = 0
    random.seed()
    rk = vector(FF,
        [random.randint(0, FF.characteristic())
            for _ in range(R)])
    print(rk)

    sum_dict = {}
    sum = 0
    for x0 in FF:
        for x1 in FF:
            for x2 in FF:
                for x3 in FF:
                    x = vector(FF,
                    [x0, x1, x2, x3])
                    y = gmimc_crf_enc(
                        x, toy, r0, r1, rk)

                    tmp = y[0] - 2 * x3
                    sum += tmp
                    if tmp not in sum_dict:
                        sum_dict[tmp] = 1
                    else:
                        sum_dict[tmp] += 1
                    counter += 1

    print(counter)
    for i in sum_dict:
        print i, sum_dict[i]
    print("sum: {}".format(sum))
    print("toy_gmimc_crf_t4_zc_9r\n")

    return

def toy_gmimc_crf_t4_zc_11r():
    """
    A ZC of crf
    (0, ..., 0, a_1) -> (b_1, 0, ..., 0)
    with (3t - 1) rounds and a_1 = b_1
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 11
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_crf_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R)
    r0 = 1
    r1 = R + r0 - 1
    counter = 0
    random.seed()
    rk = vector(FF,
        [random.randint(0, FF.characteristic())
            for _ in range(R)])
    print(rk)

    sum_dict = {}
    sum = 0
    for x0 in FF:
        for x1 in FF:
            for x2 in FF:
                for x3 in FF:
                    x = vector(FF,
                    [x0, x1, x2, x3])
                    y = gmimc_crf_enc(
                        x, toy, r0, r1, rk)

                    tmp = 2 * y[0] - 2 * x3
                    sum += tmp
                    if tmp not in sum_dict:
                        sum_dict[tmp] = 1
                    else:
                        sum_dict[tmp] += 1
                    counter += 1

    print(counter)
    for i in sum_dict:
        print i, sum_dict[i]
    print("sum: {}".format(sum))
    print("toy_gmimc_crf_t4_zc_11r\n")

    return

def toy_gmimc_crf_t6_p5_zc_anyrounds():
    FF = GF(5)
    R = 50
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_crf_Params(
        field=FF,
        r=5,
        c=1,
        num_rounds=R)
    r0 = 1
    r1 = R + r0 - 1
    counter = 0
    random.seed()
    rk = vector(FF,
        [random.randint(0, FF.characteristic())
            for _ in range(R)])
    print(rk)

    sum_dict = {}
    sum = 0
    for x0 in FF:
        for x1 in FF:
            for x2 in FF:
                for x3 in FF:
                    for x4 in FF:
                        for x5 in FF:
                            x = vector(FF,
                            [x0, x1, x2, x3, x4, x5])
                            y = gmimc_crf_enc(
                                x, toy, r0, r1, rk)

                            tmp = y[0] + x3

                            sum += tmp
                            if tmp not in sum_dict:
                                sum_dict[tmp] = 1
                            else:
                                sum_dict[tmp] += 1
                            counter += 1

    print(counter)
    for i in sum_dict:
        print i, sum_dict[i]
    print("sum: {}".format(sum))
    print("toy_gmimc_crf_t6_p5_zc_anyrounds\n")

    return

toy_gmimc_crf_t4_zc2int_9r()
toy_gmimc_crf_t4_zc_9r()
toy_gmimc_crf_t4_zc_11r()
toy_gmimc_crf_t6_p5_zc_anyrounds()

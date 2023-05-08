load('GMiMC_nyb.sage')

import sys
import random

def toy_gmimc_nyb_t4_zc2int_7r():
    """
    This INT is from IDC of nyb
    (C, A, ..., A) -> (U, B, U, ..., U) with (2t - 1) rounds
    instantiated with t = 4, p = 11
    """
    FF = GF(11)
    R = 7
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_nyb_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R,
        t = 4)
    r0 = 1
    r1 = R + r0 - 1
    counter = 0
    random.seed()
    rk = vector(FF, [random.randint(0, FF.characteristic())] * R)
    print(rk)

    sum_dict = {}
    sum = 0
    for x1 in FF:
        for x2 in FF:
            for x3 in FF:
                x0 = 1
                x = vector(FF, [x0, x1, x2, x3])
                y = gmimc_nyb_enc(x, toy, r0, r1, rk)

                tmp = y[1]
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
    print("toy_gmimc_nyb_t4_zc2int_7r\n")

    return

def toy_gmimc_nyb_t4_zc_7r():
    """
    This ZC is transformed from IDC of nyb
    (b_1, 0, ..., 0) -> (0, a_1, 0, ..., 0)
    with (2t - 1) rounds
    instantiated with t = 4, p = 11
    """
    FF = GF(11)
    R = 7
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_nyb_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R,
        t = 4)
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
                for x3 in FF:
                    x = vector(FF, [x0, x1, x2, x3])
                    y = gmimc_nyb_enc(x, toy, r0, r1, rk)

                    tmp = y[1] - 2 * x0
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
    print("toy_gmimc_nyb_t4_zc_7r\n")

    return

def toy_gmimc_nyb_t4_zc_6r():
    """
    This ZC is transformed from IDC of nyb
    (0, alpha, ..., 0) -> (beta, 0, ..., 0)
    with (2t - 2) rounds
    instantiated with t = 4, p = 11
    """
    FF = GF(11)
    R = 6
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_nyb_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R,
        t = 4)
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
                for x3 in FF:
                    x = vector(FF, [x0, x1, x2, x3])
                    y = gmimc_nyb_enc(x, toy, r0, r1, rk)

                    tmp = y[-1] - 2 * x0
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
    print("toy_gmimc_nyb_t4_zc_6r\n")

    return

def toy_gmimc_nyb_t4_zc_9r():
    """
    This ZC is transformed from IDC of nyb
    (0, 0, b_1, ..., 0) -> (0, a_1, 0, ..., 0)
    with (2t + 1) rounds and a_1 = b_1
    instantiated with t = 4, p = 11
    """
    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMC_nyb_Params(
        field=FF,
        r=3,
        c=1,
        num_rounds=R,
        t = 4)
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
                for x3 in FF:
                    x = vector(FF, [x0, x1, x2, x3])
                    y = gmimc_nyb_enc(x, toy, r0, r1, rk)

                    tmp = y[1] - x2
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
    print("toy_gmimc_nyb_t4_zc_9r\n")

    return

# toy_gmimc_nyb_t4_zc2int_7r()
# toy_gmimc_nyb_t4_zc_7r()
# toy_gmimc_nyb_t4_zc_9r()
toy_gmimc_nyb_t4_zc_6r()

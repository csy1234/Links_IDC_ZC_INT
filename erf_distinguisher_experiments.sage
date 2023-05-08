load('GMiMC_erf.sage')

import sys
import random

def toy_gmimc_erf_t4_zc2int_9r():
    """
    This INT from ZC of erf
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
            for x3 in FF:
                x2 = 2 * x3 - x0 - x1
                x = vector(FF,
                [x0, x1, x2, x3])
                y = gmimc_erf_enc(
                    x, toy, r0, r1, rk)

                tmp = \
                1 * (-2 * y[0] + y[1] + y[2] + y[3])
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
    print("toy_gmimc_erf_t4_zc2int_9r\n")

    return

def toy_gmimc_erf_t4_zc_9r():
    """
    A ZC of erf
    (a_1, ..., a_1, (2-t)a_1) -> ((2-t)b_1, b_1, ..., b_1)
    with (3t -3) rounds
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
                    y = gmimc_erf_enc(
                        x, toy, r0, r1, rk)

                    tmp = \
                    2*(-2 * y[0] + y[1] + y[2] + y[3]) \
                    - (x[0] + x[1] + x[2] - 2 * x[3])
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
    print("toy_gmimc_erf_t4_zc_9r\n")

    return

def toy_gmimc_erf_t4_zc_11r():
    """
    A ZC of erf
    (a_1, ..., a_1, (2-t)a_1) -> ((2-t)b_1, b_1, ..., b_1)
    with (3t - 1) rounds with a_1 = b_1
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 11
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
                    y = gmimc_erf_enc(
                        x, toy, r0, r1, rk)

                    tmp = \
                    (-2 * y[0] + y[1] + y[2] + y[3]) \
                    - (x[0] + x[1] + x[2] - 2 * x[3])
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
    print("toy_gmimc_erf_t4_zc_11r\n")

    return

def toy_gmimc_erf_t4_zc_8r():
    """
    A ZC of erf, from IDC of design paper
    (0, ..., 0, a_1, -a_1) -> (0, *, ..., *)
    with (3t - 4) rounds
    instantiated with t = 4, p = 11
    """

    FF = GF(11)
    R = 9
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
                    y = gmimc_erf_enc(
                        x, toy, r0, r1, rk)

                    tmp = \
                    (x[2] - x[3]) \
                    - (0 * y[0] + 3 * y[1] + 4 * y[2] + 5 * y[3])
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
    print("toy_gmimc_erf_t4_zc_8r\n")

    return

def toy_gmimc_erf_t6_p5_lc_anyrounds():
    FF = GF(5)
    R = 50
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
                            y = gmimc_erf_enc(
                                x, toy, r0, r1, rk)

                            tmp = \
                            1*(y[0]+y[1]+y[2]+y[3]+y[4]+y[5]) - \
                            1*(x0 + x1 + x2 + x3 + x4 + x5)

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
    print("toy_gmimc_erf_t6_p5_lc_anyrounds\n")

    return

def toy_gmimc_erf_t6_Fq5_zc2int_anyrounds():
    FF = GF(5)
    R = 50
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
                        x5 = - (x0 + x1 + x2 + x3 + x4)
                        x = vector(FF,
                        [x0, x1, x2, x3, x4, x5])
                        y = gmimc_erf_enc(
                            x, toy, r0, r1, rk)

                        tmp = \
                        y[0]
                        #(y[0] + y[1] + y[2] + y[3] + y[4] + 1 * y[5])

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
    print("toy_gmimc_erf_t6_Fq5_zc2int_anyrounds\n")

    return

def toy_gmimc_erf_t6_Fq5_zc2int_inverse_anyrounds():
    FF = GF(5)
    R = 50
    print("Round {} with GF{}".format(
        R, FF.characteristic()))
    toy = GMiMCParams(
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
    for x1 in FF:
        x0, x2, x3, x4, x5 = (0, 1, 2, 3, 4)
        x = vector(FF,
        [x0, x1, x2, x3, x4, x5])
        y = gmimc_erf_enc(
            x, toy, r0, r1, rk)

        tmp = \
        (y[0] + y[1] + y[2] + y[3] + y[4] + y[5])

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
    print("toy_gmimc_erf_t6_Fq5_zc2int_inverse_anyrounds\n")

    return

toy_gmimc_erf_t4_zc2int_9r()
# toy_gmimc_erf_t6_Fq5_zc2int_anyrounds()
# toy_gmimc_erf_t6_Fq5_zc2int_inverse_anyrounds()
# toy_gmimc_erf_t4_zc_9r()
# toy_gmimc_erf_t4_zc_11r()
# toy_gmimc_erf_t6_p5_lc_anyrounds()
# toy_gmimc_erf_t4_zc_8r()

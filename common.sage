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

# Prime fields.
F3  = GF(3)
F5  = GF(5)
F11 = GF(11)
F17 = GF(17)
F61 = GF(2**61 + 20 * 2**32 + 1)
F81 = GF(2**81 + 80 * 2**64 + 1)
F91 = GF(2**91 + 5 * 2**64 + 1)
F125 = GF(2**125 + 266 * 2**64 + 1)
F161 = GF(2**161 + 23 * 2**128 + 1)
F253 = GF(2**253 + 2**199 + 1)

# Binary fields.
X = GF(2)['X'].gen()
Bin3 = GF(2**3, name='a', modulus=X**3 + X + 1)
Bin5 = GF(2**5)
Bin63 = GF(2**63, name='a', modulus=X**63 + X + 1)
Bin81 = GF(2**81, name='a', modulus=X**81 + X**4 + 1)
Bin91 = GF(2**91, name='a', modulus=X**91 + X**8 + X**5 + X + 1)
Bin127 = GF(2**127, name='a', modulus=X**127 + X + 1)
Bin161 = GF(2**161, name='a', modulus=X**161 + X**18 + 1)
Bin255 = GF(2**255, name='a', modulus=X**255 + X**5 + X**3 + X**2 + 1)


def check_collision(hash_func, params, input1, input2):
    hash1 = hash_func(input1, params)
    hash2 = hash_func(input2, params)
    if params.field.characteristic() == 2:
        print 'hash1:', [bin(h.integer_representation()) for h in hash1]
        print 'hash2:', [bin(h.integer_representation()) for h in hash2]
    else:
        print 'hash1:', hash1
        print 'hash2:', hash2

    # Input length must be the same and the two inputs must be different for a
    # valid collision.
    print 'Preconditions?', input1 != input2 and len(input1) == len(input2)
    print 'Collision?', hash1 == hash2


def sponge(permutation_func, inputs, params):
    """
    Applies the sponge construction to permutation_func.
    inputs should be a vector of field elements whose size is divisible by
    params.r.
    permutation_func should be a function which gets (state, params) where state
    is a vector of params.m field elements, and returns a vector of params.m
    field elements.
    """
    assert parent(inputs) == VectorSpace(params.field, len(inputs)), \
        'inputs must be a vector of field elements. Found: %r' % parent(inputs)

    assert len(inputs) % params.r == 0, \
        'Number of field elements must be divisible by %s. Found: %s' % (
            params.r, len(inputs))

    state = vector([params.field(0)] * params.m)

    for i in xrange(0, len(inputs), params.r):
        state[:params.r] += inputs[i:i+params.r]
        state = permutation_func(state, params)

    # We do not support more than r output elements, since this requires
    # additional invocations of permutation_func.
    assert params.output_size <= params.r
    return state[:params.output_size]


def generate_round_constant(fn_name, field, idx):
    """
    Returns a field element based on the result of sha256.
    The input to sha256 is the concatenation of the name of the hash function
    and an index.
    For example, the first element for MiMC will be computed using the value
    of sha256('MiMC0').
    """
    from hashlib import sha256
    val = int(sha256('%s%d' % (fn_name, idx)).hexdigest(), 16)
    if field.is_prime_field():
        return field(val)
    else:
        return int2field(field, val % field.order())


def int2field(field, val):
    """
    Converts val to an element of a binary field according to the binary
    representation of val.
    For example, 11=0b1011 is converted to 1*a^3 + 0*a^2 + 1*a + 1.
    """
    assert field.characteristic() == 2
    assert 0 <= val < field.order(), \
        'Value %d out of range. Expected 0 <= val < %d.' % (val, field.order())
    res = field(map(int, bin(val)[2:][::-1]))
    assert res.integer_representation() == val
    return res


def binary_vector(field, values):
    """
    Converts a list of integers to field elements using int2field.
    """
    return vector(field, [int2field(field, val) for val in values])

def random_vector(field, t):
    return vector(field, [field.random_element() for _ in range(t)])

def binary_matrix(field, values):
    """
    Converts a list of lists of integers to field elements using int2field.
    """
    return matrix(field, [[int2field(field, val) for val in row]
                          for row in values])


def generate_mds_matrix(name, field, m):
    """
    Generates an MDS matrix of size m x m over the given field, with no
    eigenvalues in the field.
    Given two disjoint sets of size m: {x_1, ..., x_m}, {y_1, ..., y_m} we set
    A_{ij} = 1 / (x_i - y_j).
    """

    for attempt in xrange(100):
        x_values = [generate_round_constant(name + 'x', field, attempt * m + i)
                    for i in xrange(m)]
        y_values = [generate_round_constant(name + 'y', field, attempt * m + i)
                    for i in xrange(m)]
        # Make sure the values are distinct.
        assert len(set(x_values + y_values)) == 2 * m, \
            'The values of x_values and y_values are not distinct'
        mds = matrix([[1 / (x_values[i] - y_values[j]) for j in xrange(m)]
                      for i in xrange(m)])

        # Sanity check: check the determinant of the matrix.
        x_prod = product(
            [x_values[i] - x_values[j] for i in xrange(m) for j in xrange(i)])
        y_prod = product(
            [y_values[i] - y_values[j] for i in xrange(m) for j in xrange(i)])
        xy_prod = product(
            [x_values[i] - y_values[j] for i in xrange(m) for j in xrange(m)])
        expected_det = (1 if m % 4 < 2 else -1) * x_prod * y_prod / xy_prod
        det = mds.determinant()
        assert det != 0
        assert det == expected_det, \
            'Expected determinant %s. Found %s' % (expected_det, det)

        if len(mds.characteristic_polynomial().roots()) == 0:
            # There are no eigenvalues in the field.
            return mds
    raise Exception('No good MDS found')

#!/usr/bin/env python3

__author__ = 'Aiyanuj Wongkomet (aiyanuj@gmail.com)'
__version__ = '0.0.1'

import sys
import doctest

import control_flow


"""Checks for the small functions in control_flow.py."""

from control_flow import (
    even_or_odd,
    find_all_primes,
    is_prime,
    largest_divisor_five,
    count_above
)


# Normal cases: representative even and odd integers.
assert even_or_odd(10) == "10 is Even!"
assert even_or_odd(5) == "5 is Odd!"

# Edge cases: zero and a negative integer remain valid inputs.
assert even_or_odd(0) == "0 is Even!"
assert even_or_odd(-2) == "-2 is Even!"

# Failure case: the function accepts integers, not text.
try:
    even_or_odd("10")
except TypeError:
    pass
else:
    raise AssertionError("A non-integer input was accepted")



# The divisor function returns an integer or None, not display text.
assert largest_divisor_five(120) == "The largest divisor of 120 is 5"
assert largest_divisor_five(8) == "The largest divisor of 8 is 4"
assert largest_divisor_five(7) == "No divisor found for 7!"



# Normal case: some values are above the threshold.
assert count_above([8, 12, 10, 15], 10) == 2

# Boundary case: values immediately below, at and above the threshold.
assert count_above([9, 10, 11], 10) == 1

# Edge case: there are no observations to count.
assert count_above([], 10) == 0



def main(argv): 
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()   # To run with embedded tests
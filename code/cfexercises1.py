#!/usr/bin/env python3
# Author: Aiyanuj Wongkomet <aw2923@ic.ac.uk>
# Script: cfexercises1.py
# Desc: Examples of functions

def foo_1(x):
    return x ** 0.5

def foo_2(x, y):
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]

def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x): # a recursive function that calculates the factorial of x
    if x == 1:
        return 1
    if x == 0:
        return 1
    return x * foo_5(x - 1)
     
def foo_6(x): # Calculate the factorial of x in a different way; no if statement involved
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto



# only run the following example tests when this script is executed directly, not imported

if (__name__ == "__main__"):
    print(foo_1(7))
    print(foo_2(3,9))
    print(foo_3(17,5,10))
    print(foo_4(6))
    print(foo_5(6))
    print(foo_6(6))
    print(foo_4(0))
    print(foo_5(0))
    print(foo_6(0))
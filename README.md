# Floating-Point-Unit Adder and Subtractor
Designing a FPU (Floating Point Unit) which performs addition and subtraction of two 32-bit floating-point numbers for ASIC or FPGA implementations.
## 1. Overview
This project implements a floating-point adder and subtractor in RTL. The design supports basic floating-point addition and subtraction operations and includes special-case handling for overflow, underflow, zero, infinity, NaN, and sub-threshold results.

The main purpose of this design is to perform arithmetic operations on floating-point numbers while correctly detecting and handling exceptional conditions according to the supported floating-point format.



## 2. Operation
**Adding and Subtracting floating point numbers procedures:**
- **Extract and Unpack:** Separate the sign, exponent, and mantissa from both floating-point numbers.
- **Align exponents:** Find the number with the smaller exponent. Shift its mantissa to the right until its exponent matches the larger one. The shift amount determines how many bits are shifted to the right.
- **Add mantissas:** Add the two mantissas together. Remember, subtracting a number by a negative number is equivalent to addition.
- **Normalize the result:** If adding the mantissas results in a value that is not normalized (for instance, a carry-out or a number with a leading zero), adjust the exponent and shift the mantissa to normalize it. If the sum is too large or too small for the available bits, this is an overflow or underflow error.
- **Round the result:** Round the final result to fit the required precision, which can introduce inaccuracies.
<img width="1000" height="774" alt="image" src="https://github.com/user-attachments/assets/c71f5d96-2730-4a65-a20f-ba9af3e3ee65" />

# Functional Description
<img width="1000" height="826" alt="image" src="https://github.com/user-attachments/assets/174d8acd-11d7-465e-a3f0-e1a85ee63ae5" />

## Sign Computation Module
- At first, we have to change the sign of the second data input (second floating point), which means we need to change A-B to A+(-B) to make the computing proccess become much easier.
- To do that we can XOR the sign of the second floating point input and the add-sub selecting input. The output is the effective sign of the second floating point input.
- Then, we have to compare the sign of first floating point input and the effective sign of the second floating point input.
- If sign1st = eff_sign2nd, the output sign can be any of them.
- If sign1st != eff_sign2nd, the output sign if the sign of the floating point number that is bigger the other one (exponent, mantissa).


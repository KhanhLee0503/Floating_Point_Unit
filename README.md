# Floating-Point-Unit
Designing a FPU (Floating Point Unit) which performs addition and subtraction of two 32-bit floating-point numbers.
# Overview
## 1. Features
**Adding and Subtracting floating point numbers procedures:**
- **Extract and Unpack:** Separate the sign, exponent, and mantissa from both floating-point numbers.
- **Align exponents:** Find the number with the smaller exponent. Shift its mantissa to the right until its exponent matches the larger one. The shift amount determines how many bits are shifted to the right.
- **Add mantissas:** Add the two mantissas together. Remember, subtracting a number by a negative number is equivalent to addition.
- **Normalize the result:** If adding the mantissas results in a value that is not normalized (for instance, a carry-out or a number with a leading zero), adjust the exponent and shift the mantissa to normalize it. If the sum is too large or too small for the available bits, this is an overflow or underflow error.
- **Round the result:** Round the final result to fit the required precision, which can introduce inaccuracies.
<img width="1000" height="774" alt="image" src="https://github.com/user-attachments/assets/c71f5d96-2730-4a65-a20f-ba9af3e3ee65" />

## 2. Interface
<img width="1000" height="176" alt="image" src="https://github.com/user-attachments/assets/9fe00b43-6b61-45d2-b930-ebc087c143fe" />


# Functional Description
<img width="1000" height="826" alt="image" src="https://github.com/user-attachments/assets/174d8acd-11d7-465e-a3f0-e1a85ee63ae5" />
## Sign Computation Module
- At first, we have to change the sign of the second data input (second floating point), which means we need to change A-B to A+(-B) to make the computing proccess become much easier.
- To do that we can XOR the sign of the second floating point input and the add-sub selecting input. The output is the effective sign of the second floating point input.


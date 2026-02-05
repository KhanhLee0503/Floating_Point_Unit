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

## 2. Interface
<img width="1000" height="222" alt="image" src="https://github.com/user-attachments/assets/e66af3c6-9fe9-4fa8-bcb6-c69a46772949" />

# Functional Description
<img width="1000" height="385" alt="image" src="https://github.com/user-attachments/assets/a6fdc70d-fa8c-4eb8-ab58-1625ebac53eb" />
<img width="1000" height="964" alt="image" src="https://github.com/user-attachments/assets/694194e4-7725-4377-b45f-f560f7fee717" />

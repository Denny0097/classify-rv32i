# Assignment 2: Classify
```
             _   _   _   _            _____   __      __  ____    ___    _____ 
     /\     | \ | | | \ | |          |  __ \  \ \    / / |___ \  |__ \  |_   _|
    /  \    |  \| | |  \| |  ______  | |__) |  \ \  / /    __) |    ) |   | |       |\_/|
   / /\ \   | . ` | | . ` | |______| |  _  /    \ \/ /    |__ <    / /    | |       `o.o'
  / ____ \  | |\  | | |\  |          | | \ \     \  /     ___) |  / /_   _| |_      =(_)=
 /_/    \_\ |_| \_| |_| \_|          |_|  \_\     \/     |____/  |____| |_____|       U
```
## Advisor
Jserv (Ching-Chun Huang)

## Introduction
A simple Artificial Neural Net (ANN), which will be able to classify handwritten digits to their actual number

### Note
The RISC-V calling convention is crucial in this HW2, so I’ve spent most of my time learning and implementing it.

## Part A : Mathematical Functions
### Task 0: Multiply
1. Extract their signs first.
2. Then, sort them to reduce the number of additions needed.
3. Use addition to perform multiplication.
4. Finally, combine the sign with the value.

### Task 1: ReLU
$$ReLU(a) = max(a, 0)$$
1. Calculate the address of the current element.
2. Apply ReLU: set to 0 if the element is negative.
3. Repeat the loop until the entire array has been processed.

### Task 2: ArgMax
1. Calculate the address of the current element.
2. Check if the current element is greater than the maximum element.
3. If true, update the index to reflect the position of the largest element.
4. Repeat the loop until the entire array has been processed.

### Task 3.1: Dot Product
$$dot(a,b) = \Sigma_{i=0}^{n-1} (a_i,b_j)$$
1. Calculate offset for current element in first array.
2. Calculate offset for current element in second array.
3. Multiply the two values and add to result accumulator.

### Task 3.2: Matrix Multiplication
$$C[i][j]=dot(A[i],B[:,j])$$
1. inner_loop_end: Calculate the address of the next row.
2. outer_loop_end: Restore the stack.

## Part B : File Operations and Main
### Task 1: Read Matrix
1. Replace the ``mul`` instruction with the RV32I instructions.

### Task 2: Write Matrix
1. Replace the ``mul`` instruction with the RV32I instructions.

### Task 3: Classification
1. Matrix Multiplication:
**hidden_layer = matmul(m0,input)**
2. ReLU Activation:
**relu(hidden_layer)**
3. Second Matrix Multiplication:
**socres = matmul(m1,hidden_layer)**
4. Classification:
Call ``armax`` to find the index of the highest score.

```

## Reference
- [Assignment2: Complete Applications](https://hackmd.io/@sysprog/2024-arch-homework2)
- [CMU CS61C](https://cs61c.org/fa24/labs/lab03/)

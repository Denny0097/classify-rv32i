
.globl multiple
.text
multiple:
    # s9: return val
    li      s9, 0
mul_loop_start:
    ble     a1, x0, mul_loop_end
    add     s9, s9, a0
    addi    a1, a1, -1
    j       mul_loop_start
mul_loop_end:
    mv      a0, s9
    ret


    .text
    .globl my_mul
my_mul:
    # Arguments:
    # Return value in a0

    # Initialize result register
    li      t0, 0               # t0 will store the result (初始化結果為 0)
    li      t1, 0               # t1 is the bit position counter (初始位移量)

mul_loop:
    # Check if the least significant bit of a1 (multiplier) is 1
    andi    t2, a1, 1    # Extract the least significant bit of multiplier

    # If the bit is 1, add (multiplicand << t1) to the result
    beqz    t2, skip_add # If the bit is 0, skip addition
    sll     t3, a0, t1          # Shift multiplicand by t1 
    add     t0, t0, t3          # Add shifted multiplicand to result 

skip_add:
    # Shift multiplier right by 1 
    srli    a1, a1, 1
    addi    t1, t1, 1           # Increment the bit position counter 
    
    # Repeat for all bits 
    bnez    a1, mul_loop        # If a1 is not zero, repeat the loop

    # Store the result in a0 and return
    mv      a0, t0              # Move result to a0
    ret
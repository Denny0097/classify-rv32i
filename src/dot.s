.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    addi    sp, sp, -12
    sw      s8, 0(sp)
    sw      s9, 4(sp)
    li  t0, 0            
    li  t1, 0      
    mv  s8, a0
    mv  s9, a1  

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    # t1: i for iterator, t0: return val
    slli t4, a3, 2 # stride for v0 (bytes)
    slli t5, a4, 2 # stride for v1 (bytes)
    lw      t2, 0(s8)
    lw      t3, 0(s9)
    # mul     t6, t2, t3
    addi    sp, sp, -24
    sw      a0, 0(sp)
    sw      a1, 4(sp)
    sw      s9, 8(sp)
    sw      ra, 12(sp)
    sw      t0, 16(sp)
    sw      t1, 20(sp)
    
    mv      a0, t2
    mv      a1, t3
    jal     multiple
    mv      t6, a0
    lw      a0, 0(sp)
    lw      a1, 4(sp)
    lw      s9, 8(sp)
    lw      ra, 12(sp)
    lw      t0, 16(sp)
    lw      t1, 20(sp)
    addi    sp, sp, 24

    add     t0, t0, t6
    add     s8, s8, t4
    add     s9, s9, t5
    addi    t1, t1, 1
    j       loop_start
loop_end:
    mv      a0, t0
    lw      s8, 0(sp)
    lw      s9, 4(sp)
    addi    sp, sp, 12
    ret

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

# =======================================================
#multiply function
#Input 
#        a0: multiplicand
#        a1: multiplier
#Output 
#        a0: multiplication result
# =======================================================


multiple:
    # s9: return val
    li      s9, 0
    xor     t0, a0, a1      # t0 will have sign bit set if signs differ
    srai    t0, t0, 31      # Extract the sign bit to determine final sign
    mv      t1, a0
    mv      a0, a1
    addi    sp, sp, -8
    sw      ra, 0(sp)
    jal     abs
    mv      a1, a0
    mv      a0, t1
    jal     abs
    lw      ra, 0(sp)
    addi    sp, sp, 8
    bne     t0, x0, mul_loop_start_2

# positive
mul_loop_start:
    ble     a1, x0, mul_loop_end
    add     s9, s9, a0
    addi    a1, a1, -1
    j       mul_loop_start
mul_loop_end:
    mv      a0, s9
    ret
# negtive
mul_loop_start_2:
    ble     a1, x0, mul_loop_end_2
    add     s9, s9, a0
    addi    a1, a1, -1
    j       mul_loop_start_2
mul_loop_end_2:
    sub     s9, x0, s9
    mv      a0, s9
    ret
abs:
	bge	a0, x0, is_positive
	sub	a0, x0, a0
is_positive:
	ret




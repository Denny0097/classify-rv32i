.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Write a matrix of integers to a binary file
# FILE FORMAT:
#   - The first 8 bytes store two 4-byte integers representing the number of 
#     rows and columns, respectively.
#   - Each subsequent 4-byte segment represents a matrix element, stored in 
#     row-major order.
#
# Arguments:
#   a0 (char *) - Pointer to a string representing the filename.
#   a1 (int *)  - Pointer to the matrix's starting location in memory.
#   a2 (int)    - Number of rows in the matrix.
#   a3 (int)    - Number of columns in the matrix.
#
# Returns:
#   None
#
# Exceptions:
#   - Terminates with error code 27 on `fopen` error or end-of-file (EOF).
#   - Terminates with error code 28 on `fclose` error or EOF.
#   - Terminates with error code 30 on `fwrite` error or EOF.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # save arguments
    mv s1, a1        # s1 = matrix pointer
    mv s2, a2        # s2 = number of rows
    mv s3, a3        # s3 = number of columns

    li a1, 1

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file descriptor

    # Write number of rows and columns to file
    sw s2, 24(sp)    # number of rows
    sw s3, 28(sp)    # number of columns

    mv a0, s0
    addi a1, sp, 24  # buffer with rows and columns
    li a2, 2         # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    li t0, 2
    bne a0, t0, fwrite_error

    # mul s4, s2, s3   # s4 = total elements
    addi    sp, sp, -24
    sw      a0, 0(sp)
    sw      a1, 4(sp)
    sw      s9, 8(sp)
    sw      ra, 12(sp)
    sw      t0, 16(sp)
    sw      t1, 20(sp)
    
    mv      a0, s2
    mv      a1, s3
    jal     multiple
    mv      s4, a0
    lw      a0, 0(sp)
    lw      a1, 4(sp)
    lw      s9, 8(sp)
    lw      ra, 12(sp)
    lw      t0, 16(sp)
    lw      t1, 20(sp)
    addi    sp, sp, 24


    # write matrix data to file
    mv a0, s0
    mv a1, s1        # matrix data pointer
    mv a2, s4        # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    bne a0, s4, fwrite_error

    mv a0, s0

    jal fclose

    li t0, -1
    beq a0, t0, fclose_error

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 44

    jr ra

fopen_error:
    li a0, 27
    j error_exit

fwrite_error:
    li a0, 30
    j error_exit

fclose_error:
    li a0, 28
    j error_exit

error_exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 44
    j exit



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
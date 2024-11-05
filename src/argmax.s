.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
loop_start:
    # TODO: Add your own implementation
    lw      t3, 0(t0)       # use t3 for store vector[i] 
    ble     t3, t2  next_loop
changeMax:                  # change max value
    mv      t2, t3          
    mv      a0, t1          # a0 record max value's index
    
next_loop:
    addi    t0, t0, 4
    addi    t1, t1, 1
    blt     t1, a1, loop_start
    
handle_error:
    li a0, 36
    j exit

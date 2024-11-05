.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    # Check outer loop condition
    beq t1 s1 outer_loop_end

    # Set inner loop index
    li s4 0

inner_loop_start:
    # Check inner loop condition
    beq s4 s2 inner_loop_end

    # t0 = row index * len(row) + column index
    mul t0 s2 t1 
    add t0 t0 s4 
    slli t0 t0 2

    # Load matrix element
    add t0 t0 s0
    lw t6 0(t0)

    # relu
    bgt     t6, x0, notChange
    li      t6, 0
notChange:
    sw      t6, 0(t0)

    addi s4 s4 1
    j inner_loop_start

inner_loop_end:
 
    addi t1 t1 1
    j loop_start

outer_loop_end:
    # Epilogue

    ret
error:
    li a0, 36          
    j exit          

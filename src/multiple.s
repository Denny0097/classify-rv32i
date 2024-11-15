
.globl multiple
.text
multiple:
    # s9: return val
    li      s9, 0
    li      a0, -4
    li      a1, 3
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


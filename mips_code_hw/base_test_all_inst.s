.data

# Size = 14
arr1: .word 0x5, 0xA, 0xF, 0x5A, 0x5F, 0xAF, 0x5AA, 0x5AF, 0x5FA, 0x5FF, 0xAAF, 0xAFF, 0xFA5, 0xFFF

.text

addi $t0, $zero, 0xE	# $t0 = size = 14
addi $zero, $t0, 0xE	# Should not modify anything
addi $t1, $zero, 0x1	# $t1 = 0x1

add $t2, $t0, $t1		# $t2 = 0xF
subi $t3, $t2, 0xC

addiu $t3, $t2, 0x7FFF	# $t3 = 0x800E, no overflow
lui $t4, 0xFFFF			# $t4 = 0xFFFF0000

addu $t5, $t4, $t3		# $t5 = 0xE, no overflow (0xFFFF800E)

and $t6, $t4, $t2		# $t6 = 0x0
and $t6, $t4, $t3		# $t6 = 0x10000
andi $t7, $t4, 0xFFFF	# $t7 = 0x0

# la $t1, arr1			# $t1 = &arr1
lui $t1, 0x1001		# replaces la $t1, arr1	from previous line
lui $t8, 0xAA55			# $t8 = 0xAA550000

lw $t9, 0($t1)			# $t9 = arr1[0]
lw $t8, 4($t1)			# $t8 = arr1[1]
lw $t7, 8($t1)			# $t7 = arr1[2]

nor $t2, $t2, $t2		# $t2 = 0xFFFFFFF0
nor $t3, $t0, $t6		# $t3 = 0xFFFEFFF1

xor $a0, $t3, $t2		# $a0 = 0x10001
xori $a1, $t8, 0xAA55	# $a1 = 0xAA5F

or $a2, $t9, $t8		# $a2 = 0xF
ori $a3, $a2, 0x8FF0	# $a3 = 0x8FFF

addiu $v0, $v0, 0xF0	# reset $at
nop
nop

beq $ra, $v0, exit		# Only branch if jr has been called
nop

slt $s0, $a0, $a1		# $s0 = 0x0
slt $s1, $t4, $a1		# $s1 = 0x1
sltu $s2, $t4, $a1		# $s2 = 0x0
sltu $s3, $t3, $t2		# $s3 = 0x1

slti $s4, $a2, 0xE		# $s4 = 0x0
sltiu $s5, $a2, 0x7FFF	# $s5 = 0x1

sll $s6, $s5, 31		# $s6 = 0x80000000
srl $s7, $t3, 5			# $s7 = 0x07FFF7FF
sra $s7, $s7, 11		# $s7 = 0x0000FFFE
sll $s7, $s7, 16		# $s7 = 0xFFFE0000
sra $s7, $s7, 31 		# $s7 = 0xFFFFFFFF

sw $a3, ($t1)			# arr1[0] = 0x8FFF
sw $s7, 4($t1)			# arr1[1] = 0xFFFFFFFF
sw $s6, 8($t1)			# arr1[2] = 0x80000000

sub $sp, $s7, $a3		# $sp = 0xFFFF7000
subu $ra, $t3, $t2		# $ra = 0xFFFF0001

beq $t0, $s4, b_eq		# don't take branch
nop

addiu $v0, $zero, 0xE
nop
nop

beq $t0, $v0, b_eq		# take branch
nop

beq_done:
	bne $t0, $v0, b_ne	# don't take branch
	nop

	addiu $v1, $zero, 0xFE
	nop
	nop

	bne $t0, $v1, b_ne	# take branch
	nop

b_eq:
	addiu $at, $ra, 0
	j beq_done
	nop
	
b_ne: 
	addiu $ra, $zero, 0x100
	j done_branching
	nop
	
done_branching:
	lui $sp, 0x1001
	ori $sp, 0x1000
	jal jump_link
	nop
	
jump_link:
	addu $v0, $zero, $ra	# $at = $ra = 0x
	subi $v0, $v0, 0xF0		# set jump address
	nop
	nop
	
	jr $v0
	nop

exit:
	# Exit program
	halt
	nop
	nop
	
	li $v0, 10
	syscall

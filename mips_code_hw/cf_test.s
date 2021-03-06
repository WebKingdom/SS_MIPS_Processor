# Create and test an application which uses each of the required control-flow instructions and has a call depth of at least 5
# beq, bne, j, jal, jr, repl.qb
.data
msg: .asciiz "done"
.text

jal start

add $t2, $t1, $t1

bne $t1, $t2, compare

start:
	addi $t1, $0, 12
	jr $ra
	
compare: 
	sll $t1, $t1, 1
	
	beq $t1, $t2, checker	
	
checker:
	addi $v0, $0, 4
	la $a0, msg
	j done
	
done:
	halt

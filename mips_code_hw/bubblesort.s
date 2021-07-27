#Create and test an application that sorts an array with N elements using the BubbleSort algorithm.
.data
array: .word 2, 6, 3, 1, 55, 9, 4, 99, 7, -5
newline: .asciiz ", "
.text

#puesdocode:
#for i from 1 to N
#for j from 0 to N-1
#if a[j] > a[j+1]
#swap (a[j], a[j+1])

Main: 
	la    $a0, array	#array base address
	addi  $a1, $zero, 10 	#array size
	
	jal BubbleSort
	
	#exit program
	halt  #halt for testingframework
  
	li $v0, 10
	syscall

BubbleSort: #swap (a[j], a[j+1])
	addi $t0, $t0, 0 #int i
	addi $t1, $t1, 0 #int j
	addi $t2, $a1, 0 #size of array
	addi $t3, $t3, 0 #comparison variable
	addi $s1, $s1, 0 #array address
	addi $s0, $a0, 0 #load base address for the array passed from function

outerloop: #for i from 1 to N
	beq $t0, $t2 exit	#if int i == len(array)
	
	addi $t0 ,$t0, 1	#i++
	addi $t1, $zero, 0	#reset j to 0
	addi $s1, $s0,  0	#reset address to base address
	
	j innerloop

innerloop: #for j from 0 to N-1
	sub $t5, $t2, $t0	#n-i
	subi $t5, $t5, 1	#t5-1
	slt $t3, $t1, $t2
	
	beq $t3, $zero, outerloop 	# if( j < n-i-1) we break the loop
	
	lw $t6, 0($s1) 		#load first int	
	lw $t7, 4($s1) 		#load second int
	
	slt $t3, $t7, $t6 	# t3 = second < first
	
	#beq $t3, 1, swap
	addi $1, $0, 1
	
	beq $1, $11, swap
	
	#end loop increase j loop back
	addi $t1, $t1, 1	#j++
	addi $s1, $s1, 4	#base address +=4
	j innerloop

swap:
	addi $t5, $t6, 0  #temp = t6
	addi $t6, $t7, 0	#t6   = t7
	addi $t7, $t5, 0	#t7   = temp
	
	sw $t6, 0($s1)
	addi $t1, $t1, 1	#j++
	sw $t7, 4($s1)
	addi $s1, $s1, 4	#base address +=4
	j innerloop

exit:
	addi $t5, $zero, 0	#t5 will be used as i
	add $s1, $zero, $s0     #set current address to base address
	beq $t3, $zero, end #
	
	addi $t5, $t5, 1 #
	addi $s1, $s1, 4 #
	
	#j printArray
	
	#printArray:
	#s0 base
	#s1 address
	#t2 array size
	
	#commented out print just for testing
	#slt $t3, $t5, $t2	#if( t5 < t2)  go to end
	##beq $t3, 0, end		#otherwise load array[i] and print
	#print integer at array[i]
	#lw $t6, 0($s1)   	#load array[i]
	#li $v0, 1		#syscall to print int
	#addi $a0, $t6, 0	#load value into printer
	#syscall			#print value
	
	#print newline for organization
	#li $v0, 4		#syscall to print int
	#la $a0, newline		#load value into printer
	#syscall			#print value

	##addi $t5, $t5, 1
	##addi $s1, $s1, 4

	##j printArray
	
	##nop
end:
jr $ra

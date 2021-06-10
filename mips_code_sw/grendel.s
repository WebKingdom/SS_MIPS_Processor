#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
	# li $sp, 0x10011000
	lui $sp, 0x1001
	nop
	nop
	ori $sp, $sp, 0x1000
	
	# li $fp, 0
	addi $fp, $fp, 0
	
	# la $ra pump	# replaced by below
	lui $ra, 0x40
	nop
	nop
	ori $ra, $ra, 0x2C
	
	j main # jump to the starting location
	nop
	
pump:
	halt
	nop
	nop

main:
        addiu   $sp,$sp,-40 # MAIN
        nop
        nop
        
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add    	$fp,$sp,$zero
        nop
        nop
        
        sw      $0,24($fp)
        j       main_loop_control
        nop

main_loop_body:
        lw      $4,24($fp)
        # la 	$ra, trucks	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x80
        
        j     is_visited
        nop
        
        trucks:

        xori    $2,$2,0x1
        nop
        nop
        
        andi    $2,$2,0x00ff
        nop
        nop
        
        beq     $2,$0,kick
        nop

        lw      $4,24($fp)
        # addi 	$k0, $k0,1# breakpoint
        # la 	$ra, billowy	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0xBC
        
        j     	topsort
        nop
        billowy:

kick:
        lw      $2,24($fp)
        nop
        nop
        
        addiu   $2,$2,1
        nop
        nop
        
        sw      $2,24($fp)
        nop
        nop
        
main_loop_control:
        lw      $2,24($fp)
        nop
        nop
        
        sltiu    $2,$2, 4
        nop
        nop
        
        beq	$2, $zero, hew # beq, j to simulate bne
        nop
        
        j       main_loop_body
        nop
        
        hew:
        sw      $0,28($fp)
        j       welcome
        nop

wave:
        lw      $2,28($fp)
        nop
        nop
        
        addiu   $2,$2,1
        nop
        nop
        
        sw      $2,28($fp)
        nop
        nop
        
welcome:
        lw      $2,28($fp)
        nop
        nop
        
        slti    $2,$2,4
        nop
        nop
        
        xori	$2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop
        nop
        
        beq     $2,$0,wave
        nop

        move    $2,$0
        move    $sp,$fp
        nop
        nop
        
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $ra
        nop
        
interest:
        lw	$4,24($fp)
        # la	$ra, new	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x1A4
        
        j	is_visited
        nop
        
	new:
        xori    $2,$2,0x1
        nop
        nop
        
        andi    $2,$2,0x00ff
        nop
        nop
        
        beq     $2,$0,tasteful
        nop

        lw      $4,24($fp)
        # la	$ra, partner	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x1E0
        
        j     	topsort
        nop
        
        partner:

tasteful:
        addiu   $2,$fp,28
        nop
        nop
        
        move    $4,$2
        # la	$ra, badge	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x208
        
        j     next_edge
        nop
        
        badge:
        sw      $2,24($fp)
        nop
        nop
        
turkey:
        lw      $3,24($fp)
        li      $2,-1
        nop
        nop
        
        beq	$3,$2,telling # beq, j to simulate bne
        nop
        
        j	interest
        nop
        
        telling:
		# la 	$v0, res_idx	# replaced by below
		lui $v0, 0x1001
		nop
		nop
		ori $v0, $v0, 0x28
		nop
		nop
		
		lw	$v0, 0($v0)
		nop
		nop
        addiu   $4,$v0,-1
        # la 	$3, res_idx	# replaced by below
        lui $3, 0x1001
	nop
	nop
	ori $3, $3, 0x28
        nop
        nop
        
        sw 	$4, 0($3)
        # la	$4, res	# replaced by below
        lui $4, 0x1001
        
        #lui     $3,%hi(res_idx)
        #sw      $4,%lo(res_idx)($3)
        #lui     $4,%hi(res)
        sll $3,$2,2
        nop
        nop
        
        srl	$3,$3,1
        nop
        nop
        
        sra	$3,$3,1
        nop
        nop
        
        sll $3,$3,2
        nop
        
       	xor	$at, $ra, $2 # does nothing 
        nor	$at, $ra, $2 # does nothing 
        
        # la	$2, res	# replaced by below
        lui $2, 0x1001
        nop
        nop
        
        andi	$at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        nop
        nop
        
        addu 	$2, $4, $at
        nop
        nop
        
        addu    $2,$3,$2
        nop
        nop
        
        lw      $3,48($fp)
        nop
        nop
        
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop
        
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $ra
        nop
   
topsort:
        addiu   $sp,$sp,-48
        nop
        nop
        
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        nop
        nop
        
        sw      $4,48($fp)
        lw      $4,48($fp)
        # la	$ra, verse	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x350
        
        j	mark_visited
        nop
        
        verse:

        addiu   $2,$fp,28
        lw      $5,48($fp)
        
        nop
        move    $4,$2
        # la 	$ra, joyous	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x378
        
        j	iterate_edges
        nop
        
        joyous:

        addiu   $2,$fp,28
        # la	$ra, whispering	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x398
        
        move    $4,$2
        
        j     	next_edge
        nop
        
        whispering:

        sw      $2,24($fp)
        j       turkey
        nop

iterate_edges:
        addiu   $sp,$sp,-24
        nop
        nop
        
        sw      $fp,20($sp)
        move    $fp,$sp
        nop
        nop
        
        sw      $5,28($fp)
        sw      $4,24($fp)
        subu	$at, $fp, $sp
        lw      $2,28($fp)
        nop
        
        sw      $0,12($fp)
        sw      $2,8($fp)
        
        lw      $2,24($fp)
        lw      $3,12($fp)
        lw      $4,8($fp)
        nop
        
        sw      $3,4($2)
        sw      $4,0($2)
        
        lw      $2,24($fp)
        move    $sp,$fp
        nop
        nop
        
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr      $ra
        nop
        
next_edge:
        addiu   $sp,$sp,-32
        nop
        nop
        
        sw      $31,28($sp)
        sw      $fp,24($sp)
        add	$fp,$zero,$sp
        nop
        nop
        
        sw      $4,32($fp)
        j       waggish
        nop

snail:
        lw      $2,32($fp)
        lw      $2,32($fp)
        nop
        lw      $3,0($2)
        lw      $2,4($2)
        nop
        
        move    $4,$3
        move    $5,$2
        
        # la	$ra,induce	# replaced by below
        lui $ra, 0x0040
        nop
        nop
        ori $ra, $ra, 0x478
        
        j       has_edge
        nop
        
        induce:
        beq     $2,$0,quarter
        nop
        
        lw      $2,32($fp)
        nop
        nop
        
        lw      $2,4($2)
        nop
        nop
        
        addiu   $4,$2,1
        lw      $3,32($fp)
        nop
        nop
        
        sw      $4,4($3)
        j       cynical
        nop


quarter:
        lw      $2,32($fp)
        nop
        nop
        
        lw      $2,4($2)
        nop
        nop
        
        addiu   $3,$2,1
        lw      $2,32($fp)
        nop
        nop
        
        sw      $3,4($2)

waggish:
        lw      $2,32($fp)
        nop
        nop
        
        lw      $2,4($2)
        nop
        nop
        
        slti    $2,$2,4
        nop
        nop
        
        beq	$2,$zero,mark # beq, j to simulate bne
        nop
        
        j	snail
        nop
        
        mark:
        li      $2,-1

cynical:
        move    $sp,$fp
        nop
        nop
        
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        
has_edge:
        addiu   $sp,$sp,-32
        nop
        nop
        
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        
        sw      $4,32($fp)
        sw      $5,36($fp)
        # la      $2,adjacencymatrix	# replaced by below
        lui $2, 0x1001
        nop
        nop
        ori $2, $2, 0x14
        
        lw      $3,32($fp)
        nop
        nop
        
        sll     $3,$3,2
        nop
        nop
        
        addu    $2,$3,$2
        nop
        nop
        
        lw      $2,0($2)
        nop
        nop
        
        sw      $2,16($fp)
        li      $2,1
        nop
        nop
        
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       measley
        nop

look:
        lw      $2,8($fp)
        nop
        nop
        
        sll     $2,$2,1
        nop
        nop
        
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        
        addiu   $2,$2,1
        nop
        nop
        
        sw      $2,12($fp)
        
measley:
        lw      $3,12($fp)
        lw      $2,36($fp)
        nop
        nop
        
        slt     $2,$3,$2
        nop
        nop
        
        beq     $2,$0,experience # beq, j to simulate bne
        nop
        
        j 	look
        nop
        
       	experience:
        lw      $3,8($fp)
        lw      $2,16($fp)
        nop
        nop
        
        and     $2,$3,$2
        nop
        nop
        
        sltu    $2,$0,$2
        nop
        nop
        
        move    $sp,$fp
        andi    $2,$2,0x00ff
        nop
        
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        
mark_visited:
        addiu   $sp,$sp,-32
        nop
        nop
        
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        
        li      $2,1
        sw      $4,32($fp)
        nop
        
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       recast
        nop

example:
        lw      $2,8($fp)
        nop
        nop
        
        sll     $2,$2,8
        nop
        nop
        
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        
        addiu   $2,$2,1
        nop
        nop
        
        sw      $2,12($fp)
recast:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        
        slt     $2,$3,$2
        nop
        nop
        
        beq	$2,$zero,pat # beq, j to simulate bne
        nop
        
        j	example
        nop
        
        pat:
       	# la	$2, visited	# replaced by below
       	lui $2, 0x1001
       	nop
       	nop
       	ori $2, $2, 0x24
       	nop
       	nop
       	
        sw      $2,16($fp)
        nop
        nop
        
        lw      $2,16($fp)
        nop
        nop
        
        lw      $3,0($2)
        lw      $2,8($fp)
        nop
        nop
        
        or      $3,$3,$2
        lw      $2,16($fp)
        nop
        
        move    $sp,$fp
        sw      $3,0($2)
        nop
        
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        
is_visited:
        addiu   $sp,$sp,-32
        nop
        nop
        
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        
        ori     $2,$zero,1
        sw      $4,32($fp)
        nop
        
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       evasive
        nop

justify:
        lw      $2,8($fp)
        nop
        nop
        
        sll     $2,$2,8
        nop
        nop
        
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        
        addiu   $2,$2,1
        nop
        nop
        
        sw      $2,12($fp)
evasive:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        
        slt     $2,$3,$2
        nop
        nop
        
        beq	$2,$0,representitive # beq, j to simulate bne
        nop
        
        j     	justify
        nop
        
        representitive:

        # la	$2,visited	# replaced by below
        lui $2, 0x1001
        nop
        nop
        ori $2, $2, 0x24
        nop
        nop
        
        lw      $2,0($2)
        nop
        nop
        
        sw      $2,16($fp)
        lw      $3,16($fp)
        lw      $2,8($fp)
        nop
        nop
        
        and     $2,$3,$2
        nop
        nop
        
        sltu    $2,$0,$2
        move    $sp,$fp
        nop
        
        andi    $2,$2,0x00ff
        
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop


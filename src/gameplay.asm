.data
game_begin_message_string: .asciiz "Press OK to begin."
game_end_message_string: .asciiz "Game over! Your time: "
game_quit_message_string: .asciiz "You have quit the game. "

.text
.globl game_start_popup
.globl game_end_popup
.globl game_begin_message_string
.globl game_end_message_string
.globl game_board_array_populate


game_start_popup:
	addi $sp $sp -4		#adjust stack pointer
	sw $ra 0($sp)		#save register in stack pointer
	li $v0 55
	la $a0 game_begin_message_string
	la $a1 2
	syscall
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra #return
	
game_end_popup:
	li $v0 56
	la $a0 game_end_message_string
	jal find_current_time_ms
	add $a1 $0 $0 # -> this is where time in integer goes; implement time first
	syscall
	li $v0 10
	syscall ## GAME ENDS HERE
	
########################################################################################
	
game_board_array_populate:
	addi $sp $sp -36
	sw $ra 32($sp) 
	sw $s0 28($sp)
	sw $s1 24($sp)
	sw $s2 20($sp)
	sw $s3 16($sp)
	sw $s4 12($sp)
	sw $s5 8($sp)
	sw $s6 4($sp)
	sw $s7 0($sp)
	
	li $s0 0		#inc counter < 16
	la $s1 exprs
	la $s2 values
	la $s3 generated
	la $s4 randArray
	la $s5 match_matrix
	
random_select_loop:
	li $v0 42		# get rng 0 <= x < 16
	li $a0 0		
	li $a1 16		# max number range
	syscall			# call
	
	addi $t0 $a0 0		# $t0 holds random number
	sll $t1 $t0 2		# $t1 = random x 4
	add $t2 $t1 $s4		# random index of randarray
	lw $t3 0($t2) 		# see if used or not
	bne $t3 $0 random_select_loop	# draw again if used
	
	# else
	addi $t3 $0 1		# load imm value 1
	sw $t3 0($t2) 		# go mark used with bool value 1
	
	sll $t1 $t0 2		# rng x 4
	add $t2 $t1 $s1		# add this for random index of EXPRS
	lw $t1 0($t2)		# pull from random select expr
	
	sll $t4 $s0 2		# index x 4
	
	add $t6 $t4 $s3		# add to generated array
	sw $t1 0($t6) 		# place expression in generated	
	
	sll $t1 $t0 2        	# offset for values array 
	add $t5 $t1 $s2      	# address of values[$t0]
	lw $t3 0($t5)         	# load value from values array
	sw $t3 4($t6)         	# store the value to generated
	
	addi $s0 $s0 2
	beq $s0 16 shuffleRandArray
	j random_select_loop
	

shuffleRandArray:
	la $a0 generated
	la $a1 randArray
	la $a2 usedAR
	jal shuffle		# call function from prologue
	
	lw $ra 32($sp)		# save registers on the stack
	lw $s0 28($sp)
	lw $s1 24($sp)
	lw $s2 20($sp)
	lw $s3 16($sp)
	
	lw $s4 12($sp)
	lw $s5 8($sp)
	lw $s6 4($sp)
	lw $s7 0($sp)
	addi $sp $sp 36
	jr $ra
	
shuffle:
	addi $sp $sp -16
	sw $ra 12($sp)
	sw $s0 8($sp)
	sw $s1 4($sp)
	sw $s2 0($sp)
	
	addi $s0 $a0 0
	addi $s1 $a1 0
	addi $s2 $a2 0
	addi $t0 $0 0
	
shuffle_loop:
	beq $t0 16 return_from_gbap	# check for counter = 16
	lw $t1 0($s0)			# get the first 
	
	li $a1 16
	li $v0 42
	syscall
	
	sll $t2 $a0 2
	add $t3 $s2 $t2
	lw $t4 0($t3)
	
	bne $t4 0 shuffle_loop
	
	add $t2 $s1 $t2
	sw $t1 0($t2)
	addi $t2 $0 1
	sw $t2 0($t3)
	
	addi $s0 $s0 4
	addi $t0 $t0 1
	
	j shuffle_loop
	
return_from_gbap:
	lw $ra 12($sp)
	lw $s0 8($sp)
	lw $s1 4($sp)
	lw $s2 0($sp)
	addi $sp $sp 16
	jr $ra
	
########################################################################################
	

	
	

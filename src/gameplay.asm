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
	
game_board_array_populate:
	addi $sp $sp -4
	sw $ra 0($sp)
	
	
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
	

	
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
	
	li $s0 8		#inc counter < 8
	la $s1 exprs
	la $s2 values
	la $s3 generated
	la $s4 randArray
	
	
	
	# get rng 0 <= x < 16
	li $v0 42		
	li $a0 0		
	li $a1 16
	syscall
	
	li $t0 8
	
	# in generated[x] <- place from 
	# li $v0 1
	# syscall
	
	sll $t0 $a0 2 		#memory offset to choose 
	
	
return_from_gbap:
	lw $ra 32($sp)
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
	

	
	

.data
game_begin_message_string: .asciiz "Press OK to begin."
game_end_message_string: .asciiz "Game over! Your time: "
game_quit_message_string: .asciiz "You have quit the game. "
user_out_of_bound: .asciiz "\nINDEX OUT OF BOUNDS. Range is (0-15)\n"
user_error_same_index: .asciiz "\nINDEX WAS ALREADY INPUTTED. Please input two different indexes.\n"
user_error_index_match: .asciiz "\nINDEX IS ALREADY MATCHED. Please input two indexes that have yet to be matched.\n"

.text
.globl game_start_popup
.globl game_end_popup
.globl game_begin_message_string
.globl game_end_message_string
.globl game_board_array_populate
.globl game_start_function

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
	syscall
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
	
game_start_function:
	addi $sp $sp -24
	sw $ra 0($sp)
	sw $s0 4($sp) # first cards index
	sw $s1 8($sp) # second cards index
	sw $s2 12($sp) # first cards value
	sw $s3 16($sp) # second cards value
	sw $s4 20($sp) # size of display delay loop

	li $t4 0 # used for flipping cards
	li $t5 0 # used for flipping cards
	li $t6 0 # used for flipping cards
	li $t7 0 # used for flipping cards
	li $t9 0 # counts number of matches user makes
game_loop_one:
	li $s4 11500
	# user wins game
	beq $t9 8 game_win
	
	la $a0 board
	jal printBoard
	
	# read first index value
	jal read_user_input
	bgt $a0 15 user_invalid_input
	beq $a0 -1 user_invalid_input

	# save index for later use
	move $t5 $a0
	move $s0 $a0
	
	# check if user has already matched at inputted index
	jal check_prev_index
	
	# display flipped card
	move $t5 $s0
	jal clear_console
	jal flip_card
	la $a0 flippableBoard
	jal printBoard
	
	# get first card's value
	move $a0 $s0
	jal solveCard
	move $s2 $v0
	
game_loop_two:
	# read second index value
	jal read_user_input
	bgt $a0 15 user_invalid_input
	beq $a0 -1 user_invalid_input
	beq $a0 $s0 user_same_index
	
	# save index for later use
	move $t5 $a0
	move $s1 $a0
	
	# check if user has already matched at inputted index
	jal check_prev_index
	
	# display both flipped cards
	move $t5 $s1
	jal clear_console
	jal flip_card
	la $a0 flippableBoard
	jal printBoard
	
	# get second card's value
	move $a0 $s1
	jal solveCard
	move $s3 $v0
	
	beq $s3 $s2 match_success
	bne $s3 $s2 match_fail
	
	# display new board 
	jal clear_console
	la $a0 board
	jal printBoard

	j game_loop_one
	
flip_card:

	la $t4 randArray
	sll $t5 $t5 2	# index *4 for offset
	add $t6 $t4 $t5
	lw $t7 0($t6)

	la $t4 flippableBoard
	add $t6 $t5 $t4
	sw $t7 0($t6)
	
	jr $ra
			
match_success:
	addi $t9 $t9 1 # increment match counter
	jal match_success_sound
	
	# create new board with matched cards flipped over
	la $t4 flippableBoard
	sll $s0 $s0 2
	add $t6 $s0 $t4
	lw $t7 0($t6)
	
	la $t4 board
	add $t6 $s0 $t4
	sw $t7 0($t6)
	
	la $t4 flippableBoard
	sll $s1 $s1 2
	add $t6 $s1 $t4
	lw $t7 0($t6)
	
	la $t4 board
	add $t6 $s1 $t4
	sw $t7 0($t6)
	

	jal clear_console

	j game_loop_one	
	
match_fail:
	jal match_fail_sound
	
	# resets flippable board with question marks in respective indexes
	la $t4 board
	sll $s0 $s0 2
	add $t6 $t4 $s0
	lw $t7 0($t6)
	
	la $t4 flippableBoard
	add $t6 $t4 $s0
	sw $t7 0($t6)
	
	la $t4 board
	sll $s1 $s1 2
	add $t6 $t4 $s1
	lw $t7 0($t6)
	
	la $t4 flippableBoard
	add $t6 $t4 $s1
	sw $t7 0($t6)
	
	jal display_delay_buffer
	jal clear_console
	
	j game_loop_one

# a buffer so user has time to see incorrect match before clearing console	
display_delay_buffer:
	subi $s4 $s4 1
	bnez $s4 display_delay_buffer
	
	jr $ra
	
# Exception handling if user inputs an index that was previously matched		
check_prev_index:
	# checks if there is a question mark at indexed card and makes user redo input if there isnt
	la $t4 board
	sll $t5 $t5 2
	add $t6 $t4 $t5
	
	lbu $t7 1($t6)
	bne $t7 '?' display_error_match
	
	jr $ra
	
# display error message for prev index error and jump back to game loop
display_error_match:
	jal clear_console
	la $a0 user_error_index_match
	li $v0 4
	syscall
	
	j game_loop_one
	
# Exception handling if user inputs oob index	
user_invalid_input:
	jal clear_console
	li $v0 4
	la $a0 user_out_of_bound
	syscall
	
	j game_loop_one
	
# Exception handling if user inputs the same index 
user_same_index:
	jal clear_console
	li $v0 4
	la $a0 user_error_same_index
	syscall
	
	# Reset flippable board to get rid of the invalid input by user
	la $t4 board
	sll $s0 $s0 2
	add $t6 $t4 $s0
	lw $t7 0($t6)
	
	la $t4 flippableBoard
	add $t6 $t4 $s0
	sw $t7 0($t6)
	
	la $t4 board
	sll $s1 $s1 2
	add $t6 $t4 $s1
	lw $t7 0($t6)
	
	la $t4 flippableBoard
	add $t6 $t4 $s1
	sw $t7 0($t6)
	
	j game_loop_one
	
# User won game return to main	
game_win:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	addi $sp $sp 24
	
	jr $ra

	
	

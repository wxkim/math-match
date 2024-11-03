.data
game_begin_message_string: .asciiz "Press OK to begin."
game_end_message_string: .asciiz "Game over! Your time: "
game_quit_message_string: .asciiz "You have quit the game. "



.text
.globl game_start_popup, game_end_popup, game_begin_message_string, game_end_message_string

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
	add $a1 $0 $0 # -> this is where time in integer goes; implement time first
	syscall
	
	li $v0 10
	syscall ## GAME ENDS HERE
	
game_board_array_populate:
	
	
	

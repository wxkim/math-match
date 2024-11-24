# Main file to compile from
# CS2340 Long Project
# Authors: Will Kim ||| wxk220007 ||| wkim@utdallas.edu
# Teammate: Henrique Santos || HGS230001 || hgs230001@utdallas.edu

.data
_main_msg_: .asciiz "In main (game loading)...\n"
_main_msg_ingame_: .asciiz "\nPlaying game"
minutes_display : .asciiz " minutes and "
seconds_display: .asciiz " seconds!"

.text
.globl main 
main:
	# stores start time to calculate final time
	li $v0 30
	syscall
	move $s0 $a0 # start time lower 32 bits
	
	# store lower 32 bits in stack
	addi $sp $sp -4
	sw $s0 0($sp)
	
	jal clear_console
	
	# randomize board and populate randArray
	jal game_board_array_populate

	# game start goes into game loop
	jal game_start_function
	
	# user won game
	la $a0 board
	jal printBoard 
	
	# loads start time to calculate final time
	lw $s0 0 ($sp)
	addi $sp $sp 4
	
	# Calculate time taken for game
	li $v0 30
	syscall
	move $s2 $a0 # end time lower 32 bits
	
	subu $s4 $s2 $s0 # subtracts lower 32 bits of end time and start time (result in ms)
	div $s4 $s4 1000 # converts milliseconds -> seconds
	mflo $s4 # stores total seconds in $s6
	div $s5 $s4 60 # stores total minutes in $s7
	mfhi $s6 # stores remainding seconds in $s5

	# display game over message
	la $a0 game_end_message_string
	li $v0 4
	syscall
	
	# Display # of minutes game lasted
	move $a0 $s5
	li $v0 1 
	syscall
	la $a0 minutes_display
	li $v0 4
	syscall
	
	# Display # of remaining seconds game lasted
	move $a0 $s6
	li $v0 1
	syscall
	la $a0 seconds_display
	li $v0 4
	syscall
	
	jal printJoystick
	# plays game won sound
	jal game_win_sound
	
	
	# Exit program
	li $v0 10
	syscall
	

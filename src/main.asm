# Main file to compile from
# CS2340 Long Project
# Authors: Will Kim ||| wxk220007 ||| wkim@utdallas.edu
# Teammate: Henrique Santos || HGS230001 || hgs230001@utdallas.edu

.data
_main_msg_: .asciiz "In main (game loading)...\n"
_main_msg_ingame_: .asciiz "\nPlaying game"

.text
.globl main 
main:
	jal clear_console
	li $v0 4
	la $a0 _main_msg_
	syscall
	
	# randomize board and populate randArray
	jal game_board_array_populate
	
	# game start goes into game loop
	jal game_start_popup
	jal game_start_function
	
	# user won game 
	jal game_win_sound
	la $a0 board
	jal printBoard
	# jal game_end_popup have to implement time first
	
	li $v0 10
	syscall
	
	#li $v0 4
	#la $a0 _main_msg_ingame_ 
	#syscall
	

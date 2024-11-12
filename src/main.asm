# Main file to compile from
# CS2340 Long Project
# Authors: Will Kim ||| wxk220007 ||| wkim@utdallas.edu
# Teammate: Henrique Santos

.data
_main_msg_: .asciiz "In main (game loading)...\n"
_main_msg_ingame_: .asciiz "\nPlaying game"

.globl main 

.text
main:
	jal clear_console
	li $v0 4
	la $a0 _main_msg_
	syscall
	
	#jal read_user_input	
	
	#jal game_start_popup
	
	#jal game_board_array_populate
	
	#la $a0 randArray
	#jal printBoard

	
	#jal match_success_sound
	#jal match_fail_sound
	#jal card_select_sound
	#jal game_win_sound
	
	#jal clear_console
	
	#li $v0 4
	#la $a0 _main_msg_ingame_ 
	#syscall
	
	

	
	#jal game_end_popup
	
	
	
	li $v0 10
	syscall
	




# main file to compile from
# CS2340 Long Project
# Authors: Will Kim ||| wxk220007 ||| wkim@utdallas.edu
# Teammate: Henrique Santos

# defined variables
# create arrays
# rng upper bound 16 (0 to 16-1) for index
# find index on rng via sll 2
# at index of RNG place 1 (bool array) in usedAR
# first rng engine is for selecting from bank (8 times)
# second rng engine for placement during board creation (8 times)

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
	
	#jal game_start_popup
	
	jal game_board_array_populate
	
	la $a0 randArray
	jal printBoard
	
	#jal match_success_sound
	#jal match_fail_sound
	#jal card_select_sound
	#jal game_win_sound
	
	#jal clear_console
	
	li $v0 4
	la $a0 _main_msg_ingame_ 
	syscall

	
	#jal game_end_popup
	
	# addi $s0 $0 8
	# every successful card match: addi $s0 $s0 -1
	# loop while $s0 not 0
	# break and end game when $s0 = 0
	
	
	
	li $v0 10
	syscall
	




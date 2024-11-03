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
	li $v0 4
	la $a0 _main_msg_
	syscall
	
	jal game_start_popup
	
	la $a0 exprs
	jal printBoard
	
	li $v0 4
	la $a0 _main_msg_ingame_
	syscall
	
	#la $a0 exprs
	
	#jal game_end_popup

	
	li $v0 10
	syscall
	




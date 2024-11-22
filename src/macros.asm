# list of macros for ease of use.
# link compiled with ".include"
# does not contain any procedures, only macros.
# header file
# author

.data
_1space: .asciiz " "
_2space: .asciiz "  "
_3space: .asciiz "   "
# Joystick and buttons ascii art
joystick_top1: .asciiz "\t        ___  "
joystick_top2: .asciiz "\t       (   ) "
joystick_handle: .asciiz "\t        | |  "
joystick_lower1: "\t      __| |__"
joystick_lower2: "\t     /_______\\"
firstcircle_level1: .asciiz "\t         / / "
firstcircle_level2: .asciiz "\t       /    /"
firstcircle_level3: .asciiz "\t        / / "
secondcircle_level1: .asciiz "\t    * *"
secondcircle_level2: .asciiz "\t   *   *"
secondcircle_level3: .asciiz "\t\t\t    * *"
thirdcircle_level1: .asciiz "    = = "
thirdcircle_level2: .asciiz "  =   ="
thirdcircle_level3: .asciiz "    = = "
# Ascii game board
_plusline: .asciiz "\t\t\t-----------------------------------------------------------------------------------------"
inner_board_fill_line: 	.asciiz "\t\t\t|                     |                     |                     |                     |"
left_wall_board: .asciiz "\t\t\t|         "
middle_wall_board: .asciiz "         |         "
right_wall_board: .asciiz "         |"

_newline: .asciiz "\n"

.macro fill_board_line_macro
	la $a0 _newline		# print a newline
	syscall
	
	la $a0 inner_board_fill_line
	syscall
	
	la $a0 _newline		# print a newline
	syscall
	
	la $a0 inner_board_fill_line
	syscall

.end_macro 

.macro printNewLine
	li $v0 4
	la $a0 _newline		# print a newline
	syscall
.end_macro 


# list of macros for ease of use.
# link compiled with ".include"
# does not contain any procedures, only macros.
# header file
# author

.data
_1space: .asciiz " "
_2space: .asciiz "  "
_3space: .asciiz "   "
_plusline:		.asciiz "-----------------------------------------------------------------------------------------"
inner_board_fill_line: 	.asciiz "|                     |                     |                     |                     |"

left_wall_board: .asciiz "|         "
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
	
	# la $a0 _newline		# print a newline
	# syscall
.end_macro 

.macro printNewLine
	li $v0 4
	la $a0 _newline		# print a newline
	syscall
.end_macro 

# list of macros for ease of use.
# link compiled with ".include"
# does not contain any procedures, only macros.
# header file
# author

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

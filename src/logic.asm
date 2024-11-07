## Game Logic file
#

.data
.align 2
exprs: .asciiz	"2x3", "3x4", "5x2", "5x3", 	# expression board 4 by 4 bank
		"4x4", "2x7", "6x6", "4x5", 
		"3x7", "8x5", "5x5", "5x6", 
		"2x9", "1x7", "4x6", "5x7"
		
values: .asciiz " 6 ", "12 ", "10 ", "15 ",	# value board 4 by 4 bank
		"16 ", "14 ", "36 ", "20 ",
		"21 ", "40 ", "25 ", "30 ",	
		"18 ", " 7 ", "24 ", "35 "

generated: .space 128 					# 16 x 8 reserved mem for board creation
randArray: .space 128 					# 16 x 8 reserved mem for second rng engine (placement)

board: .asciiz 	" ? ", " ? ", " ? ", " ? ", 		# default board hidden
		" ? ", " ? ", " ? ", " ? ", 
		" ? ", " ? ", " ? ", " ? ", 
		" ? ", " ? ", " ? ", " ? "
		
flippableBoard: .asciiz 	
		" ? ", " ? ", " ? ", " ? ", 		# store flipped cards here, and copy to board if successful
		" ? ", " ? ", " ? ", " ? ", 
		" ? ", " ? ", " ? ", " ? ", 
		" ? ", " ? ", " ? ", " ? "

usedAR: .word 	0,0,0,0,				# boolean array for used indices in rng (expr)
		0,0,0,0,
		0,0,0,0,
		0,0,0,0

usedRNG: .word 	0,0,0,0,				# boolean array for used indiced in rng (vals)
		0,0,0,0,
		0,0,0,0,
		0,0,0,0

.include "macros.asm"
.include "const.asm"

.text


.globl printBoard
.globl board
.globl flippableBoard
.globl exprs
.globl values
.globl clear_console
.globl generated
.globl randArray


printBoard:
	addi $sp $sp -4
	sw $ra 0($sp)
	
	addi $t0 $a0 0		#$t0 <- $a0 holds the address of the array as argument
	addi $t8 $0 0
	j print_loop
	
print_loop:
	printNewLine
	
	la $a0 _plusline	# print a line of pluses
	syscall
	
	fill_board_line_macro
	printNewLine
	
	la $a0 left_wall_board 		# first row element
	syscall
	
	la $a0 0($t0)
	syscall
	
	la $a0 middle_wall_board	#second row element
	syscall
	
	la $a0 4($t0)
	syscall
	
	la $a0 middle_wall_board 	#third row element
	syscall
	
	la $a0 8($t0)
	syscall
	
	la $a0 middle_wall_board 	#third row element
	syscall
	
	la $a0 12($t0)
	syscall
	
	la $a0 right_wall_board		#4th row element
	syscall
	
	fill_board_line_macro
	addi $t8 $t8 1
	addi $t0 $t0 16
	blt $t8, 4, print_loop
	
return_from_printloop:
	printNewLine
	li $v0 4
	la $a0 _plusline	# print a line of pluses
	syscall
	lw $ra 0($sp)		# return function
	addi $sp $sp 4
	jr $ra 			#return

clear_console:
    li $t0, 58              # print nl 58 times (to emulate clear screen)
clear_loop:
    printNewLine
    subi $t0, $t0, 1        # Decrement counter
    bgtz $t0, clear_loop    # Repeat until counter reaches zero
    jr $ra                  # Return to caller



	
	
	
	
	
	

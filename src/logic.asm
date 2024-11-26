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
randArray: .space 128 					# 16 x 8 reserved mem for second rng engine (placement) !>THIS IS THE IMPORTANT ONE<!

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
		
match_matrix: .word 					# probably unused for now
		0,0,0,0,				# integer array for used for checking successful match
		0,0,0,0,
		0,0,0,0,
		0,0,0,0

.include "macros.asm"

.text

.globl printBoard
.globl board
.globl flippableBoard
.globl exprs
.globl values
.globl clear_console
.globl generated
.globl randArray
.globl usedAR
.globl usedRNG
.globl match_matrix
.globl printJoystick
.globl printJoystickLeft
.globl printJoystickRight

printBoard:
	addi $sp $sp -4
	sw $ra 0($sp)
	
	addi $t0 $a0 0		#$t0 <- $a0 holds the address of the array as argument
	addi $t8 $0 0

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

# Prints ascii joystick
printJoystick:

	printNewLine
	printNewLine
	la $a0 joystick_top1
	syscall
	printNewLine
	la $a0 joystick_top2
	syscall
	la $a0 firstcircle_level1
	syscall
	printNewLine
	la $a0 joystick_handle
	syscall
	la $a0 firstcircle_level2
	syscall
	printNewLine
	la $a0 joystick_handle
	syscall
	la $a0 firstcircle_level3
	syscall
	printNewLine
	la $a0 joystick_lower1
	syscall
	la $a0 secondcircle_level1
	syscall
	la $a0 thirdcircle_level1
	syscall
	printNewLine
	la $a0 joystick_lower2
	syscall
	la $a0 secondcircle_level2
	syscall
	la $a0 thirdcircle_level2
	syscall
	printNewLine
	la $a0 secondcircle_level3
	syscall
	la $a0 thirdcircle_level3
	syscall
	printNewLine
	
	jr $ra
# print ascii joystick tilted left & button pressed
printJoystickLeft:
	printNewLine
	printNewLine
	la $a0 joystickleft_top1
	syscall
	printNewLine
	la $a0 joystickleft_top2
	syscall
	la $a0 firstcircle_level1
	syscall
	printNewLine
	la $a0 joystickleft_handle1
	syscall
	la $a0 firstcircle_level2
	syscall
	printNewLine
	la $a0 joystickleft_handle2
	syscall
	la $a0 firstcircle_level3
	syscall
	printNewLine
	la $a0 joystickleft_lower1
	syscall
	la $a0 tiltcircle_level1
	syscall
	la $a0 thirdcircle_level1
	syscall
	printNewLine
	la $a0 joystickleft_lower2
	syscall
	la $a0 tiltcircle_level2
	syscall
	la $a0 thirdcircle_level2
	syscall
	printNewLine
	la $a0 tiltcircle_level3
	syscall
	la $a0 thirdcircle_level3
	syscall
	printNewLine
	
	jr $ra

# Prints ascii joystick titled right & button pressed
printJoystickRight:
	printNewLine
	printNewLine
	la $a0 joystickright_top1
	syscall
	printNewLine
	la $a0 joystickright_top2
	syscall
	la $a0 firstcircle_level1
	syscall
	printNewLine
	la $a0 joystickright_handle1
	syscall
	la $a0 firstcircle_level2
	syscall
	printNewLine
	la $a0 joystickright_handle2
	syscall
	la $a0 firstcircle_level3
	syscall
	printNewLine
	la $a0 joystickright_lower1
	syscall
	la $a0 tiltcircle_level1
	syscall
	la $a0 thirdcircle_level1
	syscall
	printNewLine
	la $a0 joystickright_lower2
	syscall
	la $a0 tiltcircle_level2
	syscall
	la $a0 thirdcircle_level2
	syscall
	printNewLine
	la $a0 tiltcircle_level3
	syscall
	la $a0 thirdcircle_level3
	syscall
	printNewLine
	
	jr $ra
clear_console:
    li $t0, 58              # print nl 58 times (to emulate clear screen)
clear_loop:
    printNewLine
    subi $t0, $t0, 1        # Decrement counter
    bgtz $t0, clear_loop    # Repeat until counter reaches zero
    jr $ra                  # Return to caller



	
	
	
	
	
	

## Game Logic file


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
		
_1space: .asciiz " "
_2space: .asciiz "  "
_3space: .asciiz "   "

.text

.globl printBoard, printCoveredBoard
printBoard:
	la $t0, exprs
	li $v0, 4
	
	la $a0, 0($t0)
	syscall
	

	
	la $a0, 4($t0)
	syscall
	
	la $a0, 8($t0)
	syscall
	
	li $v0, 10
	syscall
	
	
#memcpy??
printCoveredBoard:
	addi $sp $sp -8
	
	addi $sp $sp 8
	

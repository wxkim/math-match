# Conversions

.data 
.align 2
matchMessage_debug_T: .asciiz "It's a match!"
matchMessage_debug_F: .asciiz "It's not a match!"
userPromptForCard: .asciiz "\nEnter the index of the card you want to flip (for single digit index start with 0), or enter (Q/q) to quit: "
inputBuffer: .space 24
cardSelectinIndex_debug: .asciiz "\nYour selected card #"
user_quit_message: .asciiz "\nThanks for playing! Now Exiting."


.globl stringToInt
.globl solveCard
.globl read_user_input

.text

stringToInt:            	# 1 argument in $a0
	addi $sp $sp -4
	sw $ra 0($sp)
	
	li $v0 0           	# initialize v0 : where final int answer stored
  	li $t0 10          	# const register later converting
loop:
    	lb $t1 0($a0)           # load byte from string
    	beq $t1 $0 print        # branch if null terminator read
    	li $t2 48               # ascii value of integer 0
    	beq $t1 113 user_quit   # check if user chose to quit game
    	beq $t1 81 user_quit    # check if user chose to quit game
    	
    	blt $t1 $t2 invalid     # check if oobounds
    	li $t2 57               # ascii value of integer 91
    	bgt $t1 $t2 invalid     # check if oobounds
    	li $t2 48
    	sub $t1 $t1 $t2         # subtract loaded ascii value from 0's 
                            	 # ascii value to get true integer
    	mul $v0 $v0 $t0         # bump place <- 1
    	add $v0 $v0 $t1         # add to total 
    	addi $a0 $a0 1          # increment address
    	j loop                  # jump back repeat loop
print: 
    	addiu $a0 $v0 0       	# save value in v0
    	j exit

invalid:
    	li $v0 -1
    	j exit
user_quit:
	li $v0 -2 
	j exit

exit: 
    	lw $ra 0($sp)
    	addi $sp $sp 4
    	jr $ra

    	
    
################################################################################

solveCard:				# 1 argument in $a0 <- contains the number of card chosen  ;; reads from randArray
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	
	la $s0 randArray		# load address of the gameboard randArray
	move $s1 $a0			# copy selected card index to $s1
	sll $s1 $s1 2			# x 4 for mem
	add $t0 $s0 $s1 		# retrieves the card from the memory array
	
	lbu $t1 1($t0)			# load word[1]
	
	beq $t1 'x' parseExpression	# if word[1] = 'x' ;; branch 
	bne $t1 'x' parseValue		# if word[1] != 'x' ;; branch
parseExpression:
	lb $t1 0($t0)
	lb $t2 2($t0)
	
	subu $t1 $t1 48
	subu $t2 $t2 48
	
	mulu $t0 $t1 $t2
	addi $v0 $t0 0
	
	j return_from_solveCard
	
parseValue:
	li $t2 0
	lbu $t1 0($t0)            # load first digit character
	beq $t1 32 parseSecondIndex # checks if it is a single digit value
	subu $t1 $t1 48         # convert ASCII to integer
	mul $t2 $t2 10
	add $t2 $t2 $t1
parseSecondIndex:
	lbu $t1 1($t0)		# load second digit character
	beq $t1 32 endParseValue
    	subu $t1 $t1 48
    	mul $t2 $t2 10
    	add $t2 $t2 $t1

endParseValue:
    	move $v0 $t2             # Store the result in $v0

return_from_solveCard:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	addi $sp $sp 12
	jr $ra
	
	
################################################################################
	
read_user_input:
	addi $sp $sp -8
	sw $ra 0($sp)
	sw $v0 4($sp)
	
	li $v0 4
	la $a0 userPromptForCard
	syscall
	
	li $v0 8
	la $a0 inputBuffer
	li $a1 3
	syscall
	
	#lw $t0 0($a0)
	#addi $a0 $t0 0
	la $a0 inputBuffer
	jal stringToInt
	addi $t0 $v0 0
	
	beq $t0 -2 user_quit_game

	li $v0 4
	la $a0 cardSelectinIndex_debug
	syscall
	
	li $v0 1
	move $a0 $t0
	syscall
	
	lw $ra 0($sp)             
        lw $v0 4($sp)     
    	addi $sp $sp 8           
    	jr $ra 
	
user_quit_game: # user chooses to quit the game: option(q/Q)
	li $v0 4
	la $a0 user_quit_message
	syscall
	
	li $v0 10
	syscall
	


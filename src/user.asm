# Conversions

.data 
matchMessage_debug_T: .asciiz "It's a match!"
matchMessage_debug_F: .asciiz "It's not a match!"

.globl stringToInt
.globl solveCard

stringToInt:            	# 1 argument in $a0
	addi $sp $sp -4
	sw $ra 0($sp)
	
	li $v0 0           	# initialize v0 : where final int answer stored
  	li $t0 10          	# const register later converting
loop:
    	lb $t1 0($a0)           # load byte from string
    	beq $t1 $0 print        # branch if null terminator read
    	li $t2 48               # ascii value of integer 0
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
	add $s1 $a0 $0			# copy selected card index to $s1
	sll $s1 $s1 2			# x 4 for mem
	add $t0 $s0 $s1 		# retrieves the card from the memory array
	
	lb $t1 4($t0)			# load word[1]
	beq $t1 'x' parseExpression	# if word[1] = 'x' ;; branch 
	bne $t1 'x' parseValue		# if word[1] != 'x' ;; branch
parseExpression:
	lb $t1 0($t0)
	lb $t2 8($t0)
	
	subu $t1 $t1 48
	subu $t2 $t2 48
	
	mulu $t0 $t1 $t2
	addi $v0 $t0 0
	
	j return_from_solveCard
	
parseValue:
	lb $t1 0($t0)            # load first digit character
	beq $t1 32 endParseValue
    	subi $t1 $t1 48         # convert ASCII to integer
    	move $t2 $t1             # initialize result with the first digit

parseValueLoop:
    	addi $t0 $t0 1          # move to the next character
    	lb $t1 0($t0)            # load the next character
    	beqz $t1 endParseValue   # if null terminator end loop
    
    	subi $t1 $t1 48         # convert ASCII to integer
    	mul $t2 $t2 10          # shift current result left by one decimal place
    	add $t2 $t2 $t1         # add the new digit

    	j parseValueLoop

endParseValue:
    	move $v0 $t2             # Store the result in $v0
    	


return_from_solveCard:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	addi $sp $sp 12
	jr $ra
	
	
################################################################################
	
	
	
	

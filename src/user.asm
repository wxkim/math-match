# FROM HOMEWORK 3 QUESTION 2
.globl stringToInt

stringToInt:            # 1 argument in $a0
    li $v0 0            # initialize v0 : where final int answer stored
    li $t0 10           # const register later converting
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
    addiu $a0, $v0, 0       # save value in v0
    li $v0 1
    syscall
    j exit

invalid:
    li $v0 -1
    j exit

exit:
    li $v0 10
    syscall

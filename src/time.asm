# system time

.data 
time_start_hi: .word 0
time_start_lo: .word 0

time_end_hi: .word 0
time_end_lo: .word 0

.globl find_current_time_ms

.text
find_current_time_ms: 		#gets system time. we only care about the lower 32
	addi $sp $sp -4		#adjust stack pointer
	sw $ra 0($sp)		#save register in stack pointer
	
	li $v0 30
	syscall
	
	addi $v0 $a0 0
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra


# system time

.data 
time_start_hi: .word 0
time_start_lo: .word 0

time_end_hi: .word 0
time_end_lo: .word 0

.text
find_current_time_ms: 		#gets system time. we only care about the lower 32
	li $v0 30
	syscall
	
	addi $v0 $a0 0
	
	jr $ra


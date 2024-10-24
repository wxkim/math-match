# system time

.data 
time_start_hi: .word 0
time_start_lo: .word 0

time_end_hi: .word 0
time_end_lo: .word 0

.text
find_time:
	li $v0
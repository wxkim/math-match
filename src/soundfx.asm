.globl card_select_sound, match_success_sound, match_fail_sound, game_win_sound
 
.text

card_select_sound:
	addi $sp $sp -20
	sw   $a0, 0($sp) 
	sw   $a1, 4($sp)
	sw   $a2, 8($sp) 
	sw   $a3, 12($sp)
	sw   $ra, 16($sp) 
	 
	#woodblock
	li $v0 31           
	addi $a0 $0 75
	addi $a1 $0 80
	addi $a2 $0 115
	addi $a3 $0 80
	
	syscall
	
	lw   $a0, 0($sp) 
	lw   $a1, 4($sp) 
	lw   $a2, 8($sp) 
	lw   $a3, 12($sp) 
	lw   $ra, 16($sp)
	addi $sp $sp 20
	
	jr $ra

match_success_sound:
	addi $sp $sp -20
	sw   $a0, 0($sp) 
	sw   $a1, 4($sp)
	sw   $a2, 8($sp) 
	sw   $a3, 12($sp)
	sw   $ra, 16($sp) 
	 
	li $v0 31           
	addi $a0 $0 75
	addi $a1 $0 80
	addi $a2 $0 8
	addi $a3 $0 60
	
	syscall
	
	li $v0 32
	addi $a0 $0 40
	syscall
	
	li $v0 31           
	addi $a0 $0 80
	addi $a1 $0 80
	addi $a2 $0 8
	addi $a3 $0 60
	syscall
	
	li $v0 32
	addi $a0 $0 50
	syscall
	
	li $v0 31           
	addi $a0 $0 84
	addi $a1 $0 80
	addi $a2 $0 8
	addi $a3 $0 80
	syscall
	
	lw   $a0, 0($sp) 
	lw   $a1, 4($sp) 
	lw   $a2, 8($sp) 
	lw   $a3, 12($sp) 
	lw   $ra, 16($sp)
	addi $sp $sp 20
	
	jr $ra


match_fail_sound:
	addi $sp $sp -20
	sw   $a0, 0($sp) 
	sw   $a1, 4($sp)
	sw   $a2, 8($sp) 
	sw   $a3, 12($sp)
	sw   $ra, 16($sp) 
	 
	li $v0, 31               
   	li $a0, 46            
    	li $a1, 150           
    	li $a2, 5              	
    	li $a3, 70              
    	syscall              
    	
    	li $v0 32
	addi $a0 $0 100
	syscall
    	
    	li $v0, 31               
   	li $a0, 39              
    	li $a1, 250             
    	li $a2, 5               
    	li $a3, 70            
    	syscall                  
	
	lw   $a0, 0($sp) 
	lw   $a1, 4($sp) 
	lw   $a2, 8($sp) 
	lw   $a3, 12($sp) 
	lw   $ra, 16($sp)
	addi $sp $sp 20
	
	jr $ra
	

game_win_sound: #place holder c major scale for now; change it into something better l8r
	addi $sp $sp -20
	sw   $a0, 0($sp) 
	sw   $a1, 4($sp)
	sw   $a2, 8($sp) 
	sw   $a3, 12($sp)
	sw   $ra, 16($sp) 
	 
	li $v0, 31
	li $a0, 60
	li $a1, 1400
	li $a2,25
	li $a3, 60
	syscall


	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 62
	li $a1, 1000
	li $a2, 25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 64
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 65
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 67
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 69
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 71
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall

	li $v0, 32
	li $a0, 600
	syscall

	li $v0, 31
	li $a0, 72
	li $a1, 1000
	li $a2,25
	li $a3, 60
	syscall
	
	
	lw   $a0, 0($sp) 
	lw   $a1, 4($sp) 
	lw   $a2, 8($sp) 
	lw   $a3, 12($sp) 
	lw   $ra, 16($sp)
	addi $sp $sp 20
	
	jr $ra





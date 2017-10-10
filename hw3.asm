##############################################################
# Homework #3
# name: Wonguen Cho
# sbuid: 109461283	
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
    	addi $sp, $sp ,-4
    	sw $ra, 0($sp)
    	la $t0, 0xffff0000 
    	lw $t1, size_row	#$t1 = 10
    	lw $t2, size_col 	#$t2 = 10
    	
    	li $t3, 0	#i, row counter
    	
    	
row_loop: 
	li $t4, 0 		#j, colum conter
col_loop:
 	mul $t5, $t3, $t2		#i*numcol
	add $t5, $t5, $t4		#i*num+j
    	sll $t5, $t5, 1		#2*(i*num_col+j)
    	add $t5, $t5, $t0		#current index + base of array address
    	
	beq $t3, 2, checkJForEye		#if the i value is same as eye location check it's J value
	beq $t3, 3, checkJForEye		#if the i value is same as eye location check it's J value
	
	beq $t3, 6, checkJForMouse1		#if the i value is same as mouse location check it's J value
	beq $t3, 7, checkJForMouse2		#if the i value is same as mouse location check it's J value
	beq $t3, 8, checkJForMouse3		#if the i value is same as mouse location check it's J value
	
	j normal_cell
checkJForEye : 
	beq $t4, 3, eyeCell			#if the j value is smae as eye location go to print eye cell.
	beq $t4, 6, eyeCell			#if the j value is smae as eye location go to print eye cell
	j normal_cell				#if j is not in eye location just normal cell
checkJForMouse1 : 
	beq $t4, 2, mouseCell			#if the j value is smae as mouse location go to print eye cell
	beq $t4, 7, mouseCell			
	j normal_cell
checkJForMouse2 : 
	beq $t4, 3, mouseCell			#if the j value is smae as mouse location go to print eye cell
	beq $t4, 6, mouseCell			#if the j value is smae as mouse location go to print eye cell
	j normal_cell
checkJForMouse3:
	beq $t4, 4, mouseCell			#if the j value is smae as mouse location go to print eye cell
	beq $t4, 5, mouseCell			#if the j value is smae as mouse location go to print eye cell
	j normal_cell
	
eyeCell : 
	li $t6, 0x42		#This decimal indicate character.
    	sb $t6, 0($t5)		# the value which indicate green saved into 0xffff00@@
    	addi $t5, $t5, 1		# next byte
    	li $t6, 0xb7		#this value indicate color
    	sb $t6, 0($t5)		# green value save into 0xffff00@(@+1)
    	addi $t4, $t4, 1	#j++
    	blt $t4, $t2, col_loop
    	j col_loop_done   
mouseCell :  
	li $t6, 0x45		#This decimal indicate character.
    	sb $t6, 0($t5)		# the value which indicate green saved into 0xffff00@@
    	addi $t5, $t5, 1		# next byte
    	li $t6, 0x1f		#this value indicate color
    	sb $t6, 0($t5)		# green value save into 0xffff00@(@+1)
    	addi $t4, $t4, 1	#j++
    	blt $t4, $t2, col_loop
    	j col_loop_done   
normal_cell:
    	li $t6, 0x00		#This decimal indicate character.
    	sb $t6, 0($t5)		# the value which indicate green saved into 0xffff00@@
    	addi $t5, $t5, 1		# next byte
    	li $t6, 0x0f		#this value indicate color
    	sb $t6, 0($t5)		# green value save into 0xffff00@(@+1)
    	addi $t4, $t4, 1	#j++
    	blt $t4, $t2, col_loop
    	j col_loop_done
col_loop_done : 
	addi $t3, $t3, 1	# i++
	blt $t3, $t1, row_loop
row_loop_done:
    	
	lw $ra, 0($sp)		#$get original $ra
    	addi $sp, $sp, 4		#close stack
	jr $ra
	#li $v0, 10
	#syscall
##############################
# PART 2 FUNCTIONS
##############################

open_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
   addi $sp, $sp, -8
   sw	$ra, 0($sp)
   sw $s0, 4($sp)
   
   li $v0, 13				#open the file
   li $a1, 0
   li $a2, 0
   syscall
   
 
   
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

close_file:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
     addi $sp, $sp, -8
     sw	$ra, 0($sp)
     sw $s0, 4($sp)
   
     li $v0, 16			#close the file
     syscall
     
     lw $s0, 4($sp)
     lw $ra, 0($sp)
     addi $sp, $sp, 8
    ###########################################
    jr $ra

load_map:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    move $s0, $a1	#saved arg1(which is the cells array in to $s0
    #first check the number of values in the text file is valid
    la $a1, input_buf 		#$a1 = input buffer space 
    li  $a2, 300			#save maximum value into $a2
    li $v0, 14			#read from file.
    syscall				#$v0, returns the contains number of characters.
    
    move $s1, $a1	#$s1 save the input_buffer
    la $s2, coordinate_num
    li $t0, 0			#count for number   	
count_read_num : 
	lb $t1, 0($s1)	#$t1 saves the value of first character of $s1
	beqz $t1, exit_count_read_num	#if $t1 has null value, exit.
	blt $t1, 48, not_num	#if the value is smaller than '0' go to not_num
	bgt $t1, 57, not_num	#if the value is greater than '9' go to not_num
       	addi $t0, $t0, 1		#if $t1 is number => count++
    	addi $s1, $s1, 1		#go to next character
    	sb $t1, 0($s2)		#save the number into coordinate number array
    	addi $s2, $s2, 1		#the next space $s2
   	j count_read_num
not_num : 
	beq $t1, 32, non_num_char		#if $t1 is space = > non_num char
	beq $t1, 10, non_num_char		#if $t1 is new_line => non_num char
	beq $t1, 9, non_num_char 		#if $t1 is tap => non_num_char
	beq $t1, 13, non_num_char		#if $t1 is carriage return = > non_num_char
   	j invalid_count_read_num		#if $t1 has invalid value go to invald_count_read_num
non_num_char : 
	addi $s1, $s1, 1					#go to next Character
	j count_read_num			#go to loop
	
invalid_count_read_num : 
	li $v0, -1
	j finish_load
exit_count_read_num : 
	sub $s2, $s2, $t0
	li $t2, 2	#$t2 -> 2
	div $t0, $t2	#count / 2
	mfhi	$t3		#$t3 is remainder to check the file has odd numbers value
	mflo  $t4		#$t4 means number of bumbs
	bnez $t3, invalid_count_read_num 	#if the file doesn't have odd number values, it will be error.
	beqz $t4, invalid_count_read_num 	#if there are no bumb = > error
	bgt	$t4, 99, invalid_count_read_num 	#if the number of bumb >99 =>error
	li $t5, 0		#count for bumb location
save_bomb_location_loop:
	bge $t5, $t4, exit_location_loop		#if bomb count > bumb num -> exit
	lb $t0, 0($s2)				#$t0 the i coordinator of bumb
	addi $t0, $t0, -48			# $t0 - '0'	=> i
	addi $s2, $s2, 1				#next character
	lb $t1, 0($s2)				#$t1 is j coordinator of bumb
	addi $t1, $t1, -48			#$t1 - '0' 	=> j 
	addi $s2, $s2, 1				#next chracter
	#######check twice#######
	li $t6, 10
	mul $t3, $t0, $t6
	add $t3, $t3, $t1		#i*10+j
	add $s0, $s0, $t3	#move pointer
	move $t6, $t3
	lb $t3, 0($s0)		#$t3 = moved value
	sub $s0, $s0, $t6
	andi $t3, $t3, 0x20	
	bnez	$t3, twice_bomb


	li $t3, 10					#$t3  = 10
	mul $t0, $t0, $t3 		#$t0 = i*10
	add $t0, $t0, $t1			# i*10+j
	
	add $s0, $s0, $t0		#move $s0 address by i*10+j
	li $t1, 0x20				#$t1 = 00100000
	sb $t1, 0($s0)			#save 00100000 into $s0
	sub $s0, $s0, $t0		#make orginal address
	addi $t5, $t5, 1			#count ++
	j save_bomb_location_loop
twice_bomb: 
	addi $t4, $t4, -1
	j save_bomb_location_loop
exit_location_loop:	
	#determine the cell which has bomb or not.
	li $t5, 0	#bomb counter/
	li $t0, 0	#i = 0;
	li $t1, 0 	#j = 0;	#error because j must be go to 0
	li $t2, 10	#$t2 = 10
find_num_bomb_loop_row: 
	
	bge $t0, 10, exit_loop_row
	
find_num_bomb_loop_col : 
	bge $t1, 10, exit_loop_col
	mul $t3, $t0, $t2	#i*10
	add $t3, $t3, $t1	#i*10+j
	add $s0, $s0, $t3	#$s0's point move
	lb $t4, 0($s0)		#$t4's value is current coordinate's value
	sub $s0, $s0, $t3	
	andi $t4, $t4, 0x20
	bnez $t4, bomb_cell	#if the cell has bomb go to bomb cell label
	
	
	move $t3, $t0	#$t3 = i
	addi $t3, $t3, -1	#$t3 = i-1
	
fist_row:
	#(i-1, j-1) 
	#(i-1, j)
	#(i-1, j+1)
	move $t4, $t1	#$t4 = j
	addi $t4, $t4, -1	#$t4 = j-1
	bgez $t3, check_first_row	#check the value in i-1 row	if(i-1>=0)
third_row:
	#(i+1, j-1)
	#(i+1, j)
	#(i+1, j+1)
	move $t3, $t0	#$t3 = i
	addi $t3, $t3, 1	#$t3 = i+1
	ble	$t3, 9, check_third_row		#check the value in i+1 row	if(i+1<=9)
second_row:
	#(i, j-1)
	#(i, j)
	#(i, j+1)
	#########hoho####
	move $t3, $t0
	move $t4, $t1	#$t4 = j
	addi $t4, $t4, -1	#j = j-1
	#i, j-1
	bgez $t4, i_j_m1	#if(j-1>=0) goto i,j-1 true
check_i_j_p1 : 	#i, j+1
	move $t4, $t1 #$t4 = j
	addi $t4, $t4, 1	#$t4 = j+1
	ble	$t4, 9, i_j_p1	#if(j+1<=9) goto i-1, j+1 true
check_i_j: #i, j
	mul $t6, $t3, $t2		#$t6 = (i)*10
	add $t6, $t6, $t1		#$t6 = (i)*10+j
	add $s0, $s0, $t6	#find the corrdinate corleated to (i, j)
	lb $t7, 0($s0)		#get the value from $s0				#!!!!!!!!!!!if (i,j) has bomb it doesn't have to display number
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, finish_check_bomb_num	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j finish_check_bomb_num
i_j_m1: 	
	#check (i, j-1)
	mul $t6, $t3, $t2		#$t6 = (i)*10
	add $t6, $t6, $t4		#$t6 = (i)*10+j-1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i, j-1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_j_p1	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j check_i_j_p1
i_j_p1:
	#check(i, j+1)
	mul $t6, $t3, $t2		#$t6 = (i)*10
	add $t6, $t6, $t4		#$t6 = (i)*10+j+1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i, j+1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_j	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++

	j finish_check_bomb_num
#######################	Check First Row's Bomb	#####################
check_first_row:
	
	move $t4, $t1	#$t4 = j
	addi $t4, $t4, -1	#j = j-1
	#i-1, j-1
	bgez $t4, i_m1_j_m1	#if(j-1>=0) goto i-1,j-1 true
check_i_m1_j_p1 : 	#i-1, j+1
	move $t4, $t1 #$t4 = j
	addi $t4, $t4, 1	#$t4 = j+1
	blt	$t4, 9, i_m1_j_p1	#if(j+1<=9) goto i-1, j+1 true
check_i_m1_j: #i-1, j
	mul $t6, $t3, $t2		#$t6 = (i-1)*10
	add $t6, $t6, $t1		#$t6 = (i-1)*10+j
	add $s0, $s0, $t6	#find the corrdinate corleated to (i-1, j)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, third_row	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j third_row
i_m1_j_m1: 	
	#check (i-1, j-1)
	mul $t6, $t3, $t2		#$t6 = (i-1)*10
	add $t6, $t6, $t4		#$t6 = (i-1)*10+j-1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i-1, j-1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_m1_j_p1	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j check_i_m1_j_p1
i_m1_j_p1:
	#check(i-1, j+1)
	mul $t6, $t3, $t2		#$t6 = (i-1)*10
	add $t6, $t6, $t4		#$t6 = (i-1)*10+j+1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i-1, j+1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_m1_j	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j check_i_m1_j
############################	Check Third Row's Bombs	############################
check_third_row:
	
	move $t4, $t1	#$t4 = j
	addi $t4, $t4, -1	#j = j-1
	#i+1, j-1
	bgez $t4, i_p1_j_m1	#if(j-1>=0) goto i+1,j-1 true
check_i_p1_j_p1 : 	#i+1, j+1
	move $t4, $t1 #$t4 = j
	addi $t4, $t4, 1	#$t4 = j+1
	ble	$t4, 9, i_p1_j_p1	#if(j+1<=9) goto i+1, j+1 true
check_i_p1_j: #i+1, j
	mul $t6, $t3, $t2		#$t6 = (i+1)*10
	add $t6, $t6, $t1		#$t6 = (i+1)*10+j
	add $s0, $s0, $t6	#find the corrdinate corleated to (i+1, j)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, second_row	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j second_row
i_p1_j_m1: 	
	#check (i+1, j-1)
	mul $t6, $t3, $t2		#$t6 = (i+1)*10
	add $t6, $t6, $t4		#$t6 = (i+1)*10+j-1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i+1, j-1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_p1_j_p1	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j check_i_p1_j_p1
i_p1_j_p1:
	#check(i+1, j+1)
	mul $t6, $t3, $t2		#$t6 = (i+1)*10
	add $t6, $t6, $t4		#$t6 = (i+1)*10+j+1
	add $s0, $s0, $t6	#find the corrdinate corleated to (i+1, j+1)
	lb $t7, 0($s0)		#get the value from $s0
	sub $s0, $s0, $t6	#point original adress
	andi $t7, $t7, 0x20	#$t7 = $t7 and 00100000
	beqz $t7, check_i_p1_j	#if ($t7 = 0 ) no bumb go to next step
	addi $t5, $t5, 1		#bomb counter++
	j check_i_p1_j		
	
########################	Check bomb num		###########################################
bomb_cell : 
	addi $t1, $t1, 1		#j ++
	j find_num_bomb_loop_col	
finish_check_bomb_num:	
	mul $t6, $t0, $t2		#$t6 = i*10
	add $t6, $t6, $t1		#$t6 = i*10+j
	add $s0, $s0, $t6	#move pointer by coordinator value
	lb $t7, 0($s0)		#get value 
	add $t7, $t7, $t5		#$t7 = 7 bit + the num of bombs
	sb $t7, 0($s0)		#save again
	sub $s0, $s0, $t6	#pointer originally
	li $t5, 0			#$t5 is 0 again
	addi $t1, $t1, 1		#j ++
	j find_num_bomb_loop_col	
exit_loop_col:
	addi $t0, $t0, 1		#i++
	li $t1, 0 	#j = 0;
	j find_num_bomb_loop_row
exit_loop_row : 
	li $v0, 0
finish_load :     
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    ###########################################
    jr $ra

##############################
# PART 3 FUNCTIONS
##############################

init_display:
    #Define your code here
    addi $sp, $sp ,-16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    la $t0, 0xffff0000 
    lw $t1, size_row	#$t1 = 10
    lw $t2, size_col 	#$t2 = 10
    lw $s0, cursor_row	#cursor row =>$s0
    lw $s1, cursor_col	#cursor col => $s1
    li $t3, 0	#i, row counter
    	
    	
row_loop_display: 
	li $t4, 0 		#j, colum conter
col_loop_display:
 	mul $t5, $t3, $t2		#i*numcol
	add $t5, $t5, $t4		#i*numcol+j
    	sll $t5, $t5, 1		#2*(i*num_col+j) because the value has 4 byte( 2byte is for characte,r 2byte for color)
    	add $t5, $t5, $t0		#current index + base of array address

    	beq $t3, $s0, check_cursor
hidden_cell_display:
    	li $t6, 0x00			#This decimal indicate character.
    	sb $t6, 0($t5)		# the value which indicate green saved into 0xffff00@@
    	addi $t5, $t5, 1		# next byte
    	li $t6, 0x70			#this value indicate color
    	sb $t6, 0($t5)		# gray value save into 0xffff00@(@+1)
    	addi $t4, $t4, 1		#j++
    	blt $t4, $t2, col_loop_display
    	j col_loop_done_display

check_cursor : 
	beq $t4, $s1, cursor_cell
	j hidden_cell_display
cursor_cell:
	li $t6, 0x00
	sb $t6, 0($t5)
	addi $t5, $t5, 1
	li $t6, 0xb7	#yello backgouround - for ground : unmodified
	sb $t6, 0($t5)	
	addi $t4, $t4, 1
	blt $t4, $t2, col_loop_display
	j col_loop_done_display
col_loop_done_display : 
	addi $t3, $t3, 1	# i++
	blt $t3, $t1, row_loop_display
row_loop_done_display:
    	lw $s2, 12($sp)
    	lw $s1, 8($sp)
    	lw $s0, 4($sp)
	lw $ra, 0($sp)		#$get original $ra
    	addi $sp, $sp, 16		#close stack
    	
	jr $ra
set_cell:
    #Define your code here
    ############################################
   #a0 = row index $a1 = col index $a2 = character to be displayed
   #$a3 = foreground color, argument5 = background color
   lw $t9, 0($sp)	#get fifth argument from stack
   #addi $sp, $sp, 4	#remove the space of fifth argument's
   
   addi $sp, $sp, -20
   sw $ra, 0($sp)
   sw $s0, 4($sp)
   sw $s1, 8($sp)
   sw $s2, 12($sp)
   sw $s3, 16($sp)
   
   move $s3, $t9
check_valid_cell:
	bgt $a0, 9, invalid_cell
	blt  $a0, 0, invalid_cell
	bgt $a1, 9, invalid_cell
	blt $a1, 0, invalid_cell
	bgt $a3, 15, invalid_cell
	blt $a3, 0, invalid_cell
	bgt $s3, 15, invalid_cell
	blt $s3, 0, invalid_cell
	
continue_set_cell:
   move $t0, $a0		#$t0 is value of i
   move $t1, $a1		#$t1 is value of j
   li $t2, 10
   mul $t0, $t0, $t2	#i*10
   add $t0, $t0, $t1	#i*10+j $t0 indicate the position of cell
   sll	$t0, $t0, 1		#2(i*10+j)
   la $t1, 0xffff0000 	#base address of MMIO
   add $t1, $t1, $t0	#move the pointer
   
   move $t2, $a3		#$t2 foreground
   move $t3, $s3		#$t3 background-color
   li $t4, 16
   mul $t3, $t3, $t4	#$t3 = 16*background
   add $t3, $t3, $t2	#$t3 = 16* backgorund + foreground => 0x(background)(foreground) 
   sb $a2, 0($t1)		#save the color into cell
   addi $t1, $t1, 1	#move 1 byte to save ascii
   sb $t3, 0($t1)		# save the characters into memory
   
   
   li $v0, 0
   j finish_set_cell
   
invalid_cell : 
    li $v0, -1		#if the cell is invalid, return -1

finish_set_cell:
    ###########################################
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

reveal_map:
    #Define your code here
    addi $sp , $sp, -28
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s3, 24($sp)
  
   #$a0 = status of game, #$a1 = the array of cell
   
   beqz $a0, exit_reveal_map	#on going
   beq $a0, -1, lost_game		#if($a0 == -1) lost game
won_game : 
	  jal smiley
	  j exit_reveal_map
lost_game:
	move $s0, $a1	#$s0 is cell_array which contains the information of cells
	li $s4, 0	#i = 0;
	li $s5, 0	#j = 0;

	 
reveal_map_loop_row:
	lw $t2, size_row
	bge $s4, $t2, exit_reveal_map_loop_row
	li $s5, 0	#j = 0;
reveal_map_loop_col : 
	lw $t3, size_col
	bge $s5, $t3, exit_reveal_map_loop_col
	move $a0, $s4		#$a0 = row
	move $a1, $s5		#$a1 = col
	li $t4, 10
	mul $t4, $s4, $t4		#$t4 = i*10 
	add $t4, $t4, $s5		#i*10+j
	add $s0, $s0, $t4	#move pointer by coordinate
	
	lb $s1, 0($s0)		#$s1 saves the value which is  advanced by coordinate
	sub $s0, $s0, $t4	#return original position
	move $t4, $s1
	andi $t4, $t4, 0x20	#check the cell has bomb or not 00100000 - 32(dec) = 20(hex)
	bnez $t4, reveal_bomb_cell	#if it is 00100000 -> bomb cell
	move $t4, $s1
	andi $t4, $t4, 0x10	#check the cell has flag or not - 00010000 - 16(dec) = 10(hex)
	bnez $t4, flag_cell	#if it is 00010000-> flag cell
	move $t4, $s1
	andi $t4, $t4, 0xf	#check the cell hs number  00001111 - 15(dec) f (hex)
	bnez $t4, num_cell	#if it has 1<=x<=8	go to num cell
	
	li $a2, 0	#null
	li $a3, 15	#white
	li $s3, 0	#black
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1	#col++
	j reveal_map_loop_col
reveal_bomb_cell:
	lw $t5, cursor_row
	lw $t6, cursor_col
	beq $s4, $t5, check_col_exp
continue_bomb_cell : 	
	andi $t4, $s1, 0x10
	bnez $t4, bomb_flag_cell
	
	li $a2, 0x42	#$a2 = 'b'
	li $a3, 7	#gray
	li $s3, 0	#black
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	j reveal_map_loop_col
check_col_exp:
	beq $s5, $t6, exp_cell
	jal continue_bomb_cell
exp_cell:
	li $a2, 0x45	#$a2 = 'e'
	li $a3, 15		#white
	li $s3, 9		#bright red
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	j reveal_map_loop_col
flag_cell:
	li $a2, 0x46	#a3 = 'f'
	move $t4, $s1	
	andi $t4, $t4, 0x20	#check the flag has bomb or not
	bnez $t4, bomb_flag_cell	
	li $a3, 12	#bright blue
	li $s3, 9	#bright red
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	j reveal_map_loop_col
bomb_flag_cell:
	li $a2, 0x46
	li $a3, 12	#bright blue 
	li $s3, 10	#bright green
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	j reveal_map_loop_col
num_cell:
	move $a2, $t4	
	addi $a2, $a2, 48	#num+'0'
	li $a3, 13	#bright Magenta
	li $s3, 0	#black
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	j reveal_map_loop_col
exit_reveal_map_loop_col:	
	addi $s4, $s4, 1	#row ++
	jal reveal_map_loop_row
exit_reveal_map_loop_row : 
	j exit_reveal_map	
exit_reveal_map:   
   lw $s3, 24($sp)
   lw $s5, 20($sp)
   lw $s4, 16($sp)
   lw $s2, 12($sp)
   lw $s1, 8($sp)
   lw $s0, 4($sp)
   lw $ra, 0($sp)
   addi $sp, $sp, 28
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    #Define your code here
    ############################################
    #$a0 - cell array $a1 - user input
    ##########################################
    addi $sp, $sp, -40
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $a0, 20($sp)
    sw $a1, 24($sp)
    sw $a2, 28($sp)
    sw $s4, 32($sp)
    sw $s5, 36($sp)
    move $s0, $a0	#$s0 cell array
    move $s1, $a1	#$s1 user input
    lw $s2, cursor_row	#$s2 = > cursor _row
    lw $s3, cursor_col	#$3 => cursor_col
    li $t5, 0			#$t5 = > movement of row
    li $t6, 0			#$t6 => movement of col
    beq $s1, 0x57, cursor_up	#if user input = 'W' -> cursor up
    beq $s1, 0x77, cursor_up #if user input = 'w' -> cursor up
    beq $s1, 0x53, cursor_down #if userinput ='S' = > cursor down
    beq $s1, 0x73, cursor_down #if user input = 's' = > cursor down
    beq $s1, 0x41, cursor_left		#if user input='A' => cursor left
    beq $s1, 0x61, cursor_left		#if user input='a'=> cursor left
    beq $s1, 0x44, cursor_right	#if user input - 'D' => cursor right
    beq $s1, 0x64, cursor_right	#if user input - 'd' -> cursor right
    beq $s1, 0x46, mark_flag		#if user input - 'F' => mark flag
    beq $s1, 0x66, mark_flag		#if user input - 'f' => mark flag
    beq $s1, 0x52, reveal_the_cell	#if user input = 'R' => reveal the cell
    beq $s1, 0x72, reveal_the_cell	#if user input = 'r' => reveal the cell
    jal invalid_user_input
cursor_up:
	beqz	$s2, invalid_user_input		#if cursor row ==0 => exit		#check user input is ascii or normal number
	addi $s2, $s2, -1					# cursor row --
	sw  $s2, cursor_row
	addi $t5, $t5, -1				# change the cursor's row location
	j valid_cursor	
cursor_down:
	beq $s2, 9, invalid_user_input		#if cursor row==9 -> exit	
	addi $s2, $s2, 1					#cursor row++
	sw $s2, cursor_row
	addi $t5, $t5, 1				#change the cursor's row location
	j valid_cursor	 			
cursor_left:
	beqz $s3, invalid_user_input 		#if cursor col ==0 -> exit
	addi $s3, $s3, -1					#cursor col--
	sw $s3, cursor_col
	addi $t6, $t6, -1				#change the cursor's col location
	j valid_cursor
cursor_right:
	beq $s3, 9, invalid_user_input		#if cursor col ==9 => exit
	addi $s3, $s3, 1					#cursor col++
	sw $s3, cursor_col
	addi $t6, $t6, 1				#change the cursor's col location
	j valid_cursor
valid_cursor : 
	move $a0, $s2		#$a0 row
	move $a1, $s3		#$a1 col
	move $t7, $s3
	li $a2, 0x00		#$a2 no character
	li $a3, 0x0 			#li $t6, 0xb0		#yello backgouround - for ground : unmodified
	addi $sp, $sp, -4
	li $s3, 0xb
	sw $s3, 0($sp)	#save the fifth argument into stack
	
	jal set_cell		# go to set cell
	addi $sp, $sp, 4
	#original cursor
	sub $s2, $s2, $t5	#$s2 original cursor i
	move $s3, $t7
	sub $s3, $s3, $t6	#$s3 original cursor j
	
	li $t0, 10	#$t0 = 10
	mul $t0, $s2, $t0		#i*10
	add $t0, $t0, $s3		#i*j
	add $s0, $s0, $t0	#move pointer
	lb $t1, 0($s0)		#pop the value
	sub $s0, $s0, $t0	
	
	move $a0, $s2
	move $a1, $s3
	
	andi $t2, $t1, 0x40	#check it is reveal
	bnez $t2, recover_reveal_cell# valid_user_input
	andi $t2, $t1, 0x10
	bnez $t2, recover_flag_cell	#flag cell
	
	#hidden Cell	
	li $a2, 0x00
	li $a3, 0x0
	addi $sp, $sp, -4
	li $s3, 0x7
	sw $s3, 0($sp)
	jal set_cell
	addi $sp, $sp, 4
	j valid_user_input	
	#######$$ save fifth argument  for setting cell
recover_reveal_cell:
	andi $t2, $t1, 0xf
	bnez $t2, recover_num_cell
	li $a2, 0x00
	li $a3, 0xf
	addi $sp, $sp, -4
	li $s3, 0x0
	sw $s3, 0($sp)
	jal set_cell
	addi $sp, $sp, 4
	j valid_user_input
recover_num_cell:
	move $a2, $t2
	addi $a2, $a2, 48	#add '0'
	li $a3, 13	#bright Magenta
	li $s3, 0	#black
	addi $sp, $sp, -4
	sw $s3, 0($sp)	#save the fifth argument into stack
	jal set_cell
	addi $sp, $sp, 4
	j valid_user_input
recover_flag_cell:
	li $a2, 0x46
	li $a3, 12
	addi $sp, $sp, -4
	li $s3, 0x7
	sw $s3, 0($sp)
	jal set_cell
	addi $sp, $sp, 4
	j valid_user_input
mark_flag:
	li $t0, 10
	mul $t0, $s2, $t0			#$t0 = i*10
	add $t0, $t0, $s3			#$t0 = i*10+j
	add $s0, $s0, $t0		#move the pointer
	lb $t1, 0($s0)			#$t1 = value in cursor cell
	sub $s0, $s0, $t0		#move original address in cell_array
	andi $t2, $t1, 0x40 		#check cell is reveal 
	bnez $t2, invalid_user_input	#if cell is already revealed => error.
	andi $t2, $t1, 0x10		#check cell is already marked with flag
	bnez $t2, already_flag		#if $t2 is not 0 => already _flaged to remove flag
	addi $t1, $t1, 0x10
	add $a0, $a0, $t0		
	sb $t1, 0($a0)			#change the value in the cell to flag
	sub $a0, $a0, $t0		#return to original address
	
	move $a0, $s2		#$a0 - row
	move $a1, $s3		#$a1 = col
	li $a2, 0x46		#set 'f'
	li $a3, 0xc			#set blue color for foreground
	li $s3, 0xb			#set gray color for background
	addi $sp, $sp, -4		
	sw $s3, 0($sp)
	jal set_cell			#call set_Cell
	addi $sp, $sp, 4
	j valid_user_input 	
already_flag:
	li $t3, 0x10			#$t3 = 0001000
	sub $t1, $t1, $t3		#remove flag by value - 0001000(flag cell)
	add $a0, $a0, $t0	#move cell_array pointer
	sb $t1, 0($a0)		#save changed cell
	sub $a0, $a0, $t0	#move orignally
	
	move $a0, $s2		#$a0 row
	move $a1, $s3		#$a1 col
	move $t7, $s3
	li $a2, 0x00		#$a2 no character
	li $a3, 0x0 			#li $t6, 0xb0		#yello backgouround - for ground : unmodified
	addi $sp, $sp, -4
	li $s3, 0xb
	jal set_cell
	addi $sp, $sp, 4
	j valid_user_input
	
reveal_the_cell:
	li $t0, 10
	mul $t0, $s2, $t0			#$t0 = i*10
	add $t0, $t0, $s3			#$t0 = i*10+j
	add $s0, $s0, $t0		#move the pointer
	lb $t1, 0($s0)			#$t1 = value in cursor cell
	sub $s0, $s0, $t0		#move original address in cell_array
	andi $t2, $t1, 0x40 		#check cell is reveal 
	bnez $t2, invalid_user_input	#if cell is already revealed => error.
	addi $t1, $t1, 0x40	#give the reveal cell
	add $a0, $a0, $t0	#advance by cursor cell
	sb $t1, 0($a0)		#change the value in the cell with reveal
	sub $a0, $a0, $t0	#return to orignal adress
	###Why I add this statement ? move $a1, $s2		#$a1 = row
	###Why I add this statement ? move $a2, $s3		#$a3 = col
	andi $t2, $t1, 0x20	#To check the cell has bomb
	bnez $t2, contain_bomb
	andi $t2, $t1, 0x10	#check this cell has flag
	bnez $t2, reveal_flag_cell	#if cell already has flag go to delete flag
continue_after_check_flag :
	andi $t2, $t1, 0xf	#check this cell is only number
	bnez $t2, reveal_num_cell
	
	move $a0, $s2		#$a0 - row
	move $a1, $s3		#$a1 = col
	li $a2, 0x00		#set 'null'
	li $a3, 0xf			#set white color for foreground
	move $s5, $s3
	li $s3, 0x0			#set black color for background
	addi $sp, $sp, -4		
	sw $s3, 0($sp)
	jal set_cell			#call set_Cell
	addi $sp, $sp, 4
	move $s3, $s5
	move $a0, $s0		#normal cell
	move $a1, $s2
	move $a2, $s3
	
	jal search_cells		#search cell have to return to valid _user_input
	
	j valid_user_input	#when search_cell is made, delete it
contain_bomb:
	move $a0, $s2		#$a0 - row
	move $a1, $s3		#$a1 = col
	li $a2, 0x45		#set 'e'
	li $a3, 0xf			#set white color for foreground
	li $s3, 0x9			#set red color for background
	addi $sp, $sp, -4		
	sw $s3, 0($sp)
	jal set_cell			#call set_Cell
	addi $sp, $sp, 4
	#jal search_cells		doesn' have to excute search_cell
	j valid_user_input	#when search cell is made, delete it
reveal_flag_cell:
	li $t3, 0x10			#$t3 = 0001000
	sub $t1, $t1, $t3		#remove flag by value - 0001000(flag cell)
	add $a0, $a0, $t0	#move cell_array pointer
	sb $t1, 0($a0)		#save changed cell
	sub $a0, $a0, $t0	#move orignally
	j continue_after_check_flag
reveal_num_cell:
	move $a0, $s2		#$a0 - row
	move $a1, $s3		#$a1 = col
	move $a2, $t2		#set number
	addi $a2, $a2, 48	#num+'0'
	li $a3, 0xd			#set bright magenda color for foreground
	li $s3, 0x0			#set black color for background
	addi $sp, $sp, -4		
	sw $s3, 0($sp)
	jal set_cell			#call set_Cell
	addi $sp, $sp, 4
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	#jal search_cells
	 
	j valid_user_input	#when search cell is made, delete it		
invalid_user_input: 
    li $v0, -1
    j finish_perform_action
valid_user_input:    
    li $v0, 0
finish_perform_action:
    lw $s5, 36($sp)
    lw $s4, 32($sp)
    lw $a2, 28($sp)
    lw $a1, 24($sp)
    lw $a0, 20($sp)
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 40
    jr $ra

game_status:
    #Define your code here
    ############################################
    #$a0 = cell_arrays
    # #num of bomb cell = num of bomb cell&&flagcell = > win
    # if there are bomb cell&&exlplode cell = > lose
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0	#$s0 = argument
    li $t0, 0		# i =0
    li $t1, 0		# j =0
    li $s2, 0		#bomb counter
    li $s3, 0		#bomb and flag counter
    li $t8, 0 		#count flag
search_whole_cell_row: 
	bgt $t0, 9, exit_search_whole_cell_row	#if i > 9 => exit
	li $t1, 0	#j = 0
search_whole_cell_col:
	bgt $t1, 9, exit_search_whole_cell_col	#if j>9 -> exit
	li $t2, 10
	mul $t2, $t0, $t2		#i*10
	add $t2, $t2, $t1		#i*10+j
	add $s0, $s0, $t2	#move pointer by coordinator
	lb $s1, 0($s0)		#$s1 saves the information of a cell
	sub $s0, $s0, $t2	#move back pointer orignally
	andi $t2, $s1, 0x20	#check bomb
	bnez $t2, increase_bomb_count	#$t2 is not zero go to increase bomb count

back_from_increase_bomb_count:	
	andi $t2, $s1, 0x10	#check flag
	bnez $t2, increase_flag_count

back_from_increase_flag_count:
	addi $t1, $t1, 1
	j search_whole_cell_col	#back to first col loop
exit_search_whole_cell_col:
	addi $t0, $t0, 1
	j search_whole_cell_row
exit_search_whole_cell_row:
		beq $s2, $s3, check_win
after_check_win:
	j finish_with_ongoing

increase_bomb_count:
	addi $s2, $s2, 1		#bomb count ++
	################ if this cell is revealed => go to lose###############
	andi $t2, $s1, 0x40
	bnez $t2, finish_with_lose		#if the bomb cell was revealed, you lose.
	j back_from_increase_bomb_count	
increase_flag_count:
	addi $t8, $t8, 1	#flag count++
	andi $t2, $s1, 0x20	#bomb
	bnez $t2, flag_with_bomb
	j back_from_increase_flag_count
flag_with_bomb:
	addi $s3, $s3, 1	#bomb&flag count++
	j back_from_increase_flag_count
check_win:
	beq $s2, $t8, finish_with_win
	j after_check_win
    ##########################################
finish_with_win:
	li $v0, 1
	j finish_status
finish_with_lose:
	li $v0, -1
	j finish_status
finish_with_ongoing:
	li $v0, 0 
	j finish_status
finish_status:    
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
#$a0 cell_arrays, $a1 row, $a2 col
    addi $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp) 
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    
    move $fp, $sp		#fp  = the stack pointer
    move $s0, $a0	# = array
    move $s1, $a1	#$a1 = row
    move $s2, $a2	#$s2 = col
    addi $sp, $sp, -8
    sw $s1, 0($sp)			#push row
    sw $s2, 4($sp)		#sp.push(col)
search_cells_loop:
	beq $fp, $sp, exit_search_cell_loop	#while(sp!=fp)
	lw $s2, 4($sp)	#col
	lw $s1, 0($sp)	#row
	addi $sp, $sp, 8
	
	#move $t0, $s1	#row = $sp.pop
	#move $t1, $s2	#col = $sp.pop
	
	li $t2, 10
	mul $t2, $s1, $t2
	add $t2, $t2, $s2
	add $s0, $s0, $t2	#move pointer of cell array
	lb $s3, 0($s0)		#$t3 is value of the location's
	andi $t4, $s3, 0x10
	beqz $t4, reveal_cell_in_search_cells	#if(!cell[row][col].isFlag()) = > cell[row][col].reveal();
	sub $s0, $s0, $t2
back_to_search_cells_loop:
	#move $t0, $s1	#row = $sp.pop
	#move $t1, $s2	#col = $sp.pop
	andi $t4, $s3, 0xf	#compare the numbercell
	bnez $t4, search_cells_loop		#if(cell[row][col].getNumber()==0){ => this satement if false => go to loop agian
first_if:
	#if(row+1&&cell[row+1][col].isHidden()&&!cell[row+1][col].isFlag()){
	
	move $t5, $s1
	addi $t5, $t5,1	#row+1
	bge $t5, 10, second_if		#row+1<10 = false => second_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row+1]
	add $t6, $t6, $s2		#[row+1][col]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row+1][col]
	sub $s0, $s0, $t6		
	andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, second_if	#cell[row+1][col].hidden() =false => second_if#######################
	
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, second_if	#cell[row+1][col].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, second_if	#!cell[row+1][col].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row+1)
    	sw $s2, 4($sp)		#sp.push(col)
second_if:
	#if(col+1<10&&cell[row][col+1].isHidden()&&!cell[row][col+1].isFlag()){
	
	
	move $t5, $s2
	addi $t5, $t5, 1	#col+1
	bge $t5, 10, third_if		#col+1<10 = false => second_if
	
	li $t6, 10
	mul $t6, $s1, $t6		#[row]
	add $t6, $t6, $t5		#[row][col+1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row][col+1]
	sub $s0, $s0, $t6		
	
	andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, third_if	#cell[row+1][col].hidden() =false => second_if#######################
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, third_if	#cell[row][col+1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, third_if	#!cell[row][col+1].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $s1, 0($sp)			#sp.push(row)
    	sw $t5, 4($sp)		#sp.push(col+1)

third_if:
	#if(row-1>=0&& cell[row-1][col].isHidden()&&!cell[row-1][col].isFlag()){
	
	
	move $t5, $s1
	addi $t5, $t5,-1	#row-1
	blt $t5, 0, forth_if		#row-1>=10 = false => second_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row-1]
	add $t6, $t6, $s2		#[row-1][col]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row-1][col]
	sub $s0, $s0, $t6
		andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, forth_if	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, forth_if	#cell[row-1][col].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, forth_if	#!cell[row-1][col].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row-1)
    	sw $s2, 4($sp)		#sp.push(col)
   	
forth_if:
	
	
	#if(col-1<10&&cell[row][col-1].isHidden()&&!cell[row][col-1].isFlag()){
	move $t5, $s2
	addi $t5, $t5, -1	#col-1
	blt $t5, 0, fifth_if		#col-1>=0 = false => second_if
	
	li $t6, 10
	mul $t6, $s1, $t6		#[row]
	add $t6, $t6, $t5		#[row][col-1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row][col-1]
	sub $s0, $s0, $t6
		andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, fifth_if	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, fifth_if	#cell[row][col-1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, fifth_if	#!cell[row][col-1].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $s1, 0($sp)			#sp.push(row)
    	sw $t5, 4($sp)		#sp.push(col-1)
fifth_if:
	
	
	#if((row-1>=0&&col-1>=0)&&cell[row-1][col-1].isHidden()&&!cell[row-1][col-1].isFlag()){
	move $t5, $s1
	addi $t5, $t5,-1	#row-1
	blt $t5, 0, sixth_if		#row-1>=0 = false => second_if
	
	move $t8, $s2
	addi $t8, $t8, -1	#col-1
	blt $t8, 0, sixth_if		#col-1>=0	= false => sixth_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row-1]
	add $t6, $t6, $t8		#[row-1][col-1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row-1][col-1]
	sub $s0, $s0, $t6
	
	andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, sixth_if	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, sixth_if	#cell[row-1][col-1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, sixth_if	#!cell[row-1][col-1].isFlag() =false => second_if 
	

	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row-1)
    	sw $t8, 4($sp)		#sp.push(col-1)

sixth_if:
	
	
	#if((row-1>=0&&col+1<10)&&cell[row-1][col+1].isHidden()&&!cell[row-1][col+1].isFlag()){
	move $t5, $s1
	addi $t5, $t5,-1	#row-1
	blt $t5, 0, seventh_if		#row-1>=0 = false => second_if
	
	move $t8, $s2
	addi $t8, $t8, 1	#col+1
	bge $t8, 10, seventh_if		#col+1<10	= false => sixth_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row-1]
	add $t6, $t6, $t8		#[row-1][col+1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row-1][col+1]
	sub $s0, $s0, $t6
		andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, seventh_if	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, seventh_if	#cell[row-1][col+1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6, seventh_if	#!cell[row-1][col+1].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row-1)
    	sw $t8, 4($sp)		#sp.push(col+1)   

seventh_if:
	
	
	  #if((row+1>=0&&col-1>=0)&&cell[row+1][col-1].isHidden()&&!cell[row+1][col-1].isFlag()){
	move $t5, $s1
	addi $t5, $t5,1	#row+1
	bge $t5, 10, eighth_if		#row+1>=0 = false => second_if
	
	move $t8, $s2
	addi $t8, $t8, -1	#col-1
	blt $t8, 0, eighth_if		#col-1>=0	= false => sixth_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row+1]
	add $t6, $t6, $t8		#[row+1][col-1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row+1][col-1]
	sub $s0, $s0, $t6
		andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, eighth_if	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, eighth_if	#cell[row+1][col-1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6,  eighth_if	#!cell[row+1][col-1].isFlag() =false => second_if 
	
	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row+1)
    	sw $t8, 4($sp)		#sp.push(col-1) 
eighth_if:
	
	
	 #if((row+1>=0&&col+1>=0)&&cell[row+1][col+1].isHidden()&&!cell[row+1][col+1].isFlag()){
	move $t5, $s1
	addi $t5, $t5,1	#row+1
	bge $t5, 10, search_cells_loop		#row+1>=0 = false => second_if
	
	move $t8, $s2
	addi $t8, $t8, 1	#col+1
	bge $t8, 10, search_cells_loop		#col+1>=0	= false => sixth_if
	
	li $t6, 10
	mul $t6, $t5, $t6		#[row+1]
	add $t6, $t6, $t8		#[row+1][col+1]
	add $s0, $s0, $t6	#advance the pointer
	lb $t7, 0($s0)		#$t7 is the value of cell[row+1][col+1]
	sub $s0, $s0, $t6
		andi $t6, $t7, 0x20	#is bomb?	###########################
	bnez $t6, search_cells_loop	#cell[row+1][col].hidden() =false => second_if#######################		
	andi $t6, $t7, 0x40	#is reavel?
	bnez $t6, search_cells_loop	#cell[row+1][col+1].hidden() =false => second_if
	
	andi $t6, $t7, 0x10	#is flaged?
	bnez $t6,  search_cells_loop	#!cell[row+1][col+1].isFlag() =false => second_if 
	
	
	
	addi $sp, $sp, -8
    	sw $t5, 0($sp)			#sp.push(row+1)
    	sw $t8, 4($sp)		#sp.push(col+1) 
	j search_cells_loop
	
reveal_cell_in_search_cells : 
	sub $s0, $s0, $t2
	andi $t4, $s3, 0x40
	bnez $t4, back_to_search_cells_loop
	addi $s3, $s3, 0x40	#give reveal()
	add $s0, $s0, $t2
	sb $s3, 0($s0)		#cell[row][cell].reveal()
	sub $s0, $s0, $t2
	move $s4, $s3
	
	andi $t4, $s3, 0x0f
	bnez $t4, num_cell_in_search
	
	move $a0, $s1
	move $a1, $s2
	li $a2, 0x0
	li $a3, 0x0f
	addi $sp, $sp, -4
	li $s3, 0x00
	sw $s3, 0($sp)
	jal set_cell
	addi $sp, $sp, 4
	move $s3, $s4
	
	j  back_to_search_cells_loop
num_cell_in_search:
  	move $a0, $s1
	move $a1, $s2
	addi $t4, $t4, 48
	move $a2, $t4 
	
	li $a3, 0x0d
	addi $sp, $sp, -4
	li $s3, 0x00
	sw $s3, 0($sp)
	jal set_cell
	addi $sp, $sp, 4
	move $s3, $s4
	
	j  back_to_search_cells_loop
exit_search_cell_loop:
	#left 
    lw $s7, 32($sp)
    lw $s6, 28($sp)
    lw $s5, 24($sp)
    lw $s4, 20($sp)
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 36
    
    jr $ra	

    


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cursor_row: .word 0
cursor_col: .word 0
size_row : .word 10
size_col : .word 10
filename23: .asciiz "map2.txt"
			 #.space 200 		#initialize the matrix
input_buf : .space 300
coordinate_num : .space 200
star : .asciiz "**********\n"
#place any additional data declarations here


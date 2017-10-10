.data
.text
.globl main

main:
	li $a0, 10
	li $a1, 1
	li $a2, 0xb
	li $a3, 6
	li $t0, 3
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal set_cell
	move $a0, $v0
	li $v0, 1
	syscall
	
.include "hw3.asm"

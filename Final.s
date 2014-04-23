.data 							# data section
	msg0: 	 .asciiz "Press 0 for new user, and 1 for return user: \n"
	msg1: 	 .asciiz "Input username: \n"
	msg2: 	 .asciiz "User password: \n"
	msg3: 	 .asciiz "Input security question: \n"
	msg4: 	 .asciiz "Welcome to system, username:  "
	msg5: 	 .asciiz "Input username: \n"
	msg6: 	 .asciiz "Incorrect password! \n"
	msg7: 	 .asciiz "Input answer to security question: \n"
	msg8: 	 .asciiz "Input password: \n"
	msg9: 	 .asciiz "Press 0 to try to login again , and 1 to recover passowrd: \n"
	newline: .asciiz "\n"

	new_user: 		.word	4
	try_question: 	.word	4
	username: 		.word 	4
	try_username: 	.word 	4
	user_password: 	.word 	4
	try_password: 	.word 	4
	user_answer: 	.word 	4
	try_answer: 	.word 	4
	user_question: 	.word 	8	
	
	start: 			.word	0x00400000
	

	

	.text
	.globl _start
	_start:
main:
	return_dest_2:
		li $v0, 4			#Asks if the user has an account or not
		la $a0, msg0
		syscall

		li $v0, 5			#Decides whether or not to prompt for login
		syscall
		sw $v0, new_user
		

		li $t1, 1
		lw $t3, new_user
		beq $0, $t3, setup
		beq $t1, $t3, returning_user
		j end

setup:
		
		
		li $v0, 4			#Asks user for username
		la $a0, msg1
		syscall

		li $v0, 8			#Takes user input for username
		la $a0, username
		syscall

		li $v0, 4			#Asks user for password
		la $a0, msg8
		syscall

		li $v0, 8			#Takes user input for password
		la $a0, user_password
		syscall

		addi $t1, $0, 1   	#Use this as placeholder 1. Password print will return here once password is printed back to the user
		j	password_print
		return_dest_1:		#The location we jump back to 
		li $t1, 0 			#Clears the t1 register


		li $v0, 4			#Asks user for security question
		la $a0, msg3
		syscall

		li $v0, 8			#Takes user input for security question
		la $a0, user_question
		syscall

		li $v0, 4			#Asks user for answer to the security question
		la $a0, msg7
		syscall

		li $v0, 8			#Takes user input for the answer to the security question
		la $a0, user_answer
		syscall

		j main


returning_user:

		li $v0, 4			#Asks user for username
		la $a0, msg5
		syscall

		li $v0, 8			#Takes user input for username
		la $a0, try_username
		syscall

		lw $t5, try_username
		lw $t6, username

		bne $t5, $t6, denied
		
		li $v0, 4			#Asks user for password
		la $a0, msg8
		syscall

		li $v0, 8			#Takes user input for password
		la $a0, try_password
		syscall

		lw $t5, try_password
		lw $t6, user_password

		bne $t5, $t6, denied
		beq $t5, $t6, welcome



denied:

		li $v0, 4			
		la $a0, msg6		#Incorrect password
		syscall

		li $v0, 4			
		la $a0, msg9		#Asks if the user wants to try to recover the password	
		syscall

		li $v0, 5	
		syscall
		sw $v0, try_question	#Takes input if user wants to try to recover the password	
		
		lw $t4, try_question

		bne $0, $t4, password_recovery
		beq  $0, $t4, returning_user

		addi $t2, $t2, 1
		beq $t2, 5, end

		j denied

welcome:
		li $v0, 4			
		la $a0, msg4		#Welcomes user to system
		syscall

		li $v0, 4			
		la $a0, username		#Prints username
		syscall

		li $v0, 4			
		la $a0, newline		#Goes to next line
		syscall

		j end

password_recovery:
		li $v0, 4				
		la $a0, msg7		#Asks user for answer to security question
		syscall

		li $v0, 8			
		la $a0, try_answer #Takes user answer to security question
		syscall

		addi $t1, $0, 2   	#Use this as placeholder 2. Password print will return to main if called from here

		lw $t7, try_answer
		lw $t8, user_answer

		bne $t7, $t8, denied
		beq $t7, $t8, password_print
		j end


password_print:
		li $v0, 4
		la $a0, msg2		
		syscall

		la $a0, user_password #Prints user password back
		li $v0, 4
		syscall
 
		beq $t1, 1, return_dest_1 #if t1 is from the 1st return location, sets t0 to 1 then jumps back
		beq $t1, 2, return_dest_2
		j main

end:
		li	$v0, 10		
		syscall		


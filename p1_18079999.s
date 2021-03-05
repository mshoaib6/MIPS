#################################################################
# File: p1_18079999.s                                           #
#                                                               #
# This program is to perform three conversions, decimal to      #
# binary, decimal to quaternary and decimal to octal.           #
# It first asks to input a decimal integer through the          #
# console and then does the calculations.  Finally, it prints   #
# out the results on the console.                               #
# The program only runs for non negative integer, as stated by  #
# the requirements of the assignment.                           #
# The program is programmed to calculate the binary number      #
# first, and then it moves on to converting to quaternary and   #
# octal. Then the programme will ask the user to either         #
# continue by entering 1 or quit by entering 0.                 #
#################################################################

####################
# The data segment #
####################
	
    .data

# Create and initialise an array
# The array can store 32 integers
# The array is initialised to all 0s

resultArray:     .word 0:32

# Create some null terminated strings which are to be used in the program

strPromptFirst:  .asciiz "Enter a number: "
strPromptSecond: .asciiz "\n\nInput number is "
strPromptThird:  .asciiz "\n\nContinue? (1=Yes/0=No) "
strBye:          .asciiz "\nBye!\n"
strBinary:       .asciiz "\n\nBinary: "
strQuaternary:   .asciiz "\nQuaternary: "
strOctal:        .asciiz "\nOctal: "
strSpace:        .asciiz " "

###############################################
# The text segment -- instructions start here #
###############################################

    .text
    .globl main

main:
	#user will be prompted to input the number
	li $v0, 4
	la $a0, strPromptFirst
	syscall
	
	#user will enter the number
	li $v0, 5
	syscall
	move $t0, $v0
	
	#will print the number entered by the user
	la $a0, strPromptSecond
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	#will print the strBinary string
	li $v0, 4
	la $a0, strBinary
	syscall
	
	#initialise constant number 2 and store it in the register $t2
	#this would be later used in the calculation of binary result
	li $t1, 2
	
resultsCalculation:

	#initialising array index
    move $t2, $zero
    
    #to make a copy of the original number to be manipulated
	move $t3, $t0
	
beginConversion:

	#loop runs until content of $t3 becomes zero or less
	ble $t3, $zero, finishConversion
	
	#calculation of remainders and their storage in array
	#updating $t3 to contain the quotient only after division
	div $t3, $t1
	mflo $t3
	mfhi $t4
	sw $t4, resultArray($t2)
	addi $t2, $t2, 4
	
	#looping back to check condition
	j beginConversion
	
finishConversion:
	
	#counter for digit spacing
	li $t5, 1
	
    beq $t1, 2, indexForBinary
    beq $t1, 4, indexForQuater
    beq $t1, 8, indexForOctal

indexForBinary:

	#initialising the index of array from where the values are to be printed
	#for binary, we start from the last one 
	
	li $t2, 124
	j printArrayNow
	
indexForQuater:

	#initialising the index of array from where the values are to be printed
	#for quaternary, we start from the mid
	
	li $t2, 60             # index of the array
	j printArrayNow

indexForOctal:
	
	#initialising the index of array from where the values are to be printed
	#for octal, we print 3 blocks of 4 numbers
	
	li $t2, 44             # index of the array
	
printArrayNow:
	
	#start to print array from back, and decrease index accordingly
	#if the contents of register $t3 become less than 0, stop printing 
	#otherwise, the array index will go out of bound
	
	blt $t2, $zero, finishPrintingArray
	lw $a0, resultArray($t2)
	li $v0, 1
	syscall
	
printASpace:

	#print a space
	bne $t5, 4, nextElementToPrint
	la $a0, strSpace
	li $v0, 4
	syscall
	
	#make t5 0 again
	li $t5, 0
	
nextElementToPrint:

	#increment in the counter used for spacing
	addi $t5, $t5, 1
	
	#decrement of index
	addi $t2, $t2, -4
	
	j printArrayNow

finishPrintingArray:
	
	#set index to 0 again
	li $t2, 0
	
	resetArrayElements:
		
		#start resetting array elements to 0
		beq $t2, 128, endReset
		sw $zero, resultArray($t2)
		addi $t2, $t2, 4
		j resetArrayElements
		
	endReset:
		
		#if $t1 contained 2, then binary conversion has already been done
		#time to move to quaternary conversion now
		beq $t1, 2, convertToQuaternary
		
		#if $t1 contained 4, then quaternary conversion has already been done
		#time to move to octal conversion now
		beq $t1, 4, convertToOctal
		
		#prompt to ask if user wants to continue
		li $v0, 4
		la $a0, strPromptThird
		syscall
		
		#take user input, 0 or 1.
		li $v0, 5
		syscall
		move $t6, $v0
		
		#if user inputs 1, then go back to main, else quit the program
		beq $t6, 1, main
		j endProgram
		
convertToQuaternary:

	#print the string msg for Quaternary
	li $v0, 4
	la $a0, strQuaternary
	syscall
	
	#set t1 to 4 now, and convert to quaternary and print
	li $t1, 4
	j resultsCalculation
	
convertToOctal:

	#print the string msg for Quaternary
	li $v0, 4
	la $a0, strOctal
	syscall
	
	#set t1 to 8 now, and convert to octal and print
	li $t1, 8
	j resultsCalculation

endProgram:
		
	#print the string msg Bye 
	li $v0, 4
	la $a0, strBye
	syscall
	
	#end of program
	li $v0, 10
	syscall


##################
# End of Program #
##################

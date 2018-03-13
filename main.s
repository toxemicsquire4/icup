//For this assignment, you will do two things:
//First, the user will enter how many letters (a number 1 through 9) to
// convert into uppercase equivalents (without using toupper or cheats like that).
//The user will enter that many letters. You will then output each of those letters
// in upper case format. (If they were already uppercase, they shouldn't change).

//Second, you will write a for loop. The twist for this is that you can only use
// a *single register* to implement the for loop's variables to keep track of where it is
// and what the step size should be. (You can use other registers as normal to call
// the write syscall or to check for termination.) So not 3 registers like normally.
//The for loop will print out a diamond pattern like this:
// .
// ....
// .......
// ..........
// .......
// ....
// .
// The above represents a diamond of size == 4. The size you'll actually use
// will be equal to the original number input by the user up top in phase one.

.global _start
_start:
	//Print greeting
	MOV R0,#1		 @0 = stdin, 1 = stdout, 2 = stderr
	LDR R1,=greeting @Print from this string in the data segment
	MOV R2,#68       @68 characters to print
	MOV R7,#4		 @Choose the Write syscall (which is syscall 4)
	SWI 0			 @Syscall

	//Read from stdin one character

	MOV R0, #0		//TODO: finish this
	LDR R1,=number
	MOV R2, #2		//That is done
	MOV R7, #3
	SWI 0
/*	
	MOV R0, #1
	LDR R1, =number
	MOV R2, #2		@prints out Number value
	MOV R7, #4
	SWI 0
*/	

	
	//Convert that ASCII character to an integer of equal value
	/*												//THIS CODE WORKS EH BUT YOU KNOW IT WORKS
	LDR R4, =number
	LDRB R5, [R4] //makes R5 = r4[0]
	LDRB R6, [R4, #1]	//makes r6 = r4[1]
	SUB R5, R5, #48 //SHIT WORKS
	STRB R5, [R4, #0]
	STRB R6, [R4, #1]
	MOV R7, #10			
	STRB R7, [R4, #2]				//FUCK YOU YOURE AN ASS
	MOV R0, #1					//change number
	LDR R1, =number
        MOV R2, #3              @prints out Number value
        MOV R7, #4
        SWI 0*/
	//STR R4, [=number, 0]

	
	//Convert that ASCII character to an integer of equal value
	LDR R4, =number
	LDRB R5, [R4] //makes R5 = r4[0]
	LDRB R6, [R4, #1]       //makes r6 = r4[1]
	SUB R5, R5, #48 //SHIT WORKS

	MOV R5, R5 //THIS IS THE LIMIT COUNTER, DONT CHANGE THIS AT ALL
	ADD R5, R5, #1	//to account for the newline
	
	//Loop, read that many characters in, one at a time...
	
	
	MOV R0, #0
	LDR R1, =input
	MOV R2, R5      	        
	MOV R7, #3
	SWI 0		//String is now held within =input


	SUB R5, R5, #1 //Go back to original size of R5 b/c to keep limit counter straight
	MOV R5, R5 //THIS IS THE LIMIT COUNTER, DONT CHANGE THIS AT ALL
	LDR R4, =input
	MOV R6, #0
	CMP R5, #1
	

start_loop:	
	LDRB R7, [R4, R6]
	CMP R7, #91
	BLE skip_trans
	SUB R7, R7, #32
skip_trans:	
	STRB R7, [R4, R6]
	ADD R6, R6, #1
	CMP R6, R5
	BNE start_loop			//something is wrong here


	ADD R5, R5, #1 //add one to account for endline DUMBASS WHY IS IT CHANGED
	MOV R0, #1
	LDR R1, =input
	MOV R2, R5          @prints out Number value
	MOV R7, #4
	SWI 0

	
	


done:	
		//For each character read, uppercaseify it
		//Use a bitwise operation to do so

		//And output it

	//Now print out a diamond as described above //T
	SUB R5, R5, #1 //go back to original value
	//MOV R5, #4
	MOV R6, #1
	MOV R3, #0
	CMP R5, #1
	BEQ size_one

start1:	
	MOV R0, #1
	LDR R1, =dots //WTF IS THIS DUMB ASS SHIT NOT WORKING
	MOV R2, R6
	MOV R7, #4
	SWI 0			
	ADD R6, R6, #3
	ADD R3, R3, #1
	BAL endl
return_from_endl:	
	CMP R3, R5
	BNE start1
	BAL Done



endl:	
	MOV R0, #1
	LDR R1, =endline
	MOV R2, #1
	MOV R7, #4
	SWI 0
	BAL return_from_endl
	

Done:

	MOV R2, #3
	SUB R3, R5, #1
	MUL R6, R5, R2
	SUB R6, R6, #5
start2:	
	MOV R0, #1
	LDR R1, =dots
	MOV R2, R6
	MOV R7, #4
	SWI 0
	SUB R6, R6, #3
	SUB R3, R3, #1
	BAL endl2
return_from_endl2:
	CMP R3, #0
	BNE start2
	BAL done2
endl2:
	MOV R0, #1
	LDR R1, =endline		//check endl data
	MOV R2, #1
	MOV R7, #4
	SWI 0
	BAL return_from_endl2



done2:	
	BAL quit
size_one:	
	MOV R0, #1
	LDR R1, =dots
	MOV R2, #1
	MOV R7, #4
	SWI 0
	LDR R1, =endline
	SWI 0
	
quit:
	MOV R7,#1		@Exit Syscall
	SWI 0


.data
	greeting: .ascii "Please enter how many letters you would like to uppercaseify (1-9):\n"
	number:	 .ascii " " 		//DO NOT USE
	input: .ascii "                                                                                                     "
	dots: .ascii "................................................................................"
	endline: .ascii "\n"			// added this b/c dumb user wouldn't do input correctly
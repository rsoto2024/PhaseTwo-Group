/*Rebeca Soto, Mathew L, Amanuel- Group 5
Phase Two, Part A */

.global _start

						
.data
	mem_number: .word 12
	div_result: .byte

						@user hardcodes two values into Register R4 and R5 in  
.text
_start:
	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0

	ADD R0, R4, R5			@R0 has the result of the addition
	MUL R1, R4, R5  		@R1 stores the result of multiplication				
	BVS Overflow_error		@checks if overflow occurred
	Overflow_error:
					@the product is larger than the registers can handle
	CMP R5, #0
	BEQ divisor_cantbe_zero
divisor_cantbe_zero:			@division by zero is an error
	MOV R0, #0
	MOV R2, R4
	B divlooptest
divloop:
	ADD R0, R0, #1			@increase counter / solution by 1
	SUB R2, R2, R5			@16-2
	
divlooptest:
	CMP R2, r5
	BGE divloop	

	LDR R1, =div_result		@load memory address into R1
	STR R0, [R1]			@Stores the quotient in the memmory location div_result


					@Using Bitwise operations AND, OR, XOR and shift operations
	MOV R8, #0x92 			@Move the binary digits of Ox92 into R8
	MOV R9, #0x80 			@Move the binary digits of Ox80 into R9
	EOR R10, R8, R9 		@Use XOR logic to isolate bits 2 and 5
	LSL R11, #3 			@Shift the 2nd bit to the most significant bit
	LSR R11, #4 			@Shift 4 digits to the right
	ORR R11, #0xF6 			@changes all 0 bits to 1
	AND R11, #0x55 			@changes the bit pattern to 

						@Addressing mode demonstrations
						@Register to Register, memory to register and vice versa
	MOV R12, R1			@moves the value in R1 to R12
	LDR R12, =mem_number		@loads memory address of mem_number to R12
	LDR R12, [R12]			@loads the value at the memory address to register 12
	STR R12, [R11]			@store the value from R12 at the memory address in R11

						@Stack operations
	SUB sp, sp, #4			@allocates space for the SP
	LDR R1, [sp]			@R1 is copied to that allocated memory and its address
	STR R1, [sp]  			@memory from the top is added back to R1 
	ADD sp, sp, #4 			@stack pointer moves by 4 bytes, deallocating memory
	PUSH {R7, R8}			@stores the registers on the stack
	POP {R7, R8}			@loads the previously allocated memory to the stack


	B end
end:



/*Some of part C
Amanuel B, Mathew L, Rebeca S
*/.global main
.data 
myarray: .word 1,2,3,4,5
myarraysize: .word 5
.text 
@Input: R0 = array address, R1 =array size
@Output: R0 = min, R1 = max, R2 = sum


main:
	LDR R0, =myarray			@Load base address of myarray
	LDR R1, =myarraysize	
	LDR R1, [R1]				@Array size 
	MOV R2, #0				@Initialized to zero, loop counter
	MOV R4, #0				@Sum in array_stats
	MOV R5, #0				@temp current max
	MOV R6, #0				@@temp min
	
	PUSH {R0, R1}				@Preserve R0-R1
	
	BL looptest
	B end

looptest:
	CMP R2, R1
	BGE end					@Branches when the loop has processed the array
	B loop
 
loop:
	LDR R3,[R0, R2, LSL #2] @Loop through array elements
	ADD R2, R2, #1				@updates the loop counter
	BL array_stats
	B looptest


@---------------------------------------------------------------------------------------------------
array_stats:
	BL sum
	BL max
	BL set_min_a
	BL min
	CMP R2, R1
	BEQ array_stats_values
	B loop
@------------------------
sum:
	//PUSH {R4}				@using R4 in this function so preserving 
	ADD R4, R4, R3
	BX LR
@-------------------------
max:
	//PUSH {R5}
	CMP R3, R5 				@Determine MAX
	BGT found_max
	BX LR
	found_max:
	MOV R5, R3				@Outputs the max value of the array
	MOV PC, lr				@return to call min
@---------------------
min:
	CMP R6, #0
	BLE set_min_a
	CMP R3, R6				@Compares the current array element with the current max 
	BLE found_min
	BX LR
	set_min_a:	
	CMP R2, #1
	BEQ set_min_b
	BX LR

					@sets the temp min value to the first array element
set_min_b:
	MOV R6, R3
	BX LR
		
found_min:
	MOV R6, R3
	BX LR

@-----------------------------
array_stats_values:
	MOV R0,R6				@Holds the min value
	MOV R2, R4				@holds Sum of array
	MOV R1, R5				@holds the max value
	POP {R0, R1}
@--------------------
	
array_rotate:
	MOV R2, #1				@rotation amount
	MOV R3,	#0				@holds array values beginnig at first element to be shifted
	MOV R4, #0				@holds array value of the element to the right of the need to shift value
	MOV R5, #0				@points to the value R3, 1,2,3,4,5-increments by 1, starts at 0
	MOV R6, #1				@points to the value in R4, 
	MOV R7, #0				@Initialize the value to hold a value to be shifted 
	
	B looptest2

loop2:					@loops through the array with different values saved in different holders
	LDR R3, [R0, R5, LSL #2]@holds elements 1,3,5 after each loop, r5 is incremented
	BL s_hold
	BL store_toright
	ADD R6, R6, #2				@increment R6(1) by 1, move to element 2,4,
	ADD R5, R5, #2				@increment R5(0) by 1, move to element 1,3,5
	B looptest2

looptest2:
	CMP R6, R1
	BGT end
	B loop2

store_toright:
	CMP R6, R1
	BGE store_last
	LDR R4,[R0,R6, LSL #2]			@loads the values to be replaced, holds them until R5 points to the correct position(2,4,6)
	STR R3, [R0, R6, LSL #2]		@this array replaces index 0 to index 1(shifting right), index 1 was saved to register 4
	BX LR
	s_hold:	
	CMP R5, #0				@If it is not the firsl element we want to branch 
	BGT move_hold
	BX LR
	move_hold:					
	STR R4, [R0, R5, LSL #2]		@places displaced value where the next value was just removed
	BX LR

store_last:
	MOV R6, #0
	STR R3, [R0, R6, LSL #2]		@Store the last element in index 0
	B end

end:

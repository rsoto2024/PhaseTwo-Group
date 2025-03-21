   
   
   .data

array:	.word 3, -1, 2
arraysize: .word 3

    
	.text
	.global _start
	_start:
	LDR R0, =array
	LDR R1, =arraysize
	LDR R1, [R1]
	BL array_sort
	Bl array_search
	BL array_stats
	Bl array_rotate
	
.global sort
array_sort:
    PUSH {R4, R5, LR}       @ Save return address and preserve registers
    MOV R5, #1   					@1st element to put in temp, position is one ahead of R2, loop counter
	CMP R1, #1						@If array size is 1 element or less than 1 the sort is done
    BLE sort_done   				
	B outer_loop_test				@Branches to initiate sort 
outer_loop_test:
	CMP R5, R1						@before looping checks the loop counter is less than or equal to array size
	BGE sort_done
	B outer_loop					@If condition met branches to outer_loop
	
outer_loop:
    LDR R3, [R0, R5, LSL #2]      	@R3 will be temporary holder for element compared	
	MOV R2, R5						@Pass R2 as an argument
	CMP R2, #1						@If there are elements to the left to compare then branch to swap
	BGE sort

no_sort:
	ADD R5, R5, #1					@Increment loop counter and Moves on to the next element to the right ahead of R2 by one
	B outer_loop_test
sort:
	SUB R2, R2, #1					@will hold the number of elements to the left of R6 
	CMP R2, #0						@Determines whether there are elements to the left to compare
	BLT no_sort
	LDR R4, [R0, R2, LSL #2]    	@Load left element
	CMP R4, R3						@Compare left elements with element 1,
	BLE no_sort
	STR R4, [R0, R6, LSL #2]  		@sort to ascending order
	STR R3, [R0, R2, LSL #2]
	B sort
none_to_compare:
	ADD R5, R5, #1
	
sort_done:
    POP {R4, R5, LR}
    BX LR


.global array_search 
array_search:
	PUSH {R0, R1, lr}
    MOV R3, #0          @ Index counter = 0
	MOV R2, #2			@ search value
    MOV R4, #-1         @ Default return value (-1 if not found)

loop:
    CMP R1, #0			@Checks if the array size is at least one element
	BLE not_found		@if the array size is 0 or less, no element was found
    LDR R5, [R0, R3, LSL #2]   @ Load current element (word-sized)
    CMP R5, R2          @ Compare with search value
    BEQ found
    ADD R3, R3, #1      @ Increment index
    B loop

found:
    MOV R6, R3          @ Return index
	POP {R0, R1, lr}
    BX LR

not_found:
    MOV R0, R4          @ Return -1 (not found)
	POP {R0,R1, lr}
    BX LR
	
	
.global array_stats
@Input: R0 = array address, R1 =array size
@Output: R0 = min, R1 = max, R2 = sum
array_stats:
	MOV R2, #0				@Initialized to zero, loop counter
	MOV R4, #0				@Sum in array_stats
	MOV R5, #0				@temp current max
	MOV R6, #0				@@temp min
	BL looptest
loop_:
	LDR R3,[R0, R2, LSL #2] @Loop through array elements
	BL array_s
	B looptest
looptest:
	CMP R2, R1
	BGE end					@Branches when the loop has processed the array
	B loop_
array_s:
	BL sum
	BL max
	BL set_min_a
	BL min
	CMP R2, R1
	BEQ array_stats_values
	ADD R2, R2, #1			@updates the loop counter
	B loop_
sum:
	ADD R4, R4, R3
	BX LR
max:
	CMP R3, R5 				@Determine MAX
	BGT found_max
	BMI found_max			@Handles negative values
	BX LR
found_max:
	MOV R5, R3				@Outputs the max value of the array
	MOV PC, lr				@return to call min
min:
	CMP R6, R3				@Compares the current min valuewith itself and later with the next element
	BLE set_min_a
	CMP R3, R6				@Compares the current array element with the current max 
	BLE found_min
	BX LR
set_min_a:					@At the first iteration we are setting the 1st element as our temporary min
	CMP R2, #0
	BEQ set_min_b
	BX LR		
set_min_b:					@sets the temp min value to the first array element
	MOV R6, R3
	BX LR
found_min:
	MOV R6, R3
	BX LR
array_stats_values:
	MOV R0,R6				@Holds the min value
	MOV R2, R4				@holds Sum of array
	MOV R1, R5				@holds the max value
	BX LR
	
.global array_rotate	
array_rotate:
	PUSH {R4, R5, R6, R7,lr}
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
	ADD R6, R6, #2			@increment R6(1) by 1, move to element 2,4, ?
	ADD R5, R5, #2			@increment R5(0) by 1, move to element 1,3,5
	B looptest2

looptest2:
	CMP R6, R1
	BGT end
	B loop2

store_toright:
	CMP R6, R1
	BGE store_last
	LDR R4,[R0,R6, LSL #2]	@loads the values to be replaced, holds them until R5 points to the correct position(2,4,6)
	STR R3, [R0, R6, LSL #2]	@this array replaces index 0 to index 1(shifting right), index 1 was saved to register 4
	BX LR
s_hold:	
	CMP R5, #0					@If it is not the firsl element we want to branch 
	BGT move_hold
	BX LR
move_hold:					
	STR R4, [R0, R5, LSL #2]	@places displaced value where the next value was just removed
	BX LR

store_last:
	MOV R6, #0
	STR R3, [R0, R6, LSL #2]			@Store the last element in index 0
	B end

end:
	POP {R4, R5, R6, R7, lr}
	BX LR

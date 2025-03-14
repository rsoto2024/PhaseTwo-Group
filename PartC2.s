	.section .data
array:
    .byte 10, 20, 30, 40, 50, 60, 70, 80, 90 

	.section .text
	.global _start        

_start:
    LDR R0, =array  @ Load address of the array into R0
    MOV R1, #9      @ Array size 
    MOV R2, #40     @ Search value 

    BL array_search @ Call function

    @ Exit the program
    MOV R7, #1      
    SWI 0        

array_search:
    MOV R3, #0          @ Index counter = 0
    MOV R4, #-1         @ Default return value (-1 if not found)

loop:
    CMP R3, R1          
    BGE not_found       @ Check if R3(index counter) >= R1(array size). If yes, branch to not_found

    LDRB R5, [R0, R3]   @ Load into R5 a specified byte in array in R0, R3 determines which byte
    CMP R5, R2          @ Compare R5 with with search value
    BEQ found           @ If match, branch to found

    ADD R3, R3, #1      @ R3+1 into R3
    B loop              @ Continue loop

not_found:
    MOV R0, R4          @ Return -1
    BX LR               @ Return

found:
    MOV R0, R3          @ Return index i
    BX LR               @ Return
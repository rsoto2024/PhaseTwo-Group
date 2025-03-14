/* Some of part C
   Amanuel B, Mathew L, Rebeca S 
*/

.global main

.data
myarray:      .word 1,2,3,4,5
myarraysize:  .word 5

.text
@ Input:  R0 = array address, R1 = array size
@ Output: R0 = min, R1 = max, R2 = sum

main:
    LDR R0, =myarray         @ Load base address of myarray
    LDR R1, =myarraysize
    LDR R1, [R1]             @ Load array size
    MOV R2, #0               @ Initialize loop counter
    MOV R4, #0               @ Sum in array_stats
    MOV R5, #0               @ Temporary max
    MOV R6, #0               @ Temporary min
    PUSH {R0, R1}            @ Preserve R0-R1
    BL looptest
    B end

loop:
    LDR R3, [R0, R2, LSL #2] @ Load array element
    ADD R2, R2, #1           @ Update loop counter
    BL array_stats
    B looptest

looptest:
    CMP R2, R1
    BGE end                  @ Branch if loop is complete
    B loop

@ -------------------------------------------------------------------------------------
array_stats:
    BL sum
    BL max
    BL set_min_a
    BL min
    CMP R2, R1
    BEQ array_stats_values
    B loop

@ ------------------------ Sum Function ------------------------
sum:
    ADD R4, R4, R3           @ Add current value to sum
    BX LR

@ ------------------------ Max Function ------------------------
max:
    CMP R3, R5               @ Compare with current max
    BGT found_max
    BX LR

found_max:
    MOV R5, R3               @ Update max
    MOV PC, LR               @ Return

@ ------------------------ Min Function ------------------------
min:
    CMP R6, #0
    BLE set_min_a
    CMP R3, R6               @ Compare with current min
    BLE found_min
    BX LR

set_min_a:
    CMP R2, #1
    BEQ set_min_b
    BX LR

set_min_b:
    MOV R6, R3               @ Initialize min with first element
    BX LR

found_min:
    MOV R6, R3               @ Update min
    BX LR

@ ------------------------ Store Array Stats ------------------------
array_stats_values:
    MOV R0, R6               @ Store min value
    MOV R2, R4               @ Store sum
    MOV R1, R5               @ Store max
    POP {R0, R1}
    
@ ------------------------ Array Rotation ------------------------
array_rotate:
    MOV R2, #1               @ Rotation amount
    MOV R3, #0               @ Holds value to be shifted
    MOV R4, #0               @ Holds next value in shift
    MOV R5, #0               @ Points to shifting value
    MOV R6, #1               @ Points to next value
    MOV R7, #0               @ Temp hold
    B looptest2

loop2:
    LDR R3, [R0, R5, LSL #2] @ Load elements to shift
    BL s_hold
    BL store_toright
    ADD R6, R6, #2           @ Increment R6
    ADD R5, R5, #2           @ Increment R5
    B looptest2

looptest2:
    CMP R6, R1
    BGT end
    B loop2

store_toright:
    CMP R6, R1
    BGE store_last
    LDR R4, [R0, R6, LSL #2] @ Load next element
    STR R3, [R0, R6, LSL #2] @ Shift right
    BX LR

s_hold:
    CMP R5, #0
    BGT move_hold
    BX LR

move_hold:
    STR R4, [R0, R5, LSL #2] @ Store displaced value
    BX LR

store_last:
    MOV R6, #0
    STR R3, [R0, R6, LSL #2] @ Store last element in first index
    B end

end:

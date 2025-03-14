    .section .data
array:
    .byte 9, 7, 5, 3, 1, 8, 6, 4, 2 

    .section .text
    .global _start

_start:
    LDR R0, =array   @ Load the address of the array
    MOV R1, #9       @ Array size (9 bytes)
    BL sort          @ Call sorting function

    B end_program    @ Stop execution

sort:
    PUSH {LR}        @ Save return address

    SUBS R1, R1, #1  @ Array size minus 1
    BEQ sort_done    @ If array is empty or 1 element, return

outer_loop:
    MOV R2, R1       @ Outer loop counter = Array size (9 bytes)
    MOV R3, R0       @ Start of address of the array

sort_loop:
    LDRB R4, [R3]     @ Load first number
    LDRB R5, [R3, #1] @ Load next number
    CMP R4, R5        @ Compare the two numbers
    BLE continue_loop  @ If R4 < R5, skip swap and continue loop. O

    STRB R5, [R3]     @ Swap: Store next number in current position
    STRB R4, [R3, #1] @ Swap: Store current number in next position
    B continue_loop   @ Explicit branch after swapping

continue_loop:
    ADD R3, R3, #1    @ Move to next byte 
    SUBS R2, R2, #1   @ Reduce sort loop counter by 1
    BNE sort_loop    @ If more elements left, continue

    SUBS R1, R1, #1   @ Reduce outer loop counter by 1
    BNE outer_loop    @ Repeat sorting pass if needed

sort_done:
    POP {LR}          @ Restore return address
    BX LR             @ Return

end_program:
    B end_program     
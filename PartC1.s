    .section .data

    .section .text
    .global sort
    .global array_search

@ ----------------------
@ Sorting Function
@ ----------------------
sort:
    PUSH {LR}        @ Save return address
    SUBS R1, R1, #1  @ Array size minus 1
    BEQ sort_done    @ If array is empty or 1 element, return

outer_loop:
    MOV R2, R1       @ Outer loop counter

inner_loop:
    LDRB R3, [R0, R2]     @ Load element at index R2
    LDRB R4, [R0, R2, #-1]! @ Load previous element

    CMP R3, R4
    BHS no_swap

    STRB R3, [R0, R2, #-1] @ Swap elements
    STRB R4, [R0, R2]

no_swap:
    SUBS R2, R2, #1
    BNE inner_loop

    SUBS R1, R1, #1
    BNE outer_loop

sort_done:
    POP {LR}
    BX LR

@ ----------------------
@ Array Search Function
@ ----------------------
array_search:
    MOV R3, #0          @ Index counter = 0
    MOV R4, #-1         @ Default return value (-1 if not found)

loop:
    CMP R3, R1          @ Compare index with array size
    BGE not_found

    LDRB R5, [R0, R3]   @ Load current element
    CMP R5, R2          @ Compare with search value
    BEQ found

    ADD R3, R3, #1      @ Increment index
    B loop

found:
    MOV R0, R3          @ Return index
    BX LR

not_found:
    MOV R0, R4          @ Return -1 (not found)
    BX LR

    .section .data

    .section .text
    .global sort
    .global array_search        
    .global array_stats
    .global array_rotate

@ ---------------------------------
@ Sorting Function
@ ---------------------------------
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

@ ---------------------------------
@ Array Search Function
@ ---------------------------------
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


@ ---------------------------------
@ Array Stats
@ ---------------------------------
array_stats:
    PUSH {LR}             @ Save return address
    MOV R2, #0            @ Initialize sum to 0
    LDR R3, [R0]          @ Load first element as min
    LDR R4, [R0]          @ Load first element as max
    MOV R5, #0            @ Index counter

stats_loop:
    LDR R6, [R0, R5, LSL #2]  @ Load array element
    ADD R2, R2, R6        @ Add to sum

    CMP R6, R3            @ Compare with current min
    BLT update_min
    CMP R6, R4            @ Compare with current max
    BGT update_max
    B next_element

update_min:
    MOV R3, R6            @ Update min
    B next_element

update_max:
    MOV R4, R6            @ Update max

next_element:
    ADD R5, R5, #1        @ Increment index
    CMP R5, R1            @ Check if end of array
    BLT stats_loop

    MOV R0, R3            @ Return min in R0
    MOV R1, R4            @ Return max in R1
    MOV R2, R2            @ Return sum in R2

    POP {LR}
    BX LR                 @ Return

@ ---------------------------------
@ Array Rotation
@ ---------------------------------
array_rotate:
    PUSH {LR, R2, R3, R4}
    
    CMP R1, #1             @ If array has 1 or 0 elements, return
    BLE rotate_done

    LDR R2, [R0, R1, LSL #2]  @ Load last element
    MOV R3, R1             @ Copy array size
    SUB R3, R3, #1         @ Reduce by one

rotate_loop:
    LDR R4, [R0, R3, LSL #2]  @ Load previous element
    STR R4, [R0, R3, LSL #2, #4]  @ Shift right
    SUBS R3, R3, #1
    BGE rotate_loop

    STR R2, [R0]           @ Store last element in first position

rotate_done:
    POP {LR, R2, R3, R4}
    BX LR                  @ Return

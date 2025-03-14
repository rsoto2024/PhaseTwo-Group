    .section .data
array:
    .byte 10, 3, 8, 1, 6, 4, 2, 7, 5
array_size:
    .word 9

search_value:
    .word 6

    .section .text
    .global _start
    .extern sort
    .extern array_search

_start:
    LDR R0, =array    @ Load array address
    LDR R1, =array_size
    LDR R1, [R1]      @ Load array size
    BL sort           @ Call sorting function

    LDR R2, =search_value
    LDR R2, [R2]      @ Load search value
    BL array_search   @ Call search function

    @ Exit program
    MOV R7, #1
    SWI 0

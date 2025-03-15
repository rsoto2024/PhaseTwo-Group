    .section .data
array:
    .word 10, 3, 8, 1, 6, 4, 2, 7, 5   @ Example array
array_size:
    .word 9                            @ Size of the array
search_value:
    .word 6                            @ Value to search

    .section .text
    .global _start
    .extern str_length
    .extern str_copy
    .extern str_compare
    .extern str_concat
    .extern sort
    .extern array_search
    .extern array_stats
    .extern array_rotate

_start:
    LDR R0, =array        @ Load array address
    LDR R1, =array_size
    LDR R1, [R1]          @ Load array size
    BL sort               @ Call sorting function

    LDR R2, =search_value
    LDR R2, [R2]          @ Load search value
    BL array_search       @ Call search function

    BL array_stats        @ Compute min, max, sum

    BL array_rotate       @ Rotate array right by 1 position

    @ Exit program
    MOV R7, #1
    SWI 0

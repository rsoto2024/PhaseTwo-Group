
.global _start

.data
  lenstring: .string ""
  copystring: .string "test copy"
  copystring2: .space 0xFF
  compstring1: .string "testing"
  compstring2: .string "test"
  concatstring1: .string "testing "
  concatstring2: .string "testing 123"
  concatstring3: .space 0xFF

.text
_start:
//String Length Function - expect 0 in R0
str_length:
    MOV R0, #0  @ Set register to store count to 0
    LDR R1, =lenstring  @ Load string into R1

loop_length:
    LDRB R2, [R1, R3]  @ Load byte from string at R1 with offset in R3
    CMP R2, #0  @ Compare byte to null terminator
    BEQ str_copy  @ If null, go to next part
    ADD R0, #1  @ Increment counter
    ADD R3, #1  @ Increment offset
    B loop_length  @ Repeat loop

//String Copy Function - expect "test copy" in copystring2
str_copy:
    MOV R3, #0  @ Reset offset to 0
    LDR R0, =copystring2  @ Load destination address
    LDR R1, =copystring  @ Load source string address

loop2:
    LDRB R2, [R1, R3]  @ Load byte from source string
    STRB R2, [R0, R3]  @ Store byte in destination string
    ADD R3, #1  @ Increment offset
    CMP R2, #0x00  @ Compare byte to null terminator
    BNE loop2  @ If not null, repeat

//String Compare Function - expect 1 in R0
str_compare:
    LDR R0, =compstring1  @ Load first string
    LDR R1, =compstring2  @ Load second string
    CMP R0, R1  @ Compare the two strings
    BGT greater  @ If greater, branch to greater
    BLT less  @ If less, branch to less
    BEQ equal  @ If equal, branch to equal

greater:
    MOV R0, #1  @ Set R0 to 1 if greater
    B str_concat  @ Continue with string concatenation

less:
    MOV R0, #-1  @ Set R0 to -1 if less
    B str_concat  @ Continue with string concatenation

equal:
    MOV R0, #0  @ Set R0 to 0 if equal
    B str_concat  @ Continue with string concatenation

//String Concatenate Function - expect "testing testing 123" in concatstring3
str_concat:
    MOV R4, #0  @ Reset offset to 0
    LDR R0, =concatstring3  @ Load space for concatenated string
    LDR R1, =concatstring1  @ Load first string
    LDR R2, =concatstring3  @ Load second string

loop3:
    LDRB R3, [R1, R4]  @ Load byte from first string
    STRB R3, [R0, R4]  @ Store byte in concatenated string
    ADD R4, #1  @ Increment offset
    CMP R3, #0x00  @ Check for null terminator
    BNE loop3  @ If not null, loop again

loop4:
    LDRB R3, [R2, R4]  @ Load byte from second string
    STRB R3, [R0, R4]  @ Store byte in concatenated string
    ADD R4, #1  @ Increment offset
    CMP R3, #0x00  @ Check for null terminator
    BNE loop4  @ If not null, loop again

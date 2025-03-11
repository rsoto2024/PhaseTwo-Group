.data
	lenstring: .string "count length"
	copystring: .string "copy string"
	copystring2: .space 0xFF
	compstring1: .string "compare"
	compstring2: .string "compare this"
	concatstring1: .string "this and"
	concatstring2: .string "that"
	concatstring3: .space 0xFF
.text
.global main
main:
str_length:
	MOV r0, #0 // set register that will store count to 0
	LDR r1, =lenstring // load r1 with string from memory
loop:
	LDRB r2, [r1, r3] // load byte of string from r1 with an offset of whatever value is in r3
	CMP r2, #0 // compare byte that is in r2 with 0 to check for null
	BEQ str_copy // if it is null, send immediatly to next part of program
	ADD r0, #1 // if it is not null add 1 to counter
	ADD r3, #1 // if it is not null, add 1 to offset
	B loop // branch back to beginning of loop
	
str_copy:
	MOV r3, #0 // set offset register to 0
	LDR r0, =copystring2 // load empty space into r0
	LDR r1, =copystring // load r1 with string from memory
loop2:
	LDRB r2, [r1, r3] // load byte from r1 to r2 with offset of r3
  STRB r2, [r0, r3] // store byte from r2 in r0 with offset of r3
	ADD r3, #1 // add 1 to offset
  CMP r2, #0x00 // compare r2 to null
  BNE loop2 // if not equal to null, loop again
	
str_compare:
	LDR r0, =compstring1 // load first string into r0
	LDR r1, =compstring2 // load second string into r1
	CMP r0, r1 // compare values of the two strings
	BGT greater // branch if greater
	BLT less // branch if less
	BEQ equal // branch if equal
equal:
	MOV r0, #0 // move 0 to r0 if equal
	B str_concat // next part of program
greater:
	MOV r0, #1 // move 1 to r0 if greater
	B str_concat // next part of program
less:
	MOV r0, #-1 // move -1 to r0 if less
	B str_concat // next part of program

str_concat:
	MOV r4, #0 // set offset register to 0
	LDR r0, =concatstring3 // load r0 with space
	LDR r1, =concatstring1 // load r2 with first string
	LDR r2, =concatstring3 // load r3 with second string
loop3:	
	LDRB r3, [r1, r4] // load byte from r1 to r3 with offset of r4
  STRB r3, [r0, r4] // store byte from r3 in r0 with offset of r4
	ADD r4, #1 // add 1 to offset
  CMP r3, #0x00 // compare r3 to null
  BNE loop3 // if not equal to null, loop again
loop4:
	LDRB r3, [r2, r4] // load byte from r1 to r3 with offset of r4
  STRB r3, [r0, r4] // store byte from r3 in r0 with offset of r4
	ADD r4, #1 // add 1 to offset
  CMP r3, #0x00 // compare r3 to null
  BNE loop4 // if not equal to null, loop again

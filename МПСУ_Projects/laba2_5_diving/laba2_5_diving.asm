.include "m2560def.inc"
.def temp0		=r15
.def temp1		=r16
.def temp2		=r17
.def counter 	=r20
.def high_part		=r21
.def middle_part	=r22
.def low_part 		=r23

	ldi counter,2
	ldi high_part,0x00   
	ldi middle_part,0x00
	ldi low_part,0x0F
	
	mov temp0,low_part
	mov temp1,middle_part
	mov temp2,high_part
main:
	lsr temp2
	ror temp1
	ror temp0
	dec counter
	breq result_saving
	rjmp main

result_saving:
	sts 0x0345,temp2
	sts 0x0346,temp1
	sts 0x0347,temp0

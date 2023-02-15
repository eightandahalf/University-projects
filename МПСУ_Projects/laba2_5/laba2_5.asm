.include "m2560def.inc"
.def temp0		=r15
.def temp1		=r16
.def temp2		=r17
.def counter 	=r20
.def high_part	=r21
.def low_part 	=r22

	ldi counter,2
	ldi high_part,0xA4   
	ldi low_part,0x5B
	
	mov temp0,low_part
	mov temp1,high_part
	ldi temp2,0x00
main:
	lsl temp0
	rol temp1
	rol temp2
	dec counter
	breq result_saving
	rjmp main

result_saving:
	sts 0x0345,temp2
	sts 0x0346,temp1
	sts 0x0347,temp0

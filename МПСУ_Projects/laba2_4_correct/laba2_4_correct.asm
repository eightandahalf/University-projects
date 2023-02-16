.include "m328pdef.inc"
.def result 	=r16
.def temp		=r17
.def counter	=r18
main:
	ldi ZL,LOW(array * 2)
	ldi ZH,HIGH(array * 2)
	ldi counter,8

	lpm temp,Z

sum_cycle:
	lsl temp
	brcc not_result_increment
	inc result 
not_result_increment:
	dec counter
	cpi counter,0x01
	brpl sum_cycle

	sts 0x0200,result

array: .db 0x21, 0x00

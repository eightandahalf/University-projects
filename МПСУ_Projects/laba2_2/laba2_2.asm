.include "m2560def.inc"

init: 
	ldi r16,0xFF
	ldi r17,0b00100000
	ldi r18,0x01
	ldi r19,0x00
main:
	and r16,r17
	cpi r16,0b00000001
	brmi neg_set // check flag of negative value(N) and jump if that flag set
	sts 0x0200,r18
	rjmp init
neg_set:
	sts 0x0200,r19
	rjmp init

// Write a program that allows you to set, reset, invert i and j bits of a given operand in register R. 
// The result is presented as a table. Programs to check for operands: 0xFF, 0xF0, 0x0F, 0x00
.include "m328pdef.inc"
.def init_data 			=r16
.def set_and_invertion 	=r17
.def reset				=r18
.def temp				=r19
init:
	ldi init_data, 0x00 // 0000 0000
	ldi set_and_invertion,0b10100000
	ldi reset,0b01011111

main:
	// reset
	mov temp,init_data
	and temp,reset
	sts 0x0345,temp // 0000 0000 = 00

	// set
	mov temp,init_data
	or temp,set_and_invertion
	sts 0x0346,temp // 1010 0000 = 50

	// invertion
	mov temp,init_data
	eor temp,set_and_invertion
	sts 0x0347,temp // 1010 0000 = 50
rjmp init
	

// Converting hex-number to unpacked BCD
// Example: from 69(dec) = 0x45(0100 0101) -> to (0000 0100) + (0000 0101) = 0x04 + 0x05

.include "m328pdef.inc"
.def ones 		=r16
.def tens 		=r17
.def hundreads 	=r18
.def init_data 	=r19
.def lsb		=r20
.def msb		=r21

init:
	ldi init_data,0xFF // 255(in dec)
	clr ones
	clr tens
	clr hundreads

main:
	subi init_data,10
	brcs return_data_to_memory
	inc tens
	cpi tens,10
	brcc plus_hundread
	clc
	rjmp main
return_data_to_memory:
	subi init_data,-10
	mov ones,init_data
	mov lsb,ones // lsb = 0x05
	// converting tens to form that will correctly add their value to LSB
	andi tens,0b00001111 // tens = 0x05
	swap tens // tens = 0x50
	//
	add lsb,tens // lsb = 0x50 + 0x05 = 0x55
	mov msb,hundreads // msb = 0x02
	sts 0x0345,msb
	sts 0x0346,lsb
	rjmp init
plus_hundread:
	inc hundreads
	subi tens,10
	rjmp main
	

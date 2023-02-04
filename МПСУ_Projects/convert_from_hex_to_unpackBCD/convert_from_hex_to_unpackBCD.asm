// Converting hex-number to unpacked BCD
// Example: from 69(dec) = 0x45(0100 0101) -> to (0000 0100) + (0000 0101) = 0x04 + 0x05

.include "m328pdef.inc"
.def lsb 	=r16
.def msb 	=r17

init:
	ldi lsb,0x45 // 69(in dec)

main:
	subi lsb,10
	brcs return_data_to_memory
	inc msb
	rjmp main

return_data_to_memory:
	subi lsb,-10
	sts 0x0345,msb
	sts 0x0346,lsb

rjmp init

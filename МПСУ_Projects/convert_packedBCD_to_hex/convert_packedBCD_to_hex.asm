// Converting packed BCD to hex-number
// Example: from 0x25 = 0010 0101 = 37(dec) -> 0x19 = 25(dec) = 0001 1001
.include "m328pdef.inc"
.def temp 	=r16
.def bcd 	=r17	
.def hex 	=r18
.def mult10 =r19

main:
	ldi bcd,0x65
	ldi mult10,10 // mult = 10
	mov temp,bcd // temp = bcd = 0x65
	andi bcd,0b11110000
	// leaving only MSB bits of BCD word(number)
	// in our ex: bcd = 0x60
	swap bcd // highest in the LSB
	// allocating MSB bits(number of number of tens) to LSB bits
	// bcd = 0x06
	mul bcd,mult10 
	// multiplying number of tens to ten
	// bcd = 0x06 * 10(in hex no matter what it will, but in decimal 
	// it will 6 * 10 = 60, because 0x06 in hex = 6 in decimal
	mov bcd,temp // returning bcd reg to initial data, i.e
	// bcd = 0x65
	andi bcd,0b00001111 
	// levaing only LSB bits
	// bcd = 0x05
	add bcd,r0 
	// sum of 60(dec) and 0x05
	// i.e. before all this program, 6 in 0x65 was mean only six, 
	// but now it will 60(in decimal)
	sts 0x0345,bcd
ret



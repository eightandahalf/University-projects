// Converting 3 byte hex to packed(4 registers) and unpacked bcd(7 registers)
// Example: 
.include "m328pdef.inc"

main:
	// initial values in registrs
	.def hex0	= r25
	.def hex1	= r26
	.def hex2   = r27

	// in exit packed bcd in registrs
	.def t_bcd_0 = r13 ; bcd value digits 1 and 0
	.def t_bcd_1 = r14 ; bcd value digits 3 and 2
	.def t_bcd_2 = r15 ; bcd value digits 4 and 5
	.def t_bcd_3 = r16 ; bcd value digit 6

	// in exit unpacked bcd in registrs
	.def N1 = r1 // lowest
	.def N2 = r2
	.def N3 = r3
	.def N4 = r4
	.def N5 = r5
	.def N6 = r6
	.def N7 = r7 // highest

	// helpful registrs
	.def cnt16a = r18 // cycle counter
	.def tmp16a = r19 // time value
	.def temp = r20
	// registers addresses in memory
	.equ at_bcd_0 = 13 // ..?address of tBCD0
	.equ at_bcd_3 = 16 // ..?address of tBCD3

	bin2BCD24:
		ldi cnt16a,24 // loop counter initialization
		ldi hex0,0x12
		ldi hex1,0x23
		ldi hex2,0x45
		clr t_bcd_0
		clr t_bcd_1
		clr t_bcd_2
		clr t_bcd_3
		clr ZH ; clear ZH // r31
	b_bcd_x_1:
		lsl hex0 ; shift input value
		rol hex1 ; through all bytes
		rol hex2 ; through all bytes
		rol t_bcd_0
		rol t_bcd_1
		rol t_bcd_2
		rol t_bcd_3
		dec cnt16a ; decrement loop counter
		brne b_bcd_x2 // jump if counter not zero
		// unpack
		ldi temp,0b00001111

		mov N1,t_bcd_0 // n1 = 0X65
		and N1,temp // n1 = 0x05
		mov N2,t_bcd_0 // n2 = 0x65
		swap N2 // n2 = 0x56
		and N2,temp // n2 = 0x06

		mov N3,t_bcd_1 // n3 = 0x78
		and N3,temp // n3 = 0x08
		mov N4,t_bcd_1 // n4 = 0x78
		swap n4 // n4 = 0x87
		and N4,temp // n4 = 0x07

		mov N5,t_bcd_2
		and N5,temp
		mov N6,t_bcd_2
		swap N6
		and N6,temp
		mov N7,t_BCD_3
		ret
	b_bcd_x2:
		ldi r30,at_bcd_3 + 1 // r30 = address(at_bcd_3+) + 1 = 17(dec)
	b_bcd_x_3:
		ld tmp16a,-Z // tmp16a = value of address at_bcd_3
		subi tmp16a,-$03 // tmp16a = tmp16a - (-0x03) = 0x0003
		sbrc tmp16a,3 // if 3-st bit != 1 than miss next line
		st Z,tmp16a ; store back
		ld tmp16a,Z // tmp16a = value of address at_bcd_3
		subi tmp16a,-$30 // tmp16a = tmp16a - (-0x30) = 0x0030
		sbrc tmp16a,7 // if 7-th bit != 1 than miss next line
		st Z,tmp16a ; store back
		cpi ZL,at_bcd_0 // ZL(r30) - at_bcd_0 = 17(dec) - 13(dec)
		brne b_bcd_x_3 ; loop again if ZL > at_bcd_0
		rjmp b_bcd_x_1 
	; // end
ret



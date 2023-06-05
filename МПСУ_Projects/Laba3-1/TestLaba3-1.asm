.include "m328pdef.inc"

.def necessary_amount_of_rol = r22 // register that we use to count iterations of shifting data from port B5 to compare that data with 
								   // number of port D7, i.e. if port B5 = 00100000, then after two shifting of the word to the left
								   // we will get 10000000, and after comparing 10000000(B5) with 10000000(D7) we will get 0, i.e
								   // 10000000 - 10000000 = 0, and if that comparing equal to zero, then we switching diode to
								   // ON condition, in another way diode will switched off
init: 
	// 1 meaning output of data, while logic 0 meaning input of data
	ldi r16, 0b00000000
	out DDRB, r16 // input 
	ldi r16, 0b10000000	
	out DDRD, r16 // output
	ldi r19, 0b10000000 // BUTTON OFF
main:
	in r16, PINB
	ldi necessary_amount_of_rol, 2
getting_right_word_to_compare:
	lsl r16 // shifting data of registor two time
	dec necessary_amount_of_rol
	brne getting_right_word_to_compare // if z flag = 0, then jump
	cp r16, r19
	breq diode_switch // if z flag = 1, then jump, and it means that we will switch OFF our diode
	eor r16, r19 // if z flag = 0, then we switched ON diode
	out PORTD, r16
	brne main
diode_switch: // diode switching ON
	eor r16, r19 
	out PORTD, r16
	rjmp main

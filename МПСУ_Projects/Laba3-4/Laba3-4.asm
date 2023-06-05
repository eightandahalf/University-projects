.include "m328pdef.inc"
.def tens = r21
.def ones = r23
.def prev_state = r24
.def new_state = r25

init:
	ldi r16,Low(RAMEND)
	out SPL,r16
	ldi r16,High(RAMEND)
	out SPH,r16
	ldi r16,0b11110000
	out DDRD, r16
	rcall LCD_Init
	ldi ones,0x30 	; first symbol on display
	ldi tens,0x30	; second symbol on disply
	ldi prev_state,0x00	; previous state
main:
	sbis PINC,5
	ldi ones,0x30
	sbis PINC,5
	ldi tens,0x30
	in new_state,PIND
	andi new_state,0b00001100
switch:
	cpi prev_state,0b00001000
	breq state_2
	
	cpi prev_state,0b00000100
	breq state_1

	cpi prev_state,0b00000000
	breq state_0

	cpi prev_state,0b00001100
	breq state_3
state_2:
	cpi new_state,0b00001100
	breq plus
	cpi new_state,0b00000000
	breq minus
	rjmp indic

state_1:
	cpi new_state,0b00001100
	breq minus
	cpi new_state,0b00000000
	breq plus
	rjmp indic

state_0:
	cpi new_state,0b00001000
	breq plus
	cpi new_state,0b00000100
	breq minus
	rjmp indic

state_3:
	cpi new_state,0b00001000
	breq minus
	cpi new_state,0b00000100
	breq plus
	rjmp indic

plus:
	inc ones ; 0x30 + 1 = 0x31
	cpi tens,0x34
	breq max_num_of_tens_reached
	cpi ones,0x3A
	brne indic ; jump if z not set. ones not overflow
	subi ones,0x0A
	inc tens
	
max_num_of_tens_reached:
	cpi ones,0x36
	breq limit_reached
	rjmp indic

limit_reached:
	dec ones
	rjmp indic

minus:
	dec ones ; 0x30 - 1 = 0x2F
	cpi ones,0x2F ; 0x2F - 0x2F = 0
	breq ones_eq_to_0 ; jump if z flag is set
	rjmp indic

ones_eq_to_0:
	cpi tens,0x30 ; 0x30 - 0x30 = 0
	breq zero_counter ; jump if z flag is set
	dec tens
	ldi ones,0b00111001 ; 9
	rjmp indic

zero_counter:
	inc ones
	rjmp indic

indic:
	sts 0x0205,tens
	sts 0x0206,ones
	ldi r17,7
	rcall LCD_Update
	mov prev_state,new_state
	rjmp main
	

.include "hd44780.asm"                            

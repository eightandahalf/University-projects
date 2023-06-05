//
// WARNING
// ������ ������������ �������� ��� ��������� ������� � ������ �����:
//  cpi ones,0b00010000
// 	brpl num_of_ones_more_than_one  ; jump if N flag is not set, and it meand that
// 									; num of ones more than 0
// 	cpi tens,0b00000001
// 	brmi counter_eq_to_0            ; jump if N flag is set, and it means that	
// 						  		    ; num of tens equal to zero and num of ones eq to 0
// 	subi tens,0b00000001
// 	add ones,0b10010000
// 	dec counter
// 	rjmp ret1
// counter_eq_to_0:
// 	rjmp ret1
// num_of_ones_more_than_one:
// 	sub ones,R16
// 	dec counter
// ret1: reti
//
// ��� ��� ��� ��������� �� 9 ����� 1, � ������� ������� ����� �������, ������� ��� 
// ���������� ��������� ��� ���� ����� ������ �����, �� ���� 1001 0000 - 0001 0000 = 1000 0000. 
// ������� � ������� ������� ������� �� ��������������� ���������� ���������.
// ������� ��� ����� ������� �������������� ������ �������� ����������� ������ 
// ��������, ������� ����� ����� �������� ������� �� �����, � ����� ���������� �� 
// ��������� 0XF0, ��� �������� ���������, ���� �� ���� ������� �������
//
//
//
// ��������� ������� ������������ ����� ������� ������, ������� ��������� � (���) 
// �������, ������ ������� ����������� ������������ �������� � ��������������� ���������� ��������.

// ������ ��������� �������� 3 ���� ���������:

// �������  ����� � �������� �������� ������� ��� ����������. ������ ������ ����������� 
// ������� ��������� � ������ ����� ��������, � ������������ ������� �������� ���������� 
// �� ������ ������� ��������  ��� ���������� ���������. ������� �������� ����� (CS) �������� ������ �������.
// ������� ������ � �������� ������, ��������� � �������  �������, ����������� ���������. 
// ������� �������� ������ (DS) �������� ������ �������.
// ������� ����� � �������� ������ �������� ��� ��� ��������� (��� �������� � ������������ 
// �������), ��� � ���  ������� ����������� (��� �������� � ������� ���������), � ����� ������������ 
// ��� �������� ���������� � ���������. ������� �������� ����� (SS) �������� ������ �������. ����� 
// ������� ������� ����� �������� ���������� SS:ESP.//
//
//
//
// CSEG - ����������� �������

// ��������� CSEG ���������� ������ ������������ ��������. �������� ���� ����� �������� �� ���������� 
// ����������� ���������, ������� ������������ � ���� ����������� ������� ��� ����������. ����������� 
// ������� �������� ��������� �� ���������. ����������� �������� ����� ���� ����������� �������� ���������, 
// ������� ������� �� ��������, � ��������. ��������� ORG ����� ���� ������������ ��� ���������� ���� � �������� 
// � ����������� ����� ��������. ��������� CSEG �� ����� ����������.

// ORG - ���������� ��������� � ��������

// ��������� ORG ������������� ������� ��������� ������ �������� ��������, ������� ��������� ��� ��������. ��� 
// �������� ������ ��� ������������� ������� ��������� � SRAM (���), ��� �������� �������� ��� ����������� �������, 
// � ��� �������� EEPROM ��� ��������� � EEPROM. ���� ��������� ������������ ����� (� ��� �� ������) �� ����� 
// ����������� �� ������ ���������� � ��������� ���������. ����� ������� ���������� ����������� ������� � ������� 
// EEPROM ����� ����, � ������� ��� ����� 32 (��������� ������ 0-31 ������ ����������). �������� �������� ��� ��� 
// ��� � EEPROM ������������ ��������� �������� � ��� ������������ �������� - ���������.

// 'ORG' ������������� �����, �� �������� ��������� �� ��� ��� ������ ��������� � ������.
// �� ��� ������ ��������� �������� ���������, ����������� �����. ��� ��������� �������� ����� �������� ������������,
// ��������� ��� ��� �� ���� ������ �� ���������, �� ��� �����, ������������ � ��� � �������� ������� "$" ����������, 
// ��� ����-�� �� ��� �� ������� �� ����� ������.
//
.include "m328pdef.inc"
.def ones = r20			  ; counter of ones
.def tens = r21			  ; counter of tens
.def counter = r22  	  ; general counter 
.def nine = r23

.cseg
.org $0000 jmp RESET      ; (Reset)
.org $0002 jmp Ext_INT0   ; (INT0) External Interrupt Request 0
.org $0004 jmp Ext_INT1   ; (INT1) External Interrupt Request 1

.org INT_VECTORS_SIZE     ; ����� ������� ����������

Ext_INT0:                 	; ���������� ���������� �� ����� INT0
    add ones,R16		  	; add 1 to counter of ones
	inc counter			 	; increment general counter
	cpi counter,0x2E      	; comparing general counter and max available value
	brne limit_not_reached	; jump if Z flag is not set, and it means that limit not reached
	sub ones,R16			; decrease ones for one if max value is reached
	dec counter				; decrement general counter if max value is reached
	rjmp ret0				; jump to end of interrupt, as we reached max value
limit_not_reached:			  
	cpi ones,0xA0			; comparing ones and 10(decimal)
	brne ret0 				; jump if Z flag is not set, and it means that ones not reached decimal 10
	inc tens				; incrementing amount of tens
	clr ones				; clearing amount of ones
ret0: reti                	; ����� �� ����������� ����������

Ext_INT1:                 ; ���������� ���������� �� ����� INT1
	sub ones,R16
	cpi ones,0xF0
	brne num_of_ones_more_than_one 	 ; jump if Z flag is not set, and it means that
								     ; num of ones more than 0
	cpi tens,0x01
	brmi counter_eq_to_0           	 ; jump if N flag is set, and it means that	
						  		     ; num of tens equal to zero and num of ones eq to 0
	subi tens,0x01
	ldi ones,0b10010000
	dec counter
	rjmp ret1
counter_eq_to_0:
	clr ones
	clr tens
	clr counter
	rjmp ret1
num_of_ones_more_than_one:
	dec counter
ret1: reti                ; ����� �� ����������� ����������

Reset:
	ldi R16,Low(RAMEND) ; ����� ���������
    out SPL,R16         ; ������������ ������������� �����
    ldi R16,High(RAMEND); ��������� ����� ���������������
    out SPH,R16         ; �� ����� ���
    ldi R16,0b00000011  ; ��������� ����������
    out EIMSK,R16       ; INT0 � INT1 ��������
    ldi R16,0b00001010  ; ��������� ������� ��������� ����������
    sts EICRA,R16       ; �� ����� �������� �������
    sei                 ; ��������� ���������� ���������
    ldi R16,0b11110000  ; ��������� �� ����� ����� 4..7
    out DDRD,R16        ; ����� D
	ldi R16,0b00001111  ; ��������� �� ����� ����� 0..3
    out DDRB,R16        ; ����� B
	clr R16
	out DDRC,R16
    clr counter         ; ����� ��������
    ldi R16,0b00010000  ; 1
	ldi nine,0b10010000 ; 9
main: 
	sbis PINC,5         ; ��������� ������ RESET
    rjmp clear          ; ���� ������, �� ����� ��������
    andi ones,0b11110000
    out PORTD,ones       ; �����
	andi tens,0b00001111 ; 
	out PORTB,tens
    rjmp main

clear:
	clr ones
	clr tens
	clr counter
	rjmp main

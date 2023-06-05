/*
* ��� : hd44780.asm
* �������� : ��� ������� ��� ���������-��������� LCD HD44780
* ������� ������:
*DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0 ��������
*0 0 0 0 0 0 0 1 ������� ������. ������� ������ �� 0 ������� DDRAM
*0 0 0 0 0 0 1 - ��������� �� DDRAM ����� �������, ������� ������ �� 0
*0 0 0 0 0 1 I/D S ��������� ������ ������ � �������
*0 0 0 0 1 D C B ��������� ������ �����������
*0 0 0 1 S/C R/L - - ����� ������� ��� ������, � ����������� �� �����
*0 0 1 DL N F - - ����� ����� �����, ������ ���� � ������� �������
*0 1 AG AG AG AG AG AG ����������� ��������� �� SGRAM � ������ ����� � SGRAM
*1 AD AD AD AD AD AD AD ����������� ��������� �� DDRAM � ������ ����� � DDRAM

�������� ��������� ���:
I/D � ���������/��������� �������� ������. �� ������� 0 � ���������. �.�. ������ ���������
���� ����� ������� � n-1 ������. ���� I/D=1 � ���������.
S � ����� ������. ��� S=1 � ������ ����� �������� ����� ���������� ���� ������, ���� ��
��������� ����� DDRAM. ������ ��� ������ �� ����� ������� ������, �� ��� 40 ��������,
����� �� ������� �� �����.
D � �������� �������. ��� D=0 ����������� ��������, ��� ���� � DDRAM ����� �������� ���������
������. � ����� �������� ��������� � ��� ������� ���� �������� 1.
� � �������� ������ � ���� ��������. 1 � ������ �������
B � ������� ������ � ���� ��������� ������� ��������.
S/C � ����� ������� ��� ������. ���� ����� 0, �� ���������� ������. ���� 1, �� �����. �� ������
���� �� �������
R/L � ����������� ������ ������� � ������. 0 � �����, 1 � ������.
D/L � ������ ���� ������. 1-8 ���, 0-4 ����
N � ����� �����. 0 � ���� ������, 1 � ��� ������.
F � ������ ������� 0 � 5�8 �����. 1 � 5�10 ����� (����������� ������ �����)
AG � ����� � ������ CGRAM
�D � ����� � ������ DDRAM
*/

.include "m328pdef.inc"
.def tim1=r19            ; ������� ����� 1
.def tim2=r20            ; ������� ����� 2

.equ LCDdat_PORT = PORTD
.equ LCDdat_DDR = DDRD
.equ LCDctrl_PORT = PORTB
.equ LCDctrl_DDR = DDRB

.equ LCD_D4 = 4
.equ LCD_D5 = 5
.equ LCD_D6 = 6
.equ LCD_D7 = 7

.equ LCD_RS = 0         ;����� PD4 ��� ������������ ������� RS
.equ LCD_EN = 1         ;����� PD2 ��� ������������ ������� E

;******** ����� ������� ��� � ������ [$0200] 16 �������� �� LCD **********
;������� ��������: � r17 ���������� ��������� ��������
LCD_Update:
ldi r16,0b10000000      ;������ ����� � DDRAM 80 - 0-�, �0 - 1-�
rcall Wait5ms;
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait5ms;
ldi R31,$02             ;Z=$0200
clr R30
m2: ld r16,Z+           ;r16=[$0200]
rcall LCD_SendDat
rcall Wait38ms
dec R17
cpi R17,0
brne m2
ret

;****************************������������� ��-������**********************
LCD_Init:
sbi LCDdat_DDR,LCD_D4
sbi LCDdat_DDR,LCD_D5
sbi LCDdat_DDR,LCD_D6
sbi LCDdat_DDR,LCD_D7
sbi LCDctrl_DDR,LCD_RS
sbi LCDctrl_DDR,LCD_EN

rcall Wait38ms;
rcall Wait38ms;
rcall Wait38ms;
rcall Wait38ms;
rcall Wait38ms;
rcall Wait38ms;

ldi R16,$30             ;��������� ������� 8 �������� 1-� ���.....
rcall LCD_Cmd1Byte      ;�������� ������� �� LCD ����� ������
rcall Wait38ms          ;
rcall LCD_Cmd1Byte      ;8 �������� 2-� ���... �������� ������� �� LCD
rcall Wait38ms          ;
ldi R16,$20             ;��������� ���� �� 4 �������
rcall LCD_Cmd1Byte      ;�������� ������� �� LCD ����� ������
rcall Wait38ms
ldi R16,$20             ;��������� ���� �� 4 �������

rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait38ms;
ldi R16,0b00101000      ;���� 4 �������, 2 �������� ���������, ������� 5�8
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait38ms;
ldi R16,0b00001000      ;���������� �����������, �������, ��������
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait38ms;
ldi R16,0b00000001      ;������� ������ � ��������� ������� � ������ ������ ������
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait38ms;
ldi R16,0b00000110      ;����� ���������� ������, ��� ������
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
rcall Wait38ms;
ldi R16,$0C             ;�������� LCD, ��������� ������, ��������� ��������
rcall LCD_Cmd1_2Byte    ;�������� ������� �� LCD ����������
ret

LCD_WriteNibble:
sbrs R16, 4
cbi LCDdat_PORT,LCD_D4
sbrc R16, 4
sbi LCDdat_PORT,LCD_D4
sbrs R16, 5
cbi LCDdat_PORT,LCD_D5
sbrc R16, 5
sbi LCDdat_PORT,LCD_D5
sbrs R16, 6
cbi LCDdat_PORT,LCD_D6
sbrc R16, 6
sbi LCDdat_PORT,LCD_D6
sbrs R16, 7
cbi LCDdat_PORT,LCD_D7
sbrc R16, 7
sbi LCDdat_PORT,LCD_D7
ret

;****************** ������������ �������� ������� � ��-������ *************
LCD_Cmd1_2Byte:
cbi PORTB,LCD_RS        ; ������������� RS=0 (�������);
rcall LCD_Send1_2Byte
ret

;****************** ������������ �������� ������ � ��-������ *************
LCD_SendDat:
sbi PORTB,LCD_RS        ; ������������� RS=1 (������);
rcall LCD_Send1_2Byte
ret

LCD_Send1_2Byte:        ;������ ���������
sbi LCDctrl_PORT,LCD_EN ;E=1
rcall LCD_WriteNibble   ;��������� � ���� ������� �������
cbi LCDctrl_PORT,LCD_EN ;E=0
swap r16
sbi LCDctrl_PORT,LCD_EN ;E=1
rcall LCD_WriteNibble   ;��������� � ���� ������� �������
cbi LCDctrl_PORT,LCD_EN ;E=0
ret

;****************** ������������ �������� ������� � ��-������ *************
LCD_Cmd1Byte:
cbi LCDctrl_PORT,LCD_RS ;������������� RS=0 (�������);
rcall LCD_WriteNibble
sbi LCDctrl_PORT,LCD_EN ;E=1
cbi LCDctrl_PORT,LCD_EN ;E=0
clr R16
ret

;********************** ������������ �������� *****************************
Wait50us:               ; �������� 50���
ldi tim1,65
Wait51:
dec tim1                ; 1����
brne Wait51             ; 2����� � 1���� �� ������
ret                     ; 4 ����� ����� 195 ������ 0,0000121875 ��� ��� F_CPU=16��� 12,18���

Wait150us:              ; �������� 150���
rcall Wait50us
rcall Wait50us
rcall Wait50us
ret                     ;0,0000375 ��� (37.5���)

Wait5ms:                ; �������� 5��
ldi tim2,100            ; �������� ��������
Wait501: rcall Wait50us
dec tim2
brne Wait501
ret

Wait38ms:               ; �������� 38��
ldi tim2,0              ; �������� ��������
Wait381:
rcall Wait150us
dec tim2
brne Wait381
ret
.include "m328pdef.inc"

.def ones 		=r3
.def tens 		=r21
.def hundreads 	=r4
.def init_data 	=r22
.def thirty		=r5
.def	dd8u	=r6		;dividend
.def	dv8u	=r7		;divisor
.def	drem8u	=r8		;remainder
.def divisor = r9
.def limit_of_reg = r10
.def num_of_step = r25
.def temp = r16
.def int_part = r23
.def frac_part = r24
.def def_int_part = r13 // 5
.def def_frac_part = r14 // 0.65625

init: 
	// initialization of variables, that will contain value that will show on display
	ldi temp,0
	mov int_part,temp
	mov frac_part,temp

	ldi temp,5
	mov def_int_part,temp // default int part = 5
	ldi temp,0b01010100
	mov def_frac_part,temp // default frac_part = 0.65625
	//

	ldi temp,Low(RAMEND)
	out SPL,temp
	ldi temp,High(RAMEND)
	out SPH,temp
	CLR temp
	out DDRC,temp
    
; REGIST ADCSRA - STATUS AND CONTROL REGISTER ADC
;Бит 7 - ADEN: ADC Enable – "1" / "0" – включение/выключение схемы ЦАП.
;Бит 6 – ADSC: ADC Start Conversion – "1" – Запуск аналогово-цифрового преобразования.
;Бит 5 – ADATE: ADC Auto Trigger Enable – Автозапуск преобразования по внешним сигналам.
;Бит 4 – ADIF: ADC Interrupt Flag – "1" – Преобразование завершилось. Регистры данных ADCH:ADCL обновились.
;Бит 3 – ADIE: ADC Interrupt Enable – Разрешение прерывания по флагу ADIF.
;Биты 2:0 – ADPS2:0: ADC Prescaler Select Bits – Коэффициент деления частоты между XTAL и тактовым входом АЦП.
;           7    6     5     4     3     2     1     0
;ADCSRA = ADEN ADSC  ADATE ADIF  ADIE  ADPS2 ADPS1 ADPS0
      ldi temp,0b10000111  ;разрешить АЦП-прерывание и CLK/128
      sts ADCSRA,temp      ;старт преобразования
;ADPS2 ADPS1 ADPS0 = 111 = 	CLK/64; CLK - тактовая частота МК

;          7     6     5     4     3     2     1     0
;ADMUX = REFS1 REFS0 ADLAR  MUX4  MUX3  MUX2  MUX1  MUX0
      ldi temp,0b00100000  ;опорное - напряжение питания,
      sts ADMUX,temp       ;результат выравнивается to the left,
                          ;0-й канал АЦП
;Регистр ADMUX управляет выбором канала АЦП, источника опорного напряжения и способом выравнивания результата.
;REFS1 REFS0 = 0	0 - Внешний вывод AREF
;Бит 5 - ADLAR: ADC Left Adjust Result – выравнивание результата влево или вправо; ADLAR = 0 - выравнивание влево
;Биты 4:0 - MUX4:0: Analog Channel and Gain Selection Bits – выбор аналогового входа, подключенного ко входу АЦП согласно таблицы
	
	rcall LCD_Init

READ_ADC:
	lds temp,ADCSRA
	ori temp,0b01000000 ; ori Rd, K - «Логическое ИЛИ» РОН и константы
	sts ADCSRA,temp      ;запуск преобразования
KEEP_POLING:	  ;сидим здесь в ожидании конца преобразования
	lds temp,ADCSRA
	mov r18,temp
	andi r18,0b00010000 ; andi Rd, K - «Логическое И» РОН и константы
	cpi r18,0b00010000  ;преобразование завершено?
	brne KEEP_POLING ; jump if z flag not set
	lds r17, ADCSRA
	ldi r20, 0b00001000
	eor r17,r20 		  ; «Исключающее ИЛИ» - установка единицы только при сравнении разных величин
	sts ADCSRA,r17      ;пишем 1 для очистки флага ADIF
 
    lds init_data,ADCH    ;	the result of the transformation
	ldi temp,$30 		  ; setting address of 0 value on display MC to variables that we will use and save them in memory from 0x200
	mov ones,temp
	mov tens,temp
	mov hundreads,temp
	mov thirty,temp

	clr num_of_step 	  ; clearing previous results
	clr int_part
	clr frac_part

	ldi temp,255
	mov divisor,temp
	mov limit_of_reg,temp
	rcall dividing	
	mov temp,dd8u // result of dividing
	cpi temp,1
	breq max_value_on_display
transform:
	cpi init_data,0
	breq last_step // jump if init data equal to zero

	rcall sum_of_frac_values ;int_part + def frac_part
	inc num_of_step
	cpi num_of_step,0x2D
	breq last_step // jump if reached limit of max number on display = **

	cpi init_data,127 // comparing value that we get from ADC with 127;
	brpl init_value_more_than_127 // jump if flag n is not set;
								  // and it means that init_data > 127
	;; if we here, then we know that init_data < 127 and 
	;; N flag wouldn't interfere with comparing values
	cp init_data,int_part // comparing init_data and "actual_value" 
						  // after adding of 5.65625 of num_of_step times.
	brmi last_step // If int_part more than init_data, it means that
				   // we found value that +- equal to init_data, and now
				   // N flag will set and we will transform that value to
				   // unpacked bcd.	   
	rjmp transform // If init_data yet more than int_part, then we will
				   // add 5.65625 to int_part and frac_part and compare 
				   // init_data and int_part again

init_value_more_than_127: 
	cpi int_part,127 // comparing int_part and 127, to understand where we are
	brpl both_more_than_127 // jump if n flag is not set, and it means that int_part
							// more than 127
zero_value_less_than_127_and_init_more:
	rjmp transform // if init_value more than 127, and int_part < 127, we should add
				   // 5.65625 to int_part and frac_part again

both_more_than_127:
	cp init_data,int_part
	brmi last_step ; jump is flag n is set; it means that int_part +- equal to init_data
	rjmp transform ; if int_part < init_data then we should again add 5.65625 to int_part
				   ; and frac_part
last_step:
	clr init_data
	mov init_data,num_of_step // saving in init_data number of steps to reach init_data from ADC
	rjmp convert_bin_to_dec
	
max_value_on_display:
	ldi init_data,45
		
convert_bin_to_dec:   
	subi init_data,10
	brcs return_data_to_memory
	inc tens
	cpi tens,0x3A
	breq plus_hundread ; jump if z flag is set
	clc
	rjmp convert_bin_to_dec
return_data_to_memory:
	subi init_data,-10
	mov ones,init_data
	rjmp indic
plus_hundread:
	inc hundreads
	subi tens,0x0A
	rjmp convert_bin_to_dec			
indic:
	add ones,thirty
	sts 0x0200,tens
	sts 0x0201,ones
	ldi r17,0x02
	rcall LCD_Update
	rjmp READ_ADC
	
///////////////////////////DIVIDING/////////////////////
dividing:

;***** Code
initial:
	mov dd8u,init_data
	mov dv8u,divisor
div8u:	sub	drem8u,drem8u;clear remainder and carry
	rol	dd8u		;shift left dividend ; 					$0100 0101 -> 1000 1010/ C = 0
	rol	drem8u		;shift dividend into remainder; 		$0 -> 0 
	sub	drem8u,dv8u	;remainder = remainder - divisor; 		$rem = 0 - 40
	brcc d8u_1		;if result negative						$
	add	drem8u,dv8u	;restore remainder; 					$rem = 0
	clc				;clear carry to be shifted into result; $C = 0
	rjmp	d8u_2	;else
d8u_1:	sec			;set carry to be shifted into result

d8u_2:	rol	dd8u	;shift left dividend;					$1000 1010 -> 0001 0100/ C = 1
	rol	drem8u		;shift highest bit of dividend into lowest bit of remainder.
				    ;$rol(00) = 01; carry flag C = 0.
					;We put the carry flag after rol of (dividend) in the remainder.
					;Carry flag in this case a kind of bridge between the highest bit of 
					;dividend number and the lowest bit ofremainder
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 1 - 64(dec) < 0
	brcc	d8u_3	;if result negative						$
	add	drem8u,dv8u	;restore remainder  			 		$rem = 1	
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_4	;else
d8u_3:	sec			;set carry to be shifted into result

d8u_4:	rol	dd8u	;shift left dividend					$0001 0100 -> 0010 1000/ C = 0
	rol	drem8u		;shift dividend into remainder			$rol(01) = 10 = 2(dec)
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 2 - 64(dec) < 0
	brcc	d8u_5	;if result negative						$
	add	drem8u,dv8u	;restore remainder						$rem = 2
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_6	;else
d8u_5:	sec			;set carry to be shifted into result	

d8u_6:	rol	dd8u	;shift left dividend					$0010 1000 -> 0101 0000/ C = 0
	rol	drem8u		;shift dividend into remainder			$rol(10) = 100 = 4(dec); we put the carry flag in the remainder
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 4 - 64(dec) < 0
	brcc	d8u_7	;if result negative						$
	add	drem8u,dv8u	;restore remainder  			 		$rem = 4
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_8	;else
d8u_7:	sec			;set carry to be shifted into result

d8u_8:	rol	dd8u	;shift left dividend					$0101 0000 -> 1010 0000/ C = 0
	rol	drem8u		;shift dividend into remainder			$rol(100) = 1000 = 8(dec)
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 8 - 64(dec) < 0
	brcc	d8u_9	;if result negative						$
	add	drem8u,dv8u	;restore remainder 			     		$rem = 8
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_10	;else
d8u_9:	sec			;set carry to be shifted into result

d8u_10:	rol	dd8u	;shift left dividend					$1010 0000 -> 0100 0000/ C = 1
	rol	drem8u		;shift dividend into remainder			$rol(1000) = 0001 0001 = 17(dec)
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 17 - 64(dec) < 0
	brcc	d8u_11	;if result negative						$
	add	drem8u,dv8u	;restore remainder 			     		$rem = 17
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_12	;else
d8u_11:	sec			;set carry to be shifted into result

d8u_12:	rol	dd8u	;shift left dividend					$0100 0000 -> 1000 0000/ C = 0
	rol	drem8u		;shift dividend into remainder			$rol(0001 0001) = 0010 0010 = 34(dec)
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 34 - 64(dec) = 0
	brcc	d8u_13	;if result negative						$
	add	drem8u,dv8u	;restore remainder 			     		$rem = 34(dec)
	clc				;clear carry to be shifted into result  $C = 0
	rjmp	d8u_14	;else		
d8u_13:	sec			;set carry to be shifted into result   	 

d8u_14:	rol	dd8u	;shift left dividend					$1000 0000 -> 0000 0000/ C = 1
	rol	drem8u		;shift dividend into remainder			$rol(0010 0010) = 0100 0101 = 69(dec)
	sub	drem8u,dv8u	;remainder = remainder - divisor		$rem = 69 - 64(dec) = 5(dec)
	brcc	d8u_15	;if result negative						$
	add	drem8u,dv8u	;restore remainder 			     	
	clc				;clear carry to be shifted into result  
	rjmp	d8u_16	;else
d8u_15:	sec			;set carry to be shifted into result	$C = 1

d8u_16:	rol	dd8u	;shift left dividend					$0000 0000 -> 0000 0001/ C = 0

ret
/////////////////

//////////////MULTIPLYING////////////////
multiplying:
	 mov r12,drem8u
	 ldi r17,45
	 mul r17,r12		                      
	 mov r25,r1	
	 mov r26,r0	                        
ret
//////////////////////////////////////

////////////////SUM_OF_FRAC_VALUES/////////////
sum_of_frac_values:
	add frac_part,def_frac_part // frac_part it's sort of global variable to 
								// save fractional part of every-every sum of new step.
								// While def_frac_part = 0.65626
	sbrs frac_part,7 // miss next command if 7 bit of frac_part is set.
					 // It means that value of frac_part reach value more or equal to 1, and we should add
					 // 1 to int_part and reset that bit in frac_part
	rjmp bit_7_not_set
	inc int_part // adding 1 to int_part from 7 bit of frac_part
	cbr frac_part,0b10000000 // reset 7 bit of frac_part

bit_7_not_set:
	add int_part,def_int_part // int_part it's sort of global variable to
							  // save integer part of every-every sum of new step.
							  // While def_int_part = 5
ret
///////////////////////////////////

.include "hd44780.asm"                            


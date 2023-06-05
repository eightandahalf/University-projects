.include "m328pdef.inc"

.def ones 		=r21
.def tens 		=r22
.def hundreads 	=r23
.def init_data 	=r24
.def thirty		=r25
init:
	ldi r16,Low(RAMEND)
	out SPL,r16
	ldi r16,High(RAMEND)
	out SPH,r16
	CLR r16
	out DDRC,r16
	rcall LCD_Init
    
; REGIST ADCSRA - STATUS AND CONTROL REGISTER ADC
;Бит 7 - ADEN: ADC Enable – "1" / "0" – включение/выключение схемы ЦАП.
;Бит 6 – ADSC: ADC Start Conversion – "1" – Запуск аналогово-цифрового преобразования.
;Бит 5 – ADATE: ADC Auto Trigger Enable – Автозапуск преобразования по внешним сигналам.
;Бит 4 – ADIF: ADC Interrupt Flag – "1" – Преобразование завершилось. Регистры данных ADCH:ADCL обновились.
;Бит 3 – ADIE: ADC Interrupt Enable – Разрешение прерывания по флагу ADIF.
;Биты 2:0 – ADPS2:0: ADC Prescaler Select Bits – Коэффициент деления частоты между XTAL и тактовым входом АЦП.
;           7    6     5     4     3     2     1     0
;ADCSRA = ADEN ADSC  ADATE ADIF  ADIE  ADPS2 ADPS1 ADPS0
      ldi r16,0b10000111  ;разрешить АЦП-прерывание и CLK/128
      sts ADCSRA,r16      ;старт преобразования
;ADPS2 ADPS1 ADPS0 = 111 = 	CLK/64; CLK - тактовая частота МК

;          7     6     5     4     3     2     1     0
;ADMUX = REFS1 REFS0 ADLAR  MUX4  MUX3  MUX2  MUX1  MUX0
      ldi r16,0b00000000  ;опорное - напряжение питания,
      sts ADMUX,r16       ;результат выравнивается to the left,
                          ;0-й канал АЦП
;Регистр ADMUX управляет выбором канала АЦП, источника опорного напряжения и способом выравнивания результата.
;REFS1 REFS0 = 0	0 - Внешний вывод AREF
;Бит 5 - ADLAR: ADC Left Adjust Result – выравнивание результата влево или вправо; ADLAR = 0 - выравнивание влево
;Биты 4:0 - MUX4:0: Analog Channel and Gain Selection Bits – выбор аналогового входа, подключенного ко входу АЦП согласно таблицы
	
READ_ADC:
      lds r16,ADCSRA
      ori r16,0b01000000 ; ori Rd, K - «Логическое ИЛИ» РОН и константы
      sts ADCSRA,R16      ;запуск преобразования
KEEP_POLING:	  ;сидим здесь в ожидании конца преобразования
      lds r16,ADCSRA
      mov r18,r16
      andi r18,0b00010000 ; andi Rd, K - «Логическое И» РОН и константы
      cpi r18,0b00010000  ;преобразование завершено?
      brne KEEP_POLING ; jump if z flag not set

      lds r17, ADCSRA
      ldi r20, 0b00001000
      eor r17,r20 		  ; «Исключающее ИЛИ» - установка единицы только при сравнении разных величин
      sts ADCSRA,r17      ;пишем 1 для очистки флага ADIF

convert_bin_to_dec:  
    lds init_data,ADCH    ;заканчиваем читать результат в ADCH после ADCL
	ldi ones,0x30
	ldi tens,0x30
	ldi hundreads,0x30
	ldi thirty,0x30
main:
	subi init_data,10
	brcs return_data_to_memory
	inc tens
	cpi tens,0x3A
	brcc plus_hundread
	clc
	rjmp main
return_data_to_memory:
	subi init_data,-10
	mov ones,init_data
	add ones,thirty
	rjmp indic
plus_hundread:
	inc hundreads
	subi tens,0x0A
	rjmp main
	
indic:
	sts 0x0200,tens
	sts 0x0201,ones
	ldi r17,2
	rcall LCD_Update
	rjmp main
	

.include "hd44780.asm"                            

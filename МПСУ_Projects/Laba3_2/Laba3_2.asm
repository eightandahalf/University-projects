.include "m328pdef.inc"
//
// 	WARNING - ALL REGISTERS THAT CONTAIN VALUES TO DISPLAY CONTAIN ADDRESSES OF 
// 	ELEMENTS IN SPECIAL PLACE OF DISPLAY MICROCONTROLLER
//
//
init: ldi R16,Low(RAMEND);обязательная инициализация стека
      out SPL,R16
      ldi R16,High(RAMEND)
      out SPH, R16
      clr R16
      out DDRC, R16     ;PortC  на ввод
	  ldi R16,0b11110000
	  out DDRD, R16 
      rcall LCD_Init    ;инициализация ЖКИ
      ldi R21, $30      ;symbol "0" - to display number of ones
	  ldi R22, $30		;for display number of tens
	  ldi R23, $30		;for display number of hundreads
	  ldi R24, $30
      bclr 6            ;разрешить увеличение счёта b6SREG=0
main: 
	  sbis PIND, 1   	;skip next line if 1-st bit of PINC is 1
    	  ldi R21, $30
      sbis PIND, 1	
		  ldi R22, $30

	  sbic PINC, 5     	;sktp if + button push! skip next line if 5-st bit of PINC is 0
      rjmp allow_increase 	;jump if button to increase value in display doesn't
	  				   		;pressed
	  brts check_for_increasing_num_of_tens ;jump if T flag is set
      inc R21
	  bset 6		  	;Ban the counter for incrementing
	  rjmp check_for_increasing_num_of_tens
allow_increase: ;and since button to increase value on display doesn't press,
				;then we allow for user to increase that value
	  bclr 6
check_for_increasing_num_of_tens:
	   cpi R21, $3A    			   ;$3A contains next symbol after last numeric symbol
					 			   ;i.e., 0011 1001 = "9", and 0011 1010 = ":"
 	   brne check_for_max_value    ;flag Z check and jump if that flag is not set
	   mov R21,R24		;mov zero to counter of ones
	   inc R22			;increment number of tens
check_for_max_value:
	   cpi R21, $36
	   brne indic
	   cpi R22, $34
	   brne indic
	   dec R21
indic:sts 0x0200, R22
	  sts 0x0201, R21
      ldi R17,0x02	   ;количество символов, выводимых на ЖКИ
      rcall LCD_Update ;вывод на ЖКИ области ОЗУ с адреса [$0200]
      rjmp main        ;организация бесконечного цикла

.include "hd44780.asm" ;библиотека работы с ЖКИ. Обязательно
                       ;подключение в конце программы

;Выводы DB7…DB0 это шина данных/адреса.
;E — стробирующий вход. Дрыгом напряжения на этой линии мы даем
;понять дисплею что нужно забирать/отдавать данные с/на шину 
;данных.
;RW — определяет в каком направлении у нас движутся данные. Если 
;1 — то на чтение из дисплея, если 0 то на запись в дисплей.
;RS — определяет что у нас передается, команда (RS=0) или данные 
;(RS=1). Данные будут записаны в память по текущему адресу, а 
;команда исполнена контроллером.

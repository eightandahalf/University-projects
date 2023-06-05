//
// WARNING
// НЕЛЬЗЯ ИСПОЛЬЗОВАТЬ ПОДОБНЫЙ КОД ОБРАБОТКИ СИГНАЛА С КНОПКИ МИНУС:
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
// ТАК КАК ПРИ ВЫЧИТАНИИ ИЗ 9 ЧИСЛА 1, В СТАРШЕМ РАЗРЯДЕ БУДЕТ ЕДИНИЦА, КОТОРУЮ НАШ 
// КОМПИЛЯТОР ВОСПРИМЕТ КАК ЗНАК МИНУС НАШЕГО ЧИСЛА, ТО ЕСТЬ 1001 0000 - 0001 0000 = 1000 0000. 
// ЕДИНИЦА В СТАРШЕМ РАЗРЯДЕ ГОВОРИТ ОБ ОТРИЦАТЕЛЬНОСТИ РЕЗУЛЬТАТА ВЫРАЖЕНИЯ.
// ПОЭТОМУ НАМ НУЖНО ВЫБРАТЬ АЛЬТЕРНАТИВНЫЙ СПОСОБ ПРОВЕРКИ ЛИКВИДНОСТИ НАШЕГО 
// ЗНАЧЕНИЯ, ПОЭТОМУ БУДЕТ СРАЗУ ВЫЧИТАТЬ ЕДИНИЦУ ИЗ ЧИСЛА, А ПОТОМ СРАВНИВАТЬ СО 
// ЗНАЧЕНИЕМ 0XF0, ЭТО ЗНАЧЕНИЕ ПОЛУЧИТСЯ, ЕСЛИ ИЗ НУЛЯ ВЫЧЕСТЬ ЕДИНИЦУ
//
//
//
// Физически сегмент представляет собой область памяти, занятую командами и (или) 
// данными, адреса которых вычисляются относительно значения в соответствующем сегментном регистре.

// Каждая программа содержит 3 типа сегментов:

// Сегмент  кодов – содержит машинные команды для выполнения. Обычно первая выполняемая 
// команда находится в начале этого сегмента, и операционная система передает управление 
// по адресу данного сегмента  для выполнения программы. Регистр сегмента кодов (CS) адресует данный сегмент.
// Сегмент данных – содержит данные, константы и рабочие  области, необходимые программе. 
// Регистр сегмента данных (DS) адресует данный сегмент.
// Сегмент стека — содержит адреса возврата как для программы (для возврата в операционную 
// систему), так и для  вызовов подпрограмм (для возврата в главную программу), а также используется 
// для передачи параметров в процедуры. Регистр сегмента стека (SS) адресует данный сегмент. Адрес 
// текущей вершины стека задается регистрами SS:ESP.//
//
//
//
// CSEG - Программный сегмент

// Директива CSEG определяет начало программного сегмента. Исходный файл может состоять из нескольких 
// программных сегментов, которые объединяются в один программный сегмент при компиляции. Программный 
// сегмент является сегментом по умолчанию. Программные сегменты имеют свои собственные счётчики положения, 
// которые считают не побайтно, а пословно. Директива ORG может быть использована для размещения кода и констант 
// в необходимом месте сегмента. Директива CSEG не имеет параметров.

// ORG - Установить положение в сегменте

// Директива ORG устанавливает счётчик положения равным заданной величине, которая передаётся как параметр. Для 
// сегмента данных она устанавливает счётчик положения в SRAM (ОЗУ), для сегмента программ это программный счётчик, 
// а для сегмента EEPROM это положение в EEPROM. Если директиве предшествует метка (в той же строке) то метка 
// размещается по адресу указанному в параметре директивы. Перед началом компиляции программный счётчик и счётчик 
// EEPROM равны нулю, а счётчик ОЗУ равен 32 (поскольку адреса 0-31 заняты регистрами). Обратите внимание что для 
// ОЗУ и EEPROM используются побайтные счётчики а для программного сегмента - пословный.

// 'ORG' устанавливает адрес, по которому следующий за ней код должен появиться в памяти.
// За ней должно следовать числовое выражение, указывающее адрес. Эта директива начинает новое адресное пространство,
// следующий код сам по себе никуда не двигается, но все метки, определенные в нем и значение символа "$" изменяются, 
// как если-бы он был бы помещён по этому адресу.
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

.org INT_VECTORS_SIZE     ; Конец таблицы прерываний

Ext_INT0:                 	; Обработчик прерывания по входу INT0
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
ret0: reti                	; Выход из обработчика прерывания

Ext_INT1:                 ; Обработчик прерывания по входу INT1
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
ret1: reti                ; Выход из обработчика прерывания

Reset:
	ldi R16,Low(RAMEND) ; Старт программы
    out SPL,R16         ; Обязательная инициализация стека
    ldi R16,High(RAMEND); Указатель стека устанавливается
    out SPH,R16         ; на конец ОЗУ
    ldi R16,0b00000011  ; Разрешить прерывания
    out EIMSK,R16       ; INT0 и INT1 локально
    ldi R16,0b00001010  ; Настройка условия генерации прерывания
    sts EICRA,R16       ; по спаду входного сигнала
    sei                 ; Разрешить прерывания глобально
    ldi R16,0b11110000  ; Настройка на вывод линий 4..7
    out DDRD,R16        ; порта D
	ldi R16,0b00001111  ; Настройка на вывод линий 0..3
    out DDRB,R16        ; порта B
	clr R16
	out DDRC,R16
    clr counter         ; Сброс счётчика
    ldi R16,0b00010000  ; 1
	ldi nine,0b10010000 ; 9
main: 
	sbis PINC,5         ; Проверить кнопку RESET
    rjmp clear          ; Если нажата, то сброс счётчика
    andi ones,0b11110000
    out PORTD,ones       ; Вывод
	andi tens,0b00001111 ; 
	out PORTB,tens
    rjmp main

clear:
	clr ones
	clr tens
	clr counter
	rjmp main

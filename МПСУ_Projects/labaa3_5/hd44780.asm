/*
* Имя : hd44780.asm
* Описание : Это драйвер для алфавитно-цифрового LCD HD44780
* Таблица команд:
*DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0 Значение
*0 0 0 0 0 0 0 1 Очистка экрана. Счетчик адреса на 0 позицию DDRAM
*0 0 0 0 0 0 1 - Адресация на DDRAM сброс сдвигов, Счетчик адреса на 0
*0 0 0 0 0 1 I/D S Настройка сдвига экрана и курсора
*0 0 0 0 1 D C B Настройка режима отображения
*0 0 0 1 S/C R/L - - Сдвиг курсора или экрана, в зависимости от битов
*0 0 1 DL N F - - Выбор числа линий, ширины шины и размера символа
*0 1 AG AG AG AG AG AG Переключить адресацию на SGRAM и задать адрес в SGRAM
*1 AD AD AD AD AD AD AD Переключить адресацию на DDRAM и задать адрес в DDRAM

Значение отдельных бит:
I/D — инкремент/декремент счётчика адреса. По дефолту 0 — Декремент. Т.е. каждый следующий
байт будет записан в n-1 ячейку. Если I/D=1 — Инкремент.
S — сдвиг экрана. При S=1 с каждым новым символом будет сдвигаться окно экрана, пока не
достигнет конца DDRAM. Удобно при выводе на экран длинной строки, на все 40 символов,
чтобы не убегала за экран.
D — включить дисплей. При D=0 изображение исчезнет, при этом в DDRAM можно готовить следующую
строку. А чтобы картинка появилась в эту позицию надо записать 1.
С — включить курсор в виде прочерка. 1 — курсор включен
B — сделать курсор в виде мигающего черного квадрата.
S/C — сдвиг курсора или экрана. Если стоит 0, то сдвигается курсор. Если 1, то экран. По одному
разу за команду
R/L — направление сдвига курсора и экрана. 0 — влево, 1 — вправо.
D/L — ширина шины данных. 1-8 бит, 0-4 бита
N — число строк. 0 — одна строка, 1 — две строки.
F — размер символа 0 — 5х8 точек. 1 — 5х10 точек (встречается крайне редко)
AG — адрес в памяти CGRAM
АD — адрес в памяти DDRAM
*/

.include "m328pdef.inc"
.def tim1=r19            ; счетчик цикла 1
.def tim2=r20            ; счетчик цикла 2

.equ LCDdat_PORT = PORTD
.equ LCDdat_DDR = DDRD
.equ LCDctrl_PORT = PORTB
.equ LCDctrl_DDR = DDRB

.equ LCD_D4 = 4
.equ LCD_D5 = 5
.equ LCD_D6 = 6
.equ LCD_D7 = 7

.equ LCD_RS = 0         ;линия PD4 для формирования сигнала RS
.equ LCD_EN = 1         ;линия PD2 для формирования сигнала E

;******** ВЫВОД ОБЛАСТИ ОЗУ С АДРЕСА [$0200] 16 СИМВОЛОВ НА LCD **********
;Входной параметр: в r17 количество выводимых символов
LCD_Update:
ldi r16,0b10000000      ;Задать адрес в DDRAM 80 - 0-й, С0 - 1-й
rcall Wait5ms;
rcall LCD_Cmd1_2Byte    ;Отправка команды на LCD полубайтом
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

;****************************ИНИЦИАЛИЗАЦИЯ ЖК-МОДУЛЯ**********************
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

ldi R16,$30             ;установка функции 8 разрядов 1-й раз.....
rcall LCD_Cmd1Byte      ;отправка команды на LCD одним байтом
rcall Wait38ms          ;
rcall LCD_Cmd1Byte      ;8 разрядов 2-й раз... отправка команды на LCD
rcall Wait38ms          ;
ldi R16,$20             ;установка шины на 4 разряда
rcall LCD_Cmd1Byte      ;отправка команды на LCD одним байтом
rcall Wait38ms
ldi R16,$20             ;установка шины на 4 разряда

rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
rcall Wait38ms;
ldi R16,0b00101000      ;шина 4 разряда, 2 строчный индикатор, матрица 5х8
rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
rcall Wait38ms;
ldi R16,0b00001000      ;отключение индикаторва, курсора, мерцания
rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
rcall Wait38ms;
ldi R16,0b00000001      ;очистка экрана и установка курсора в начало первой строки
rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
rcall Wait38ms;
ldi R16,0b00000110      ;режим инкремента адреса, без сдвига
rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
rcall Wait38ms;
ldi R16,$0C             ;включить LCD, отключить курсор, отключить мерцание
rcall LCD_Cmd1_2Byte    ;отправка команды на LCD полубайтом
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

;****************** ПОДПРОГРАММА ПЕРЕДАЧИ КОМАНДЫ В ЖК-МОДУЛЬ *************
LCD_Cmd1_2Byte:
cbi PORTB,LCD_RS        ; устанавливаем RS=0 (команда);
rcall LCD_Send1_2Byte
ret

;****************** ПОДПРОГРАММА ПЕРЕДАЧИ ДАННЫХ В ЖК-МОДУЛЬ *************
LCD_SendDat:
sbi PORTB,LCD_RS        ; устанавливаем RS=1 (данные);
rcall LCD_Send1_2Byte
ret

LCD_Send1_2Byte:        ;выдача полубайта
sbi LCDctrl_PORT,LCD_EN ;E=1
rcall LCD_WriteNibble   ;Выставили в порт старшую тетраду
cbi LCDctrl_PORT,LCD_EN ;E=0
swap r16
sbi LCDctrl_PORT,LCD_EN ;E=1
rcall LCD_WriteNibble   ;Выставили в порт младшую тетраду
cbi LCDctrl_PORT,LCD_EN ;E=0
ret

;****************** ПОДПРОГРАММА ПЕРЕДАЧИ КОМАНДЫ В ЖК-МОДУЛЬ *************
LCD_Cmd1Byte:
cbi LCDctrl_PORT,LCD_RS ;устанавливаем RS=0 (команда);
rcall LCD_WriteNibble
sbi LCDctrl_PORT,LCD_EN ;E=1
cbi LCDctrl_PORT,LCD_EN ;E=0
clr R16
ret

;********************** ПОДПРОГРАММЫ ЗАДЕРЖКИ *****************************
Wait50us:               ; задержка 50мкс
ldi tim1,65
Wait51:
dec tim1                ; 1такт
brne Wait51             ; 2такта и 1такт на выходе
ret                     ; 4 такта Итого 195 тактов 0,0000121875 сек для F_CPU=16МГц 12,18мкс

Wait150us:              ; задержка 150мкс
rcall Wait50us
rcall Wait50us
rcall Wait50us
ret                     ;0,0000375 сек (37.5мкс)

Wait5ms:                ; задержка 5мс
ldi tim2,100            ; загрузка счётчика
Wait501: rcall Wait50us
dec tim2
brne Wait501
ret

Wait38ms:               ; задержка 38мс
ldi tim2,0              ; загрузка счётчика
Wait381:
rcall Wait150us
dec tim2
brne Wait381
ret
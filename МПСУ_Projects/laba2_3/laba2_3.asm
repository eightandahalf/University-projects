.include "m2560def.inc"
.def first_op 	=r16
.def temp 		=r17
.def init_data	=r18
.def result		=r19
.def sec_op		=r20
.def masc_to_invertion 	=r21
init:
	ldi init_data,0xA2
	ldi first_op,0b10100000
	ldi sec_op,0b00001010
	ldi masc_to_invertion,0b00001000
main:	
	mov temp,init_data
	and temp,first_op
	mov first_op,temp

	cpi first_op,0b10100000
	breq fist_op_eq_1
	cpi first_op,0b10000000
	breq fist_op_eq_0
	cpi first_op,0b00100000
	breq fist_op_eq_0
	
	// if we here than - first_op = 0

	rjmp fist_op_eq_0

fist_op_eq_0:
	ldi first_op,0
	mov temp,init_data
	and temp,sec_op
	mov sec_op,temp
	eor sec_op,masc_to_invertion

	cpi sec_op,0b00001010
	breq result_operation
	cpi sec_op,0b00001000
	breq result_zero
	cpi sec_op,0b00000010
	breq result_zero

	// if we here than - sec_op = 0 and first_op = 0
	
	add sec_op,first_op
	mov result,sec_op
	sts 0x0245,result

	rjmp init
fist_op_eq_1:
	ldi first_op,1
	mov temp,init_data
	and temp,sec_op
	mov sec_op,temp
	eor sec_op,masc_to_invertion

	cpi sec_op,0b00001010
	breq result_operation
	cpi sec_op,0b00001000
	breq result_zero
	cpi sec_op,0b00000010
	breq result_zero

	// if we here than - sec_op = 0 and first_op = 0

	add sec_op,first_op
	mov result,sec_op
	sts 0x0245,result

	rjmp init
result_operation:
	ldi sec_op,1
	add sec_op,first_op
	mov result,sec_op
	sts 0x0245,result
	rjmp init
result_zero:
	ldi sec_op,0
	add sec_op,first_op
	mov result,sec_op
	sts 0x0245,result
	rjmp init

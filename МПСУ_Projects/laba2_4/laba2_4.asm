.include "m328pdef.inc"
.def result 	=r16
.def temp		=r17
init:
	//.equ first_elem_address = 0x0200 // address of first element in array 
	//.equ last_elem_address = 0x0209 // address of last element in array 

	.equ msb_of_first_elem_add = $2
	.equ lsb_of_first_elem_add = $0
	.equ msb_of_last_elem_add = $2
	.equ lsb_of_last_elem_add = $9
	ldi result,0

main:
	ldi r31,msb_of_last_elem_add // r30 = address(last_elem_in_array) + 1 = 0x0210
	ldi r30,lsb_of_last_elem_add + 1 

	sum_cycle:
		ld temp,-Z // tmp16a = value of address at_bcd_3
		add result,temp
		cpi ZL,lsb_of_first_elem_add // ZL(r30) - lsb_of_first_elem_add = 0x09-0x00
		breq put_res_to_memory ; loop again if ZL > at_bcd_0
		rjmp sum_cycle 
put_res_to_memory:
	sts 0x0345,result
	
	

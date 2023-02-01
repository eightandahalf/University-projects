.include "m328pdef.inc"

// .def	dres8u	=r16		;result
.def	dd8u	=r15		;dividend
.def	dv8u	=r16		;divisor
.def	drem8u	=r17		;remainder

;***** Code
init:
	ldi r20,0x45
	mov dd8u,r20
	ldi dv8u,0x40 // 40 hex = 64 decimal
	sts 0x0345,r15
	sts 0x0346,r17
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

.include "m328pdef.inc"
.def six =r16
.def sixty =r17
.def sixtysix =r18
.def first_operand =r19
.def second_operand =r20
.def msb_res =r23
.def lsb_res =r24
init:
	mov lsb_res,first_operand
	sts 0x0345,msb_res
	sts 0x0346,lsb_res
	ldi msb_res,0x00
	ldi six,0x06
	ldi sixty,0x60
	ldi sixtysix,0x66
	ldi first_operand,0x99 // result
	ldi second_operand,0x45
main:
	add first_operand,second_operand
	brhc H_equal_to_0_way // Checks the half-port flag (H) and performs a jump if this bit is reset
	// if we here that it means that H = 1
	brcc H_eq_to1_and_C_equal_to0 // Checks the migration flag (C) and performs a jump if this bit is reset
		/////////
		////////
		// if we here that it means that H = 1 and C = 1 after sum of two operand
		////////
		/////////

		inc msb_res
		clc

		add first_operand,sixtysix
		brhc firstway_h_eq_to0
		brcc firstway_h_eq_to_1_c_to_0
		// after adding correct num to sum we get c = 1, h = 1
		inc msb_res
		clc 
		sub first_operand,sixtysix
		rjmp init
		firstway_h_eq_to0:
			brcc firstway_h_and_c_eq_to0
			// after adding correct num to sum we get c = 1, h = 0
			inc msb_res
			sub first_operand,sixty
			rjmp init
		firstway_h_and_c_eq_to0:
			// after adding correct num to sum we get c = 0, h = 0
			rjmp init // check+
		firstway_h_eq_to_1_c_to_0:
			// after adding correct num to sum we get c = 0, h = 1
			sub first_operand,six
			rjmp init

	H_equal_to_0_way:
		brcc H_and_C_equal_to_0_way // Checks the migration flag (C) and performs a jump if this bit is reset
		/////////
		////////
		// if we here that it means that H = 0 and C = 1 after sum of two operand
		////////
		/////////
		
		inc msb_res
		clc

		add first_operand,sixtysix
		brhc secondway_h_eq_to0
		brcc secondway_h_eq_to_1_c_to_0
		// after adding correct num to sum we get c = 1, h = 1
		inc msb_res
		clc 
		sub first_operand,sixty
		rjmp init
		secondway_h_eq_to0:
			brcc secondway_h_and_c_eq_to0
			// after adding correct num to sum we get c = 1, h = 0
			inc msb_res
			sub first_operand,sixtysix
			rjmp init
		secondway_h_and_c_eq_to0:
			// after adding correct num to sum we get c = 0, h = 0
			sub first_operand,six // was check+
			rjmp init
		secondway_h_eq_to_1_c_to_0:
			// after adding correct num to sum we get c = 0, h = 1
			rjmp init // was checks+

	H_eq_to1_and_C_equal_to0:
		/////////
		////////
		// if we here that it means that H = 1 and C = 0 after sum of two operand
		////////
		/////////
		add first_operand,sixtysix
		brhc thirdway_h_eq_to0
		brcc thirdway_h_eq_to_1_c_to_0
		// after adding correct num to sum we get c = 1, h = 1
		inc msb_res
		clc 
		sub first_operand,six // was check?
		rjmp init
		thirdway_h_eq_to0:
			brcc thirdway_h_and_c_eq_to0
			// after adding correct num to sum we get c = 1, h = 0
			inc msb_res // was check+
			rjmp init
		thirdway_h_and_c_eq_to0:
			// after adding correct num to sum we get c = 0, h = 0
			sub first_operand,sixty // was check+
			rjmp init
		thirdway_h_eq_to_1_c_to_0:
			// after adding correct num to sum we get c = 0, h = 1
			sub first_operand,sixtysix
			rjmp init

	H_and_C_equal_to_0_way:
		/////////
		////////
		// if we here that it meand that H = 0 and C = 0 after sum of two operand
		////////
		/////////
		add first_operand,sixtysix
		brhc fourthway_h_eq_to0
		brcc fourthway_h_eq_to_1_c_to_0
		// after adding correct num to sum we get c = 1, h = 1
		inc msb_res // was check+
		clc 
		rjmp init
		fourthway_h_eq_to0:
			brcc fourthway_h_and_c_eq_to0
			// after adding correct num to sum we get c = 1, h = 0
			inc msb_res
			sub first_operand,six // was check+
			rjmp init
		fourthway_h_and_c_eq_to0:
			// after adding correct num to sum we get c = 0, h = 0
			sub first_operand,sixtysix // was check+
			rjmp init
		fourthway_h_eq_to_1_c_to_0:
			// after adding correct num to sum we get c = 0, h = 1
			sub first_operand,sixty // was check+
			rjmp init

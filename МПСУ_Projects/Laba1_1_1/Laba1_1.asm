// First case: R12 = 0x88, R18 = 45
// Second case: R12 = 0x00, R18 = 45
// Third case: R12 = 0xFF, R18 = 45
//
// Immediate instructions only work with registers 16 through 31. 
// Trying to use them with registers 0 through 15 will result in an error.
// 
// The contents of one register can be copied to another register using the 
// mov instruction. Since ldi only works on registers 16 through 31, the mov 
// instruction is a useful way to load a constant into one of the lower 16 registers. 
// For example, the below code shows a constant being loaded in r18 and mov being used 
// to copy it to r12.
// 
.include "m328pdef.inc"
	  lds r18,0x0245 // the second operand is placed in 0x0245

	  // adding:

	  ldi r20,0x88
	  mov r12,r20    // the first operand that equals to is placed in r12
      add r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  

      ldi r20,0x00
	  mov r12,r20    // the first operand that equals to is placed in r12
	  add r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  

 	  ldi r20,0xFF
	  mov r12,r20    // the first operand that equals to is placed in r12
	  add r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  

	  // substracting:

	  ldi r20,0x88
	  mov r12,r20    // the first operand that equals to is placed in r12
      sub r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  

      ldi r20,0x00
	  mov r12,r20    // the first operand that equals to is placed in r12
	  sub r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  

 	  ldi r20,0xFF
	  mov r12,r20    // the first operand that equals to is placed in r12
	  sub r12,r18    // addition r12=r12+r18
      sts 0x0345,r12 // result preservation  
end:  rjmp end       


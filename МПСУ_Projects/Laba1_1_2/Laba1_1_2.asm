// First case: R12 = 0x88, R17 = 0x88, R18 = 0x45, R19 = 0xAB
// First case: R12 = 0x00, R17 = 0x00, R18 = 0xAB, R19 = 0x45
// First case: R12 = 0xFF, R17 = 0xFF, R18 = 0xA4, R19 = 0x5B
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

	  // adding:

      ldi r20,0x88   // r20 - temp register
	  mov r12,r20    // r12,0x88
      ldi r17,0x88   // r20,0x88
      lds r18,0x0245 // r18,0x45
      lds r19,0x0246 // r19,0xAB
      add r17,r19    // r21 = r21 + r18
      adc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation  

	  ldi r20,0x00   // r20 - temp register
	  mov r12,r20    // r12,0x00
      ldi r17,0x00   // r20,0x00
      lds r18,0x0245 // r18,0xAB
      lds r19,0x0246 // r19,0x45
      add r17,r19    // r21 = r21 + r18
      adc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation  

 	  ldi r20,0xFF   // r20 - temp register
	  mov r12,r20    // r12,0xFF
      ldi r17,0xFF   // r20,0xFF
      lds r18,0x0245 // r18,0xA4
      lds r19,0x0246 // r19,0x5B
      add r17,r19    // r21 = r21 + r18
      adc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation  

	  // substracting:
	
      ldi r20,0x88   // r20 - temp register
	  mov r12,r20    // r12,0x88
      ldi r17,0x88   // r20,0x88
      lds r18,0x0245 // r18,0x45
      lds r19,0x0246 // r19,0xAB
      sub r17,r19    // r21 = r21 + r18
      sbc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation  

	  ldi r20,0x00   // r20 - temp register
	  mov r12,r20    // r12,0x00
      ldi r17,0x00   // r20,0x00
      lds r18,0x0245 // r18,0xAB
      lds r19,0x0246 // r19,0x45
      sub r17,r19    // r21 = r21 + r18
      sbc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation  

 	  ldi r20,0xFF   // r20 - temp register
	  mov r12,r20    // r12,0xFF
      ldi r17,0xFF   // r20,0xFF
      lds r18,0x0245 // r18,0xA4
      lds r19,0x0246 // r19,0x5B
      sub r17,r19    // r21 = r21 + r18
      sbc r12,r18    // r20 = r20 + r19 + FlagC
	  sts 0x0346,r17 // result preservation  
	  sts 0x0345,r12 // result preservation    
end:  rjmp end       


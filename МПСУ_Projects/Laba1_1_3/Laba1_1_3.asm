// First case: R17 = 0x00, R18 = 0x02, r12 = 0x45
// Second case: R17 = 0x00, R18 = 0x10, r12 = 0x45
// Third case: R17 = 0x01, R18 = 0x00, r12 = 0x45
// Fourth case: R17 = 0xA4, R18 = 0x5B, r12 = 0x45
.include "m328pdef.inc"
	 ldi r20,0x45  
	 mov r12,r20	
	 lds r17,0x0245
	 lds r18,0x0246	
	 mul r18,r12		                      
	 mov r25,r1	
	 mov r26,r0	                        
	 mul r17,r12		                       
	 add r25,r0		                          
	 sts 0x0345,r1		
	 sts 0x0346,r25	 
	 sts 0x0347,r26	                                                                                      
end:  rjmp end     

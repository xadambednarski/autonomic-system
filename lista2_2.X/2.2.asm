list p=16f877A
#include <p16f877a.inc>
__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF
RES_VECT CODE 0x0000
    goto START
    
MAIN_PROG CODE
 
START			
    bcf STATUS, RP1	
    bsf STATUS, RP0	
    movlw 0x00		
    movwf TRISA		
    movlw 0xFF		
    movwf TRISC		
    bcf STATUS, RP0     
    movlw 0x00		
    movwf PORTA		
    movlw 0x00		
    movwf 0x20		
    goto LOOP		

LED0
    btfsc PORTA,0	
    bcf 0x20, 0		
    btfss PORTA,0	
    bsf 0x20, 0		
    goto FLAG0		
    
LED1
    btfsc PORTA,1	
    bcf 0x20, 1		
    btfss PORTA,1	
    bsf 0x20, 1		
    goto FLAG1		
LED2
    btfsc PORTA,2	
    bcf 0x20, 2
    btfss PORTA,2
    bsf 0x20, 2
    goto FLAG2
LED3
    btfsc PORTA,3
    bcf 0x20, 3
    btfss PORTA,3
    bsf 0x20, 3
    goto FLAG3

LOOP			
    btfsc PORTC, 0	
    goto LED0		
    FLAG0		
    btfsc PORTC, 1	
    goto LED1		
    FLAG1
    btfsc PORTC, 2	
    goto LED2
    FLAG2
    btfsc PORTC, 3	
    goto LED3
    FLAG3
    movf 0x20, W	
    movwf PORTA		
    goto LOOP		
    end    
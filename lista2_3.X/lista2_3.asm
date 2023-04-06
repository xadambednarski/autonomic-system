list p=16f877A
#include "p16f877a.inc"
 __CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF
 
RES_VECT  CODE    0x0
    GOTO START
    
CBLOCK 0x20
    time_0
    time_1
    curr_led
ENDC

MAIN_PROG CODE

START
    banksel TRISA	
    clrf TRISA		
    banksel PORTA	
    clrf curr_led	
    bsf curr_led, 0	

LEDON
    movlw 0xFF
    movwf PORTA		    

LOOP
    movlw 0xFF		   
    movwf timer_0	    
    goto LOOP1		    

LOOP1
    movlw 0xFF		   
    movwf time_1	    
    decf time_0	   
    btfsc STATUS, Z	    
    goto LEDOFF

LOOP2
    decf time_1
    btfsc STATUS, Z	    
    goto LOOP1		    
    goto LOOP2		    
    
LEDOFF
    movf curr_led, 0	    
    xorwf TRISA, 1	    
    rlf curr_led, 1	    
    btfsc curr_led, 5   
    goto END_		  
    goto LOOP	    

END_
    goto $
    end
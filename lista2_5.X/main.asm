;list p=16f877A
#include "p16f877a.inc"

 __CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF

RES_VECT  CODE    0x0
    GOTO START               

MAIN_PROG CODE

curr_state equ 0x20
prev_state equ 0x21
time equ 0x22
time_curr equ 0x23

START
    banksel OPTION_REG
    movlw 0x00
    movwf TRISA
    movwf TRISB
    movlw 0xFF
    movwf TRISC

    bcf OPTION_REG, 7	    
    bcf OPTION_REG, 5	    
    bcf OPTION_REG, 4	    
    bcf OPTION_REG, 3	    
    bsf OPTION_REG, 2
    bsf OPTION_REG, 1
    bsf OPTION_REG, 0	    
    
    banksel PORTA
    movlw 0x00
    movwf PORTA
    movwf prev_state
    
    movlw 0x01
    movwf time
    movwf time_curr
    
    goto LOOP
    
    
INCREASE
    movlw b'00000010'
    movwf curr_state
    
    bcf STATUS, Z 
    comf prev_state, 0	   
    andwf curr_state, 0 
    btfsc STATUS, Z	   
    return		   
    
    bcf STATUS, Z
    movf time, 0	  
    sublw 0xFF
    btfsc STATUS, C	    
    incf time, 1	   
    return
    
DECREASE
    movlw b'00000001'
    movwf curr_state
    
    bcf STATUS, Z
    comf prev_state, 0	  
    andwf curr_state, 0
    btfsc STATUS, Z	    
    return		    
    
    bcf STATUS, Z
    movf time, 0	  
    sublw 0x01
    btfsc STATUS, C	    
    decf time, 1	    
    return

FLASH
    bcf INTCON, 2	    
    decfsz time_curr    
    goto LOOP		    
    
    movlw 0xFF		    
    xorwf PORTA, 1	    
    movf time, 0	    
    movwf time_curr	   
    
LOOP
    movlw 0x00		
    movwf curr_state	 
    
    btfsc PORTC, 0
    call DECREASE
    btfsc PORTC, 1
    call INCREASE
    
    movf curr_state, 0 
    movwf prev_state	    

    movf time_curr, 0  
    movwf PORTB		
    
    btfsc INTCON, 2
    goto FLASH
    goto LOOP		
    end

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
    movlw 0x00
    movwf 0x21	
    movlw 0x00
    movwf 0x22	
    movlw 0x00
    movwf 0x23	
    movlw 0x01
    movwf 0x25	

LOOP1
    movlw 0xFF		
    movwf 0x26	
    decf 0x25	
    btfsc STATUS,Z
    goto LOOP
LOOP2
    decf 0x26	
    btfsc STATUS,Z
    goto LOOP1
    goto LOOP2
    
    
LOOP
    movlw 0xFF		
    movwf 0x25	
    movlw 0x3F
    
    btfsc PORTC, 0
    movwf 0x20	
    btfsc PORTC, 1
    movwf 0x21
    btfsc PORTC, 2
    movwf 0x22
    btfsc PORTC, 3
    movwf 0x23
    
    btfss 0x20,0
    bcf PORTA,0	
    btfss 0x21,0
    bcf PORTA,1
    btfss 0x22,0
    bcf PORTA,2
    btfss 0x23,0
    bcf PORTA,3
    
    btfsc 0x20,0
    bsf PORTA,0
    btfsc 0x21,0
    bsf PORTA,1
    btfsc 0x22,0
    bsf PORTA,2
    btfsc 0x23,0
    bsf PORTA,3
		
    btfsc PORTA,0
    rrf 0x20, 1
    btfsc PORTA,1
    rrf 0x21, 1
    btfsc PORTA,2
    rrf 0x22, 1
    btfsc PORTA,3
    rrf 0x23, 1
    goto LOOP1
    end

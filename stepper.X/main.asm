#include "p18f452.inc"

  CONFIG  OSC = RCIO
  CONFIG  OSCS = OFF
  
  CONFIG  PWRT = OFF
  CONFIG  BOR = ON
  CONFIG  BORV = 20
  
  CONFIG  WDT = OFF
  CONFIG  WDTPS = 128
  
  CONFIG  CCP2MUX = ON
  
  CONFIG  STVR = ON
  CONFIG  LVP = ON
  
  CONFIG  CP0 = OFF
  CONFIG  CP1 = OFF
  CONFIG  CP2 = OFF
  CONFIG  CP3 = OFF
  
  CONFIG  CPB = OFF
  CONFIG  CPD = OFF
    
  CONFIG  WRT0 = OFF
  CONFIG  WRT1 = OFF
  CONFIG  WRT2 = OFF
  CONFIG  WRT3 = OFF
  
  CONFIG  WRTC = OFF
  CONFIG  WRTB = OFF
  CONFIG  WRTD = OFF
  
  CONFIG  EBTR0 = OFF
  CONFIG  EBTR1 = OFF
  CONFIG  EBTR2 = OFF
  CONFIG  EBTR3 = OFF
  
  CONFIG  EBTRB = OFF

ZERO   CODE 0x0000
    GOTO START
PROG   CODE
   
CZEKAJ_SLOW
    movlw 0xff
    movwf 0x80
    movwf 0x81
    
CZEKAJ_FAST
    movlw 0x10
    movwf 0x80
    movwf 0x81
    
CZEKAJ1
    decf 0x80
    btfsc STATUS,Z 
    return
CZEKAJ2
    decf 0x81
    btfsc STATUS,Z 
    goto CZEKAJ1
    goto CZEKAJ2

CHECK_STOP
    btfss PORTD, 0
    return
    goto WAIT_RESUME

WAIT_RESUME
    btfss PORTD, 1
    goto WAIT_RESUME
    return

CHECK_SPEED
    btfsc PORTD, 2
    goto SLOWER
    btfsc PORTD, 3
    goto FASTER
    return
    
SLOWER
    movlw 0xff
    movwf 0x80
    return

FASTER
    movlw 0x10
    movwf 0x80
    return

    
PETLA_DO_PRZODU 
    movlw b'00000001'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_TYLU
    
    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00000010'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_TYLU
    
    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00000100'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_TYLU

    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00001000'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_TYLU
    
    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    
    goto PETLA_DO_PRZODU

PETLA_DO_TYLU
    movlw 0x01
    movwf 0x85

    movlw b'00001000'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_PRZODU
    
    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000100'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_PRZODU

    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000010'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_PRZODU

    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000001'
    movwf PORTB
    
    btfsc PORTD, 4
    goto PETLA_DO_PRZODU

    btfss PORTD, 2
    btfss PORTD, 3
    call CZEKAJ_SLOW
    call CZEKAJ_FAST
    
    call CHECK_STOP
    call CHECK_SPEED
    
    goto PETLA_DO_TYLU

START
    clrf TRISB
    bsf  TRISD, 0
    bsf  TRISD, 1
    bsf  TRISD, 2
    bsf  TRISD, 3
    goto PETLA_DO_PRZODU
END

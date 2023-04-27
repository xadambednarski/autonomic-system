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
   
WAIT_SLOW
    movlw 0xff
    movwf 0x80
    movwf 0x81
    
WAIT_FAST
    movlw 0x10
    movwf 0x80
    movwf 0x81
    
WAIT1
    decf 0x80
    btfsc STATUS,Z 
    return

WAIT2
    decf 0x81
    btfsc STATUS,Z 
    goto WAIT1
    goto WAIT2

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

WAIT_DISPLAY
    movlw 0x02
    movwf 0x80

WAIT_DISPLAY1
    movlw 0x02
    movwf 0x81
    decf 0x80
    btfsc STATUS,Z
    return

WAIT_DISPLAY2
    decf 0x81
    btfsc STATUS, Z
    goto WAIT_DISPLAY1
    goto WAIT_DISPLAY2

CONFIRM
    btfss PORTC, 0
    incf PORTC, 1
    call WAIT_DISPLAY1
    movlw b'11111110'
    andwf PORTC, 1
    call WAIT_DISPLAY
    return
    
DISPLAY_FAST
    
    movlw b'00000000'
    movwf PORTC
    
    movlw b'00110000'
    movwf PORTA
    call CONFIRM
    
    movlw b'00001111'
    movwf PORTA
    call CONFIRM
    
    movlw b'00000110'
    movwf PORTA
    call CONFIRM
    
    movlw b'00000001'
    movwf PORTA
    call CONFIRM
    
;   w
    movlw b'01110111'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
    
;   =
    movlw b'00111101'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM

;   0
    movlw b'00110000'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   ,
    movlw b'00101100'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   8
    movlw b'00111000'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   4
    movlw b'00110001'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
    
    movlw b'00000001'
    movwf PORTA
    call CONFIRM

    return

DISPLAY_SLOW
    
    movlw b'00000000'
    movwf PORTC
    
    movlw b'00110000'
    movwf PORTA
    call CONFIRM
    
    movlw b'00001111'
    movwf PORTA
    call CONFIRM
    
    movlw b'00000110'
    movwf PORTA
    call CONFIRM
    
    movlw b'00000001'
    movwf PORTA
    call CONFIRM
    
;   w
    movlw b'01110111'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
    
;   =
    movlw b'00111101'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM

;    1
    movlw b'00110001'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   ,
    movlw b'00101100'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   4
    movlw b'00110100'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
;   0
    movlw b'00110000'
    movwf PORTA
    movlw b'00000101'
    movwf PORTC
    call CONFIRM
    
    movlw b'00000001'
    movwf PORTA
    call CONFIRM
    
    return

SLOWER1
    movlw 0x00
    movwf 0x90
    call WAIT_SLOW
    movlw 0xff
    movwf 0x91
    return

FASTER1
    movlw 0x00
    movwf 0x91
    call WAIT_FAST
    movlw 0xff
    movlw 0x90
    return
    

GO_FORWARD
    btfss 0x90, 1
    call DISPLAY_SLOW

    btfss 0x91, 1
    call DISPLAY_FAST

    movlw b'00000001'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_BACKWARD
    
    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00000010'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_BACKWARD
    
    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00000100'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_BACKWARD

    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    
    movlw b'00001000'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_BACKWARD
    
    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    
    goto GO_FORWARD

GO_BACKWARD
    btfss 0x90, 1
    call DISPLAY_SLOW

    btfss 0x91, 1
    call DISPLAY_FAST

    movlw b'00001000'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_FORWARD
    
    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000100'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_FORWARD

    call SLOWER1
    btfsc PORTD, 3
    call FASTER1

    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000010'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_FORWARD

    call SLOWER1
    btfsc PORTD, 3
    call FASTER1

    call CHECK_STOP
    call CHECK_SPEED
    movlw b'00000001'
    movwf PORTB
    
    btfsc PORTD, 4
    goto GO_FORWARD

    call SLOWER1
    btfsc PORTD, 3
    call FASTER1
    
    call CHECK_STOP
    call CHECK_SPEED
    
    goto GO_BACKWARD

START
    clrf TRISB
    clrf TRISA
    clrf TRISC
    bsf  TRISD, 0
    bsf  TRISD, 1
    bsf  TRISD, 2
    bsf  TRISD, 3
    
    movlw 0x00
    movwf 0x90
    
    movlw 0xff
    movwf 0x91

    call GO_FORWARD
    END

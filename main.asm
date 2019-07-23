    .thumb

       .text
       .align  2
P5IN    .field 0x40004C40,32  ; Port 5 Input
P4IN    .field 0x40004C21,32  ; Port 4 Input
P5OUT   .field 0x40004C42,32  ; Port 5 Output
P4OUT   .field 0x40004C23,32  ; Port 4 Output
P5DIR   .field 0x40004C44,32  ; Port 5 Direction
P4DIR   .field 0x40004C25,32  ; Port 4 Direction
P5REN   .field 0x40004C46,32  ; Port 5 Resistor Enable
P4REN   .field 0x40004C27,32  ; Port 4 Resistor Enable
P5DS    .field 0x40004C48,32  ; Port 5 Drive Strength
P4DS    .field 0x40004C29,32  ; Port 4 Drive Strength
P5SEL0  .field 0x40004C4A,32  ; Port 5 Select 0
P4SEL0  .field 0x40004C2B,32  ; Port 4 Select 0
P5SEL1  .field 0x40004C4C,32  ; Port 5 Select 1
P4SEL1  .field 0x40004C2D,32  ; Port 4 Select 1



      .global main
      .thumbfunc main

main: .asmfunc
    BL  Port5_Init                  ; initialize P5.0 and make it input
    BL  Port4_Init                  ; initialize P4.0 and make it output
loop
    MOV  R7, #0x34BC
    MOV  R8, #0x2E18
    BL  Port5_Input                 ; read pushb button on port 5
    CMP R0, #0x01                   ; R0 == 0x10?
    BEQ swpressed                  ; if so, button is pressed
    CMP R0, #0x00                   ; R0 == 0x00?
    BEQ nopressed                   ; if so, push button not pressed
                                    ; if none of the above, unexpected return value

    BL  Port4_Output                ; continue
    B   loop
swpressed
    MOV R0, #0x01                   ; R0 = 1
    BL  Port4_Output                ; turn ON the LED
    B   loop
nopressed
    MOV R0, #0                      ; R0 = 0 (LEDs OFF)
    BL  Port4_Output                ; turn LED OFF
    SUBS R7, #01
    CMP R7, #0
    BNE nopressed
    B toggle
    B   loop

toggle
    MOV R0, #0x01                   ; R0 = 1
    BL  Port4_Output                ; turn ON the LED
    SUBS R8, #01
    CMP  R8, #0
    BNE toggle
    B loop

    .endasmfunc
;------------Port5_Init------------
; Initialize GPIO Port 5 for positive logic on P5.0
; as the LaunchPad is wired.
; Input: none
; Output: none
; Modifies: R0, R1
Port5_Init: .asmfunc
    LDR  R1, P5SEL0
    MOV  R0, #0x00                  ; configure P5.0 as GPIO
    STRB R0, [R1]
    LDR  R1, P5SEL1
    MOV  R0, #0x00                  ; configure P5.0 as GPIO
    STRB R0, [R1]
    LDR  R1, P5DIR
    MOV  R0, #0x00                  ; make P5.0 input
    STRB R0, [R1]
    ;LDR  R1, P5REN
    ;MOV  R0, #0x01                  ; enable pull resistor on P5.0
    ;STRB R0, [R1]
    LDR  R1, P5OUT
    MOV  R0, #0x01                  ; P5.0 are pull-up
    STRB R0, [R1]
    BX  LR
    .endasmfunc
;------------Port5_Input------------
; Read and return the status of the switches.
; Input: none
; Output:
;         R0  0x01 if push button is pressed
;         R0  0x12 if push button not pressed
; Modifies: R1
Port5_Input: .asmfunc
    LDR  R1, P5IN
    LDRB R0, [R1]                   ; read all 8 bits of Port 5
    AND  R0, R0, #0x01              ; select the input pins P5.0
    BX   LR
    .endasmfunc
;------------Port4_Init------------
; Initialize GPIO Port 4
; Input: none
; Output: none
; Modifies: R0, R1
Port4_Init: .asmfunc
    LDR  R1, P4SEL0
    MOV  R0, #0x00                  ; configure P4.0 as GPIO
    STRB R0, [R1]                    ;P4SEL0 = 0
    LDR  R1, P4SEL1
    MOV  R0, #0x00                  ; configure P4.0 as GPIO
    STRB R0, [R1]                    ;P4SEL1 = 0 (00 sets PORTS as I/O)
    LDR  R1, P4DS
    MOV  R0, #0x01                  ; make P4.0 high drive strength
    STRB R0, [R1]                    ;P4DS = 0111
    LDR  R1, P4DIR
    MOV  R0, #0x01                  ; make P4.0 out
    STRB R0, [R1]                    ;P4DIR = 0111
    LDR  R1, P4OUT
    MOV  R0, #0x01                  ; LED on
    STRB R0, [R1]                    ;P4OUT = 1 (LEDS initially ON)
    BX   LR
    .endasmfunc
;------------Port4_Output------------
; Set the output state of P5.
; Input: R0  new state of P5 (only 8 least significant bits)
; Output: none
; Modifies: R1
Port4_Output: .asmfunc
    LDR  R1, P4OUT
    STRB R0, [R1]                   ; write to P4.0
    BX   LR

    .endasmfunc
    .end



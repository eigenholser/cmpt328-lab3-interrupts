; Lab 3 Interrupts
;
; Initialize GPIOF interrupt on SW1. Cycle through LED colors on interrupt.
;
; PF4 is SW1 on the board. LED red, blue, and green are PF1, PF2, and PF3.
;
; Debouncing SW1 added a bunch of complexity. But is was a lot of fun figuring
; it out and writing the code.
;
; Uses Advanced High Performance Bus rather than legacy Advanced Peripheral
; Bus.

        NAME    main
      
        PUBLIC  main
        PUBLIC  GPIOPortF_Handler
        PUBLIC  SysTick_Handler

; See "lm4f120h5qr.h" in arm/inc/TexasInstruments
SYSCTL_RCGCGPIO_R               EQU     0x400FE608
SYSCTL_GPIOHBCTL_R              EQU     0x400FE06C
GPIO_PORTF_AHB_DATA_BITS_R      EQU     0x4005D000
GPIO_PORTF_AHB_DATA_R           EQU     0x4005D3FC
GPIO_PORTF_AHB_DIR_R            EQU     0x4005D400
GPIO_PORTF_AHB_DEN_R            EQU     0x4005D51C
GPIO_PORTF_AHB_IS_R             EQU     0x4005D404
GPIO_PORTF_AHB_IM_R             EQU     0x4005D410
GPIO_PORTF_AHB_ICR_R            EQU     0x4005D41C
GPIO_PORTF_AHB_PUR_R            EQU     0x4005D510

; NVIC registers
; GPIOF
NVIC_EN0_R                      EQU     0xE000E100
NVIC_PRI7_R                     EQU     0xE000E41C

; SysTick
NVIC_ST_CTRL_R                  EQU     0xE000E010
NVIC_ST_RELOAD_R                EQU     0xE000E014
NVIC_ST_CURRENT_R               EQU     0xE000E018
NVIC_SYS_PRI3_R                 EQU     0xE000ED20

; Program constants
; systick_reload represents the time interval of our SysTick interrupt.
systick_reload                  EQU     0x001FFFFF      ; Max value 24 bits

        SECTION .text : CODE (2)
        THUMB

; ---------->% main >%----------
; Initialize and loop waiting for interrupt
main
        BL      GPIOF_Init
        BL      GPIOF_Interrupt_Init
        B       .               ; Loop forever

; ---------->% GPIOF_Init >%----------
; Enable GPIOF SW1 and LED pins.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_Init
        ; Enable GPIOF Advanced High Performance Bus
        LDR     R0, =SYSCTL_GPIOHBCTL_R
        MOVS    R1, #1B << 5      ; GPIOF
        STR     R1, [R0]
        
        ; Enable GPIOF clock
        LDR     R0, =SYSCTL_RCGCGPIO_R
        MOVS    R1, #1B << 5      ; GPIOF
        STR     R1, [R0]

        ; GPIOF direction
        LDR     R0, =GPIO_PORTF_AHB_DIR_R
        MOVS    R1, #0x0E       ; Pins 2345 out
        STR     R1, [R0]
        
        ; GPIOF digital enable
        LDR     R0, =GPIO_PORTF_AHB_DEN_R
        MOVS    R1, #0x1E       ; Pins 234 out
        STR     R1, [R0]

        BX      LR

; ---------->% GPIOF_Interrupt_Init >%----------
; Initialize GPIOF interrupt and NVIC interrupt.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_Interrupt_Init
        ; GPIOF interrupt priority
        LDR     R0, =NVIC_PRI7_R
        MOVS    R1, #0x0                ; Highest
        STR     R1, [R0]
        
        ; GPIOF interrupt priority
        LDR     R0, =GPIO_PORTF_AHB_PUR_R
        MOVS    R1, #1B << 4            ; SW1 pull up resistor
        STR     R1, [R0]        
        
        ; GPIOF NVIC interrupt enable
        LDR     R0, =NVIC_EN0_R
        MOVS    R1, #0x40000000         ; TODO: Define constant
        STR     R1, [R0]
        
        PUSH    {LR}
        BL      GPIOF_PF5_Interrupt_Enable
        POP     {LR}

        BX      LR

; ---------->% GPIOF_PF5_Interrupt_Enable >%----------
; Enable GPIOF interrupt on PF5
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_PF5_Interrupt_Enable
        LDR     R0, =GPIO_PORTF_AHB_IM_R
        MOVS    R1, #0x10       ; TODO: This is bad. Need to preserve any bits.
;        ORR     R1, R1, #0x10   ; Set the one bit 0x10
        STR     R1, [R0]
        BX      LR
        
; ---------->% GPIOF_PF5_Interrupt_Disable >%----------
; Disable GPIOF interrupt on PF5.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_PF5_Interrupt_Disable
        LDR     R0, =GPIO_PORTF_AHB_IM_R      
        BIC     R1, R1, #0x10   ; Clear the one bit 0x10
        STR     R1, [R0]
        BX      LR

; ---------->% SysTick_Init >%----------
; Initialize SysTick timer with interrupts.
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Init
        ; Disable SysTick during init
        PUSH    {LR}
        BL      SysTick_Disable         ; Must disable while initializing.
        
        ; Reload value...clock ticks in SysTick counter
        LDR     R0, =NVIC_ST_RELOAD_R   ; See datasheet p140
        LDR     R1, =systick_reload     ; Seems like long enough to wait.
        STR     R1, [R0]
        
        ; Clear Current value
        LDR     R0, =NVIC_ST_CURRENT_R  ; See datasheet p141
        MOVS    R1, #0                  ; SysTick Current Value Register
        STR     R1, [R0]
        
        ; Set interrupt priority
        LDR     R0, =NVIC_SYS_PRI3_R    ; NVIC interrupt 15 priority register
        MOVS    R1, #0x40000000         ; SysTick bits
        STR     R1, [R0]
        
        BL      SysTick_Enable          ; SysTick on
        POP     {LR}                    ; Grab return PC from stack.
        BX      LR

; ---------->% SysTick_Enable >%----------
; Enable SysTick
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Enable
        LDR     R0, =NVIC_ST_CTRL_R     ; See datasheet p138
        MOVS    R1, #7                  ; SysTick Control and Status Register
        STR     R1, [R0]
        BX      LR
        
; ---------->% SysTick_Disable >%----------
; Disable SysTick
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Disable
        LDR     R0, =NVIC_ST_CTRL_R     ; See datasheet p138
        MOVS    R1, #0                  ; SysTick Control and Status Register
        STR     R1, [R0]
        BX      LR
        
; ---------->% GPIOPortF_Handler >%----------
; Handle interrupts on GPIOF SW1 (PF5). This is convoluted in order to debounce
; SW1. First, acknowledge the interrupt to turn it off. Second, disable PF5
; interrupts. Now we want to check back in systick_reload + 1 clock cycles to
; see whether or not SW1 is still pressed (logic LOW). So we'll go about our
; business looping in main until the SysTick interrupt happens. That interrupt
; will be handled by SysTick_Handler which will check the SW1 state and reset
; the system.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOPortF_Handler
        ; Clear the interrupt.
        LDR     R0, =GPIO_PORTF_AHB_ICR_R
        MOV     R1, #0x10       ; TODO: Confirm 0x10
        STR     R1, [R0]        ; ack
        
        PUSH    {LR}            ; Need this after BL
        BL      GPIOF_PF5_Interrupt_Disable
        BL      SysTick_Init
        POP     {LR}            ; Grab return PC from stack
        BX      LR

; ---------->% SysTick_Handler >%----------
; Handle SysTick interrupt we setup in GPIOPortF_Handler for debouncing SW1.
; Disable SysTick timer since we need it only once for debouncing. Check the
; state of SW1. If SW1 is LOW it is pressed. Shift the LED and re-arm the
; GPIOF interrupt for SW1. If SW1 is HIGH it is not pressed and it was a false
; alarm. Just re-arm the GPIOF interrupt and go back to whatever was happening.
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Handler
        PUSH    {LR}                    ; Will need this later.
        BL      SysTick_Disable         ; Only needed one SysTick
        
        ; Read SW1 position. SW1 depressed will be R0 bit 5 = 0.
        LDR     R0, =GPIO_PORTF_AHB_DATA_BITS_R
        ADD     R0, R0, #0x10   ; SW1 data bits address offset
        LDR     R1, [R0]        ; SW1 state will be 1 when not pressed.
        ANDS    R1, R1, #0x10   ; Test bit 5. Is it set?
        CBNZ    R1, ReArm       ; Bit set? Re-arm GPIOF interrupt.
        
        ; Read, modify, write LED color bits
        LDR     R0, =GPIO_PORTF_AHB_DATA_BITS_R
        ADD     R0, R0, #111B << 3      ; GPIOF LED Bits offset PF123
        LDR     R1, [R0]        ; Fetch current LED color
        LSRS    R1, R1, #1      ; Shift LED color bit
        BIC     R1, R1, #1      ; Clear SW2 bit
        CBNZ    R1, SetLED
        MOVS    R1, #0x08       ; Hit zero, re-init.
SetLED
        STR     R1, [R0]        ; Switch LED
ReArm        
        ; Clear the interrupt before re-enable.
        LDR     R0, =GPIO_PORTF_AHB_ICR_R
        MOV     R1, #0x10       ; TODO: Confirm 0x10
        STR     R1, [R0]        ; ack
        BL      GPIOF_PF5_Interrupt_Enable      ; Re-arm for next SW1 press.

        POP     {LR}            ; Grab return PC from the stack.
        BX      LR
        
        END

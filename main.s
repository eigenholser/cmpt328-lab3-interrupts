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
;
; Note how the register values are set using the ORR instruction. This method
; preserves the existing bits in the register.

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
systick_reload                  EQU     0x000FFFFF      ; Max value 24 bits

; Stuff so the stack frame is easier to decipher.
junk_r0                         EQU     0x11111111      ; R0
junk_r1                         EQU     0x22222222      ; R1
junk_r2                         EQU     0x33333333      ; R3
junk_r3                         EQU     0x44444444      ; R4
junk_r12                        EQU     0x55555555      ; R12

        SECTION .text : CODE (2)
        THUMB

; ---------->% main >%----------
; Initialize and loop waiting for interrupt.
;
; The infinite loop represents work in which the processor might otherwise be 
; occupied. In this way, our SW1 button presses will still be recognized by the 
; processor and will work even if there are other tasks being performed.
main
        BL      GPIOF_Init      ; Initialize GPIO Port F
        BL      GPIOF_Interrupt_Init    ; Initialize GPIO Port F interrupts
        ; Load conspicuous values into registers so we can see them in the 
        ; stack frame later.
        LDR     R0, =junk_r0
        LDR     R1, =junk_r1
        LDR     R2, =junk_r2
        LDR     R3, =junk_r3
        LDR     R12, =junk_r12
        B       .               ; Pretend the processor is gainfully occupied.

; ---------->% CheckSW1Value >%----------
; Load the value of GPIO port F Data into R1 so we can look at the value of SW1
; while it is not pressed. That is all this does. It is for illustration only.
; Input: None
; Output: None
; Modifies: R0, R1
CheckSW1Value
        MOV     R1, #0
        LDR     R0, =GPIO_PORTF_AHB_DATA_BITS_R
        ADD     R0, R0, #0x40   ; SW1 data bit address offset
        LDR     R1, [R0]        ; Load value into R1. See watch window.
        BX      LR
        
; ---------->% GPIOF_Init >%----------
; Initialize GPIO Port F.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_Init
        PUSH    {LR}
        ; Enable GPIOF Advanced High Performance Bus
        LDR     R0, =SYSCTL_GPIOHBCTL_R ; See datasheet p258
        LDR     R1, [R0]                ; SYSCTL_GPIOHBCTL_R value to R1
        ORR     R1, R1, #1B << 5        ; GPIOF AHB enable bit set
        STR     R1, [R0]
        
        ; Enable GPIOF clock
        LDR     R0, =SYSCTL_RCGCGPIO_R  ; See datasheet p340
        LDR     R1, [R0]                ; SYSCTL_RCGCGPIO_R value to R1
        ORR     R1, R1, #1B << 5        ; GPIOF clock enable
        STR     R1, [R0]

        ; GPIOF direction
        LDR     R0, =GPIO_PORTF_AHB_DIR_R       ; See datasheet p663
        LDR     R1, [R0]                ; GPIO_PORTF_AHB_DIR_R value to R1
        ORR     R1, R1, #0x0E           ; GPIOF PF4 direction PF123 output
        STR     R1, [R0]                ; PF4 (SW1) is input by default.
        
        ; GPIOF PF4 pull up resistor for logic HIGH until SW1 press.
        BL      CheckSW1Value                   ; Before - Illustration only. 
        LDR     R0, =GPIO_PORTF_AHB_PUR_R       ; p677 GPIO Pull-Up Select
        LDR     R1, [R0]
        ORR     R1, R1, #1B << 4                ; SW1 pull up resistor
        STR     R1, [R0]
        BL      CheckSW1Value                   ; After - Illustration only. 
        
        ; GPIOF digital enable
        LDR     R0, =GPIO_PORTF_AHB_DEN_R       ; See datasheet p682
        LDR     R1, [R0]                ; GPIO_PORTF_AHB_DEN_R value to R1
        ORR     R1, R1, #0x1E           ; Set PF1234 as digital
        STR     R1, [R0]

        POP     {LR}
        BX      LR

; ---------->% GPIOF_Interrupt_Init >%----------
; Initialize GPIOF interrupt and NVIC interrupt. Both are needed for GPIO
; interrupts to be raised.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_Interrupt_Init
        ; GPIOF interrupt priority
        LDR     R0, =NVIC_PRI7_R        ; See datasheet p152
        MOV     R1, #0x0                ; Highest priority
        STR     R1, [R0]     
        
        ; GPIOF NVIC interrupt enable
        LDR     R0, =NVIC_EN0_R                 ; p142 Interrupt 0-31 Set Enable 
        LDR     R1, [R0]
        ORR     R1, R1, #0x40000000
        STR     R1, [R0]
        
        PUSH    {LR}
        BL      GPIOF_PF4_Interrupt_Enable      ; Enable GPIOF PF4 interrupt
        POP     {LR}

        BX      LR

; ---------->% GPIOF_PF4_Interrupt_Enable >%----------
; Enable GPIOF interrupt on PF4
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_PF4_Interrupt_Enable
        LDR     R0, =GPIO_PORTF_AHB_IM_R        ; See datasheet p667
        LDR     R1, [R0]                ; GPIO_PORTF_AHB_IM_R value to R1
        ORR     R1, R1, #0x10           ; Set the one bit 0x10 to enable
        STR     R1, [R0]
        BX      LR
        
; ---------->% GPIOF_PF4_Interrupt_Disable >%----------
; Disable GPIOF interrupt on PF4.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_PF4_Interrupt_Disable
        LDR     R0, =GPIO_PORTF_AHB_IM_R        ; See datasheet p667
        BIC     R1, R1, #0x10           ; Clear the one bit 0x10 to disable
        STR     R1, [R0]
        BX      LR

; ---------->% GPIOF_PF4_Interrupt_Clear >%----------
; Clear the interrupt because it will be raised again and again until we ack.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOF_PF4_Interrupt_Clear
        ; Clear the interrupt 
        LDR     R0, =GPIO_PORTF_AHB_ICR_R       ; See datasheet p670
        LDR     R1, [R0]        ; GPIO_PORTF_AHB_ICR_R register value to R1
        ORR     R1, R1, #0x10   ; Clear bit 4 interrupt
        STR     R1, [R0]        ; Ack
        BX      LR

; ---------->% SysTick_Init >%----------
; Initialize SysTick timer with interrupts. SysTick timer will count down
; systick_reload + 1 until it reaches zero. Then it will fire the interrupt.
; Interrupt will be handled by SysTick_Handler.
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Init
        ; Disable SysTick during init
        PUSH    {LR}                    ; Save LR for later.
        BL      SysTick_Disable         ; Must disable while initializing.
        
        ; Reload value...clock ticks in SysTick counter
        LDR     R0, =NVIC_ST_RELOAD_R   ; See datasheet p140
        LDR     R1, =systick_reload     ; Wait systick_reload + 1 clock cycles
        STR     R1, [R0]
        
        ; Clear Current value
        LDR     R0, =NVIC_ST_CURRENT_R  ; See datasheet p141
        MOV     R1, #0                  ; SysTick Current Value Register
        STR     R1, [R0]
        
        ; Set interrupt priority
        LDR     R0, =NVIC_SYS_PRI3_R    ; NVIC interrupt 15 priority register
        MOV     R1, #0x40000000         ; SysTick bits
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
        MOV     R1, #7                  ; SysTick Control and Status Register
        STR     R1, [R0]
        BX      LR
        
; ---------->% SysTick_Disable >%----------
; Disable SysTick
; Input: None
; Output: None
; Modifies: R0, R1
SysTick_Disable
        LDR     R0, =NVIC_ST_CTRL_R     ; See datasheet p138
        MOV     R1, #0                  ; SysTick Control and Status Register
        STR     R1, [R0]
        BX      LR
        
; ---------->% GPIOPortF_Handler >%----------
; Handle interrupts on GPIOF SW1 (PF4). This is convoluted in order to debounce
; SW1. First, acknowledge the interrupt to turn it off. Second, disable PF4
; interrupts. Now we want to check back in systick_reload + 1 clock cycles to
; see whether or not SW1 is still pressed (logic LOW). So we'll go about our
; business looping in main until the SysTick interrupt happens. That interrupt
; will be handled by SysTick_Handler which will check the SW1 state and reset
; the system.
; Input: None
; Output: None
; Modifies: R0, R1
GPIOPortF_Handler
        PUSH    {LR}            ; Need this after BL
        BL      GPIOF_PF4_Interrupt_Clear       ; Clear the interrupt.
        BL      GPIOF_PF4_Interrupt_Disable     ; Don't interrupt on bounces
        BL      SysTick_Init    ; Let SW1 settle and check back later
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
        
        ; Read SW1 position. SW1 depressed will be R0 bit 4 = 0.
        LDR     R0, =GPIO_PORTF_AHB_DATA_BITS_R
        ADD     R0, R0, #0x40   ; SW1 data bits address offset
        LDR     R1, [R0]        ; SW1 state will be 1 when not pressed.
        ANDS    R1, R1, #0x10   ; Test bit 4. Is it set?
        CBNZ    R1, ReArm       ; Bit set? Re-arm GPIOF interrupt.
        
        ; Read, modify, write LED color bits
        LDR     R0, =GPIO_PORTF_AHB_DATA_BITS_R
        ADD     R0, R0, #111B << 3      ; GPIOF LED Bits offset PF123
        LDR     R1, [R0]        ; Fetch current LED color
        LSR     R1, R1, #1      ; Right shift LED color bit
        BIC     R1, R1, #1      ; Clear SW2 bit
        CBNZ    R1, SetLED      ; Branch to SetLED if result non-zero.
        MOV     R1, #0x08       ; Hit zero, re-init LED color to green.
SetLED
        STR     R1, [R0]        ; New LED colors
ReArm        
        BL      GPIOF_PF4_Interrupt_Clear       ; Clear interrupt before re-arm
        BL      GPIOF_PF4_Interrupt_Enable      ; Re-arm for next SW1 press.

        POP     {LR}            ; Grab return PC from the stack.
        BX      LR
        
        END

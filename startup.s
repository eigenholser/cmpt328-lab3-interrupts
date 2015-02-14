        NAME    startup
        
        PUBLIC  __iar_program_start
        EXTERN  main
        EXTERN  GPIOPortF_Handler
        EXTERN  SysTick_Handler
        
Stack   EQU     0x20008000              ; Stack Pointer
        
; Vector Table
        SECTION .intvec : CODE
        DATA
        DC32    Stack                   ; 0x00000000   0   - Stack Pointer
        DC32    __iar_program_start     ; 0x00000004   1   - Reset Handler
        DC32    NMI_Handler             ; 0x00000008   2   - NMI Handler
        DC32    HardFault_Handler       ; 0x0000000C   3   - Hard Fault Handler
        DC32    MemManage_Handler       ; 0x00000010   4   - MPU Fault Handler
        DC32    BusFault_Handler        ; 0x00000014   5   - Bus Fault Handler
        DC32    UsageFault_Handler      ; 0x00000018   6   - Usage Fault Handler
        DC32    0                       ; 0x0000001C   7   - Reserved
        DC32    0                       ; 0x00000020   8   - Reserved
        DC32    0                       ; 0x00000024   9   - Reserved
        DC32    0                       ; 0x00000028  10   - Reserved
        DC32    SVC_Handler             ; 0x0000002C  11   - SVCall Handler
        DC32    DebugMon_Handler        ; 0x00000030  12   - Debug Monitor Handler
        DC32    0                       ; 0x00000034  13   - Reserved
        DC32    PendSV_Handler          ; 0x00000038  14   - PendSV Handler
        DC32    SysTick_Handler         ; 0x0000003C  15   - SysTick Handler
        DC32    GPIOPortA_Handler       ; 0x00000040  16   0 GPIO Port A
        DC32    GPIOPortB_Handler       ; 0x00000044  17   1 GPIO Port B
        DC32    GPIOPortC_Handler       ; 0x00000048  18   2 GPIO Port C
        DC32    GPIOPortD_Handler       ; 0x0000004C  19   3 GPIO Port D
        DC32    GPIOPortE_Handler       ; 0x00000050  20   4 GPIO Port E
        DC32    UART0_Handler           ; 0x00000054  21   5 UART0 Rx and Tx
        DC32    UART1_Handler           ; 0x00000058  22   6 UART1 Rx and Tx
        DC32    SSI0_Handler            ; 0x0000005C  23   7 SSI0 Rx and Tx
        DC32    I2C0_Handler            ; 0x00000060  24   8 I2C0 Master and Slave
        DC32    PWM0Fault_Handler       ; 0x00000064  25   9 PWM0 Fault
        DC32    PWM0Generator0_Handler  ; 0x00000068  26  10 PWM0 Generator 0
        DC32    PWM0Generator1_Handler  ; 0x0000006C  27  11 PWM0 Generator 1
        DC32    PWM0Generator2_Handler  ; 0x00000070  28  12 PWM0 Generator 2
        DC32    Quadrature0_Handler     ; 0x00000074  29  13 Quadrature Encoder 0
        DC32    ADC0Seq0_Handler        ; 0x00000078  30  14 ADC0 Sequence 0
        DC32    ADC0Seq1_Handler        ; 0x0000007C  31  15 ADC0 Sequence 1
        DC32    ADC0Seq2_Handler        ; 0x00000080  32  16 ADC0 Sequence 2
        DC32    ADC0Seq3_Handler        ; 0x00000084  33  17 ADC0 Sequence 3
        DC32    WDT_Handler             ; 0x00000088  34  18 Watchdog Timers 0 and 1
        DC32    Timer0A_Handler         ; 0x0000008C  35  19 16/32-Bit Timer 0A
        DC32    Timer0B_Handler         ; 0x00000090  36  20 16/32-Bit Timer 0B
        DC32    Timer1A_Handler         ; 0x00000094  37  21 16/32-Bit Timer 1A
        DC32    Timer1B_Handler         ; 0x00000098  38  22 16/32-Bit Timer 1B
        DC32    Timer2A_Handler         ; 0x0000009C  39  23 16/32-Bit Timer 2A
        DC32    Timer2B_Handler         ; 0x000000A0  40  24 16/32-Bit Timer 2B
        DC32    Comp0_Handler           ; 0x000000A4  41  25 Analog Comparator 0
        DC32    Comp1_Handler           ; 0x000000A8  42  26 Analog Comparator 1
        DC32    0                       ; 0x000000AC  43  27 Reserved
        DC32    SysCtl_Handler          ; 0x000000B0  44  28 System Control
        DC32    FlashCtl_Handler        ; 0x000000B4  45  29 Flash Memory Control and EEPROM Control
        DC32    GPIOPortF_Handler       ; 0x000000B8  46  30 GPIO Port F
        DC32    0                       ; 0x000000BC  47  31 Reserved
        DC32    0                       ; 0x000000C0  48  32 Reserved
        DC32    UART2_Handler           ; 0x000000C4  49  33 UART2 Rx and Tx
        DC32    SSI1_Handler            ; 0x000000C8  50  34 SSI1 Rx and Tx
        DC32    Timer3A_Handler         ; 0x000000CC  51  35 16/32-Bit Timer 3A
        DC32    Timer3B_Handler         ; 0x000000D0  52  36 16/32-Bit Timer 3B
        DC32    I2C1_Handler            ; 0x000000D4  53  37 I2C1 Master and Slave
        DC32    Quadrature1_Handler     ; 0x000000D8  54  38 Quadrature Encoder 1
        DC32    CAN0_Handler            ; 0x000000DC  55  39 CAN0
        DC32    CAN1_Handler            ; 0x000000E0  56  40 CAN1
        DC32    0                       ; 0x000000E4  57  41 Reserved
        DC32    0                       ; 0x000000E8  58  42 Reserved
        DC32    Hibernate_Handler       ; 0x000000EC  59  43 Hibernation Module
        DC32    USB0_Handler            ; 0x000000F0  60  44 USB0
        DC32    PWM0Generator3_Handler  ; 0x000000F4  61  45 PWM Generator 3
        DC32    uDMA_Handler            ; 0x000000F8  62  46 uDMA Software Transfer
        DC32    uDMA_Error              ; 0x000000FC  63  47 uDMA Error
        DC32    ADC1Seq0_Handler        ; 0x00000100  64  48 ADC1 Sequence 0
        DC32    ADC1Seq1_Handler        ; 0x00000104  65  49 ADC1 Sequence 1
        DC32    ADC1Seq2_Handler        ; 0x00000108  66  50 ADC1 Sequence 2
        DC32    ADC1Seq3_Handler        ; 0x0000010C  67  51 ADC1 Sequence 3
        DC32    0                       ; 0x00000110  68  52 Reserved
        DC32    0                       ; 0x00000114  69  53 Reserved
        DC32    0                       ; 0x00000118  70  54 Reserved
        DC32    0                       ; 0x0000011C  71  55 Reserved
        DC32    0                       ; 0x00000120  72  56 Reserved
        DC32    SSI2_Handler            ; 0x00000124  73  57 SSI2 Rx and Tx
        DC32    SSI3_Handler            ; 0x00000128  74  58 SSI3 Rx and Tx
        DC32    UART3_Handler           ; 0x0000012C  75  59 UART3 Rx and Tx
        DC32    UART4_Handler           ; 0x00000130  76  60 UART4 Rx and Tx
        DC32    UART5_Handler           ; 0x00000134  77  61 UART5 Rx and Tx
        DC32    UART6_Handler           ; 0x00000138  78  62 UART6 Rx and Tx
        DC32    UART7_Handler           ; 0x0000013C  79  63 UART7 Rx and Tx
        DC32    0                       ; 0x00000140  80  64 Reserved
        DC32    0                       ; 0x00000144  81  65 Reserved
        DC32    0                       ; 0x00000148  82  66 Reserved
        DC32    0                       ; 0x0000014C  83  67 Reserved
        DC32    I2C2_Handler            ; 0x00000150  84  68 I2C2 Master and Slave
        DC32    I2C3_Handler            ; 0x00000154  85  69 I2C3 Master and Slave
        DC32    Timer4A_Handler         ; 0x00000158  86  70 16/32-Bit Timer 4A
        DC32    Timer4B_Handler         ; 0x0000015C  87  71 16/32-Bit Timer 4A
        DC32    0                       ; 0x00000160  88  72 Reserved
        DC32    0                       ; 0x00000164  89  73 Reserved
        DC32    0                       ; 0x00000168  90  74 Reserved
        DC32    0                       ; 0x0000016C  91  75 Reserved
        DC32    0                       ; 0x00000170  92  76 Reserved
        DC32    0                       ; 0x00000174  93  77 Reserved
        DC32    0                       ; 0x00000178  94  78 Reserved
        DC32    0                       ; 0x0000017C  95  79 Reserved
        DC32    0                       ; 0x00000180  96  80 Reserved
        DC32    0                       ; 0x00000184  97  81 Reserved
        DC32    0                       ; 0x00000188  98  82 Reserved
        DC32    0                       ; 0x0000018C  99  83 Reserved
        DC32    0                       ; 0x00000190 100  84 Reserved
        DC32    0                       ; 0x00000194 101  85 Reserved
        DC32    0                       ; 0x00000198 102  86 Reserved
        DC32    0                       ; 0x0000019C 103  87 Reserved
        DC32    0                       ; 0x000001A0 104  88 Reserved
        DC32    0                       ; 0x000001A4 105  89 Reserved
        DC32    0                       ; 0x000001A8 106  90 Reserved
        DC32    0                       ; 0x000001AC 107  91 Reserved
        DC32    Timer5A_Handler         ; 0x000001B0 108  92 16/32-Bit Timer 5A
        DC32    Timer5B_Handler         ; 0x000001B4 109  93 16/32-Bit Timer 5B
        DC32    WideTimer0A_Handler     ; 0x000001B8 110  94 32/64-Bit Timer 0A
        DC32    WideTimer0B_Handler     ; 0x000001BC 111  95 32/64-Bit Timer 0B
        DC32    WideTimer1A_Handler     ; 0x000001C0 112  96 32/64-Bit Timer 1A
        DC32    WideTimer1B_Handler     ; 0x000001C4 113  97 32/64-Bit Timer 1B
        DC32    WideTimer2A_Handler     ; 0x000001C8 114  98 32/64-Bit Timer 2A
        DC32    WideTimer2B_Handler     ; 0x000001CC 115  99 32/64-Bit Timer 2B
        DC32    WideTimer3A_Handler     ; 0x000001D0 116 100 32/64-Bit Timer 3A
        DC32    WideTimer3B_Handler     ; 0x000001D4 117 101 32/64-Bit Timer 3B
        DC32    WideTimer4A_Handler     ; 0x000001D8 118 102 32/64-Bit Timer 4A
        DC32    WideTimer4B_Handler     ; 0x000001DC 119 103 32/64-Bit Timer 4B
        DC32    WideTimer5A_Handler     ; 0x000001E0 120 104 32/64-Bit Timer 5A
        DC32    WideTimer5B_Handler     ; 0x000001E4 121 105 32/64-Bit Timer 5B
        DC32    FPU_Handler             ; 0x000001E8 122 106 System Exception (imprecise)
        DC32    0                       ; 0x000001EC 123 107 Reserved
        DC32    0                       ; 0x000001F0 124 108 Reserved
        DC32    0                       ; 0x000001F4 125 109 Reserved
        DC32    0                       ; 0x000001F8 126 110 Reserved
        DC32    0                       ; 0x000001FC 127 111 Reserved
        DC32    0                       ; 0x00000200 128 112 Reserved
        DC32    0                       ; 0x00000204 129 113 Reserved
        DC32    0                       ; 0x00000208 130 114 Reserved
        DC32    0                       ; 0x0000020C 131 115 Reserved
        DC32    0                       ; 0x00000210 132 116 Reserved
        DC32    0                       ; 0x00000214 133 117 Reserved
        DC32    0                       ; 0x00000218 134 118 Reserved
        DC32    0                       ; 0x0000021C 135 119 Reserved
        DC32    0                       ; 0x00000220 136 120 Reserved
        DC32    0                       ; 0x00000224 137 121 Reserved
        DC32    0                       ; 0x00000228 138 122 Reserved
        DC32    0                       ; 0x0000022C 139 123 Reserved
        DC32    0                       ; 0x00000230 140 124 Reserved
        DC32    0                       ; 0x00000234 141 125 Reserved
        DC32    0                       ; 0x00000238 142 126 Reserved
        DC32    0                       ; 0x0000023C 143 127 Reserved
        DC32    0                       ; 0x00000240 144 128 Reserved
        DC32    0                       ; 0x00000244 145 129 Reserved
        DC32    0                       ; 0x00000248 146 130 Reserved
        DC32    0                       ; 0x0000024C 147 131 Reserved
        DC32    0                       ; 0x00000250 148 132 Reserved
        DC32    0                       ; 0x00000254 149 133 Reserved
        DC32    PWM1Generator0_Handler  ; 0x00000258 150 134 PWM1 Generator 0
        DC32    PWM1Generator1_Handler  ; 0x0000025C 151 135 PWM1 Generator 1
        DC32    PWM1Generator2_Handler  ; 0x00000260 152 136 PWM1 Generator 2
        DC32    PWM1Generator3_Handler  ; 0x00000264 153 137 PWM1 Generator 3
        DC32    PWM1Fault_Handler       ; 0x00000268 154 138 PWM1 Fault
        
       
       
        SECTION .text : CODE (2)
        THUMB
        
; Reset Vector        
__iar_program_start
        B       main
        
; Processor Exception Handlers
NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
;SysTick_Handler
        B       .

; Software Interrupt Service Routines
GPIOPortA_Handler
GPIOPortB_Handler
GPIOPortC_Handler
GPIOPortD_Handler
GPIOPortE_Handler
UART0_Handler
UART1_Handler
SSI0_Handler
I2C0_Handler
PWM0Fault_Handler
PWM0Generator0_Handler
PWM0Generator1_Handler
PWM0Generator2_Handler
Quadrature0_Handler
ADC0Seq0_Handler
ADC0Seq1_Handler
ADC0Seq2_Handler
ADC0Seq3_Handler
WDT_Handler
Timer0A_Handler
Timer0B_Handler
Timer1A_Handler
Timer1B_Handler
Timer2A_Handler
Timer2B_Handler
Comp0_Handler
Comp1_Handler
SysCtl_Handler
FlashCtl_Handler
;GPIOPortF_Handler
UART2_Handler
SSI1_Handler
Timer3A_Handler
Timer3B_Handler
I2C1_Handler
Quadrature1_Handler
CAN0_Handler
CAN1_Handler
Hibernate_Handler
USB0_Handler
PWM0Generator3_Handler
uDMA_Handler
uDMA_Error
ADC1Seq0_Handler
ADC1Seq1_Handler
ADC1Seq2_Handler
ADC1Seq3_Handler
SSI2_Handler
SSI3_Handler
UART3_Handler
UART4_Handler
UART5_Handler
UART6_Handler
UART7_Handler
I2C2_Handler
I2C3_Handler
Timer4A_Handler
Timer4B_Handler
Timer5A_Handler
Timer5B_Handler
WideTimer0A_Handler
WideTimer0B_Handler
WideTimer1A_Handler
WideTimer1B_Handler
WideTimer2A_Handler
WideTimer2B_Handler
WideTimer3A_Handler
WideTimer3B_Handler
WideTimer4A_Handler
WideTimer4B_Handler
WideTimer5A_Handler
WideTimer5B_Handler
FPU_Handler
PWM1Generator0_Handler
PWM1Generator1_Handler
PWM1Generator2_Handler
PWM1Generator3_Handler
PWM1Fault_Handler
        B       .

        END
        
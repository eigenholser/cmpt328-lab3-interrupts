Lab 3 - Interrupts
==================

This lab project was developed for the Westminster College Spring 2015 CMPT328
Computer Architecture course.

This was developed using the IAR Systems Embedded Workbench. Some slight
modifications will be necessary for Keil uVision or Code Composer.

Demonstrates processor interrupts in the ARM Cortex M4F as implemented on
the TI Tiva C Series Launchpad Evaluation Kit.

Implements complete vector table in ``startup.s``. Interrupts are enabled and
configured for ``SW1`` button push. Debouncing is implemented using the
SysTick.

The basic debouncing strategy is to enable interrupt on GPIO Port F, ``SW1``.
On a ``SW1`` button press, immediately disable the interrupt and enable the
SysTick with interrupt. When the SysTick interrupt is handled, check to see if
``SW1`` is still pressed. If so, rotate the LED. Otherwise do nothing. When
finished, enable GPIO Port F interrupt and repeat.

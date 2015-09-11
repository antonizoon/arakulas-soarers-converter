/*****************************************************************************/
/* hwdefs.h : hardware definitions for the known HW configurations           */
/*****************************************************************************/

#ifndef __hwdefs_h__
#define __hwdefs_h__

/*
Currently supported configurations:

LAYOUT_TEENSY_2
===============
Teensy 2.0
ATmega32U4
Onboard LED      PD6, Active High
PS/2 Data        PD0
PS/2 Clock       PD1
PS/2 Reset       PB7
Caps Lock LED    PF5
Num Lock LED     PF6
Scroll Lock LED  PF7
Aux Key 1..5     PB0..PB4

LAYOUT_PRO_MICRO
================
Pro Micro
ATmega32U4
Onboard LED      PD5, Active Low
PS/2 Data        PD0       (Pin 3)
PS/2 Clock       PD1       (Pin 2)
PS/2 Reset       PB6       (Pin 10)
Caps Lock LED    PF5       (Pin A2)
Num Lock LED     PF6       (Pin A1)
Scroll Lock LED  PF7       (Pin A0)
Aux Key 1..5     PB1..PB5  (Pins labeled 15,16,14,8,9)

LAYOUT_ADAFRUIT
===============
AdaFruit Breakout Board
ATmega32U4
Onboard LED      PE6, Active High
PS/2 Data        PD0
PS/2 Clock       PD1
PS/2 Reset       PB7
Caps Lock LED    PF5
Num Lock LED     PF6
Scroll Lock LED  PF7
Aux Key 1..5     PB0..PB4

LAYOUT_TEENSYPP_1
=================
Teensy++ 1.0
AT90USB646
Onboard LED      PD6, Active Low
PS/2 Data        PD0
PS/2 Clock       PD1
PS/2 Reset       PB7
Caps Lock LED    PD3
Num Lock LED     PD4
Scroll Lock LED  PD5
Aux Key 1..5     PB0..PB4

LAYOUT_TEENSYPP_2
=================
Teensy++ 2.0
AT90USB1286
Onboard LED      PD6, Active High
PS/2 Data        PD0
PS/2 Clock       PD1
PS/2 Reset       PB7
Caps Lock LED    PD3
Num Lock LED     PD4
Scroll Lock LED  PD5
Aux Key 1..5     PB0..PB4

LAYOUT_16U4
===========
Unknown
ATMega16U4
Currently exactly like LAYOUT_TEENSY_2 (just less Flash etc.)

*/

// LAYOUT_xxx may be passed in, but is overridden if it doesn't match the CPU
// __AVR_ATmega16U4__ is always LAYOUT_16U4
#if defined(LAYOUT_16U4)
  #undef LAYOUT_16U4
#endif
#define LAYOUT_16U4 !!defined(__AVR_ATmega16U4__)

// __AVR_ATmega32U4__ may be Teensy 2.0 or Pro Micro
#if !defined(__AVR_ATmega32U4__)
  #if defined(LAYOUT_PRO_MICRO)
    #undef LAYOUT_PRO_MICRO
  #endif
  #define LAYOUT_PRO_MICRO 0
  #if defined(LAYOUT_TEENSY_2)
    #undef LAYOUT_TEENSY_2
  #endif
  #define LAYOUT_TEENSY_2 0
  #if defined(LAYOUT_ADAFRUIT)
    #undef LAYOUT_ADAFRUIT
  #endif
  #define LAYOUT_ADAFRUIT 0
#else
  // ATmega32U4 can be Teensy 2.0, Adafruit breakout board or Pro Micro; default to Teensy 2.0
  #if !defined(LAYOUT_PRO_MICRO)
    #define LAYOUT_PRO_MICRO 0
  #endif
  #if !defined(LAYOUT_ADAFRUIT)
    #define LAYOUT_ADAFRUIT 0
  #endif
  #if !defined(LAYOUT_TEENSY_2)
    #define LAYOUT_TEENSY_2 !(LAYOUT_PRO_MICRO | LAYOUT_ADAFRUIT)
  #endif
  // If both Pro Micro and Adafruit are passed in, use Pro Micro (debatable)
  #if LAYOUT_PRO_MICRO && LAYOUT_ADAFRUIT
    #undef LAYOUT_ADAFRUIT
    #define LAYOUT_ADAFRUIT 0
  #endif
  // If both Pro Micro/Adafruit and Teensy 2.0 are passed in,
  // use Pro Micro/Adafruit (more specialized)
  #if (LAYOUT_PRO_MICRO|LAYOUT_ADAFRUIT) && LAYOUT_TEENSY_2
    #undef LAYOUT_TEENSY_2
    #define LAYOUT_TEENSY_2 0
  #endif
#endif

// AT90USB646 is always treated as Teensy++ 1.0
#if defined(LAYOUT_TEENSYPP_1)
  #undef LAYOUT_TEENSYPP_1
#endif
#define LAYOUT_TEENSYPP_1 !!defined(__AVR_AT90USB646__)

// __AVR_AT90USB1286__ is always treated as Teensy++ 2.0
#if defined(LAYOUT_TEENSYPP_2)
  #undef LAYOUT_TEENSYPP_2
#endif
#define LAYOUT_TEENSYPP_2 !!defined(__AVR_AT90USB1286__)

// LAYOUT_16U4 is the same as LAYOUT_TEENSY_2 for the moment
#if LAYOUT_16U4
#undef LAYOUT_TEENSY_2
#undef LAYOUT_16U4
#define LAYOUT_TEENSY_2 1
#endif

#if LAYOUT_TEENSY_2
/*****************************************************************************/
/* Teensy 2.0 Layout                                                         */
/*****************************************************************************/
// #pragma message("Compiling for Teensy 2.0")

#define OBLED_CONFIG  ( DDRD |= (1<<DDD6) )
#define OBLED_ON      ( PORTD |= (1<<PORTD6) )
#define OBLED_OFF     ( PORTD &= ~(1<<PORTD6) )

#define KBDD_HIGH     ( DDRD &= ~(1 << DDD0) , PORTD |= (1 << PORTD0) )
#define KBDD_LOW      ( PORTD &= ~(1 << PORTD0) , DDRD |= (1 << DDD0) )
#define KBDD_GET0     ( (PIND >> PIND0) & 1 )
#define KBDC_HIGH     ( DDRD &= ~(1 << DDD1) , PORTD |= (1 << PORTD1) )
// maybe wrong order?
#define KBDC_LOW      ( DDRD |= (1 << DDD1) , PORTD &= ~(1 << PORTD1) )
#define KBDC_GET0     ( (PIND >> PIND1) & 1 )
#define KBDC_GET      ( PIND & (1 << PIND1) )
#define KBDR_HIGH     ( DDRB &= ~(1 << DDB7) , PORTB |= (1 << PORTB7) )
#define KBDR_LOW      ( PORTB &= ~(1 << PORTB7) , DDRB |= (1 << DDB7) )

#define LLED_BITMASKD ( (1<<DDF7) | (1<<DDF6) | (1<<DDF5) )
#define LLED_BITMASKP ( (1<<PORTF7) | (1<<PORTF6) | (1<<PORTF5) )
#define LLED_ON(b)    ( DDRF |= LLED_BITMASKD , PORTF = (PORTF & ~LLED_BITMASKP) | ((b) << 5) )
#define LLED_OFF(b)   ( DDRF = (DDRF & (~LLED_BITMASKD)) | ((b) << 5) , PORTF |= LLED_BITMASKP )

#define AUXK_BITMASKD ( (1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0) )
#define AUXK_BITMASKP ( (1<<PORTB4)|(1<<PORTB3)|(1<<PORTB2)|(1<<PORTB1)|(1<<PORTB0) )
#define AUXK_CONFIG   ( DDRB &= ~AUXK_BITMASKD , PORTB |= AUXK_BITMASKP )
#define AUXK_GET      ( PINB & AUXK_BITMASKP )

#elif LAYOUT_PRO_MICRO
/*****************************************************************************/
/* Pro Micro Layout                                                          */
/*****************************************************************************/
// #pragma message("Compiling for Pro Micro")

#define OBLED_CONFIG  ( DDRD |= (1<<DDD5), PORTD |= (1<<PORTD5) )
// Use green TX LED as standard onboard LED
#define OBLED_ON      ( PORTD &= ~(1<<PORTD5) )
#define OBLED_OFF     ( PORTD |= (1<<PORTD5) )
// Use yellow RX LED as second onboard LED
#define OBLED2_CONFIG ( DDRB |= (1<<DDB0), PORTB |= (1<<PORTB0) )
#define OBLED2_ON     ( PORTB &= ~(1<<PORTB0) )
#define OBLED2_OFF    ( PORTB |= (1<<PORTB0) )

#define KBDD_HIGH     ( DDRD &= ~(1 << DDD0) , PORTD |= (1 << PORTD0) )
#define KBDD_LOW      ( PORTD &= ~(1 << PORTD0) , DDRD |= (1 << DDD0) )
#define KBDD_GET0     ( (PIND >> PIND0) & 1 )
#define KBDC_HIGH     ( DDRD &= ~(1 << DDD1) , PORTD |= (1 << PORTD1) )
// maybe wrong order?
#define KBDC_LOW      ( DDRD |= (1 << DDD1) , PORTD &= ~(1 << PORTD1) )
#define KBDC_GET0     ( (PIND >> PIND1) & 1 )
#define KBDC_GET      ( PIND & (1 << PIND1) )
#define KBDR_HIGH     ( DDRB &= ~(1 << DDB6) , PORTB |= (1 << PORTB6) )
#define KBDR_LOW      ( PORTB &= ~(1 << PORTB6) , DDRB |= (1 << DDB6) )

#define LLED_BITMASKD ( (1<<DDF7) | (1<<DDF6) | (1<<DDF5) )
#define LLED_BITMASKP ( (1<<PORTF7) | (1<<PORTF6) | (1<<PORTF5) )
#define LLED_ON(b)    ( DDRF |= LLED_BITMASKD , PORTF = (PORTF & ~LLED_BITMASKP) | ((b) << 5) )
#define LLED_OFF(b)   ( DDRF = (DDRF & (~LLED_BITMASKD)) | ((b) << 5) , PORTF |= LLED_BITMASKP )

#define AUXK_BITMASKD ( (1<<DDB5)|(1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1) )
#define AUXK_BITMASKP ( (1<<PORTB5)|(1<<PORTB4)|(1<<PORTB3)|(1<<PORTB2)|(1<<PORTB1) )
#define AUXK_CONFIG   ( DDRB &= ~AUXK_BITMASKD , PORTB |= AUXK_BITMASKP )
#define AUXK_GET      ( (PINB & AUXK_BITMASKP) >> 1 )

#elif LAYOUT_ADAFRUIT
/*****************************************************************************/
/* Adafruit Breakout Board Layout                                            */
/*****************************************************************************/
// #pragma message("Compiling for AdaFruit")

#define OBLED_CONFIG  ( DDRE |= (1<<DDE6) )
#define OBLED_ON      ( PORTE |= (1<<PORTE6) )
#define OBLED_OFF     ( PORTE &= ~(1<<PORTE6) )

#define KBDD_HIGH     ( DDRD &= ~(1 << DDD0) , PORTD |= (1 << PORTD0) )
#define KBDD_LOW      ( PORTD &= ~(1 << PORTD0) , DDRD |= (1 << DDD0) )
#define KBDD_GET0     ( (PIND >> PIND0) & 1 )
#define KBDC_HIGH     ( DDRD &= ~(1 << DDD1) , PORTD |= (1 << PORTD1) )
// maybe wrong order?
#define KBDC_LOW      ( DDRD |= (1 << DDD1) , PORTD &= ~(1 << PORTD1) )
#define KBDC_GET0     ( (PIND >> PIND1) & 1 )
#define KBDC_GET      ( PIND & (1 << PIND1) )
#define KBDR_HIGH     ( DDRB &= ~(1 << DDB7) , PORTB |= (1 << PORTB7) )
#define KBDR_LOW      ( PORTB &= ~(1 << PORTB7) , DDRB |= (1 << DDB7) )

#define LLED_BITMASKD ( (1<<DDF7) | (1<<DDF6) | (1<<DDF5) )
#define LLED_BITMASKP ( (1<<PORTF7) | (1<<PORTF6) | (1<<PORTF5) )
#define LLED_ON(b)    ( DDRF |= LLED_BITMASKD , PORTF = (PORTF & ~LLED_BITMASKP) | ((b) << 5) )
#define LLED_OFF(b)   ( DDRF = (DDRF & (~LLED_BITMASKD)) | ((b) << 5) , PORTF |= LLED_BITMASKP )

#define AUXK_BITMASKD ( (1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0) )
#define AUXK_BITMASKP ( (1<<PORTB4)|(1<<PORTB3)|(1<<PORTB2)|(1<<PORTB1)|(1<<PORTB0) )
#define AUXK_CONFIG   ( DDRB &= ~AUXK_BITMASKD , PORTB |= AUXK_BITMASKP )
#define AUXK_GET      ( PINB & AUXK_BITMASKP )

#elif LAYOUT_TEENSYPP_1
/*****************************************************************************/
/* Teensy++ 1.0 Layout                                                       */
/*****************************************************************************/
// #pragma message("Compiling for Teensy++ 1.0")

#define OBLED_CONFIG  ( DDRD |= (1<<DDD6) , PORTD |= (1<<PORTD6) )
#define OBLED_ON      ( PORTD &= ~(1<<PORTD6) )
#define OBLED_OFF     ( PORTD |= (1<<PORTD6) )

#define KBDD_HIGH     ( DDRD &= ~(1 << DDD0) , PORTD |= (1 << PORTD0) )
#define KBDD_LOW      ( PORTD &= ~(1 << PORTD0) , DDRD |= (1 << DDD0) )
#define KBDD_GET0     ( (PIND >> PIND0) & 1 )
#define KBDC_HIGH     ( DDRD &= ~(1 << DDD1) , PORTD |= (1 << PORTD1) )
// maybe wrong order?
#define KBDC_LOW      ( DDRD |= (1 << DDD1) , PORTD &= ~(1 << PORTD1) )
#define KBDC_GET0     ( (PIND >> PIND1) & 1 )
#define KBDC_GET      ( PIND & (1 << PIND1) )
#define KBDR_HIGH     ( DDRB &= ~(1 << DDB7) , PORTB |= (1 << PORTB7) )
#define KBDR_LOW      ( PORTB &= ~(1 << PORTB7) , DDRB |= (1 << DDB7) )

#define LLED_BITMASKD ( (1<<DDD5) | (1<<DDD4) | (1<<DDD3) )
#define LLED_BITMASKP ( (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) )
#define LLED_ON(b)    ( DDRD |= LLED_BITMASKD , PORTD = (PORTD & ~LLED_BITMASKP) | ((b) << 3) )
#define LLED_OFF(b)   ( DDRD = (DDRD & (~LLED_BITMASKD)) | ((b) << 3) , PORTD |= LLED_BITMASKP )

#define AUXK_BITMASKD ( (1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0) )
#define AUXK_BITMASKP ( (1<<PORTB4)|(1<<PORTB3)|(1<<PORTB2)|(1<<PORTB1)|(1<<PORTB0) )
#define AUXK_CONFIG   ( DDRB &= ~AUXK_BITMASKD , PORTB |= AUXK_BITMASKP )
#define AUXK_GET      ( PINB & AUXK_BITMASKP )

#elif LAYOUT_TEENSYPP_2
/*****************************************************************************/
/* Teensy++ 2.0 Layout                                                       */
/*****************************************************************************/
// #pragma message("Compiling for Teensy++ 2.0")

#define OBLED_CONFIG  ( DDRD |= (1<<DDD6) )
#define OBLED_ON      ( PORTD |= (1<<PORTD6) )
#define OBLED_OFF     ( PORTD &= ~(1<<PORTD6) )

#define KBDD_HIGH     ( DDRD &= ~(1 << DDD0) , PORTD |= (1 << PORTD0) )
#define KBDD_LOW      ( PORTD &= ~(1 << PORTD0) , DDRD |= (1 << DDD0) )
#define KBDD_GET0     ( (PIND >> PIND0) & 1 )
#define KBDC_HIGH     ( DDRD &= ~(1 << DDD1) , PORTD |= (1 << PORTD1) )
// maybe wrong order?
#define KBDC_LOW      ( DDRD |= (1 << DDD1) , PORTD &= ~(1 << PORTD1) )
#define KBDC_GET0     ( (PIND >> PIND1) & 1 )
#define KBDC_GET      ( PIND & (1 << PIND1) )
#define KBDR_HIGH     ( DDRB &= ~(1 << DDB7) , PORTB |= (1 << PORTB7) )
#define KBDR_LOW      ( PORTB &= ~(1 << PORTB7) , DDRB |= (1 << DDB7) )

#define LLED_BITMASKD ( (1<<DDD5) | (1<<DDD4) | (1<<DDD3) )
#define LLED_BITMASKP ( (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) )
#define LLED_ON(b)    ( DDRD |= LLED_BITMASKD , PORTD = (PORTD & ~LLED_BITMASKP) | ((b) << 3) )
#define LLED_OFF(b)   ( DDRD = (DDRD & (~LLED_BITMASKD)) | ((b) << 3) , PORTD |= LLED_BITMASKP )

#define AUXK_BITMASKD ( (1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0) )
#define AUXK_BITMASKP ( (1<<PORTB4)|(1<<PORTB3)|(1<<PORTB2)|(1<<PORTB1)|(1<<PORTB0) )
#define AUXK_CONFIG   ( DDRB &= ~AUXK_BITMASKD , PORTB |= AUXK_BITMASKP )
#define AUXK_GET      ( PINB & AUXK_BITMASKP )

#else

// No layout, no music
#error "Undefined layout!"

#endif

#define LSB(n) ((n) & 255)
#define MSB(n) (((n) >> 8) & 255)

// CPU Prescale
#define CPU_PRESCALE(n)	(CLKPR = 0x80, CLKPR = (n))

#define _NOP() do { __asm__ __volatile__ ("nop"); } while (0)

#endif /* defined(__hwdefs_h__) */

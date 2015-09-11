/*****************************************************************************/
/* Soarer.c : reverse-engineered from Soarer's Converter V1.12               */
/*****************************************************************************/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/atomic.h>
#include <util/delay.h>

#include "hwdefs.h"
#include "soarer.h"
#include "salloc.h"
#include "usb_comm.h"
#include "print.h"
#include "processing.h"

/*****************************************************************************/
/* PS/2 definitions and scan code translation tables                         */
/*****************************************************************************/

#define INCLUDE_KBD_TRANS_TABLES
#include "kbdtbls.h"

/*****************************************************************************/
/* Global data for this module                                               */
/*****************************************************************************/

uint8_t keyboard_codeset = 4;         // 0x0100
// a hot candidate for PROGMEM ...
uint8_t const kbd_pauseseq[8] =       // 0x0101 pause key definition
  { 0xe1, 0x14, 0x77, 0xe1, 0xf0, 0x14, 0xf0, 0x77 };
uint16_t keyboard_id = 0;             // 0x120/0x121
uint8_t kbd_breakcode = 0;            // 0x0122  incoming scan code is preceded by BREAK (0xf0)
uint8_t kbd_extended_scancode = 0;    // 0x0123  incoming scan code is extended (E0 prefix)
uint8_t kbd_extended2_scancode = 0;   // 0x0124  incoming scan code is extended (E1 prefix = Pause)
uint8_t prot_led_state = 0;           // 0x0125  protocol / LED state
uint8_t old_aux_key_bits = 0;         // 0x0126
uint8_t volatile aux_key_bits = 0;    // 0x0127
uint8_t keyboard_mode = 0;            // 1 = AT/PS2, 2 = PC/XT, 3/4 forced  // 0x0129
uint8_t volatile kbd_rcvd_byte = 0;   // 0x012a
uint8_t volatile kbd_rcvd_state = 0;  // 0x012b
uint8_t volatile kbdcmd_to_send = 0;  // 0x012e
uint8_t volatile data_0x0133 = 0;     // 0x0133
uint32_t volatile timer0_counter = 0; // 0x0136
uint16_t onboard_led_counter = 0;     // 0x013a
#ifdef OBLED2_CONFIG
uint16_t onboard_led2_counter = 0;
#endif

/*****************************************************************************/
/* Necessary prototypes used only in the module                              */
/*****************************************************************************/

void setup_aux_key_handler(void);     // A_0c5c
uint8_t get_aux_key_bits(void);       // A_0c92
void setup_timer1(uint16_t counter);  // A_0c98
void set_kbd_reset_pin(uint8_t bHigh); // A_0ce2
void disable_extint1(void);           // A_0d3e
void enable_extint1_rising(void);     // A_0d4a
void init_kbd(void);                  // A_129a
uint8_t send_kbd_command(uint8_t cmd, uint8_t timeout);  // A_133c
uint8_t fetch_kbd_byte(uint8_t *addr, uint8_t timeout);  // A_13de
uint8_t get_kbd_byte(uint8_t timeout);  // A_1492
uint8_t send_kbd_command_with_parm(uint8_t command, uint8_t cmdparm); // A_14c6
uint8_t send_kbd_command_without_parm(uint8_t command);  // A_1538
void act_onboard_led(uint16_t counter); // A_1586
#ifdef OBLED2_CONFIG
void act_onboard_led2(uint16_t counter);
#else
#define act_onboard_led2(a)
#endif
void setup_timer0(void);              // A_1592

/*****************************************************************************/
/* translate_scancode : translates incoming scan code based on kbd codeset   */
/*****************************************************************************/
// A_0660
uint8_t translate_scancode(uint8_t scancode, uint8_t bExtended)
{
switch (keyboard_codeset)
  {
  case 1:
    // A_067c
    if (scancode < sizeof(kbd_ttbl_set1))
      return pgm_read_byte(kbd_ttbl_set1 + scancode);
    break;
  case 4:
    // A_069c
    if (bExtended)
      {
      if (scancode < sizeof(kbd_ttbl_set2ex))
        return pgm_read_byte(kbd_ttbl_set2ex + scancode);
      else
        break;
      }
    // else fall thru to...
  case 2:
    // A_06b0
    if (scancode < sizeof(kbd_ttbl_set2))
      return pgm_read_byte(kbd_ttbl_set2 + scancode);
    break;
  case 3:
    // A_068c
    if (scancode < sizeof(kbd_ttbl_set3))
      return pgm_read_byte(kbd_ttbl_set3 + scancode);
    break;
  }
return 0;
}

/*****************************************************************************/
/* reset_kbdinstate :                                                        */
/*****************************************************************************/
// A_06c4
void reset_kbdinstate(void)
{
reset_macroproc();
queue_reset_usb_data();
kbd_breakcode = 0;                      /* reset state flags                 */
kbd_extended_scancode = 0;
kbd_extended2_scancode = 0;
}

/*****************************************************************************/
/* set_kbd_leds : sets the Teensy's keyboard LEDs                            */
/*****************************************************************************/
// A_06da
void set_kbd_leds(uint8_t ledbits)
{
if (get_keyboard_protocol())
  LLED_ON(ledbits);
else  // if USB host set keybord protocol to 0
  LLED_OFF(ledbits);
}

/*****************************************************************************/
/* incoming_kbd_breakcode : translates a scan code and passes it on          */
/*****************************************************************************/
// A_071e
void incoming_kbd_breakcode(uint8_t scancode, uint8_t bExtended)
{
incoming_keybreak(translate_scancode(scancode, bExtended));
}

/*****************************************************************************/
/* incoming_kbd_makecode : translates a scan code and passes it on           */
/*****************************************************************************/
// A_0724
void incoming_kbd_makecode(uint8_t scancode, uint8_t bExtended)
{
incoming_keymake(translate_scancode(scancode, bExtended));
}

/*****************************************************************************/
/* send_aux_key_changes : if there are changes in the aux key states, send'em*/
/*****************************************************************************/
// A_072a
uint8_t send_aux_key_changes(void)
{
uint8_t cur_aux_key_bits = get_aux_key_bits();
uint8_t chg_aux_key_bits = old_aux_key_bits ^ cur_aux_key_bits;
int8_t  i;

if (!chg_aux_key_bits)
  return chg_aux_key_bits;

// loop from auxkey_id=0xab..0xaf
for (i = 0; i != 6; i++)
  {
  if ((chg_aux_key_bits >> i) & 1)
    {
    // internal IDs: $AB..$AF
    if ((cur_aux_key_bits >> i) & 1)
      //A_0778
      incoming_keybreak(KEY_AUX1 + i);
    else
      // A_0780
      incoming_keymake(KEY_AUX1 + i);
    }
  }

old_aux_key_bits = cur_aux_key_bits;
return 1;
}

/*****************************************************************************/
/* main : main program function                                              */
/*****************************************************************************/
// A_07a6
int main(void)
{
uint8_t kbd_reset_pin_reset = 0; // R3
uint8_t keyboard_determined = 0; // R8
uint32_t t0ct_start;             // R10-13
uint32_t t0ct_cur; 
uint8_t kbd_byte_fetched;
uint8_t newline_after_wait;      // R5
uint8_t resend_requested;        // R9
uint8_t new_pled_state;          // R16

#if 1
uint8_t fetched_kbd_byte;  // R28[1]
#else
// in the original, there's the following code sequence here:
	rcall	A_07cc	; 0x7cc
A_07cc:
    push R0
    in  R28, SPL
    in  R29, SPH
// i.e., call yourself and then do it again.
// Presumably means "reserve 4 bytes on stack"...
#endif

// set for unscaled clock  (16MHz on all of the supported configurations)
CPU_PRESCALE(0);
OBLED_CONFIG;
#ifdef OBLED2_CONFIG
OBLED2_CONFIG;
#endif

set_kbd_leds(0);  // init keyboard LEDs to out
set_kbd_leds(7);  // set all attached keyboard LEDs on

setup_timer0();
proc_eeprom_mem_init();
init_kbd();
setup_aux_key_handler();
reset_kbdinstate();
set_kbd_reset_pin(0);

kbd_reset_pin_reset = 0;
keyboard_determined = 0;
resend_requested = 0;
newline_after_wait = 0;
t0ct_start = 0;

// big fat main loop presumably starts here
// A_080c
while (1)
  {
  if (!kbd_reset_pin_reset)
    {
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      t0ct_cur = timer0_counter;
    if (t0ct_cur > 500)
      {
      set_kbd_reset_pin(1);
      kbd_reset_pin_reset = 1;
      }
    }

  // A_0838
  if (!keyboard_determined)
    {
    // A_083e:
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      t0ct_cur = timer0_counter;
    if (t0ct_cur > 3000)
      {
      // A_0860
      uint8_t forcedtype = get_forced_keyboard_type();
      if (forcedtype & 0x0f)
        {
        keyboard_codeset = forcedtype >> 4;
        if (keyboard_codeset)
          {
          if (keyboard_codeset == 1)
            // A_0878
            keyboard_mode = 2;
          else
            // A_087e
            keyboard_mode = 1;
          }
        else
          // A_886
          keyboard_mode = forcedtype;
        }
      else
        {
        // A_0890
        keyboard_codeset = 0;
        keyboard_id = 0;
        // send echo (kbd is expected to respond with 0xee)
        if (send_kbd_command(ATCMD_ECHO, 50) == 2)
          {
          // A_08a8
          get_kbd_byte(50);  // get and ignore the response
          keyboard_mode = 1;
          if (!keyboard_codeset)
            {
            // A_08bc
            // send "Read ID" command (kbd is expected to respond with KBDM_ACK 
            // followed by 2 bytes ID, 0xab 0x83 being standard PS/2)
            // A_08c8
            if (send_kbd_command(ATCMD_READID, 50) == 2 &&
                get_kbd_byte(50) == KBDM_ACK)
              {
              uint8_t kbdid1  /*R28+2*/, kbdid2 /*R28+3*/;

              // A_08d0
              if (fetch_kbd_byte(&kbdid1, 50) == 2)
                {
                // A_08dc
                if (fetch_kbd_byte(&kbdid2, 50) == 2)
                  {
                  // A_0900
                  keyboard_id = ((uint16_t)(kbdid1) << 8) | kbdid2;
                  // A_08ea
                  // ABxx is an AT/PS2 variant, except for 
                  // 122-key host-connected keyboard (AB85)
                  // (this, BTW, also covers the IBM AT keyboard (AB83),
                  // which is really using codeset 2!)
                  if (kbdid1 == 0xab && kbdid2 != 0x85)
                    // A_08f4
                    keyboard_codeset = 4;
                  else
                    // A_08fa
                    keyboard_codeset = 3;
                  }
                else
                  {
                  // A_0916:
                  keyboard_codeset = 4;
                  keyboard_id = kbdid1; // high part empty
                  }
                }
              else
                // A_0924
                keyboard_codeset = 2;
              }
            }
          }
        else                            /* seems to be an XT keyboard        */
          {
          // A_092a
          keyboard_mode = 2;
          keyboard_codeset = 1;         /* so use scan code set 1            */
          }
        // A_0934
        if (!keyboard_codeset)          /* in case of doubt                  */
          keyboard_codeset = 4;         /* treat it as normal PS/2           */
        }

      // This seems to be the area where the EEPROM translation stuff is set up
      // A_0940
      setup_proc_kbd(keyboard_codeset, keyboard_id);
      setup_processing();
      if (keyboard_mode == 2)   // if PC/XT keyboard
        {
        // A_095c
        disable_extint1();      // switch to int on rising clock flank
        enable_extint1_rising();
        }
      // A_0960
      if (keyboard_codeset == 3)  // tell Terminal keyboards to send Make/Break
        // A_0968
        send_kbd_command_without_parm(ATCMD_SETAMKBK);
      // A_096c
      set_kbd_leds(0);  // turn off keyboard LEDs
      ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
        t0ct_start = timer0_counter;
#if 1
      print_P(PSTR("\n\nKeyboard ID: "));
#else
      usb_debug_putchar('\n');
      usb_debug_putchar('\n');
      print_P(PSTR("Keyboard ID: "));
#endif
      phex16(keyboard_id);
#if 1
      print_P(PSTR("\nCode Set: "));
#else
      usb_debug_putchar('\n');
      print_P(PSTR("Code Set: "));
#endif

#if 1
      // 12 bytes less code than the original ...
      switch (keyboard_codeset)
        {
        case 1 :
        case 2 :
        case 3 :
          phex1(keyboard_codeset);
          break;
        case 4 :
          print_P(PSTR("2 (extended)"));
          break;
        default :
          print_P(PSTR("unknown"));
          break;
        }
#else
      if (keyboard_codeset == 2)
        // A_09d4
        usb_debug_putchar('2');
      else if (keyboard_codeset == 3)
        // A_09dc
        usb_debug_putchar('3');
      else if (keyboard_codeset == 4)
        // A_09e0
        print_P(PSTR("2 (extended)"));
      else if (keyboard_codeset == 1)
        // A_09d0
        usb_debug_putchar('1');
      else
        // A_09e6
        print_P(PSTR("unknown"));
#endif
      //A_09ee
      if (keyboard_mode == 2)
        print_P(PSTR("\nMode: PC/XT\n\n"));
      else
        print_P(PSTR("\nMode: AT/PS2\n\n"));
      // A_0a04
      keyboard_determined = 1;
      }
    }

  // A_0a08:
  kbd_byte_fetched = fetch_kbd_byte(&fetched_kbd_byte, 0);
#ifdef OBLED2_CONFIG  // little "special" - blink LED2 on each incoming kbd byte
  if (kbd_byte_fetched == 2)
    act_onboard_led2(10);
#endif
  if (keyboard_determined)
    {
    // A_0a16
    if (kbd_byte_fetched >= 2)
      {
      // A_0a1c
      if (kbd_byte_fetched == 2)
        {
        // A_0a22
        if (keyboard_codeset == 1)    // if it's a PC/XT keyboard
          {
          // A_0a2c
          if (fetched_kbd_byte != 0xff)  // buffer full?
            {
            // A_0a32
            if (fetched_kbd_byte & 0x80)
              incoming_kbd_breakcode(fetched_kbd_byte & 0x7f, 0);
            else
              // A_0a40
              incoming_kbd_makecode(fetched_kbd_byte, 0);
            }
          else
            {
            // A_0ace
            reset_kbdinstate();
            // print_P(PSTR("!BF "));
            act_onboard_led(5000);
            }
          // goto A_0b08;
          }
        else    // if it's AT / PS/2
          {
          // A_0a46
          if (kbd_extended2_scancode)  // if in pause key processing
            {
            // A_0a4e
            if (fetched_kbd_byte == kbd_pauseseq[kbd_extended2_scancode])
              {
              // A_0a5c
              kbd_extended2_scancode++;
              if (kbd_extended2_scancode == 3)
                // A_0a68
                incoming_kbd_makecode(0x7e, 1);
              else if (kbd_extended2_scancode == 8)
                {
                // A_0a76
                // PAUSE has no typematic repeat or break, so treat it as
                // "released" once the PAUSE sequence is complete
                incoming_kbd_breakcode(0x7e, 1);
                kbd_extended2_scancode = 0;
                }
              }
            else
              {
              // A_0a82
              if (kbd_extended2_scancode >= 3)
                incoming_kbd_breakcode(0x7e, 1);
              kbd_extended2_scancode = 0;
              // in this special case, continue examining the incoming code
              goto kbdnopause;
              }
            }
          else
            {
            // A_0a90
            kbdnopause:  // can't seem to get rid of this (see above)
            switch (fetched_kbd_byte)
              {
              case KBDM_BUFOVR :      // Buffer overflow
#if 1  // not in original
              case KBDM_BUFOVR2 :     // Key detection error or buffer overrun
#endif
                // A_0ace
                reset_kbdinstate();
                // print_P(PSTR("!BO "));
                act_onboard_led(5000);
                break;
              case KBDM_BATOK :       // BAT finished OK
                break;
              case KBDM_EXTENDED :    // extended scan code?
                // A_0ab8
                kbd_extended_scancode = 1;
                break;
              case KBDM_EXTENDED2 :   // Pause key sequence start
                // A_0ac0:
                kbd_extended2_scancode = 1;
                break;
#if 1  // not in original
              case KBDM_ECHO :        // Response to ECHO command
                // should never come in...
                break;
#endif
              case KBDM_BREAK :       // break code coming in
                // A_0ab0
                kbd_breakcode = 1;
                break;
#if 1  // not in original
              case KBDM_ACK :         // Command Acknowledgement
                // should never come in...
                break;
#endif
              case KBDM_ERR :         // Keyboard returned an error!
#if 1  // not in original
              case KBDM_ERR2 :
#endif
                // A_0ac8
                // print_P(PSTR("!ER "));
                act_onboard_led(10000);
                break;
#if 1  // not in original, but SHOULD be...
              case KBDM_RESEND :      // Resend last command byte
                break;
#endif
              default :               // any normal key
                // A_0ad8:
                if (kbd_breakcode)
                  {
                  // A_0ae0
                  incoming_kbd_breakcode(fetched_kbd_byte, kbd_extended_scancode);
                  kbd_breakcode = 0;
                  kbd_extended_scancode = 0;
                  }
                else
                  {
                  // A_0aee
                  incoming_kbd_makecode(fetched_kbd_byte, kbd_extended_scancode);
                  kbd_extended_scancode = 0;
                  }
                break;
              }
            }
          }

// A_0b08
        resend_requested = 0;
        }
      else  // if (kbd_byte_fetched > 2)
        {
        // A_0afc
        send_kbd_command(ATCMD_RESEND, 50); // request resend of last byte
        resend_requested = 1;
        }

      // A_0b0a
      ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
        t0ct_start = timer0_counter;
      newline_after_wait = 1;
      }

    // A_0b26
    else if (!kbd_byte_fetched && !resend_requested)
      {
      // A_0b32
      new_pled_state = (get_keyboard_protocol() << 7) | get_keyboard_leds();
      if (new_pled_state != prot_led_state)
        {
        // A_0b50
        uint8_t num_lock = new_pled_state & 1;
        uint8_t caps_lock = (new_pled_state >> 1) & 1;
        uint8_t scroll_lock = (new_pled_state >> 2) & 1;

        uint8_t numscrollbits;
        // special code for IBM RT PC keyboard with inverted Num/Caps LED pos
        if (keyboard_id == KBDID_IBM_RT)
          // A_0b7c
          numscrollbits = (num_lock << 2) | (caps_lock << 1) | scroll_lock;
        else
          // A_0b8c:
          numscrollbits = (caps_lock << 2) | (num_lock << 1) | scroll_lock;
        // A_0b9a:
        send_kbd_command_with_parm(ATCMD_SETLEDS, numscrollbits);
        set_kbd_leds((scroll_lock << 2) | (num_lock << 1) | caps_lock);
        prot_led_state = new_pled_state;
        }
      }
    // A_0c08
    if (send_aux_key_changes())
      {
      // A_0bb4
      ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
        t0ct_start = timer0_counter;
      newline_after_wait = 1;
      }
    }
  // A_0bd0:
  if (newline_after_wait)
    {
    // A_0bd4:
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      t0ct_cur = timer0_counter;
    if (t0ct_cur - t0ct_start >= 50)
      {
      usb_debug_putchar('\n');
      newline_after_wait = 0;
      }
    }
  rawhid_comm();
  }  // end of big fat main loop 
}

/*****************************************************************************/
/* TIMER3_COMPA_vect : Timer/Counter3 Compare Match A                        */
/*****************************************************************************/
// A_0c10
ISR(TIMER3_COMPA_vect)
{
// ticks once per ms
// aux key bits must be stable for 10ms to be counted
static uint8_t aux_key_timercounter = 10;  // 0x0109
static uint8_t tmr_aux_key_bits = 0;       // 0x0128

uint8_t newauxkeys = AUXK_GET;  // retrieve new aux key states
if (newauxkeys != tmr_aux_key_bits)
  {
  tmr_aux_key_bits = newauxkeys;
  aux_key_timercounter = 10;
  }
if (aux_key_timercounter)
  {
  if (!--aux_key_timercounter)
    aux_key_bits = tmr_aux_key_bits;
  }
}

/*****************************************************************************/
/* setup_aux_key_handler : sets up timer 3 for aux key checking              */
/*****************************************************************************/
// A_0c5c
void setup_aux_key_handler(void)
{
AUXK_CONFIG;  // setup aux key port

// Timer 3 ticks once per ms (F_CPU / 64 / 1000 = 250)
TIMSK3 |= (1 << OCIE3A);
OCR3AH = 0;
OCR3AL = 250;
TCCR3A = 0;
TCCR3B = (1 << WGM32);
TCCR3B |= (1 << CS31) | (1 << CS30);
}

/*****************************************************************************/
/* get_aux_key_bits : returns current state of the aux keys                  */
/*****************************************************************************/
// A_0c92
uint8_t get_aux_key_bits(void)
{
return aux_key_bits;
}

/*****************************************************************************/
/* setup_timer1 : sets up timer/counter 1 for operation                      */
/*****************************************************************************/
// A_0c98
void setup_timer1(uint16_t microseconds)
{
TCCR1B &= ~((1 << CS12)|(1 << CS11)|(1 << CS10));  // set timer 1 prescaler to 0
TIMSK1 &= ~(1 << OCIE1A);   // disable Timer/Counter1 Output Compare A Match interrupt
TCNT1H = 0;                 // reset timer 1 counter
TCNT1L = 0;
TIFR1 = (1 << OCF1A);       // clear Timer/Counter1 Output Compare A Match Flag
if (microseconds)
  {
  // This works nicely at 16MHz, but would have to be changed for other speeds!
  microseconds *= 2;
  OCR1AH = (microseconds >> 8);   // set up output compare value
  OCR1AL = (microseconds & 0xff);
  TIMSK1 |= (1 << OCIE1A);    // enable Timer/Counter1 Output Compare A Match interrupt
  // This works nicely at 16MHz, but would have to be changed for other speeds!
  TCCR1B |= (1 << CS11);      // Timer 1 Clock Source = Clock / 8
  }
}

/*****************************************************************************/
/* set_kbd_reset_pin : sets up the keyboard reset pin                        */
/*****************************************************************************/
// A_0ce2
void set_kbd_reset_pin(uint8_t bHigh)
{
if (bHigh)
  KBDR_HIGH;
else
  KBDR_LOW;
}

/*****************************************************************************/
/* set_kbd_data_pin : sets the keyboard Data pin                             */
/*****************************************************************************/
// A_0cf2
void set_kbd_data_pin(uint8_t bHigh)
{
if (bHigh)
  KBDD_HIGH;
else
  KBDD_LOW;
}

/*****************************************************************************/
/* set_kbd_clock_pin : sets the clock line and waits for it                  */
/*****************************************************************************/
// A_0d02
uint8_t set_kbd_clock_pin(uint8_t bHigh)
{
uint8_t oldmask = EIMSK;                /* remember current ext.int mask     */
uint8_t i;

EIMSK &= ~(1 << INT1);                  /* disable ext. interrupt 1          */
_NOP();
if (bHigh)                              /* if we need to set it to 1         */
  // A_0d0e
  KBDC_HIGH;
else                                    /* if we need to set it to 0         */
  // A_0d14
  KBDC_LOW;

// A_0d18
// wait until line is stable (?)
for (i = 20; i > 0; i--)                /* wait a little bit for it to happen*/
  {
  if (KBDC_GET0 == bHigh)
    break;
  }
// A_0d2c
EIFR = (1 << INTF1);                    /* clear ext.int.1 interrupt flag    */
if (oldmask & (1 << INT1))              /* if it was enabled before,         */
  EIMSK |= (1 << INT1);                 /* re-enable it                      */
else                                    /* otherwise                         */
  EIMSK &= ~(1 << INT1);                /* disable ext.int.1                 */
return EIMSK;                           /* pass back current ext.int.mask    */
}

/*****************************************************************************/
/* disable_extint1 : disable external interrrupt 1                           */
/*****************************************************************************/
// A_0d3e
void disable_extint1(void)
{
cli();
EIMSK &= ~(1 << INT1);                  /* disable ext. interrupt 1          */
EIFR = (1 << INTF1);                    /* clear ext.int.1 interrupt flag    */
sei();
}

/*****************************************************************************/
/* enable_extint1_rising : enable external interrupt 1 on RISING edge        */
/*****************************************************************************/
// A_0d4a
void enable_extint1_rising(void)
{
cli();
// The rising edge of INTn generates asynchronously an interrupt request.
EICRA |= (1 << ISC11) | (1 << ISC10);   /* set up ext. interrupt 1           */
EIMSK |= (1 << INT1);                   /* enable ext. interrupt 1           */
sei();
}

/*****************************************************************************/
/* A_0d5c :                                                                  */
/*****************************************************************************/
// A_0d5c
uint8_t A_0d5c
    (
    uint8_t cmode   // 0=from IRQ1/init_kbd, 1=timer 1, 2=from send_kbd_command
    )
{
static int8_t data_0x0111 = -1;      // 0x0111
static int8_t data_0x0112 = -1;      // 0x0112
uint8_t ps2clk; // PS/2 clock line state

if (cmode)
  data_0x0112 = data_0x0111;
ps2clk = KBDC_GET0;                     /* get PS/2 Clock line               */

// R24 = data_0x0112;
if (data_0x0112 == -1)
  // A_0d7c
  data_0x0112 = 1 ^ ps2clk;             /* save inverted clock line          */

// A_0d84
switch (data_0x0112)
  {
  case 0 :
    // A_0d96
    if (!ps2clk)
      {
      // A_0dcc
      data_0x0112 = -1;
      return 4;
      }
    // A_0d9a
    setup_timer1(90);  // set timer1 to 90 microseconds
    data_0x0111 = -2;
    data_0x0112 = 1;
    return 1;
  case 1 :
    // A_0dae
    if (ps2clk)
      {
      // A_0dcc
      data_0x0112 = -1;
      return 4;
      }
    // A_0db2
    setup_timer1(1000);  // setup timer1 to 1 ms
    data_0x0111 = -1;
    data_0x0112 = 0;
    return 1;
  case -2 :
    // A_0dc8
    data_0x0112 = -1;
    return 2;
  default :
    // A_0d92
    return 1;
  }
}

/*****************************************************************************/
/* pcxt_clockin : called for keyboard mode PC/XT                             */
/*****************************************************************************/
// A_0dd6
void pcxt_clockin(uint8_t timer1)
{
static int8_t read_pcxt_nextstate = -2; // 0x010a
static int8_t read_pcxt_state = 1;      // 0x010b
static uint8_t read_pcxt_shiftin = 0;   // 0x012c
static uint8_t read_pcxt_bits = 0;      // 0x012d
uint8_t b = KBDD_GET0;                  /* get PD0 (PS/2 Data line)          */

if (timer1)
// A_0de0
  read_pcxt_state = read_pcxt_nextstate;

// A_0de8
switch (read_pcxt_state)
  {
  case -2:
    // A_0e7c
    b = 5;
    break;
  case 1 :
    // A_0e08
    read_pcxt_nextstate = -2;
    setup_timer1(1200);  // setup timer1 to 1.2ms
    read_pcxt_bits = 0;
    read_pcxt_shiftin = 0;
    if (b)
      {
      // A_0e24
      read_pcxt_state = 2;
      return;
      }
    else
      b = 6;
    break;
  case 2 :
    // A_0e2c:
    read_pcxt_shiftin = (read_pcxt_shiftin >> 1) | (b << 7);  // shift in data bit from the left
    if (++read_pcxt_bits != 8)
      return;
    // A_0e4c
    read_pcxt_nextstate = 3;
    setup_timer1(120);   // set timer 1 to 120 microseconds
    read_pcxt_state = 3;
    return;
  case 3 :
    // A_0e5e:
    setup_timer1(0);
    kbd_rcvd_byte = read_pcxt_shiftin;
    b = 2;
    break;

  default:
    return;
  }

// A_0e7e:
setup_timer1(0);
read_pcxt_state = 1;
if (b != 2)
  // A_0e70
  {
  // print_P(PSTR("!RE "));
  act_onboard_led(3000);
  }
kbd_rcvd_state = b;
}

/*****************************************************************************/
/* atps2_clockout                                                            */
/*****************************************************************************/
// A_0e94
uint8_t atps2_clockout
    (
    uint8_t fromt1                      /* flag whether called from timer 1  */
    )
{
static uint8_t atps2_write_parity = 1;    // 0x010c
static int8_t atps2_write_t1state = -1;   // 0x010d
static int8_t atps2_write_state = -1;     // 0x010e
static uint8_t atps2_write_shiftout = 0;  // 0x012f
static int8_t atps2_write_bits = 0;       // 0x0130
uint8_t curbit; // R16
uint8_t rc;  // R17

/* To write out a byte, the following has to be done
   ( from http://www.computer-engineering.org/ps2protocol/ )
    1)   Bring the Clock line low for at least 100 microseconds.
    2)   Bring the Data line low.
    3)   Release the Clock line.
    4)   Wait for the device to bring the Clock line low.
    5)   Set/reset the Data line to send the first data bit
    6)   Wait for the device to bring Clock high.
    7)   Wait for the device to bring Clock low.
    8)   Repeat steps 5-7 for the other seven data bits and the parity bit
    9)   Release the Data line.
    10) Wait for the device to bring Data low.
    11) Wait for the device to bring Clock  low.
    12) Wait for the device to release Data and Clock
*/

if (atps2_write_state == -1)      // setup to state 2
  atps2_write_state = 2;
if (fromt1)                       // if coming from timer, switch to t1 state
  atps2_write_state = atps2_write_t1state;

switch (atps2_write_state)
  {
  // Obviously, no states 0/1 in this one...
  // Has encoded the expected clock line state in bit 0
  case 2:
    // 1) Bring clock line low and wait for 200microseconds
    // A_0f0a
    atps2_write_shiftout = kbdcmd_to_send;
    atps2_write_bits = 8;
    atps2_write_parity = 1;
    atps2_write_t1state = 3;
    setup_timer1(200);  // setup timer1 to 0.2ms
    set_kbd_clock_pin(0);
    break;
  case 3 :
    // 2) Bring data line low
    // 3) release the clock line
    // 4) wait up to 20ms for the device to bring the lock line low
    // A_0f30
    set_kbd_data_pin(0);
    set_kbd_clock_pin(1);
    atps2_write_t1state = -2;
    setup_timer1(20000);  // setup timer1 to 20ms
    // fall thru to...
  case 4 :
    // A_0f44
    // Expect clock line to be high after request start
    atps2_write_state = 5;
    break;
  case 5 :
    // Send one of the 8 data bits
    // A_0f48
    curbit = atps2_write_shiftout & 1;
    set_kbd_data_pin(curbit);
    atps2_write_shiftout >>= 1;
    atps2_write_parity ^= curbit;
    if (--atps2_write_bits)
      atps2_write_state = 4;
    else
      atps2_write_state = 6;
    break;
  case 6 :
    // Expect clock line to be high after one of the data bits
    // A_0f7a
    atps2_write_state = 7;
    break;
  case 7:
    // 8) send out the parity bit
    // A_0f7e
    set_kbd_data_pin(atps2_write_parity);
    atps2_write_bits--;
    atps2_write_state = 8;
    break;
  case 8 :
    // Expect clock line to be high after the parity bit
    // A_0f92
    atps2_write_state = 9;
    break;
  case 9 :
    // 9) Release data line
    // A_0f96
    set_kbd_data_pin(1);
    atps2_write_bits--;
    atps2_write_state = 10;
    break;
  case 10 :
    // Expect clock line to be high after 9)
    // A_0fa8
    atps2_write_state = 11;
    break;
  case 11 :
    // sending done
    // A_0fb0
    setup_timer1(0);  // reset timeout counter
    if (KBDD_GET0)    //  data line is expected to be low now
      rc = 9;
    else
      rc = 2;
    // A_0fcc
    set_kbd_data_pin(1);  // release data line
    atps2_write_state = -1;
#if 0
    usb_debug_putchar('>');
    phex(rc);
    usb_debug_putchar(' ');
#endif
    return rc;
  case -2 :
    // A_0fbe
    // Something has gone wrong; the operation timed out
    // atps2_write_bits is anything between 8 and -2 (0xfe)
    rc = (atps2_write_bits << 4) | 0x05;
    if (rc >= 2)  // that is totally, totally BS IMO, since it's either <0 or >=5
      {
      set_kbd_data_pin(1);    // release data line
      atps2_write_state = -1;
      return rc;
      }
    break;
  }

// A_0fd8
if (KBDC_GET0 == ((uint8_t)atps2_write_state & 1))
  return 1;
else
  {
  // A_0ff8
  set_kbd_data_pin(1);
  atps2_write_state = -1;
  // print_P(PSTR("!WC "));
  act_onboard_led(3000);
  return 4;
  }
}

/*****************************************************************************/
/* atps2_clockin : clock line transition from high to low or timer 1         */
/*****************************************************************************/
// A_1016
uint8_t atps2_clockin(uint8_t bReset)
{
static uint8_t read_atps2_parity = 1;     // 0x010f
static int8_t read_atps2_state = -1;      // 0x0110
static uint8_t read_atps2_shiftin = 0;    // 0x0131
static uint8_t read_atps2_bits = 0;       // 0x0132
uint8_t ps2clk = KBDC_GET0;  // R15
uint8_t ps2data = KBDD_GET0;  // R16  PS/2 data line

/* AT / PS/2 read logic
   ( from http://www.computer-engineering.org/ps2protocol/ )

Bus idle state is high. When the keyboard wants to send information,
it first checks the Clock line to make sure it's at a high logic level.
If it's not, the host is inhibiting communication and the device must
buffer any to-be-sent data until the host releases Clock.
The Clock line must be continuously high for at least 50 microseconds
before the device can begin to transmit its data. 

The keyboard uses a serial protocol with 11-bit frames.  These bits are:

    1 start bit.  This is always 0.
    8 data bits, least significant bit first.
    1 parity bit (odd parity).
    1 stop bit.  This is always 1.

The keyboard/mouse writes a bit on the Data line when Clock is high,
and it is read by the host when Clock is low.

*/

if (bReset)
  {
  read_atps2_state = -1;
  return 5;
  }
// A_102e
if (read_atps2_state == -1)
  read_atps2_state = 1;

// A_103c
//ps2data = KBDD_GET0;  // PS/2 Data line

switch (read_atps2_state)
  {
  case 1 :
    // A_106c
    setup_timer1(1200);  // setup timer1 to 1.2ms
    read_atps2_bits = 0;
    read_atps2_shiftin = 0;
    read_atps2_parity = 1;
    if (ps2data)
      {
      // A_1132
      setup_timer1(0);
      read_atps2_state = -1;
      return 6;
      }
    read_atps2_state = 4;
    break;
  case 4 :
    // A_1086
    read_atps2_state = 5;
    break;
  case 5 :
    // A_108a
    read_atps2_shiftin = (ps2data << 7) | (read_atps2_shiftin >> 1);  // shift in new bit
    read_atps2_parity ^= ps2data;
    if (++read_atps2_bits == 8)
      read_atps2_state = 6;
    else
      read_atps2_state = 4;
    break;
  case 6 :
    // A_10c2
    read_atps2_state = 7;
    break;
  case 7 :
    // A_10c6
    if (read_atps2_parity != ps2data)
      {
      // A_1132:
      setup_timer1(0);
      read_atps2_state = -1;
      return 7;
      }
    read_atps2_state = 8;
    break;
  case 8 :
    // A_10d6
    read_atps2_state = 9;
    break;
  case 9 :
    // A_10da
    if (ps2data)
      {
      kbd_rcvd_byte = read_atps2_shiftin;
      keyboard_mode = 1;
      setup_timer1(0);
      read_atps2_state = -1;
      return 2;
      }
    else
      {
      // A_10f0
      // print_P(PSTR("!DL "));
      act_onboard_led(3000);
      setup_timer1(0);
      read_atps2_state = -1;
      return 8;
      }
    break;
  }

// A_10fa
if ((uint8_t)(read_atps2_state & 1) == ps2clk)
  return 1;
else
  {
  //  A_111a
  read_atps2_state = -1;
  // print_P(PSTR("!CE "));
  act_onboard_led(3000);
  return 4;
  }
}

/*****************************************************************************/
/* atps2_clock : called for keyboard modes 1,3,4                             */
/*****************************************************************************/
// A_1142
void atps2_clock
    (
    uint8_t cmode   // 0=from IRQ1/init_kbd, 1=timed out, 2=from send_kbd_command
    )
{
static uint8_t data_0x0134 = 0;         // 0x0134
static uint8_t data_0x0135 = 0;         // 0x0135
uint8_t b;     // little helper

if (cmode == 2)   // if called from send_kbd_command
  {
  if (keyboard_mode == 2)
    {
    data_0x0133 = 3;
    return;
    }
  // A_1162
  if (data_0x0135 == 1)
    {
    data_0x0135 = 3;
    if (data_0x0133)
      {
      // print_P(PSTR("!X1 "));
      act_onboard_led(3000);
      }
    // A_117e
    data_0x0133 = 1;
    cmode = 0;
    }
  else
    {
    // A_1188
    data_0x0134 = 1;
    return;
    }
  }

// A_1190
// R15 = 1;
// R13 = 2;
// R14 = 3;

// A_119c
while (1)
  {
  switch (data_0x0135)
    {
    case 0 :
      // A_11b4
      b = A_0d5c(cmode);
      if (b < 2)
        return;
      // A_11be
      else if (b == 2)
        {
        // A_11c2
        if (data_0x0134 != 0)
          {
          data_0x0134 = 0;
          if (data_0x0133 != 0)
            {
            // print_P(PSTR("!X2 "));
            act_onboard_led(3000);
            }
          // A_11dc
          data_0x0133 = 1;
          data_0x0135 = 3;
          cmode = 0;
          }
        else
          {
          // A_11e8
          data_0x0135 = 1;
          return;
          }
        }
      break;
    case 1 :
      // A_11f0
      if (KBDC_GET)  // if PS/2 Clock line high
        data_0x0135 = 0;
      else
        {
        if (data_0x0133 != 0)
          {
          // print_P(PSTR("!X3 "));
          act_onboard_led(3000);
          }
        // A_1202
        kbd_rcvd_state = 1;
        data_0x0135 = 2;
        }
      break;
    case 2 :
      // A_120c
      b = atps2_clockin(cmode);
      if (b < 2)
        return;
      else if (b != 2)
        {
        // print_P(PSTR("!X4 "));
        act_onboard_led(3000);
        }
      // A_1220
      kbd_rcvd_state = b;
      data_0x0135 = 0;
      break;
    case 3 :
      // A_1226
      b = atps2_clockout(cmode);
      if (b < 2)
        return;
      data_0x0133 = b;
      data_0x0135 = 0;
      break;
    default :
      return;
    }
  }
}

/*****************************************************************************/
/* INT1_vect : external interrupt request 1                                  */
/*****************************************************************************/
// A_1244
ISR(INT1_vect)
{
if (keyboard_mode == 2)                 /* if PC/XT keyboard attached        */
  pcxt_clockin(0);
else                                    /* if AT / PS/2 keyboard attached    */
  atps2_clock(0);
}

/*****************************************************************************/
/* init_kbd : initializes external keyboard handling                         */
/*****************************************************************************/
// A_129a
void init_kbd(void)
{
cli();                                  /* disable interrupts                */
set_kbd_clock_pin(1);
set_kbd_data_pin(1);
TCCR1A = 0;               // normal port operation
TCCR1B = (1 << WGM12);    // Timer/Counter mode CTC
// The falling edge of INT1 generates asynchronously an interrupt request
EICRA = (EICRA & ~((1 << ISC11) | (1 << ISC10))) | (1 << ISC10);
// Allow External Interrupt 1
EIMSK |= (1 << INT1);
atps2_clock(0);
sei();                                  /* allow interrupts                  */
}

/*****************************************************************************/
/* TIMER1_COMPA_vect : Timer/Counter1 Compare Match A                        */
/*****************************************************************************/
// A_12c4
ISR(TIMER1_COMPA_vect)
{
TCCR1B &= ~((1 << COM1C0) | (1 << WGM11) | (1 << WGM10));
TIMSK1 &= ~(1 << OCIE1A);
_NOP();
TCNT1H = 0;
TCNT1L = 0;
TIFR1 = (1 << OCF1A);
if (keyboard_mode == 2)                 /* if PC / XT keyboard attached      */
  pcxt_clockin(1);
else                                    /* if AT / PS/2 keyboard attached    */
  atps2_clock(1);
}

/*****************************************************************************/
/* send_kbd_command :                                                                  */
/*****************************************************************************/
// A_133c
uint8_t send_kbd_command(uint8_t cmd /*R24*/, uint8_t timeout/*R22*/)
{
uint32_t startcounter;  // R14-17
uint8_t ret;

if (keyboard_mode == 2)   // not possible on PC/XT keyboards
  return 0;

act_onboard_led2(10);  // little "special" - blink LED2 on each outgoing kbd byte

// A1356
usb_debug_putchar('w');
phex(cmd);
usb_debug_putchar(' ');
// A_1362
cli();
kbdcmd_to_send = cmd;
data_0x0133 = 0;
atps2_clock(2);
sei();

// A_1372
ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  startcounter = timer0_counter;

// A_13c2
while (data_0x0133 < 2)
  {
  if (timeout)
    {
    uint32_t now;
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      now = timer0_counter;
    // A_1392
    if (now - startcounter > timeout)
      return 10;
    }
  }

// A_13ca
ret = data_0x0133;
data_0x0133 = 0;
return ret;
}

/*****************************************************************************/
/* fetch_kbd_byte : fetches a byte from PS/2 data line with timeout          */
/*****************************************************************************/
// A_13de
uint8_t fetch_kbd_byte(uint8_t *addr, uint8_t timeout)
{
uint8_t b;  // R13
uint32_t startcounter;

ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  startcounter = timer0_counter;

b = kbd_rcvd_state;
if (timeout)
  {
  while (b < 2)
    {
    uint32_t now;
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      now = timer0_counter;
    if (now - startcounter > timeout)
      return b;
    b = kbd_rcvd_state;
    }
  }
// A_144c
else if (b < 2)
  return b;

// A_1452
kbd_rcvd_state = 0;
if (b == 2)
  {
  usb_debug_putchar('r');
  phex(kbd_rcvd_byte);
  usb_debug_putchar(' ');
  if (addr)
    *addr = kbd_rcvd_byte;
  }
else
  {
  usb_debug_putchar('R');
  phex(b);
  usb_debug_putchar(' ');
  }

return b;
}

/*****************************************************************************/
/* get_kbd_byte                                                              */
/*****************************************************************************/
// A_1492
uint8_t get_kbd_byte(uint8_t timeout)
{
uint8_t kbdbyte; // allocated on stack
uint8_t ret = fetch_kbd_byte(&kbdbyte, timeout);
if (ret != 2)
  {
  kbdbyte = 0;
  usb_debug_putchar('R');
  usb_debug_putchar('1');
  phex(ret);
  }
return kbdbyte;
}

/*****************************************************************************/
/* send_kbd_command_with_parm : sends a squence of 2 commands with ACK wait  */
/*****************************************************************************/
// A_14c6
uint8_t send_kbd_command_with_parm(uint8_t command, uint8_t cmdparm)
{
uint8_t i;
uint8_t rc;

if (keyboard_mode == 2)
  return 0;
// A_14da:
for (i = 3; i > 0; i--)                 /* 3 tries                           */
  {
  rc = send_kbd_command(command, 50);
  if (rc == 2)
    {
    // A_14e8
    rc = get_kbd_byte(50);
    if (rc == KBDM_ACK)  // if not an ACK
      {
      // A_14f2
      rc = send_kbd_command(cmdparm, 50);
      if (rc == 2)
        {
        // A_14fe
        rc = get_kbd_byte(50);
        if (rc == KBDM_ACK)
          // A_1508
          return 1;
        else
          {
          // A_150c:
          usb_debug_putchar('!');
          usb_debug_putchar('!');
          }
        }
      else
        {
        // A_1514
        usb_debug_putchar('W');
        usb_debug_putchar('2');
        }
      }
    else
      {
      // A_150c:
      usb_debug_putchar('!');
      usb_debug_putchar('!');
      }
    }
  else
    {
    // A_151c:
    usb_debug_putchar('W');
    usb_debug_putchar('1');
    }

  // A_1524:
  phex(rc);
  }
return 0;
}

/*****************************************************************************/
/* send_kbd_command_without_parm : sends a single-byte AT/PS2 command        */
/*****************************************************************************/
// A_1538
uint8_t send_kbd_command_without_parm(uint8_t command)
{
// R15 = command;
uint8_t i; // R16;
uint8_t rc; // R17;
if (keyboard_mode == 2)                 /* not for PC / XT keyboards         */
  return 0;

for (i = 3; i > 0; i--)
  {
  // A_154a:
  rc = send_kbd_command(command, 50);
  if (rc == 2)
    {
    // A_1556
    rc = get_kbd_byte(50);
    if (rc == KBDM_ACK)
      return 1;
    else
      {
      // A_1564
      usb_debug_putchar('!');
      usb_debug_putchar('!');
      }
    }
  else
    {
    // A_156c
    usb_debug_putchar('W');
    usb_debug_putchar('0');
    }
  // A_1574
  phex(rc);
  }

return 0;
}

/*****************************************************************************/
/* act_onboard_led : turns on the onboard LED                                */
/*****************************************************************************/
// A_1586
void act_onboard_led(uint16_t counter)
{
onboard_led_counter = counter;
OBLED_ON;
}

/*****************************************************************************/
/* act_onboard_led2 : turns on the onboard LED 2                             */
/*****************************************************************************/
#ifdef OBLED2_CONFIG
void act_onboard_led2(uint16_t counter)
{
onboard_led2_counter = counter;
OBLED2_ON;
}
#endif

/*****************************************************************************/
/* setup_timer0 :                                                            */
/*****************************************************************************/
// A_1592
void setup_timer0(void)
{
TIMSK0 |= (1 << OCIE0A);  // Enable Compare/Match A Interrupt
// (F_CPU / 64) / 1000 for 16MHz
OCR0A = 250;              // With Prescaler/64, this gives 1 tick per ms
TCCR0A = (1 << WGM01);    // Clear Timer on Compare Match mode
TCCR0B = 0;               // Stop Timer 0
                          // Run Timer 0 with Prescaler/64
TCCR0B |= ((1 << CS00) | (1 << CS01));
}

/*****************************************************************************/
/* TIMER0_COMPA_vect : Timer/Counter0 Compare Match A                        */
/*****************************************************************************/
// A_15ae
ISR(TIMER0_COMPA_vect)
{
// Ticks once per ms
static uint8_t volatile in_macro_tick = 0;  // 0x013c  recursion protection

timer0_counter++;
// A_15f6
if (onboard_led_counter)
  onboard_led_counter--;
else
  OBLED_OFF;                            /* turn off onboard LED              */

#ifdef OBLED2_CONFIG
if (onboard_led2_counter)
  onboard_led2_counter--;
else
  OBLED2_OFF;                           /* turn off onboard LED 2            */
#endif

// A_1610
if (in_macro_tick == 0)
  {
  in_macro_tick = 1;
  sei();
  macro_tick();
  in_macro_tick = 0;
  }
}

/*****************************************************************************/
/* processing.c : the processing part of Soarer's Converter                  */
/*****************************************************************************/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <avr/boot.h>
#include <util/atomic.h>
#include <util/delay.h>
#include <string.h>

#include "hwdefs.h"
#include "soarer.h"
#include "intkeys.h"
#include "salloc.h"
#include "usb_comm.h"
#include "print.h"
#include "processing.h"

/*****************************************************************************/
/* Global data                                                               */
/*****************************************************************************/

uint8_t cur_select_set = 1;   // 0x011e  current select set
uint8_t req_select_set = 1;  // 0x011f  requested select set
uint8_t *layerdata = 0;   // 0x016d/e big layer array
uint8_t allocated_layers = 0;  // 0x016f  # mem-allocated layers
uint8_t layer_cnt = 0;   // 0x0170
uint8_t **layer_map = 0; // 0x0171/2  layer map (pointers into EEPROM)?
uint8_t max_used_layer = 0;   // 0x0173  # layers in EEPROM?
uint8_t fn_curset = 0;   // 0x0174  bitmask of currently pressed FN1..8 keys
uint8_t *fn_keyset = 0;  // 0x0175/6 bitmask of FN modifiers for each pressed key
uint8_t modif_curset = 0;   // 0x0177 bitmask of currently pressed modifier keys
uint8_t *macro_data = 0;   // 0x0178/9 5-byte tuples
                           //          0 .....
                           //          1 .....
                           //          2 .....
                           //          3/4 ... EEPROM address of additional data
                           //                  1st 2 bytes there are counts (0..63)
                           //                  of 2-byte tuples
uint8_t allocated_macros = 0;   // 0x017a # allocated tuples in 0x0178/9
uint8_t macro_cnt = 0;     // 0x017b # filled tuples in 0x0178/9
uint8_t setup_done = 0;    // 0x017c flag whether setup completed
volatile uint8_t writing_eeprom_buffer = 0;   // 0x017d
uint8_t layerdefs = 0;     // 0x017e
uint8_t max_layer = 0;     // 0x017f
uint8_t total_macros = 0;  // 0x0180
uint8_t macro_onbreaks = 0;  // 0x0181 # onbreak macros (still tentative)
uint8_t proc_keyboard_codeset = 0;  // 0x0182
uint16_t proc_keyboard_id = 0;   // 0x0183
uint8_t key_queue_widx = 0;   // 0x0195
uint8_t key_queue_ridx = 0;   // 0x0196
uint8_t hidx_trans[256] = {0};   // 0x019a looks like current remap layer
uint8_t *modif_keyset = 0;  // 0x029a/b bitmask of modifiers for each translated key
volatile uint16_t eeprom_write_eeaddr = 0;  // 0x029c
volatile uint8_t eeprom_write_cnt = 0;   // 0x029e
volatile uint8_t eeprom_write_flag = 0;   // 0x029f
volatile uint8_t *eeprom_write_buffer = 0;  // 0x02a0
uint8_t pressed_hidxs[32] = {0}; // 0x02e3..0x0302 bitmask of currently pressed HIDXs
uint16_t key_queue[80] = {0};  // 0x030b .. 0x03aa

/*****************************************************************************/
/* get_layernum : retrieve the layer # for a key                             */
/*****************************************************************************/
// A_236c
// double checked
uint8_t get_layernum(uint8_t hidx)
{
uint8_t i;  // R25
uint8_t *p;
// works its way through an array of 2-byte items; if
// incoming parameter matches byte #0, byte #1 is returned

for (i = 0, p = layerdata; i < layer_cnt; i++, p += 2)
  if (p[0] == hidx)
    return p[1];
return 0;
}

/*****************************************************************************/
/* translate_hidx                                                            */
/*****************************************************************************/
// A_2398
// double checked
uint8_t translate_hidx(uint8_t keyid, uint8_t make)
{
uint8_t t_hidx;

if (max_used_layer)    // if layers used
  {
  uint8_t layer;
  // A_23ac
  if (make)
    fn_keyset[keyid] = fn_curset;  // remember current FN set with unmodified key
  // A_23c2
  // R2829 = keyid;
  // A_23c6
  layer = get_layernum(fn_keyset[keyid]);
  if (layer && (layer <= max_used_layer))
    {
    // A_23e4
    uint8_t lt_hidx = layer_map[layer - 1][keyid];
    if (lt_hidx)
      t_hidx = lt_hidx;
    else
      // A_2410
      t_hidx = hidx_trans[keyid];
    }
  else
    // A_2418
    t_hidx = hidx_trans[keyid];
  }
else
  // A_2418
  t_hidx = hidx_trans[keyid];

// A_2422
if (IS_FN_KEY(t_hidx))  // if FN1..FN8
  {
  // A_2432
  if (make)
    // A_243e
    fn_curset |= 1 << (t_hidx & 0x07);
  else
    // A_2450
    fn_curset &= ~(1 << (t_hidx & 0x07));
  // A_2466
  return 0;
  }

// A_2468
return t_hidx;
}

/*****************************************************************************/
/* reset_layers : resets layer data                                          */
/*****************************************************************************/
// A_2474
// Double checked
void reset_layers(void)
{
allocated_layers = 0;
layer_cnt = 0;
max_used_layer = 0;
layerdata = 0;
layer_map = 0;
fn_keyset = 0;
}

/*****************************************************************************/
/* reset_layer_trans : clears memory and resets buffer                       */
/*****************************************************************************/
// A_249a
// Double checked
void reset_layer_trans(void)
{
uint8_t i;
reset_layers();                         /* reset all data and pointers       */
i = 0;                                  /* reset remap to 0..ff              */
do
  {
  i--;
  hidx_trans[i] = i;
  } while (i);
}

/*****************************************************************************/
/* setup_layer :                                                             */
/*****************************************************************************/
// A_24b0
// double checked
void setup_layer(uint8_t keyid, uint8_t layer)
{
if (layer_cnt < allocated_layers)
  {
  uint8_t *p = layerdata + (layer_cnt * 2);
  // A_24be
  p[0] = keyid;
  p[1] = layer;
  layer_cnt++;
  }
// A_24dc
}

/*****************************************************************************/
/* reset_fnset :                                                             */
/*****************************************************************************/
// A_24de
// Double checked
void reset_fnset(void)
{
fn_curset = 0;
if (fn_keyset)
  memset(fn_keyset, 0, 256);
}

/*****************************************************************************/
/* read_remap : sets up a layer's remap table from EEPROM                    */
/*****************************************************************************/
// A_2506
// Double checked
void read_remap(uint16_t eeadr, uint8_t cnt, uint8_t layer)
{
if (layer <= max_used_layer)
  {
  uint8_t i;
  uint8_t *bufptr = (layer) ? layer_map[layer - 1] : hidx_trans;
  for (i = 0; i < cnt; i++, eeadr += 2)
    bufptr[eeprom_read_byte((const uint8_t *)eeadr)] =
        eeprom_read_byte((const uint8_t *)(eeadr + 1));
  }
}

/*****************************************************************************/
/* alloc_layers                                                              */
/*****************************************************************************/
// A_259e
// Not 100% sure yet, but fairly confident
// (anything starting at A_2600 looks QUITE different to original)
uint8_t alloc_layers(uint8_t layers, uint8_t max_used)
{
uint8_t i;
uint8_t *layerptr;

if (!max_used)
  return 1;
// A_25b4
fn_keyset = (uint8_t*)memalloc(256);  // some malloc
reset_fnset();  // reset array allocated above

// A_25c4
// allocate one big array
layerdata = (uint8_t*)memalloc(2 * layers +
                               (256 + sizeof(uint8_t*)) * max_used);
if (!layerdata)
  return 0;
// A_25f8
allocated_layers = layers;
max_used_layer = max_used;

// A_2600
layer_map = (uint8_t**)(layerdata + (layers * 2));
// A_2612
layerptr = (uint8_t *)layer_map + 2 * max_used;  // pointer after end?
for (i = 0; i < max_used; i++)
  {
  // A_2624
  layer_map[i] = layerptr;
  // A_2634
  memset(layerptr, 0, 256);
  layerptr += 256;
  }

/* The following layout is created:

layerdata:

|  (2*layers)   | (2*max_used) | (256 * max_used) |      | (256 * max_used)   |
| uninitialized |   pointers   |   area 1         | ...  | area (max_used - 1)|
| ............. | pp pp pp pp  | 0000000000000000 |      | 000000000000000000 |
                 ^ |             ^                         ^
                 | +-------------+------------------...----+
layer_map -------+

The start of layerdata is filled with a set of (FN key HIDX, layer#) tuples in
setup_layer(). */

return 1;
}

/*****************************************************************************/
/* set_setup_done                                                            */
/*****************************************************************************/
// A_2662
void set_setup_done(void)
{
setup_done = 1;
}

/*****************************************************************************/
/* reset_setup_done                                                          */
/*****************************************************************************/
// A_266a
void reset_setup_done(void)
{
setup_done = 0;
}

/*****************************************************************************/
/* find_macro : looks up a macro for a key and returns its address           */
/*****************************************************************************/
// A_2670
// double checked
uint16_t find_macro(uint8_t hidx, uint8_t modif_set)
{
uint8_t *pmacro;
uint8_t i;
for (i = 0, pmacro = macro_data; i < macro_cnt; i++, pmacro += 5)
  {
  // A_2682
  if (*pmacro == hidx)
    {
    // A_2688
    // Byte 1 are the modifiers that have to be set
    // Byte 2 is -"- plus modifiers that have to be clear
    //        upper nibble is treated differently
    //   ... or so. Not completely clear yet.
    uint8_t b1 = pmacro[1];
    uint8_t b2 = pmacro[2];
    // get modifiers that should be set and are set
    uint8_t cmset = b1 & ~b2 & modif_set;
    cmset >>= 4;    // overlay right and left modifier keys
    modif_set |= cmset;  // Not sure whether this is good ... but definitely so
    if (!((b1 ^ modif_set) & b2))
      return *(uint16_t*)(pmacro + 3);
    }
  }
// A_26ae
return 0;
}

/*****************************************************************************/
/* reset_macro_data                                                          */
/*****************************************************************************/
// A_26b6
// double checked
void reset_macro_data(void)
{
setup_done = 0;
allocated_macros = 0;
macro_cnt = 0;
#if 0  // totally useless, only WASTES time
if (macro_data)
#endif
  macro_data = 0;
}

/*****************************************************************************/
/* jmp_reset_macro_data : just a little dispatcher (wtf?)                    */
/*****************************************************************************/
// A_26d8
// double checked
void jmp_reset_macro_data(void)
{
// presumably, something's been commented out in the original code.
reset_macro_data();
}

/*****************************************************************************/
/* reset_modifset                                                            */
/*****************************************************************************/
// A_26dc
// double checked
void reset_modifset(void)
{
modif_curset = 0;
if (modif_keyset)
  memset(modif_keyset, 0, 256);
}

/*****************************************************************************/
/* setup_macros                                                              */
/*****************************************************************************/
// A_2704
// double checked
void setup_macros(uint16_t eeaddr, uint8_t macros)
{
uint8_t i, b1, b2;
uint8_t *p = macro_data + (macro_cnt * 5);

// A_272c
for (i = 0; i < macros; i++, p += 5)
  {
  // A_2734
  if (macro_cnt == allocated_macros /*R9*/)
    return;
  // A_2746
  p[0] = eeprom_read_byte((const uint8_t *)eeaddr);
  // A_275c
  p[1] = eeprom_read_byte((const uint8_t *)(eeaddr + 1));
  // A_2766
  p[2] = eeprom_read_byte((const uint8_t *)(eeaddr + 2));
  // A_2776
  *(uint16_t*)(p + 3) = eeaddr + 3;
  b1 = eeprom_read_byte((const uint8_t *)(eeaddr + 3)) & 0x3f;
  // A_278a
  b2 = eeprom_read_byte((const uint8_t *)(eeaddr + 4)) & 0x3f;
  // A_279e
  // written this way to prevent avrgcc using 16bit calculations
  b1 += b2;
  b1 += b1;
  b1 += 5;  // macro header
  eeaddr += b1;  // skip additional data
  // A_27a6
  macro_cnt++;
  // A_27ae
  }
}

/*****************************************************************************/
/* alloc_macros : allocate space for macros on heap                          */
/*****************************************************************************/
// A_27ce
// double checked
uint8_t alloc_macros(uint8_t count, uint8_t allocbase)
{
if (allocbase)
  {
  modif_keyset = (uint8_t*)memalloc(256);
  reset_modifset();
  }
// A_27e8
macro_data = (uint8_t*)memalloc(count * 5);
if (!macro_data)
  return 0;
// A_2804
allocated_macros = count;
macro_cnt = 0;
return 1;
}

/*****************************************************************************/
/* exec_macro                                                                */
/*****************************************************************************/
// A_2812
// fairly sure
void exec_macro(uint16_t eeaddr, uint8_t modif_set, uint8_t make)
{
uint8_t i;
uint8_t b1, b2, restoremeta;

b1 = eeprom_read_byte((const uint8_t*)eeaddr++);
// could be time-optimized, since b2 is only needed if !make
b2 = eeprom_read_byte((const uint8_t*)eeaddr++);
// A_283c
b1 &= 0x3f;
restoremeta = b2 & 0x80;
// R24 = R15 & 0x3f;
if (make)           // if key is pressed, 
  i = b1;           // use the make macro part
else                // otherwise
  {
  // A_2848
  i = b2 & 0x3f;    // use the onbreak macro part
  b1 += b1;         // so skip behind the make macro part
  eeaddr += b1;
  if (restoremeta)  // if norestoremeta is NOT given
    // A_285c
    queue_key(MCMD_PUSH_META | MCMD_ASSIGN_META, modif_set);
  }
// A_2864
for (; i != 0; i--) // queue macro commands
  {
  b1 = eeprom_read_byte((const uint8_t*)eeaddr++);
  b2 = eeprom_read_byte((const uint8_t*)eeaddr++);
  queue_key(b1, b2);
  }
// A_2882  if break and norestoremeta is NOT given
if (!make && restoremeta)
  queue_key(MCMD_POP_META, 0);
}

/*****************************************************************************/
/* find_exec_macro                                                           */
/*****************************************************************************/
// A_28a4
// double checked
uint8_t find_exec_macro(uint8_t keyid, uint8_t make)
{
uint8_t modif_set = modif_curset;
uint8_t rc;
uint16_t eeaddr;

if (modif_keyset)
  {
  // A_28be
  if (make)
    // A_28c2
    modif_keyset[keyid] = modif_set;
  // An "else" would be appropriate. Not in original, but here...
  else
  // A_28c8
    modif_set = modif_keyset[keyid];
  }

// A_28d6
if (setup_done &&
  // A_28de
    (eeaddr = find_macro(keyid, modif_set)) != 0)
  {
  // A_28e8
  exec_macro(eeaddr, modif_set, make);
  rc = 1;
  }
else
  // A_28f2
  rc = 0;

// A_28f4
if (IS_MODIFIER_KEY(keyid))
  {
  // A_2904
  if (make)
    // A_2910
    modif_curset |= (1 << (keyid & 0x07));
  else
    // A_2922
    modif_curset &= ~(1 << (keyid & 0x07));
  }

return rc;
}

/*****************************************************************************/
/* eeprom_write_ready : returns whether NOT writing buffer to EEPROM ATM     */
/*****************************************************************************/
// A_2942
uint8_t eeprom_write_ready(void)
{
return !writing_eeprom_buffer;
}

/*****************************************************************************/
/* write_eeprom_buffer : triggers writing buffer to EEPROM, interrupt-based  */
/*****************************************************************************/
// A_2952
// double checked
int8_t write_eeprom_buffer(uint8_t *wbuf, uint16_t eeaddr, uint8_t cnt)
{
eeprom_write_flag = 1;
if (writing_eeprom_buffer)
  return -1;
if (EECR & (1 << EEPE))
  return -2;

eeprom_write_eeaddr = eeaddr;
eeprom_write_buffer = wbuf;
eeprom_write_cnt = cnt;
writing_eeprom_buffer = 1;
EECR |= (1 << EERIE);
return 0;
}

/*****************************************************************************/
/* EE_READY_vect : EEPROM ready interrupt                                    */
/*****************************************************************************/
// A_298c
// double checked (except for register)
ISR(EE_READY_vect)
{
uint16_t weea;
if (!eeprom_write_cnt)
  {
  // A_2a00
  EECR &= ~(1 << EERIE);
  writing_eeprom_buffer = 0;
  return;
  }

// A_29b6
if (eeprom_write_flag)
  {
  // A_29be
  // skip all EEPROM bytes equal to the write buffer contents
  while (eeprom_read_byte((const uint8_t *)eeprom_write_eeaddr) ==
         *eeprom_write_buffer)
    {
    // A_29ca
    eeprom_write_buffer++;
    eeprom_write_eeaddr++;
    if (!--eeprom_write_cnt)
      {
      // A_2a00
      EECR &= ~(1 << EERIE);
      writing_eeprom_buffer = 0;
      return;
      }
    // A_2a08
    }
  }

// A_2a22
// use local var to prohibit reload for EEARH / EEARL loading from volatile
weea = eeprom_write_eeaddr;
EEARH = (weea >> 8);
EEARL = (weea & 0xff);
EEDR = *eeprom_write_buffer;
EECR |= (1 << EEMPE);
EECR |= (1 << EEPE);
eeprom_write_cnt--;
eeprom_write_buffer++;
eeprom_write_eeaddr++;
}

/*****************************************************************************/
/* _BL_ADDR : get the boot loader indirect call address                      */
/*****************************************************************************/

// should work for all devices with 16 bit PC
#define	_BL_ADDR(blsz_w) ( (uint16_t)((FLASHEND >> 1) + 1) - (blsz_w))

/*****************************************************************************/
/* jmp_bootloader : guess what                                               */
/*****************************************************************************/
// A_2a8e
// double checked
void jmp_bootloader(void)
{
uint16_t bootsz;
typedef void (*tBootLdr)(void)  __attribute__((noreturn));
uint8_t fbits = boot_lock_fuse_bits_get(GET_EXTENDED_FUSE_BITS);
if (fbits & ~FUSE_HWBE)  // if HWBE unprogrammed
  return;              // don't even TRY to go to boot loader :-)

// slightly adapted from http://www.pjrc.com/teensy/jump_to_bootloader.html
cli();
UDCON = (1 << DETACH);
USBCON = (1 << FRZCLK);
UCSR1B = 0;

_delay_ms(5);
#if defined(__AVR_AT90USB162__)                // Teensy 1.0
EIMSK = 0; PCICR = 0; SPCR = 0; ACSR = 0; EECR = 0;
TIMSK0 = 0; TIMSK1 = 0; UCSR1B = 0;
DDRB = 0; DDRC = 0; DDRD = 0;
PORTB = 0; PORTC = 0; PORTD = 0;
#elif defined(__AVR_ATmega32U4__)              // Teensy 2.0 etc.
EIMSK = 0; PCICR = 0; SPCR = 0; ACSR = 0; EECR = 0; ADCSRA = 0;
TIMSK0 = 0; TIMSK1 = 0; TIMSK3 = 0; TIMSK4 = 0; UCSR1B = 0; TWCR = 0;
DDRB = 0; DDRC = 0; DDRD = 0; DDRE = 0; DDRF = 0;
PORTB = 0; PORTC = 0; PORTD = 0; PORTE = 0; PORTF = 0;
#elif defined(__AVR_AT90USB646__)              // Teensy++ 1.0
EIMSK = 0; PCICR = 0; SPCR = 0; ACSR = 0; EECR = 0; ADCSRA = 0;
TIMSK0 = 0; TIMSK1 = 0; TIMSK2 = 0; TIMSK3 = 0; UCSR1B = 0; TWCR = 0;
DDRA = 0; DDRB = 0; DDRC = 0; DDRD = 0; DDRE = 0; DDRF = 0;
PORTA = 0; PORTB = 0; PORTC = 0; PORTD = 0; PORTE = 0; PORTF = 0;
#elif defined(__AVR_AT90USB1286__)             // Teensy++ 2.0
EIMSK = 0; PCICR = 0; SPCR = 0; ACSR = 0; EECR = 0; ADCSRA = 0;
TIMSK0 = 0; TIMSK1 = 0; TIMSK2 = 0; TIMSK3 = 0; UCSR1B = 0; TWCR = 0;
DDRA = 0; DDRB = 0; DDRC = 0; DDRD = 0; DDRE = 0; DDRF = 0;
PORTA = 0; PORTB = 0; PORTC = 0; PORTD = 0; PORTE = 0; PORTF = 0;
#endif

// get Boot Size fuse bits
fbits = boot_lock_fuse_bits_get(GET_HIGH_FUSE_BITS);
fbits = ((fbits & (~FUSE_BOOTSZ1 | ~FUSE_BOOTSZ0)) >> 1) ^ 0x03;
// calculate boot loader size in WORDS
for (bootsz = 256; fbits; fbits--)
  bootsz *= 2;
// Off we go...
((tBootLdr)_BL_ADDR(bootsz))();
}

/*****************************************************************************/
/* setup_proc_kbd :                                                          */
/*****************************************************************************/
// A_2b22
// double checked
void setup_proc_kbd(uint8_t keyboard_codeset, uint16_t keyboard_id)
{
proc_keyboard_codeset = keyboard_codeset;
proc_keyboard_id = keyboard_id;
}

/*****************************************************************************/
/* process_select                                                            */
/*****************************************************************************/
// A_2b30
// double checked
void process_select(uint8_t hidx)
{
hidx -= KEY_SELECT_0;  // 0xd8 .. 0xdf (Select Reset .. Select 7 Toggle)
if (hidx)
  // A_2b36
  req_select_set ^= (1 << hidx);
else  
  // A_2b50
  req_select_set = 1;
}

/*****************************************************************************/
/* check_eeprom_header : check for 'SC' at the start of the EEPROM data      */
/*****************************************************************************/
// A_2b58
// double checked
uint8_t check_eeprom_header(void)
{
// Writing it as
// return (eeprom_read_byte((const uint8_t *)0) == 'S' &&
//         eeprom_read_byte((const uint8_t *)1) == 'C');
// (functionally equivalent) gives inefficient avr-gcc assembler output
if (eeprom_read_byte((const uint8_t *)0) == 'S' &&
    eeprom_read_byte((const uint8_t *)1) == 'C')
  return 1;
return 0;
}

/*****************************************************************************/
/* get_forced_keyboard_type : returns forced keyboard type from EEPROM       */
/*****************************************************************************/
// A_2b7e
// double checked
uint8_t get_forced_keyboard_type(void)
{
uint16_t eecnt;

if (!check_eeprom_header())
  return 0;
eecnt = eeprom_read_word((const uint16_t *)2);
if (!eecnt ||
     eecnt >= (E2END - 7) ||
    eeprom_read_byte((const uint8_t *)4) != 1)
  return 0;
return eeprom_read_byte((const uint8_t *)6);
}

/*****************************************************************************/
/* count_macro_onbreaks                                                      */
/*****************************************************************************/
// A_2baa
// looks like a sanity check over the EEPROM that counts all
// tuples which have a count in the 5th byte
// double checked
uint8_t count_macro_onbreaks(uint16_t eeaddr, uint8_t macros, uint8_t bcnt)
{
uint8_t i, b1, b2;
uint8_t addd;

for (i = 0; i < macros; i++)
  {
  // A_2bbe
  if (bcnt < 5)                          /* bad end count                     */
    return 0;

  b1 = eeprom_read_byte((const uint8_t *)eeaddr + 3) & 0x3f;
  b2 = eeprom_read_byte((const uint8_t *)eeaddr + 4) & 0x3f;
  if (b2)  // onbreak?
    // A_2bd6
    macro_onbreaks++;
  // A_2be0
  // written this way instead of 
  //   addd = ((b1 + b2) * 2) + 5;
  // to prevent avt-gcc using 16 bit arithmetic
  addd = b1 + b2;
  addd += addd;
  addd += 5;
  if (bcnt < addd)
    return 0;
  // A_2bf0
  eeaddr += addd;
  bcnt -= addd;
  // A_2bfc
  }

// A_2c02
return 1;
}

/*****************************************************************************/
/* init_eeprom_header                                                        */
/*****************************************************************************/
// A_2c16
// double checked
void init_eeprom_header(void)
{
eeprom_write_byte((uint8_t *)3, 0);
eeprom_write_byte((uint8_t *)2, 0);
eeprom_write_byte((uint8_t *)1, 'C');
eeprom_write_byte((uint8_t *)0, 'S');
}

/*****************************************************************************/
/* setup_eeprom_header                                                       */
/*****************************************************************************/
// A_2c36
// double checked
void setup_eeprom_header(void)
{
if (!check_eeprom_header())
  init_eeprom_header();
}

/*****************************************************************************/
/* load_from_ee : tests or loads config from EEPROM                          */
/*****************************************************************************/
// A_2c40
uint8_t load_from_ee(uint16_t eeaddr, uint8_t cnt, uint8_t do_setup)
{
uint8_t b2;  // 2nd byte 
uint8_t b2type;
uint8_t b2select;

eeaddr++;  // skip 1st byte (already in cnt)
b2 = eeprom_read_byte((const uint8_t *)eeaddr);
b2type = b2 & 0x07;
if (!do_setup)
  {
  // A_2c68
  switch(b2type)
    {
    case 0 :
      print_P(PSTR("layers "));
      break;
    case 1 :
      print_P(PSTR("remaps "));
      break;
    case 2 :
      print_P(PSTR("macros "));
      break;
    }
  }
// A_2c88
// R2021 = b2;
// R1819 = req_select_set;
// R2425 = (b2 & 0x38) >> 3;
// A_2ca2
// R18 = (req_select_set >> ((b2 & 0x38) >> 3));
// A_2cac
// written this way to prevent avr-gcc using 16bit arithmetic
b2select = b2 & 0x38;
b2select >>= 3;
if (!((req_select_set >> b2select) & 1))
  {
  // A_2cb0
  if (!do_setup)
    // A_2cb6
    print_P(PSTR("!select "));
  return 1;
  }
// A_2cbc
eeaddr++;
cnt -= 2;
if (b2 & 0x40)  // bit 6 = followed by codeset bitset
  {
  // A_2cc8
  uint8_t codesets = eeprom_read_byte((const uint8_t *)eeaddr);
  codesets >>= (proc_keyboard_codeset - 1);
  if (!(codesets & 1))
    {
    // A_2ce6
    if (!do_setup)
      print_P(PSTR("!set "));
    return 1;  // not sure whether this is correct... it's an error...
    }
  // A_2cf2
  eeaddr++;
  cnt--;
  }

// A_2cfa
if (b2 & 0x80)  // bit 7 = followed by keyboard_id word
  {
  // A_2cfe
  if (eeprom_read_word((const uint16_t *)eeaddr) != proc_keyboard_id)
    {
    // A_2d10
    if (!do_setup)
      print_P(PSTR("!id "));
    return 1;  // not sure whether this is correct... it's an error...
    }
  // A_2d1e
  eeaddr += 2;
  cnt -= 2;
  }

// A_2d24
if (b2type == 1)  // remaps
  {
  // A_2da0:
  uint8_t layer = eeprom_read_byte((const uint8_t *)eeaddr);
  uint8_t rcnt = eeprom_read_byte((const uint8_t *)eeaddr + 1);
  cnt -= 2;
  if (rcnt * 2 != cnt)
    {
    // A_2dc6
    print_P(PSTR("error "));
    return 0;
    }
  // A_2dcc
  if (do_setup)
    // A_2dd0
    read_remap(eeaddr + 2, rcnt, layer);
  return 1;
  }
// A_2d2a
else if (b2type == 0)  // layers
  {
  // A_2d36:
  uint8_t lcnt = eeprom_read_byte((const uint8_t*)eeaddr);
  uint8_t i;
  cnt--;
  if (lcnt * 2 != cnt)
    {
    // A_2d52
    print_P(PSTR("error "));
    return 0;
    }
  // A_2d58
  if (!do_setup)
    // A_2d5c
    layerdefs += lcnt;
  // A_2d66
  eeaddr++;
  for (i = 0; i < lcnt; i++)
    {
    // A_2d6e
    uint8_t keyid = eeprom_read_byte((const uint8_t *)eeaddr);  // keyid? Sure?
    uint8_t layer = eeprom_read_byte((const uint8_t *)eeaddr + 1);
    if (do_setup)
      // A_2d80
      setup_layer(keyid, layer);
    else
      {
      // A_2d86
      if (max_layer < layer)
        max_layer = layer;
      }
    // A_2d92
    eeaddr += 2;
    // A_2d94
    }
  return 1;
  }
else if (b2type == 2)  // macros
  {
  // A_2dda:
  uint8_t macros = eeprom_read_byte((const uint8_t *)eeaddr++);
  if (do_setup)
    {
    // A_2dea
    setup_macros(eeaddr, macros);
    return 1;
    }
  // A_2df2
  if (!count_macro_onbreaks(eeaddr, macros, cnt))
    {
    // A_2dfe
    print_P(PSTR("error "));
    return 0;
    }
  // A_2e08
  total_macros += macros;
  return 1;
  }
else
  return 0;
}

/*****************************************************************************/
/* setup_processing                                                          */
/*****************************************************************************/
// A_2e28
uint8_t setup_processing(void)
{
uint16_t eeaddr;                        /* EEPROM start address to read from */
int16_t eecnt;                          /* (remaining) EEPROM data bytes     */
uint8_t scnt;

jmp_reset_macro_data();
reset_layer_trans();
memreset();
layerdefs = 0;
max_layer = 0;
total_macros = 0;
macro_onbreaks = 0;
if (!check_eeprom_header())
  return 0;

// A_2e54
eecnt = eeprom_read_word((const uint16_t *)2) - 4;
print_P(PSTR("\n\nremaining: "));
phex16(eecnt);
usb_debug_putchar('\n');

// A_2e7a
if (eecnt < 1 || eecnt > E2END - 9)  // 8 bytes for header, 2 for ...?
  return 0;
// If a new version can read old EEPROM contents, this needs a rewrite
if (eeprom_read_byte((const uint8_t *)4) != SETTINGS_VER ||
    eeprom_read_byte((const uint8_t *)5) > SETTINGS_SUBVER)
  return 0;

for (eeaddr = 8; eecnt > 0; eeaddr += scnt, eecnt -= scnt)
  {
  scnt = eeprom_read_byte((const uint8_t *)eeaddr);
  phex(scnt);
  usb_debug_putchar('@');
  phex16(eeaddr);
  usb_debug_putchar(' ');
  if (scnt < 5)
    {
    print_P(PSTR("len<5\n"));
    return 0;
    }
  // A_2ebe
  if (!load_from_ee(eeaddr, scnt, 0))
    {
    print_P(PSTR("!apply\n"));
    return 0;
    }
  usb_debug_putchar('\n');
  }
// A_2ee6
print_P(PSTR("layerdefs: "));
phex(layerdefs);
print_P(PSTR("\nmax_layer: "));
phex(max_layer);
print_P(PSTR("\ntotal_macros: "));
phex(total_macros);
usb_debug_putchar('\n');

if (!alloc_layers(layerdefs, max_layer))
  {
  print_P(PSTR("alloc failed.\n"));
  return 0;
  }
if (!alloc_macros(total_macros, macro_onbreaks))
  {
  reset_layers();
  memreset();
  print_P(PSTR("alloc failed.\n"));
  return 0;
  }
// A_2f46
print_P(PSTR("alloc ok.\n"));
eecnt = eeprom_read_word((const uint16_t *)2) - 4;
for (eeaddr = 8; eecnt > 0; eeaddr += scnt, eecnt -= scnt)
  {
  // A_2f5e
  scnt = eeprom_read_byte((const uint8_t *)eeaddr);
  if (!load_from_ee(eeaddr, scnt, 1))
    return 0;
  }
// A_2f82
set_setup_done();
return 1;
}

// This MIGHT be the start of a new module. Not sure.

/*****************************************************************************/
/* rawhid_comm : called from main loop                                       */
/*****************************************************************************/
// A_2f98
void rawhid_comm(void)
{
static uint32_t tcnow_start = 0;  // 0x0185 buffered timer0 counter
uint32_t tcnow;
enum           // CommStates:
  {
  csIdle = 0,  // Idle
  csWRdy,      // wait for EEPROM to get ready
  csWEEP,      // write buffer to EEPROM
  csCEEP,      // compare EEPROM to buffer
  csReset,     // Reset
  csREEP,      // read data from EEPROM
  csBoot,      // Jump to Boot Loader
  };
enum           // Commands coming in Idle state
  {
  icInfo = 1,  // Get Information
  icWEEP,      // start writing EEPROM data
  icREEP,      // start reading EEPROM data
  icBoot,      // Jump to boot loader
  };
static uint8_t rawhid_commstate = csIdle;  // 0x0189
static uint16_t xfer_len = 0;      // 0x018a
static uint16_t xfer_eeaddr = 0;   // 0x018c an EEPROM address
static uint16_t weep_word = 0;     // 0x018e data word to write into EEPROM
static uint32_t rhidc_start = 0;   // 0x0190
static uint8_t  xfer_buf_len = 0;  // 0x0194
static struct
  {
  uint8_t sendcmd;       // 0x02a2 command for rawhid sending
  uint8_t rcvbuf[64];    // 0x02a3..0x02e2 buffer for rawhid send/receive
  } comm = {0};
uint8_t cur_commstate = rawhid_commstate; // R12
uint16_t eecnt;

switch (cur_commstate)
  {
  case csIdle :
    // A_2fe0:
    // fetch a buffer
    if (usb_rawhid_recv(comm.rcvbuf, 0) <= 0)
      goto checkselect;
    switch (comm.rcvbuf[0])  // OK, which kind of command is this?
      {
      case icInfo :          // get information ?
        // A_3012
        {
        static uint8_t PROGMEM info_templ[] =  // A_060d
          {
          0x03,
          PROTOCOL_VER, PROTOCOL_SUBVER,   // protocol version
          0x01,
          CODE_VER, CODE_SUBVER,           // code version (v1.12)
          0x02,
          SETTINGS_VER, SETTINGS_SUBVER,   // max settings version (v1.01)
          0x04,
          0x00, 0x00,       // filled with current settings version (v1.01)
          0x05,
          LSB(RAMEND + 1), MSB(RAMEND + 1), // SRAM size
          0x07,
          0x00, 0x00,       // filled with # free memory bytes
          0x06,
          LSB(E2END + 1), MSB(E2END + 1), // EEPROM size
          0x08,
          0x00, 0x00,       // filled with free EEPROM memory
          0x00              // EOB
          };
        const uint8_t *s;
        uint8_t *t;
        for (s = info_templ, t = comm.rcvbuf; s < info_templ + sizeof(info_templ); s++, t++)
          *t = pgm_read_byte(s);
        // A_3028
        eecnt = eeprom_read_word((const uint16_t *)2);
        if (eecnt)
          {
          // A_3034
          comm.rcvbuf[10] = eeprom_read_byte((const uint8_t *)4);
          comm.rcvbuf[11] = eeprom_read_byte((const uint8_t *)5);
          }
        // A_304a
        *(int16_t *)(comm.rcvbuf + 22) = (E2END - 3) - eecnt;
        *(int16_t *)(comm.rcvbuf + 16) = memfree();
        // A_30c2
        comm.sendcmd = 2;
        usb_rawhid_send(&comm.sendcmd, 0);
        }
        goto checkselect;

      case icWEEP :  // this one resets the EEPROM contents and sets counter
        // A_306e
        xfer_len = ((uint16_t)(comm.rcvbuf[2]) << 8) | comm.rcvbuf[1];
        if (xfer_len < (E2END - 8))
          {
          // A_308c
          xfer_eeaddr = 4;
          weep_word = 0;  // reset EEPROM contents
          if (!write_eeprom_buffer((uint8_t*)&weep_word, 2, 2))
            {
            // A_30b0
            comm.sendcmd = 2;
            usb_rawhid_send(&comm.sendcmd, 0);
            reset_setup_done();
            // A_317c
            rawhid_commstate = csWRdy;
            break;
            }
          }
        // A_30c0
        comm.sendcmd = 1;
        usb_rawhid_send(&comm.sendcmd, 0);
        goto checkselect;
      case icREEP :  // start sending EEPROM contents
        // A_30d0:
        xfer_eeaddr = 2;
        // Why not read word?
        eeprom_read_block(&xfer_len, (const void *)2, 2);
        if (xfer_len < (E2END - 8))
          {
          // A_30fa
          xfer_eeaddr += 2;
          *(uint16_t *)comm.rcvbuf = xfer_len;
          comm.sendcmd = 2;
          usb_rawhid_send(&comm.sendcmd, 0);
          // A_32ee
          rawhid_commstate = csREEP;
          }
        else
          {
          // A_30c0
          comm.sendcmd = 1;
          usb_rawhid_send(&comm.sendcmd, 0);
          goto checkselect;
          }
        break;
      case icBoot :  // jump to boot loader
        // A_3124
        ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
          rhidc_start = timer0_counter;
        // A_314a
        comm.sendcmd = 2;
        usb_rawhid_send(&comm.sendcmd, 0);
        // A_332a
        rawhid_commstate = csBoot;
        break;
      default :
      checkselect:
        // A_315a
        if (req_select_set != cur_select_set)
          {
          // A_3168
          setup_processing();
          cur_select_set = req_select_set;
          }
        // goto A_3330;
        rawhid_commstate = csIdle;
        break;
      }
    break;
  case csWRdy :   // wait until EEPROM is ready for writing
    // A_3174
    if (eeprom_write_ready())
      {
      // A_3218
      comm.sendcmd = 3;
      usb_rawhid_send(&comm.sendcmd, 0);
      rawhid_commstate = csWEEP;
      }
    else
      // A_317c
      rawhid_commstate = csWRdy;
    break;
  case csWEEP :  // receive EEPROM buffer
    // A_3180
    if (usb_rawhid_recv(comm.rcvbuf, 0) <= 0)
      {
      // A_3226
      rawhid_commstate = csWEEP;
      break;
      }
    // A_318e
    if (comm.rcvbuf[0] == 0x82 &&
        // A_3198
        xfer_len >= comm.rcvbuf[1] &&
        // A_31b0
        !write_eeprom_buffer(comm.rcvbuf + 4, xfer_eeaddr, comm.rcvbuf[1]))
      {
      // A_31c6
      xfer_buf_len = comm.rcvbuf[1];
      comm.sendcmd = 2;
      usb_rawhid_send(&comm.sendcmd, 0);
      // A_31e0
      rawhid_commstate = csCEEP;
      }
    else
      {
      // A_3246
      comm.sendcmd = 1;
      usb_rawhid_send(&comm.sendcmd, 0);
      rawhid_commstate = csIdle;
      }
    break;
  case csCEEP : // compare EEPROM to buffer
    // A_31da
    if (!eeprom_write_ready())
      {
      rawhid_commstate = csCEEP;
      break;
      }
    // A_31e4
    // R2829 = xfer_eeaddr;
    // R13 = xfer_buf_len;
    {
    uint8_t *bp = comm.rcvbuf + 4;  // R14/15
    uint16_t eeaddr;
    // A_31f8
    for (eeaddr = xfer_eeaddr; eeaddr - xfer_eeaddr < xfer_buf_len; eeaddr++)
      {
      if (eeprom_read_byte((const uint8_t*)eeaddr) != *bp++)
        {
        // A_3246
        comm.sendcmd = 1;
        usb_rawhid_send(&comm.sendcmd, 0);
        rawhid_commstate = csIdle;
        break;
        }
      }
    }
    // A_3392
    xfer_len -= xfer_buf_len;
    xfer_eeaddr += xfer_buf_len;
    if (xfer_len)
      {
      // A_3218
      comm.sendcmd = 3;
      usb_rawhid_send(&comm.sendcmd, 0);
      // A_3226
      rawhid_commstate = csWEEP;
      }
    else
      {
      // A_322a
      weep_word = xfer_eeaddr - 4;
      if (!write_eeprom_buffer((uint8_t*)&weep_word, 2, 2))
        rawhid_commstate = csReset;
      else
        {
        // A_3246
        comm.sendcmd = 1;
        usb_rawhid_send(&comm.sendcmd, 0);
        rawhid_commstate = csIdle;
        }
      }
    break;
  case csReset :
    // A_3256:  // rawhid_commstate == 4
    if (!eeprom_write_ready())
      {
      // A_325c
      rawhid_commstate = csReset;
      break;
      }
    // A_3260
    comm.sendcmd = 4;
    usb_rawhid_send(&comm.sendcmd, 0);
    setup_processing();
    // A_3330
    rawhid_commstate = csIdle;
    break;
  case csREEP :  // this one sends a block of EEPROM data
    // A_3272
    if (usb_rawhid_recv(comm.rcvbuf, 0) <= 0)
      {
      // A_32ee
      rawhid_commstate = csREEP;
      break;
      }
    // A_3280
    if (comm.rcvbuf[0] == 3)
      {
      // A_3294
      uint8_t icnt = (xfer_len > sizeof(comm.rcvbuf)) ?
          sizeof(comm.rcvbuf) : (uint8_t)xfer_len;
      if (icnt)
        {
        // A_32ac
        eeprom_read_block(comm.rcvbuf, (const void *)xfer_eeaddr, icnt);
        usb_rawhid_send(comm.rcvbuf, 0);
        // A_32c6
        xfer_len -= icnt;
        xfer_eeaddr += icnt;
        }
      // A_32ee
      rawhid_commstate = csREEP;
      }
    else if (comm.rcvbuf[0] == 4 ||
             comm.rcvbuf[0] == 1)
      rawhid_commstate = csIdle;
    else
      // A_32ee
      rawhid_commstate = csREEP;
    break;
  case csBoot :
    // A_32f2
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
      tcnow = timer0_counter;
    if (tcnow - rhidc_start > 1000)
      jmp_bootloader();
    // A_332a
    rawhid_commstate = csBoot;
    break;
  default :
    break;
  }

// A_3336
ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
  tcnow = timer0_counter;
if (rawhid_commstate == csIdle ||
    rawhid_commstate != cur_commstate)
  // A_3358
  tcnow_start = tcnow;
// A_336a
else if (tcnow - tcnow_start > 5000)
  // A_338c
  rawhid_commstate = csIdle;
}

/*****************************************************************************/
/* setup_keybit : (re)set bit for incoming key make/break                    */
/*****************************************************************************/
// A_33d0
// double checked - identical
uint8_t setup_keybit(uint8_t keyid, uint8_t make)
{
uint8_t keybit = 1 << (keyid & 7);  // R18
keyid >>= 3;
if (make)
  {
  // A_33ec
  if (keybit & pressed_hidxs[keyid])
    // A_3418
    return 1;
  pressed_hidxs[keyid] |= keybit;
  }
else
  {
  // A_3400
  if (!(keybit & pressed_hidxs[keyid]))
    return 1;
  pressed_hidxs[keyid] &= ~keybit;
  }
return 0;
}

/*****************************************************************************/
/* get_keyboard_leds                                                         */
/*****************************************************************************/
// A_341c
uint8_t get_keyboard_leds(void)
{
return keyboard_leds; // a bit weird, since the data are definitely in USB code
}

/*****************************************************************************/
/* get_keyboard_protocol : returns the configured keyboard protocol          */
/*****************************************************************************/
// A_3422
uint8_t get_keyboard_protocol(void)
{
return keyboard_protocol; // a bit weird, since the data are definitely in USB code
}

/*****************************************************************************/
/* proc_eeprom_mem_init                                                      */
/*****************************************************************************/
// A_3428
void proc_eeprom_mem_init(void)
{
usb_init();
setup_eeprom_header();
reset_layer_trans();
}

/*****************************************************************************/
/* reset_macroproc : reset macro processor                                   */
/*****************************************************************************/
// A_3430
void reset_macroproc(void)
{
memset(pressed_hidxs, 0, sizeof(pressed_hidxs));
reset_fnset();
reset_modifset();
empty_key_queue();
}

/*****************************************************************************/
/* queue_reset_usb_data                                                      */
/*****************************************************************************/
// A_3444
void queue_reset_usb_data(void)
{
queue_key(MCMD_CLEAR_ALL, 0);
}

/*****************************************************************************/
/* incoming_keybreak : a key has been pressed                                */
/*****************************************************************************/
// A_344a
void incoming_keybreak(uint8_t keyid)
{
if (setup_keybit(keyid, 0))
  return;
// A_3456
usb_debug_putchar('-');
phex(keyid);
usb_debug_putchar(' ');
keyid = translate_hidx(keyid, 0);
if (keyid &&
    !find_exec_macro(keyid, 0))
  queue_key(MCMD_BREAK, keyid);
}

/*****************************************************************************/
/* incoming_keymake : a key has been released                                */
/*****************************************************************************/
// A_3488
void incoming_keymake(uint8_t keyid)
{
if (setup_keybit(keyid, 1))
  return;

// A_3494
usb_debug_putchar('+');
phex(keyid);
usb_debug_putchar(' ');

keyid = translate_hidx(keyid, 1);
if (keyid &&
    !find_exec_macro(keyid, 1))
  queue_key(MCMD_MAKE, keyid);
}

/*****************************************************************************/
/* queue_free :                                                              */
/*****************************************************************************/
// A_34c6
// Double checked
uint8_t queue_free(void)
{
return (key_queue_ridx - 1 - key_queue_widx) % 80;
}

/*****************************************************************************/
/* queue_key : add key to FIFO ring                                          */
/*****************************************************************************/
// A_34dc
// Double checked - not identical, but close
void queue_key(uint8_t unk1, uint8_t hidx)
{
if (!queue_free())
  return;
// A_34ea
key_queue[key_queue_widx] = (uint16_t)(unk1 << 8) | hidx;
key_queue_widx = (key_queue_widx + 1) % 80;
}

/*****************************************************************************/
/* dequeue_key : removes key from FIFO ring                                  */
/*****************************************************************************/
// A_351c
uint16_t dequeue_key(void)
{
uint16_t ret;

if (key_queue_widx == key_queue_ridx)
  return 0;
// "return 0;" is not the whole truth. In Assembler, this looks like
// ldi R30, 0 ; movw R24,R30 ; ret
// which leaves R31 uninitialized!
// A_352e
ret = key_queue[key_queue_ridx];
key_queue_ridx = (key_queue_ridx + 1) % 80;
return ret;
}

/*****************************************************************************/
/* empty_key_queue : does what it says :-)                                   */
/*****************************************************************************/
// A_3552
void empty_key_queue(void)
{
key_queue_ridx = key_queue_widx;
}

/*****************************************************************************/
/* macro_tick : called from Timer 0 Tick                                     */
/*****************************************************************************/
// A_355c
void macro_tick(void)
{
static uint8_t modifier_keys_stack_idx = 0;   // 0x0197
static uint8_t wakeup_timeout = 0;   // 0x0198
static uint8_t flagset = 0;   // 0x0199
static uint8_t modifier_keys_stack[8] = {0};    // 0x0303..0x030a
uint16_t dw; // R1617
uint8_t db;  // R25

if (usb_suspended || usb_resuming)
  {
  // if suspended and a key is pressed,
  // A_3570
  if (!usb_resuming && 
      key_queue_widx != key_queue_ridx)
    {
    // A_357a
    // wake up the host if we can
    usb_remote_wakeup();
    wakeup_timeout = 10;
    }
  return;
  }

// A_3594
if (wakeup_timeout)
  {
  // ... should check for usb_resuming==0 IMO ...
  if (!--wakeup_timeout)
    {
    reset_macroproc();
    flagset = reset_usb_keyboard_data();
    }
  return;
  }

// A_35b4
if (key_queue_widx == key_queue_ridx)
  // A_35c0
  dw = 0;
else
  // A_35c6
  dw = key_queue[key_queue_ridx];

// A_35d6
if (dw & (MCMD_PUSH_META << 8))    // PUSH_META macro command modifier
  {
  // A_35dc
  if (modifier_keys_stack_idx < 8)
    modifier_keys_stack[modifier_keys_stack_idx++] = keyboard_modifier_keys;
  // A_35f8
  dw &= ~(MCMD_PUSH_META << 8);
  }

switch (dw >> 8)
  {
  case MCMD_PRESS :         // PRESS macro command  (do MAKE follwed by BREAK)
    // A_3662
    if (key_queue_widx != key_queue_ridx)
      key_queue[key_queue_ridx] = (3 << 8) | (dw & 0xff);
    goto mcmd_make;
  case MCMD_MAKE :          // MAKE macro command (or normal key down)
    dequeue_key();
  mcmd_make:
    if (IS_SELECT_KEY(dw))
      {
      // A_368a
      process_select(dw & 0xff);
      db = 0;
      }
    else
      {
      // A_3690
      usb_debug_putchar('d');
      phex(dw & 0xff);
      usb_debug_putchar(' ');
      // A_36cc
      db = usb_keyboard_press(dw & 0xff);
      }
    dw &= 0xff;
    break;
  case MCMD_BREAK :       // BREAK macro command (or normal key up)
    dequeue_key();
    // A_36aa:  // (dw>>8) == 3
    if (IS_SELECT_KEY(dw))  // ignore SELECT_x release
      // A_3758
      db = 0;
    else
      {
      // A_36b4
      usb_debug_putchar('u');
      phex(dw & 0xff);
      usb_debug_putchar(' ');
      // A_36c6
      db = usb_keyboard_release(dw & 0xff);
      }
    dw &= 0xff;
    break;
  case MCMD_ASSIGN_META :   // ASSIGN_META macro command
    dequeue_key();
    // A_36d0
    keyboard_modifier_keys = (dw & 0xff);
    // A_371c
    db = 3;
    dw &= 0xff;
    break;
  case MCMD_SET_META :      // SET_META macro command
    dequeue_key();
    // A_36d6
    keyboard_modifier_keys |= (dw & 0xff);
    // A_371c
    db = 3;
    dw &= 0xff;
    break;
  case MCMD_CLEAR_META :    // CLEAR_META macro command
    dequeue_key();
    // A_36de
    keyboard_modifier_keys &= ~(dw & 0xff);
    // A_371c
    db = 3;
    dw &= 0xff;
    break;
  case MCMD_TOGGLE_META :   // TOGGLE_META macro command
    dequeue_key();
    // A_36e8
    keyboard_modifier_keys ^= (dw & 0xff);
    // A_371c
    db = 3;
    dw &= 0xff;
    break;
  case MCMD_POP_META :      // POP_META macro command
    dequeue_key();
    // A_36f0
    if (modifier_keys_stack_idx)
      {
      keyboard_modifier_keys = modifier_keys_stack[--modifier_keys_stack_idx];
      // A_371c
      db = 3;
      }
    else
      db = 0;
    dw &= 0xff;
    break;
  case MCMD_POP_ALL_META :  // POP_ALL_META macro command
    dequeue_key();
    // A_3708
    if (modifier_keys_stack_idx)
      {
      // A_3710
      modifier_keys_stack_idx = 0;
      keyboard_modifier_keys = modifier_keys_stack[0];
      db = 3;
      }
    else
      db = 0;
    dw &= 0xff;
    break;
  case MCMD_DELAY :         // DELAY macro command
    // A_3720
    db = (dw & 0xff) - 1;
    if (db)
      {
      // A_3726
      if (key_queue_widx != key_queue_ridx)
        key_queue[key_queue_ridx] = (MCMD_DELAY << 8) | db;
      }
    else
      // A_3748
      dequeue_key();
    db = 0;
    dw &= 0xff;
    break;
  case MCMD_CLEAR_ALL :     // CLEAR_ALL macro command
    dequeue_key();
    // A_365e
    dw &= 0xff;
    // A_3750
    db = reset_usb_keyboard_data();
    break;
  case MCMD_BOOT :          // BOOT macro command
    dequeue_key();
    // A_374c
    reset_macroproc();
    dw = 0x0100 | (dw & 0xff);
    db = reset_usb_keyboard_data();
    break;

  default:
    db = 0;
    dw &= 0xff;
    break;
  }

// A_375c:
flagset |= db;
if (flagset)
  flagset = usb_keyboard_send(flagset);
// A_3772
if (dw >> 8)
  {
  _delay_ms(5);
  jmp_bootloader();
  }
}

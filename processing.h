/*****************************************************************************/
/* processing.h : the processing part of Soarer's Converter                  */
/*****************************************************************************/

#ifndef _processing_h__
#define _processing_h__

#include <stdint.h>

#define PROTOCOL_VER    1
#define PROTOCOL_SUBVER 0
#define CODE_VER        1
#define CODE_SUBVER     12
#define SETTINGS_VER    1
#define SETTINGS_SUBVER 1

// Macro commands

#define MCMD_PUSH_META    0x80    // PUSH_META modifier
#define MCMD_PRESS        0x01    // PRESS
#define MCMD_MAKE         0x02    // MAKE
#define MCMD_BREAK        0x03    // BREAK
#define MCMD_ASSIGN_META  0x04    // ASSIGN_META
#define MCMD_SET_META     0x05    // SET_META
#define MCMD_CLEAR_META   0x06    // CLEAR_META
#define MCMD_TOGGLE_META  0x07    // TOGGLE_META
#define MCMD_POP_META     0x08    // POP_META
#define MCMD_POP_ALL_META 0x09    // POP_ALL_META
#define MCMD_DELAY        0x0A    // DELAY
#define MCMD_CLEAR_ALL    0x0B    // CLEAR_ALL
#define MCMD_BOOT         0x0C    // BOOT

#ifdef __cplusplus
extern "C" {
#endif

void setup_proc_kbd(uint8_t keyboard_codeset, uint16_t keyboard_id);  // A_2b22
uint8_t get_forced_keyboard_type(void);  // A_2b7e
uint8_t setup_processing(void); // A_2e28
void rawhid_comm(void); // A_2f98
uint8_t get_keyboard_leds(void);  // A_341c
uint8_t get_keyboard_protocol(void);  // A_3422
void proc_eeprom_mem_init(void);  // A_3428

void reset_macroproc(void);  // A_3430
void queue_reset_usb_data(void);  // A_3444
void incoming_keybreak(uint8_t keyid);  // A_344a
void incoming_keymake(uint8_t keyid);  // A_3488
void queue_key(uint8_t unk1, uint8_t hidx);  // A_34dc
void empty_key_queue(void);  // A_3552
void macro_tick(void);  // A_355c

#ifdef __cplusplus
}
#endif

#endif /* defined(_processing_h__) */

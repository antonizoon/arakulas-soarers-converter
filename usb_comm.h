/*****************************************************************************/
/* usb_comm.h : USB communication handling for hardware USB AVRs             */
/*****************************************************************************/

#ifndef _usb_comm_h__
#define _usb_comm_h__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

extern uint8_t keyboard_protocol;   // 0x0119
extern uint8_t volatile usb_suspended;  // 0x013d
extern uint8_t volatile usb_resuming;  // 0x013e
extern uint8_t keyboard_modifier_keys;  // 0x0140
extern uint8_t volatile keyboard_leds;  // 0x0141


uint8_t reset_usb_keyboard_data(void);  // A_16c0
void usb_init(void);			// A_16ee // initialize everything
void usb_remote_wakeup(void); // A_172a
uint8_t usb_keyboard_press(uint8_t keyid);  // A_174c
uint8_t usb_keyboard_release(uint8_t keyid);  // A_1848
uint8_t usb_keyboard_send(uint8_t flagset);    // A_192e
int8_t usb_debug_putchar(uint8_t c);	// A_1a62 // transmit a character

int8_t usb_rawhid_recv(uint8_t *buffer, uint8_t timeout);  // A_2254
int8_t usb_rawhid_send(const uint8_t *buffer, uint8_t timeout); // A_22b0

uint8_t usb_configured(void);		// is the USB port configured
void usb_debug_flush_output(void);	// immediately transmit any buffered output

#define USB_DEBUG_HID

#ifdef __cplusplus
}
#endif

#endif /* defined(_usb_comm_h__) */

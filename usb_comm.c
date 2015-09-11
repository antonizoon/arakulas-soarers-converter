/*****************************************************************************/
/* usb_comm.c : USB communication handling for hardware USB AVRs             */
/*****************************************************************************/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/atomic.h>
#include <string.h>

#include "hwdefs.h"
#include "soarer.h"
#include "intkeys.h"
#include "salloc.h"
#include "processing.h"
#include "usb_comm.h"

#define EP_TYPE_CONTROL			0x00
#define EP_TYPE_BULK_IN			0x81
#define EP_TYPE_BULK_OUT		0x80
#define EP_TYPE_INTERRUPT_IN		0xC1
#define EP_TYPE_INTERRUPT_OUT		0xC0
#define EP_TYPE_ISOCHRONOUS_IN		0x41
#define EP_TYPE_ISOCHRONOUS_OUT		0x40

#define EP_SINGLE_BUFFER		0x02
#define EP_DOUBLE_BUFFER		0x06

#if 1
#define EP_SIZE(s)	\
    ((s) > 32 ? 0x30 :	\
	 (s) > 16 ? 0x20 :	\
	 (s) > 8 ? 0x10 :	\
	 0x00)
#else
// This is too dumb for special cases, but
// perpetuated throughout the AVR products I've seen...
#define EP_SIZE(s)	((s) == 64 ? 0x30 :	\
			((s) == 32 ? 0x20 :	\
			((s) == 16 ? 0x10 :	\
			             0x00)))
#endif

#if defined(__AVR_AT90USB162__)
#define HW_CONFIG() 
#define PLL_CONFIG() (PLLCSR = ((1<<PLLE)|(1<<PLLP0)))
#define USB_CONFIG() (USBCON = (1<<USBE))
#define USB_FREEZE() (USBCON = ((1<<USBE)|(1<<FRZCLK)))
#elif defined(__AVR_ATmega32U4__)
#define HW_CONFIG() (UHWCON = 0x01)
#define PLL_CONFIG() (PLLCSR = 0x12)
#define USB_CONFIG() (USBCON = ((1<<USBE)|(1<<OTGPADE)))
#define USB_FREEZE() (USBCON = ((1<<USBE)|(1<<FRZCLK)))
#elif defined(__AVR_AT90USB646__)
#define HW_CONFIG() (UHWCON = 0x81)
#define PLL_CONFIG() (PLLCSR = 0x1A)
#define USB_CONFIG() (USBCON = ((1<<USBE)|(1<<OTGPADE)))
#define USB_FREEZE() (USBCON = ((1<<USBE)|(1<<FRZCLK)))
#elif defined(__AVR_AT90USB1286__)
#define HW_CONFIG() (UHWCON = 0x81)
#define PLL_CONFIG() (PLLCSR = 0x16)
#define USB_CONFIG() (USBCON = ((1<<USBE)|(1<<OTGPADE)))
#define USB_FREEZE() (USBCON = ((1<<USBE)|(1<<FRZCLK)))
#endif

// standard control endpoint request types
#define GET_STATUS			0
#define CLEAR_FEATURE			1
#define SET_FEATURE			3
#define SET_ADDRESS			5
#define GET_DESCRIPTOR			6
#define GET_CONFIGURATION		8
#define SET_CONFIGURATION		9
#define GET_INTERFACE			10
#define SET_INTERFACE			11
// HID (human interface device)
#define HID_GET_REPORT			1
#define HID_GET_IDLE			2
#define HID_GET_PROTOCOL		3
#define HID_SET_REPORT			9
#define HID_SET_IDLE			10
#define HID_SET_PROTOCOL		11
// CDC (communication class device)
#define CDC_SET_LINE_CODING		0x20
#define CDC_GET_LINE_CODING		0x21
#define CDC_SET_CONTROL_LINE_STATE	0x22

/**************************************************************************
 *
 *  Configurable Options
 *
 **************************************************************************/

// You can change these to give your code its own name.
#define STR_MANUFACTURER	L"Soarer"
#define STR_PRODUCT		L"Soarer's Keyboard Converter"


// Mac OS-X and Linux automatically load the correct drivers.  On
// Windows, even though the driver is supplied by Microsoft, an
// INF file is needed to load the driver.  These numbers need to
// match the INF file.
#define VENDOR_ID		0x16C0
#define PRODUCT_ID		0x047D

// Here, the various included interfaces can be toggled on and off.
// At least one of them, however, should be present!

#ifndef INC_IF_BOOT
#define INC_IF_BOOT   1     // Boot-compatible keyboard device
#endif
#ifndef INC_IF_KBD
#define INC_IF_KBD    1     // Full capability NKRO keyboard device
#endif
#ifndef INC_IF_DBG
#define INC_IF_DBG    1     // DebugHID Output device
#endif
#ifndef INC_IF_RAW
#define INC_IF_RAW    1     // RawHID Data I/O device
#endif


#define RAWHID_USAGE_PAGE	0xFF99	// recommended: 0xFF00 to 0xFFFF
#define RAWHID_USAGE		0x2468	// recommended: 0x0100 to 0xFFFF

#define DEBUGHID_USAGE_PAGE 0xFF31	// recommended: 0xFF00 to 0xFFFF
#define DEBUGHID_USAGE      0x0074	// recommended: 0x0100 to 0xFFFF

// USB devices are supposed to implement a halt feature, which is
// rarely (if ever) used.  If you comment this line out, the halt
// code will be removed, saving 102 bytes of space (gcc 4.3.0).
// This is not strictly USB compliant, but works with all major
// operating systems.
#define SUPPORT_ENDPOINT_HALT

/**************************************************************************
 *
 *  Endpoint Buffer Configuration
 *
 **************************************************************************/

// Soarer's Converter has a little mixup here...
// keyboard interface has index 2, endpoint 2
//    debug interface has index 1, endpoint 3
// IMO, index should be swapped (kbd =>1, debug => 2)

#define ENDPOINT0_SIZE		32

#define BOOT_SIZE		    8
#define BOOT_BUFFER		    EP_DOUBLE_BUFFER

#define KEYBOARD_SIZE		23  //...?
#define KEYBOARD_BUFFER		EP_DOUBLE_BUFFER

#define DEBUG_TX_SIZE		32
#define DEBUG_TX_BUFFER		EP_DOUBLE_BUFFER

#define RAWHID_TX_BUFFER	EP_DOUBLE_BUFFER
#define RAWHID_RX_BUFFER	EP_DOUBLE_BUFFER
#define RAWHID_TX_SIZE		64	// transmit packet size
#define RAWHID_TX_INTERVAL	2	// max # of ms between transmit packets
#define RAWHID_RX_SIZE		64	// receive packet size
#define RAWHID_RX_INTERVAL	8	// max # of ms between receive packets

enum                                    /* USB Interface Enumeration:        */
  {
#if INC_IF_BOOT
  IF_Boot,                              /* Boot Interface                    */
#endif
#if INC_IF_KBD
  IF_Kbd,                               /* Full Keyboard Interface           */
#endif
#if INC_IF_DBG
  IF_Debug,                             /* Debug Interface                   */
#endif
#if INC_IF_RAW
  IF_Raw,                               /* Raw Interface                     */
#endif

  IF_Count                              /* Total # interfaces                */
  };
enum                                    /* USB Endpoint Enumeration :        */
  {
  EP_Default,                           /* Default end point                 */
#if INC_IF_BOOT
  EP_Boot,                              /* Boot Interface                    */
#endif
#if INC_IF_KBD
  EP_Kbd,                               /* Full Keyboard Interface           */
#endif
#if INC_IF_DBG
  EP_DebugTx,                           /* Debug Interface                   */
#endif
#if INC_IF_RAW
  EP_RawTx,                             /* Raw Interface                     */
  EP_RawRx,
#endif
  EP_Count                              /* total (including 0)               */
  };

// A_035d
static const uint8_t PROGMEM endpoint_config_table[] =
  {
#if INC_IF_BOOT
  // #1 Boot keyboard endpoint
  	1, EP_TYPE_INTERRUPT_IN,  EP_SIZE(BOOT_SIZE) | BOOT_BUFFER,
#endif
#if INC_IF_KBD
  // #2 Keyboard endpoint
	1, EP_TYPE_INTERRUPT_IN,  EP_SIZE(KEYBOARD_SIZE) | KEYBOARD_BUFFER,
#endif
#if INC_IF_DBG
  // #3 Debug endpoint
	1, EP_TYPE_INTERRUPT_IN,  EP_SIZE(DEBUG_TX_SIZE) | DEBUG_TX_BUFFER,
#endif
#if INC_IF_RAW
  // #4/#5 Rawhid endpoints
	1, EP_TYPE_INTERRUPT_IN,  EP_SIZE(RAWHID_TX_SIZE) | RAWHID_TX_BUFFER,
	1, EP_TYPE_INTERRUPT_OUT,  EP_SIZE(RAWHID_RX_SIZE) | RAWHID_RX_BUFFER
#endif
  };
#define CONFIG_NUM_ENDPOINTS (EP_Count - 1)


/**************************************************************************
 *
 *  Descriptor Data
 *
 **************************************************************************/

// Descriptors are the data that your computer reads when it auto-detects
// this USB device (called "enumeration" in USB lingo).  The most commonly
// changed items are editable at the top of this file.  Changing things
// in here should only be done by those who've read chapter 9 of the USB
// spec and relevant portions of any USB class specifications!

// A_036c
static uint8_t PROGMEM device_descriptor[] = {
	18,					// bLength
	1,					// bDescriptorType
	0x00, 0x02,			// bcdUSB
	0,					// bDeviceClass
	0,					// bDeviceSubClass
	0,					// bDeviceProtocol
	ENDPOINT0_SIZE,		// bMaxPacketSize0
	LSB(VENDOR_ID), MSB(VENDOR_ID),		// idVendor
	LSB(PRODUCT_ID), MSB(PRODUCT_ID),	// idProduct
	0x00, 0x01,			// bcdDevice
	1,					// iManufacturer
	2,					// iProduct
	0,					// iSerialNumber
	1					// bNumConfigurations
};

#if INC_IF_BOOT
// A_03f2:
static uint8_t PROGMEM boot_hid_report_desc[] = {
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x06,                    // USAGE (Keyboard)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,              //   LOGICAL_MAXIMUM (255)
    0x95, 0x08,                    //   REPORT_COUNT (8)
    0x75, 0x08,                    //   REPORT_SIZE (8)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0xc0,                          // END_COLLECTION
};
#endif

#if INC_IF_KBD
// Keyboard Protocol 1, HID 1.11 spec, Appendix B, page 59-60
// A_0419
static uint8_t PROGMEM keyboard_hid_report_desc[] = {
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x06,                    // USAGE (Keyboard)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x85, 0x01,                    //   REPORT_ID (1)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x08,                    //   REPORT_COUNT (8)
    0x05, 0x07,                    //   USAGE_PAGE (Keyboard)
    0x19, 0xe0,                    //   USAGE_MINIMUM (Keyboard LeftControl)
    0x29, 0xe7,                    //   USAGE_MAXIMUM (Keyboard Right GUI)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x05,                    //   REPORT_COUNT (5)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x05, 0x08,                    //   USAGE_PAGE (LEDs)
    0x19, 0x01,                    //   USAGE_MINIMUM (Num Lock)
    0x29, 0x05,                    //   USAGE_MAXIMUM (Kana)
    0x91, 0x02,                    //   OUTPUT (Data,Var,Abs)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x75, 0x03,                    //   REPORT_SIZE (3)
    0x91, 0x03,                    //   OUTPUT (Cnst,Var,Abs)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x31,                    //   REPORT_COUNT (49)
    0x05, 0x07,                    //   USAGE_PAGE (Keyboard)
    0x19, 0x01,                    //   USAGE_MINIMUM (Keyboard ErrorRollOver)
    0x29, 0x31,                    //   USAGE_MAXIMUM (Keyboard \ and |)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x69,                    //   REPORT_COUNT (105)
    0x05, 0x07,                    //   USAGE_PAGE (Keyboard)
    0x19, 0x33,                    //   USAGE_MINIMUM (Keyboard ; and :)
    0x29, 0x9b,                    //   USAGE_MAXIMUM (Keyboard Cancel)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x08,                    //   REPORT_COUNT (8)
    0x05, 0x07,                    //   USAGE_PAGE (Keyboard)
    0x19, 0x9d,                    //   USAGE_MINIMUM (Keyboard Prior)
    0x29, 0xa4,                    //   USAGE_MAXIMUM (Keyboard ExSel)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x04,                    //   REPORT_COUNT (4)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0xc0,                          // END_COLLECTION
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x80,                    // USAGE (System Control)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x85, 0x02,                    //   REPORT_ID (2)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x03,                    //   REPORT_COUNT (3)
    0x19, 0x81,                    //   USAGE_MINIMUM (System Power Down)
    0x29, 0x83,                    //   USAGE_MAXIMUM (System Wake Up)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0x95, 0x05,                    //   REPORT_COUNT (5)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x81, 0x03,                    //   INPUT (Cnst,Var,Abs)
    0xc0,                          // END_COLLECTION
    0x05, 0x0c,                    // USAGE_PAGE (Consumer Devices)
    0x09, 0x01,                    // USAGE (Consumer Control)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x85, 0x03,                    //   REPORT_ID (3)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x18,                    //   REPORT_COUNT (24)
    0x09, 0xb5,                    //   USAGE (Scan Next Track)
    0x09, 0xb6,                    //   USAGE (Scan Previous Track)
    0x09, 0xb7,                    //   USAGE (Stop)
    0x09, 0xcd,                    //   USAGE (Unassigned)
    0x09, 0xe2,                    //   USAGE (Mute)
    0x09, 0xe5,                    //   USAGE (Bass Boost)
    0x09, 0xe7,                    //   USAGE (Loudness)
    0x09, 0xe9,                    //   USAGE (Volume Up)
    0x09, 0xea,                    //   USAGE (Volume Down)
    0x0a, 0x52, 0x01,              //   USAGE (Bass Increment)
    0x0a, 0x53, 0x01,              //   USAGE (Bass Decrement)
    0x0a, 0x54, 0x01,              //   USAGE (Treble Increment)
    0x0a, 0x55, 0x01,              //   USAGE (Treble Decrement)
    0x0a, 0x83, 0x01,              //   USAGE (AL Consumer Control Configuration)
    0x0a, 0x8a, 0x01,              //   USAGE (AL Email Reader)
    0x0a, 0x92, 0x01,              //   USAGE (AL Calculator)
    0x0a, 0x94, 0x01,              //   USAGE (AL Local Machine Browser)
    0x0a, 0x21, 0x02,              //   USAGE (AC Search)
    0x0a, 0x23, 0x02,              //   USAGE (AC Home)
    0x0a, 0x24, 0x02,              //   USAGE (AC Back)
    0x0a, 0x25, 0x02,              //   USAGE (AC Forward)
    0x0a, 0x26, 0x02,              //   USAGE (AC Stop)
    0x0a, 0x27, 0x02,              //   USAGE (AC Refresh)
    0x0a, 0x2a, 0x02,              //   USAGE (AC Bookmarks)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0xc0,                          // END_COLLECTION
};
#endif

#if INC_IF_DBG
// A_0404:
static uint8_t PROGMEM debug_hid_report_desc[] = {
    0x06, LSB(DEBUGHID_USAGE_PAGE), MSB(DEBUGHID_USAGE_PAGE), // Usage Page 0xFF31 (vendor defined)
	0x09, DEBUGHID_USAGE,	// Usage 0x74
	0xA1, 0x53,				// Collection 0x53
	0x75, 0x08,				// report size = 8 bits
	0x15, 0x00,				// logical minimum = 0
	0x26, 0xFF, 0x00,		// logical maximum = 255
	0x95, DEBUG_TX_SIZE,	// report count
	0x09, 0x75,				// usage
	0x81, 0x02,				// Input (array)
	0xC0					// end collection
};
#endif

#if INC_IF_RAW
// A_04f5
static uint8_t PROGMEM rawhid_hid_report_desc[] = {
	0x06, LSB(RAWHID_USAGE_PAGE), MSB(RAWHID_USAGE_PAGE),
	0x0A, LSB(RAWHID_USAGE), MSB(RAWHID_USAGE),
	0xA1, 0x01,				// Collection 0x01
	0x75, 0x08,				// report size = 8 bits
	0x15, 0x00,				// logical minimum = 0
	0x26, 0xFF, 0x00,			// logical maximum = 255
	0x95, RAWHID_TX_SIZE,			// report count
	0x09, 0x01,				// usage
	0x81, 0x02,				// Input (array)
	0x95, RAWHID_RX_SIZE,			// report count
	0x09, 0x02,				// usage
	0x91, 0x02,				// Output (array)
	0xC0					// end collection
};
#endif

// If you're desperate for a little extra code memory, these strings
// can be completely removed if iManufacturer, iProduct, iSerialNumber
// in the device desciptor are changed to zeros.
struct usb_string_descriptor_struct {
	uint8_t bLength;
	uint8_t bDescriptorType;
	int16_t wString[];
};
// A_0511
static struct usb_string_descriptor_struct PROGMEM string0 = {
	4,
	3,
	{0x0409}
};
// A_0515
static struct usb_string_descriptor_struct PROGMEM string1 = {
	sizeof(STR_MANUFACTURER),
	3,
	STR_MANUFACTURER
};
// A_0525
static struct usb_string_descriptor_struct PROGMEM string2 = {
	sizeof(STR_PRODUCT),
	3,
	STR_PRODUCT
};


#define CFG_DESC_SZ              9
#define IF_DESC_SZ               9
#define EP_DESC_SZ               7
#if INC_IF_BOOT
#define BOOT_HID_DESC_SZ         (2*IF_DESC_SZ)+EP_DESC_SZ
#else
#define BOOT_HID_DESC_SZ         0
#endif
#if INC_IF_KBD
#define KBD_HID_DESC_SZ          (2*IF_DESC_SZ)+EP_DESC_SZ
#else
#define KBD_HID_DESC_SZ          0
#endif
#if INC_IF_DBG
#define DBG_HID_DESC_SZ          (2*IF_DESC_SZ)+EP_DESC_SZ
#else
#define DBG_HID_DESC_SZ          0
#endif
#if INC_IF_RAW
#define RAW_HID_DESC_SZ          (2*IF_DESC_SZ)+(2*EP_DESC_SZ)
#else
#define RAW_HID_DESC_SZ          0
#endif

#define CONFIG1_DESC_SIZE        (CFG_DESC_SZ + BOOT_HID_DESC_SZ + KBD_HID_DESC_SZ + DBG_HID_DESC_SZ + RAW_HID_DESC_SZ)
#define BOOT_HID_DESC_OFFSET     (CFG_DESC_SZ + IF_DESC_SZ)
#define KEYBOARD_HID_DESC_OFFSET (CFG_DESC_SZ + BOOT_HID_DESC_SZ + IF_DESC_SZ)
#define DEBUG_HID_DESC_OFFSET    (CFG_DESC_SZ + BOOT_HID_DESC_SZ + KBD_HID_DESC_SZ + IF_DESC_SZ)
#define RAWHID_HID_DESC_OFFSET   (CFG_DESC_SZ + BOOT_HID_DESC_SZ + KBD_HID_DESC_SZ + DBG_HID_DESC_SZ + IF_DESC_SZ)

// A_037e
static uint8_t PROGMEM config1_descriptor[CONFIG1_DESC_SIZE] = {
	// configuration descriptor, USB spec 9.6.3, page 264-266, Table 9-10
	CFG_DESC_SZ, 		// bLength;
	2,					// bDescriptorType: USBDESCR_CONFIG
	LSB(CONFIG1_DESC_SIZE),			// wTotalLength
	MSB(CONFIG1_DESC_SIZE),
	IF_Count,			// bNumInterfaces
	1,					// bConfigurationValue
	0,					// iConfiguration
	0xa0,				// bmAttributes: USBATTR_BUSPOWER | USBATTR_SELFPOWER
	50,					// bMaxPower: USB_CFG_MAX_BUS_POWER/2

#if INC_IF_BOOT
// #0: boot device interface descriptor:
	// interface descriptor, USB spec 9.6.5, page 267-269, Table 9-12
	IF_DESC_SZ,			// bLength
	4,					// bDescriptorType: USBDESCR_INTERFACE
	IF_Boot,			// bInterfaceNumber
	0,					// bAlternateSetting
	1,					// bNumEndpoints
	0x03,					// bInterfaceClass (0x03 = HID)
	0x01,					// bInterfaceSubClass (0x01 = Boot)
	0x01,					// bInterfaceProtocol (0x01 = Keyboard)
	0,					// iInterface
	// HID interface descriptor, HID 1.11 spec, section 6.2.1
	IF_DESC_SZ,				// bLength
	0x21,					// bDescriptorType
	0x11, 0x01,				// bcdHID
	0,					// bCountryCode
	1,					// bNumDescriptors
	0x22,					// bDescriptorType
	sizeof(boot_hid_report_desc),	// wDescriptorLength
	0,
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	EP_DESC_SZ,			// bLength
	5,					// bDescriptorType
	EP_Boot | 0x80,		// bEndpointAddress
	0x03,					// bmAttributes (0x03=intr)
	BOOT_SIZE, 0,			// wMaxPacketSize
	1,					// bInterval
#endif

#if INC_IF_KBD
// #1: Keyboard Device interface
	// interface descriptor, USB spec 9.6.5, page 267-269, Table 9-12
	IF_DESC_SZ,			// bLength
	4,					// bDescriptorType: USBDESCR_INTERFACE
	IF_Kbd,			// bInterfaceNumber
	0,					// bAlternateSetting
	1,					// bNumEndpoints
	0x03,					// bInterfaceClass (0x03 = HID)
	0x0,					// bInterfaceSubClass (0x01 = Boot)
	0x0,					// bInterfaceProtocol (0x01 = Keyboard)
	0,					// iInterface
	// HID interface descriptor, HID 1.11 spec, section 6.2.1
	IF_DESC_SZ,				// bLength
	0x21,					// bDescriptorType
	0x11, 0x01,				// bcdHID
	0,					// bCountryCode
	1,					// bNumDescriptors
	0x22,					// bDescriptorType
	sizeof(keyboard_hid_report_desc),	// wDescriptorLength
	0,
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	EP_DESC_SZ,			// bLength
	5,					// bDescriptorType
	EP_Kbd | 0x80,		// bEndpointAddress
	0x03,					// bmAttributes (0x03=intr)
	KEYBOARD_SIZE, 0,			// wMaxPacketSize
	1,					// bInterval
#endif

#if INC_IF_DBG
// #2: Debug Device
	// interface descriptor, USB spec 9.6.5, page 267-269, Table 9-12
	IF_DESC_SZ,			// bLength
	4,					// bDescriptorType
	IF_Debug,			// bInterfaceNumber
	0,					// bAlternateSetting
	1,					// bNumEndpoints
	0x03,					// bInterfaceClass (0x03 = HID)
	0x00,					// bInterfaceSubClass
	0x00,					// bInterfaceProtocol
	0,					// iInterface
	// HID interface descriptor, HID 1.11 spec, section 6.2.1
	IF_DESC_SZ,				// bLength
	0x21,					// bDescriptorType
// A_03ab
	0x11, 0x01,				// bcdHID
	0,					// bCountryCode
	1,					// bNumDescriptors
	0x22,					// bDescriptorType
	sizeof(debug_hid_report_desc),		// wDescriptorLength
	0,
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	EP_DESC_SZ,			// bLength
	5,					// bDescriptorType
	EP_DebugTx | 0x80,		// bEndpointAddress
	0x03,					// bmAttributes (0x03=intr)
	DEBUG_TX_SIZE, 0,			// wMaxPacketSize
	1,					// bInterval
#endif

#if INC_IF_RAW
// #3: Rawhid Device interface
	// interface descriptor, USB spec 9.6.5, page 267-269, Table 9-12
	IF_DESC_SZ,			// bLength
	4,					// bDescriptorType
	IF_Raw,			// bInterfaceNumber
	0,					// bAlternateSetting
	2,					// bNumEndpoints
	0x03,					// bInterfaceClass (0x03 = HID)
	0x00,					// bInterfaceSubClass (0x01 = Boot)
	0x00,					// bInterfaceProtocol (0x01 = Keyboard)
	0,					// iInterface
	// HID interface descriptor, HID 1.11 spec, section 6.2.1
	IF_DESC_SZ,					// bLength
	0x21,					// bDescriptorType
	0x11, 0x01,				// bcdHID
	0,					// bCountryCode
	1,					// bNumDescriptors
	0x22,					// bDescriptorType
	sizeof(rawhid_hid_report_desc),		// wDescriptorLength
	0,
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	EP_DESC_SZ,			// bLength
	5,					// bDescriptorType: end point
	EP_RawTx | 0x80,		// bEndpointAddress
	0x03,					// bmAttributes (0x03=intr)
	RAWHID_TX_SIZE, 0,			// wMaxPacketSize
	RAWHID_TX_INTERVAL,			// bInterval
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	EP_DESC_SZ,			// bLength
	5,					// bDescriptorType
	EP_RawRx,			// bEndpointAddress
	0x03,					// bmAttributes (0x03=intr)
	RAWHID_RX_SIZE, 0,			// wMaxPacketSize
	RAWHID_RX_INTERVAL,			// bInterval
#endif

};

// This table defines which descriptor data is sent for each specific
// request from the host (in wValue and wIndex).
static struct descriptor_list_struct {
	uint16_t	wValue;
	uint16_t	wIndex;
	const uint8_t	*addr;
	uint8_t		length;
// A_0302
} PROGMEM descriptor_list[] = {
	{0x0100, 0x0000, device_descriptor, sizeof(device_descriptor)},
	{0x0200, 0x0000, config1_descriptor, sizeof(config1_descriptor)},
#if INC_IF_BOOT
	{0x2200, IF_Boot, boot_hid_report_desc, sizeof(boot_hid_report_desc)},
	{0x2100, IF_Boot, config1_descriptor+BOOT_HID_DESC_OFFSET, 9},
#endif
#if INC_IF_KBD
	{0x2200, IF_Kbd, keyboard_hid_report_desc, sizeof(keyboard_hid_report_desc)},
	{0x2100, IF_Kbd, config1_descriptor+KEYBOARD_HID_DESC_OFFSET, 9},
#endif
#if INC_IF_DBG
	{0x2200, IF_Debug, debug_hid_report_desc, sizeof(debug_hid_report_desc)},
	{0x2100, IF_Debug, config1_descriptor+DEBUG_HID_DESC_OFFSET, 9},
#endif
#if INC_IF_RAW
	{0x2200, IF_Raw, rawhid_hid_report_desc, sizeof(rawhid_hid_report_desc)},
	{0x2100, IF_Raw, config1_descriptor+RAWHID_HID_DESC_OFFSET, 9},
#endif
	{0x0300, 0x0000, (const uint8_t *)&string0, 4},
	{0x0301, 0x0409, (const uint8_t *)&string1, sizeof(STR_MANUFACTURER)},
	{0x0302, 0x0409, (const uint8_t *)&string2, sizeof(STR_PRODUCT)}
};
#define NUM_DESC_LIST (sizeof(descriptor_list)/sizeof(struct descriptor_list_struct))


typedef struct    // standard USB Setup Packet Layout
  {
  uint8_t  bmRequestType;
  uint8_t  bRequest;
  uint16_t wValue;
  uint16_t wIndex;
  uint16_t wLength;
  } USBSetupPacket; 

/**************************************************************************
 *
 *  Variables - these are the only non-stack RAM usage
 *
 **************************************************************************/

// zero when we are not configured, non-zero when enumerated
static volatile uint8_t usb_configuration = 0; // 0x0142

// the time remaining before we transmit any partially full
// packet, or send a zero length packet.
static volatile uint8_t debug_flush_timer = 0;  // 0x014f

// which modifier keys are currently pressed
// 1=left ctrl,    2=left shift,   4=left alt,    8=left gui
// 16=right ctrl, 32=right shift, 64=right alt, 128=right gui
uint8_t keyboard_modifier_keys=0;  // 0x0140
// 1=num lock, 2=caps lock, 4=scroll lock, 8=compose, 16=kana
uint8_t volatile keyboard_leds = 0;  // 0x0141

// which keys are currently pressed, up to 6 keys may be down at once
uint8_t boot_keys[6]={0}; // 0x0149
struct    // still slightly shady area
  {
  uint8_t data1[21]; // 0x0152 HIDX 1..KEY_EXSEL
  uint8_t data2;     // 0x0167 HIDX KEY_SYSTEM_POWER..KEY_SYSTEM_WAKE
  uint8_t data3[3];  // 0x0168 HIDX KEY_MEDIA_NEXT_TRACK..KEY_MEDIA_WWW_FAVORITES
  uint8_t data4[2];  // 0x016b unused
  } kbd_data = { {0} };

// protocol setting from the host.  We use exactly the same report
// either way, so this variable only stores the setting since we
// are required to be able to report which setting is in use.
uint8_t keyboard_protocol = 1;   // 0x0119

// the idle configuration, how often we send the report to the
// host (ms * 4) even when it hasn't changed
uint8_t keyboard_idle_config[3] = { 125, 125, 125 }; // 0x011a-0x011c
uint8_t boot_idle_config = 125;  // 0x011d

// count until idle timeout
uint8_t keyboard_idle_count[3] = { 0 };  // 0x0145
uint8_t boot_idle_count = 0;  // 0x0148

// flag whether device is suspended
uint8_t volatile usb_suspended = 0;    // 0x013d

// flag whether device resumed after suspension
uint8_t volatile usb_resuming = 0;  // 0x013e

uint8_t volatile usb_status = 0;   // 0x013f
uint8_t volatile tx_timeout_count = 0;  // 0x0143
uint8_t volatile rx_timeout_count = 0;  // 0x0144

/**************************************************************************
 *
 *  Public Functions - these are the API intended for the user
 *
 **************************************************************************/


/*****************************************************************************/
/* reset_usb_keyboard_data                                                   */
/*****************************************************************************/
// A_16c0
// double checked
uint8_t reset_usb_keyboard_data(void)
{
memset(boot_keys, 0, sizeof(boot_keys));
memset(&kbd_data, 0, sizeof(kbd_data));
keyboard_modifier_keys = 0;
return 0x0f;
}

/*****************************************************************************/
/* usb_init : initialize USB stuff                                           */
/*****************************************************************************/
// A_16ee
// double checked
void usb_init(void)
{
reset_usb_keyboard_data();

HW_CONFIG();
USB_FREEZE();				// enable USB
PLL_CONFIG();				// config PLL
while (!(PLLCSR & (1<<PLOCK))) ;	// wait for PLL lock
USB_CONFIG();				// start USB clock
UDCON = 0;				    // enable attach resistor
usb_configuration = 0;
usb_suspended = 0;
usb_resuming = 0;
usb_status = 0;
UDIEN = (1<<EORSME)|(1<<EORSTE)|(1<<SOFE)|(1<<SUSPE);
sei();
}

/*****************************************************************************/
/* usb_remote_wakeup                                                         */
/*****************************************************************************/
// A_172a
// double checked
void usb_remote_wakeup(void)
{
if (usb_status && !usb_resuming)
  {
  UDCON |= (1 << RMWKUP);               /* set "Upstream Resume" flag        */
  usb_resuming = 1;
  }
}

/*****************************************************************************/
/* usb_keyboard_press : set bit for a key ID                                 */
/*****************************************************************************/
// A_174c
uint8_t usb_keyboard_press(uint8_t keyid)
{
uint8_t rc;

if (keyid <= KEY_EXSEL)
  {
  // A_175a
  kbd_data.data1[(keyid - 1) >> 3] |= 1 << ((keyid - 1) & 7);
  rc = 0x03;
  }
else
  rc = 0x00;

// A_1782
if (keyid >= KEY_SYSTEM_POWER && keyid <= KEY_SYSTEM_WAKE)
  {
  kbd_data.data2 |= 1 << ((keyid - KEY_SYSTEM_POWER) & 7);
  rc |= 0x04;
  }
// A_17b2
else if (keyid >= KEY_MEDIA_NEXT_TRACK && keyid <= KEY_MEDIA_WWW_FAVORITES)
  {
  uint8_t id3 = keyid - KEY_MEDIA_NEXT_TRACK;  // shift it to 0x00..0x17
  kbd_data.data3[id3 >> 3] |= 1 << (id3 & 7);
  rc |= 0x08;
  }
// A_17e4
else if (keyid >= KEY_LCTRL && keyid <= KEY_RGUI)
  {
  keyboard_modifier_keys |= 1 << (keyid - KEY_LCTRL);
  // A_1836
  rc |= 0x03;
  }
// A_180c
else if (keyid <= KEY_EXSEL)
  {
  int i;
  for (i = 0; i < sizeof(boot_keys); i++)
    {
    if (boot_keys[i] == keyid)
      return rc;
    }
  // A_1824
  for (i = 0; i < sizeof(boot_keys); i++)
    {
    // A_1828
    if (!boot_keys[i])
      {
      boot_keys[i] = keyid;
      return rc | 0x03;
      }
    }
  }
return rc;
}

/*****************************************************************************/
/* usb_keyboard_release : resets bits for a key id                           */
/*****************************************************************************/
// A_1848
uint8_t usb_keyboard_release(uint8_t keyid)
{
uint8_t rc;

if (keyid <= KEY_EXSEL)
  {
  // A_1856
  kbd_data.data1[(keyid - 1) >> 3] &= ~(1 << ((keyid - 1) & 0x07));
  rc = 3;
  }
else
  rc = 0;
// A_187e
if (keyid >= KEY_SYSTEM_POWER && keyid <= KEY_SYSTEM_WAKE)
  {
  kbd_data.data2 &= ~(1 << ((keyid - KEY_SYSTEM_POWER) & 7));
  rc |= 4;
  }
// A_18b0
else if (keyid >= KEY_MEDIA_NEXT_TRACK && keyid <= KEY_MEDIA_WWW_FAVORITES)
  {
  uint8_t id3 = keyid - KEY_MEDIA_NEXT_TRACK;  // shift it to 0x00..0x17
  kbd_data.data3[id3 >> 3] &= ~(1 << (id3 & 7));
  rc |= 0x08;
  }
// A_18e4
else if (keyid >= KEY_LCTRL && keyid <= KEY_RGUI)
  {
  keyboard_modifier_keys &= ~(1 << (keyid - KEY_LCTRL));
  rc |= 0x03;
  }
else if (keyid <= KEY_EXSEL)
  {
  // A_1900
  int i;
  for (i = 0; i < sizeof(boot_keys); i++)
    if (boot_keys[i] == keyid)
      {
      boot_keys[i] = 0;
      rc |= 0x03;
      }
  }

return rc;
}

/*****************************************************************************/
/* usb_keyboard_send : sends new keyboard state                              */
/*****************************************************************************/
// A_192e
// double checked
uint8_t usb_keyboard_send(uint8_t flagset)
{
uint8_t intr_state;  // R18
uint8_t i;

// R25 = flagset;
if (usb_configuration == 0)
  return flagset;
#if INC_IF_BOOT
if (flagset & 0x01)
  {
  // A_193e
  intr_state = SREG;
  cli();
  UENUM = EP_Boot;
  // are we ready to transmit?
  if (UEINTX & (1 << RWAL))
    {
    // A_1950
    UEDATX = keyboard_modifier_keys;
    UEDATX = 0;
	for (i = 0; i < sizeof(boot_keys); i++)
      UEDATX = boot_keys[i];
    UEINTX = 0x3a;
    // A_1992
    boot_idle_count = 0;
    flagset &= ~0x01;
    }
  // A_1998
  SREG = intr_state;
  }
#else
boot_idle_count = 0;
flagset &= ~0x01;
#endif

// A_199a
if (!keyboard_protocol)
  return flagset & 0xf1;

#if INC_IF_KBD
// A_19a4
if (flagset & 0x02)
  {
  // A_19a8
  intr_state = SREG;
  cli();
  UENUM = EP_Kbd;
  // are we ready to transmit?
  if (UEINTX & (1 << RWAL))
    {
    // A_19ba
    UEDATX = 1;
    UEDATX = keyboard_modifier_keys;
    for (i = 0; i < sizeof(kbd_data.data1); i++)
      UEDATX = kbd_data.data1[i];
    UEINTX = 0x3a;
    keyboard_idle_count[0] = 0;
    flagset &= ~0x02;
    }
  // A_19e6
  SREG = intr_state;
  }
#else
keyboard_idle_count[0] = 0;
flagset &= ~0x02;
#endif

#if INC_IF_KBD
// A_19e8
if (flagset & 0x04)
  {
  // A_19ec
  intr_state = SREG;
  cli();
  UENUM = EP_Kbd;
  // are we ready to transmit?
  if (UEINTX & (1 << RWAL))
    {
    UEDATX = 2;
    UEDATX = kbd_data.data2;
    UEINTX = 0x3a;
    keyboard_idle_count[1] = 0;
    flagset &= ~0x04;
    }
  // A_1a16
  SREG = intr_state;
  }
#else
keyboard_idle_count[1] = 0;
flagset &= ~0x04;
#endif

#if INC_IF_KBD
// A_1a18
if (flagset & 0x08)
  {
  // A_1a1c
  intr_state = SREG;
  cli();
  UENUM = EP_Kbd;
  // are we ready to transmit?
  if (UEINTX & (1 << RWAL))
    {
    UEDATX = 3;
    for (i = 0; i < sizeof(kbd_data.data3); i++)
      UEDATX = kbd_data.data3[i];
    UEINTX = 0x3a;
    keyboard_idle_count[2] = 0;
    flagset &= ~0x08;
    }
  // A_1a58
  SREG = intr_state;
  }
#else
keyboard_idle_count[2] = 0;
flagset &= ~0x08;
#endif

// A_1a5e:
return flagset;
}

/*****************************************************************************/
/* usb_debug_putchar : transmit a character                                  */
/*****************************************************************************/
// 0 returned on success, -1 on error
// A_1a62
int8_t usb_debug_putchar(uint8_t c)
{
#if INC_IF_DBG
static uint8_t previous_timeout = 0;  // 0x0151
uint8_t timeout, intr_state;

// if we're not online (enumerated and configured), error
if (!usb_configuration ||
    usb_suspended ||
    usb_resuming ||
    !keyboard_protocol)
  return -1;

// interrupts are disabled so these functions can be
// used from the main program or interrupt context,
// even both in the same program!
// A_1a8c
intr_state = SREG;
cli();
UENUM = EP_DebugTx;
// if we gave up due to timeout before, don't wait again
// A_1a96
if (previous_timeout)
  {
  if (!(UEINTX & (1<<RWAL)))
    {
    SREG = intr_state;
    return -1;
    }
  previous_timeout = 0;
  }
// wait for the FIFO to be ready to accept data
// A_1aae
timeout = UDFNUML + 4;
while (1)
  {
  // are we ready to transmit?
  if (UEINTX & (1<<RWAL)) break;
  // A_1abe
  SREG = intr_state;
  // have we waited too long?
  if (UDFNUML == timeout)
    {
    previous_timeout = 1;
    return -1;
    }
  // A_1ad2
  // has the USB gone offline?
  if (!usb_configuration)
    return -1;
  // get ready to try checking again
  intr_state = SREG;
  cli();
  UENUM = EP_DebugTx;
  }
// A_1ae4
// actually write the byte into the FIFO
UEDATX = c;
// if this completed a packet, transmit it now!
if (!(UEINTX & (1<<RWAL)))
  {
  UEINTX = 0x3A;
  debug_flush_timer = 0;
  }
else
  {
  debug_flush_timer = 2;
  }
// A_1b02
SREG = intr_state;
#endif
return 0;
}

// return 0 if the USB is not configured, or the configuration
// number selected by the HOST
// (maybe in source code, but unused in Soarers Converter)
uint8_t usb_configured(void)
{
return usb_configuration;
}

// immediately transmit any buffered output.
// (maybe in source code, but unused in Soarer's Converter)
void usb_debug_flush_output(void)
{
#if INC_IF_DBG
uint8_t intr_state;

intr_state = SREG;
cli();
if (debug_flush_timer)
  {
  UENUM = EP_DebugTx;
  while ((UEINTX & (1<<RWAL)))
    {
    UEDATX = 0;
    }
  UEINTX = 0x3A;
  debug_flush_timer = 0;
  }
SREG = intr_state;
#endif
}



/**************************************************************************
 *
 *  Private Functions - not intended for general user consumption....
 *
 **************************************************************************/



// USB Device Interrupt - handle all device-level events
// the transmit buffer flushing is triggered by the start of frame
//
// A_1b0c
ISR(USB_GEN_vect)
{
	uint8_t intbits, i;
	static uint8_t div4 = 0;  // 0x0150

    intbits = UDINT;
    UDINT = 0;
    // if end of reset
    if (intbits & (1<<EORSTI)) {
        // A_1b2e
		UENUM = 0;
		UECONX = 1;
		UECFG0X = EP_TYPE_CONTROL;
		UECFG1X = EP_SIZE(ENDPOINT0_SIZE) | EP_SINGLE_BUFFER;
		UEIENX = (1<<RXSTPE);
		usb_configuration = 0;
        usb_status = 0;
        usb_suspended = 0;
        usb_resuming = 0;
        keyboard_protocol = 1;
        }
    if (intbits & (1<<SUSPI)) {
        // A_1b60
        UDIEN |= (1 << WAKEUPE);
        usb_suspended = 1;
        }
    if ((intbits & (1<<WAKEUPI)) && usb_suspended) {
        // A_1b74
        UDIEN &= ~(1<<WAKEUPE);
        usb_suspended = 0;
        }
    // A_1b8a
    if (intbits & (1<<EORSMI))
      usb_resuming = 0;

    // A_1b92
	if ((intbits & (1<<SOFI)) && usb_configuration) {
        // A_1ba0
#if INC_IF_DBG
		uint8_t t = debug_flush_timer;
		if (keyboard_protocol && t) {
			debug_flush_timer = --t;
			if (!t) {
				UENUM = EP_DebugTx;
				while ((UEINTX & (1<<RWAL))) {
					UEDATX = 0;
				}
				UEINTX = 0x3A;
			}
		}
#endif
        // A_1bd4
        if (keyboard_protocol)
          {
          if (rx_timeout_count)
            rx_timeout_count--;
          if (tx_timeout_count)
            tx_timeout_count--;
          }

        // A_1bf8
        if (!(++div4 & 0x03)) {
            // A_1c0e
#if INC_IF_BOOT
            if (boot_idle_config) {
                UENUM = EP_Boot;
                if (UEINTX & (1<<RWAL)) {
                    // A_1c24
	    		  	boot_idle_count++;
		    		if (boot_idle_count == boot_idle_config) {
                        // A_1c32
                        boot_idle_count = 0;
					    UEDATX = keyboard_modifier_keys;
					    UEDATX = 0;
					    for (i=0; i<sizeof(boot_keys); i++) {
						    UEDATX = boot_keys[i];
					    }
					    UEINTX = 0x3A;
                    }
                }
            }
#endif
#if INC_IF_KBD
            // A_1c78
            if (keyboard_protocol) {
                UENUM = EP_Kbd;
                if (keyboard_idle_config[0] && (UEINTX & (1<<RWAL))) {
                    // A_1c98
                    keyboard_idle_count[0]++;
                    if (keyboard_idle_count[0] >= keyboard_idle_config[0]) {
                        keyboard_idle_count[0] = 0;
                        UEDATX = 1;
                        UEDATX = keyboard_modifier_keys;
					    for (i=0; i<sizeof(kbd_data.data1); i++)
						    UEDATX = kbd_data.data1[i];
					    UEINTX = 0x3A;
                    }
                }
                // A_1cd0
                if (keyboard_idle_config[1] && (UEINTX & (1<<RWAL))) {
                    keyboard_idle_count[1]++;
                    if (keyboard_idle_count[1] >= keyboard_idle_config[1]) {
                        keyboard_idle_count[1] = 0;
                        UEDATX = 2;
                        UEDATX = kbd_data.data2;
					    UEINTX = 0x3A;
                    }
                }
                // A_1d06
                if (keyboard_idle_config[2] && (UEINTX & (1<<RWAL))) {
                    // A_1d16
                    keyboard_idle_count[2]++;
                    if (keyboard_idle_count[2] >= keyboard_idle_config[2]) {
                        keyboard_idle_count[2] = 0;
                        UEDATX = 3;
					    for (i=0; i<sizeof(kbd_data.data3); i++)
						    UEDATX = kbd_data.data3[i];
					    UEINTX = 0x3A;
                    }
                }
            }
#endif
        }
	}
}



// Misc functions to wait for ready and send/receive packets
static inline void usb_wait_in_ready(void)
{
	while (!(UEINTX & (1<<TXINI))) ;
}
static inline void usb_send_in(void)
{
	UEINTX = ~(1<<TXINI);
}
static inline void usb_wait_receive_out(void)
{
	while (!(UEINTX & (1<<RXOUTI))) ;
}
static inline void usb_ack_out(void)
{
	UEINTX = ~(1<<RXOUTI);
}



// USB Endpoint Interrupt - endpoint 0 is handled here.  The
// other endpoints are manipulated by the user-callable
// functions, and the start-of-frame interrupt.
//
// A_1d60
ISR(USB_COM_vect)
{
uint8_t intbits;

UENUM = 0;
intbits = UEINTX;
if (intbits & (1 << RXSTPI))
  {
  uint8_t bmRequestType;
  uint8_t bRequest;
  uint16_t wValue;
  uint16_t wIndex;
  uint16_t wLength;
  uint8_t i, n, len;
  // A_1d92
  bmRequestType = UEDATX;  // R22
  bRequest = UEDATX;       // R19
  wValue = UEDATX;         // R2021
  wValue |= (UEDATX << 8);
  wIndex = UEDATX;         // R2627 
  wIndex |= (UEDATX << 8);
  wLength = UEDATX;        // R2829
  wLength |= (UEDATX << 8);
  // A_1dd6
  // Acknowledge Setup Packet, acknowledge Transmitter Ready
  // According to the documentation, clearing RXOUTI does nothing, but
  // SETTING it would kill the current bank.
  UEINTX = ~((1<<RXSTPI) | (1<<RXOUTI) | (1<<TXINI));
  
  if (bRequest == GET_DESCRIPTOR)
    {
    const uint8_t *desc_addr;
    uint8_t	desc_length;
    // A_1de2
    const uint8_t *list = (const uint8_t *)descriptor_list;
    for (i = 0; ; i++)
      {
      if (i >= NUM_DESC_LIST)
        {
        UECONX = (1<<STALLRQ)|(1<<EPEN);  //stall
        return;
        }
      // A_1dec
      if (pgm_read_word(list) == wValue &&
        pgm_read_word(list + 2) == wIndex)
        {
        // A_1e06
        desc_addr = (const uint8_t *)pgm_read_word(list + 4);
        desc_length = pgm_read_byte(list + 6);
        break;
        }
      list += sizeof(struct descriptor_list_struct);
      }
    // A_1e1a
    len = (wLength < 256) ? wLength : 255;
    if (len > desc_length) len = desc_length;
    do
      {
      // A_1e44
      // wait for host ready for IN packet
      do
        {
        i = UEINTX;
        } while (!(i & ((1<<TXINI)|(1<<RXOUTI))));
        if (i & (1<<RXOUTI)) return;	// abort
        // A_1e5c
        // send IN packet
        n = len < ENDPOINT0_SIZE ? len : ENDPOINT0_SIZE;
        for (i = n; i; i--)
          UEDATX = pgm_read_byte(desc_addr++);
        // A_1e76
        len -= n;
        usb_send_in();
      } while (len || n == ENDPOINT0_SIZE);
      return;
    }

  // A_1e8e
  if ((bmRequestType & 0x7f) == 0x00)   // Standard Device Request
    {
    // SET_DESCRIPTOR missing
    // A_1e96
    if (bRequest == SET_ADDRESS)
      {
      // A_1e9a
      usb_send_in();
      usb_wait_in_ready();
      UDADDR = (uint8_t)(wValue | (1 << ADDEN));
      return;
      }
    else if (bRequest == SET_CONFIGURATION)
      {
      const uint8_t *cfg;
      uint8_t en;
      // A_1eb6
      usb_configuration = (uint8_t)wValue;
      usb_send_in();
      cfg = endpoint_config_table;
      for (i = 1; i <= CONFIG_NUM_ENDPOINTS; i++)
        {
        UENUM = i;
        en = pgm_read_byte(cfg++);
        UECONX = en;
        if (en)
          {
          UECFG0X = pgm_read_byte(cfg++);
          UECFG1X = pgm_read_byte(cfg++);
          }
        }
      UERST = 0x1E;
      UERST = 0;
      return;
      }
    else if (bRequest == GET_CONFIGURATION)
      {
      // A_1f00
      usb_wait_in_ready();
      // A_2122
      UEDATX = usb_configuration;
      // A_2220
      usb_send_in();
      return;
      }
    else if (bRequest == GET_STATUS)
      {
      // A_1f12
      usb_wait_in_ready();
      // A_1f78
      UEDATX = usb_status;
      UEDATX = 0;
      // A_2220
      usb_send_in();
      return;
      }
    else if (bRequest == CLEAR_FEATURE ||
             bRequest == SET_FEATURE)
      {
      // A_1f2c
      if (wValue == 1)
        {
        // A_1f34
        usb_send_in();
        if (bRequest == CLEAR_FEATURE)
          usb_status = 0;
        else
          // A_1f44
          usb_status = 1;
        return;
        }
      }
    }
#if 1
  // Totally missing from original
  else if ((bmRequestType & 0x7f) == 0x01)  // Standard Interface Request
    {
    }
#endif
  // A_1f4c
  else if ((bmRequestType & 0x7f) == 0x02)  // Standard Endpoint Request
    {
    // SYNCH_FRAME missing
    // A_1f52
    if (bRequest == GET_STATUS)
      {
      // A_1f56
      usb_wait_in_ready();
      // A_1f5e
      UENUM = (uint8_t)wIndex;
      i = (UECONX >> STALLRQ) & 1;
      UENUM = 0;
      UEDATX = i;
      UEDATX = 0;
      // A_2220
      usb_send_in();
      return;
      }
    // A_1f82
    else if (bRequest == CLEAR_FEATURE ||
             bRequest == SET_FEATURE)
      {
      // A_1f8c
      if (wValue)
        {
        // A_2228
        UECONX = (1 << STALLRQ) | (1 << EPEN);  // stall
        return;
        }
      // A_1f92
      i = wIndex & 0x7f;
      if (i < 1 || i > CONFIG_NUM_ENDPOINTS)
        {
        // A_2228
        UECONX = (1 << STALLRQ) | (1 << EPEN);  // stall
        return;
        }
      // A_1fa0
      usb_send_in();
      UENUM = i;
      if (bRequest != SET_FEATURE)
        {
        // A_1fb0
        UECONX = (1 << STALLRQC) | (1 << RSTDT) | (1 << EPEN);
        UERST = (1 << i);
        UERST = 0;
        return;
        }
      }
    }

  // A_1fce
  else if ((bmRequestType & 0x7f) == 0x21)  // HID Class Requests
    {
#if INC_IF_BOOT
    // A_20b4
    if (wIndex == IF_Boot)
      {
      // A_20ba
      if (bRequest == HID_GET_REPORT)
        {
        usb_wait_in_ready();
        UEDATX = keyboard_modifier_keys;
        UEDATX = 0;
        for (i = 0; i < sizeof(boot_keys); i++)
          UEDATX = boot_keys[i];
        // A_2220
        usb_send_in();
        return;
        }
      // A_2100
      else if (bRequest == HID_GET_IDLE)
        {
        usb_wait_in_ready();
        UEDATX = boot_idle_config;
        // A_2220
        usb_send_in();
        return;
        }
      // A_2112
      else if (bRequest == HID_GET_PROTOCOL)
        {
        usb_wait_in_ready();
        UEDATX = keyboard_protocol;
        // A_2220
        usb_send_in();
        return;
        }
      // A_2128
      else if (bRequest == HID_SET_REPORT)
        {
        usb_wait_receive_out();
        keyboard_leds = UEDATX;
        usb_ack_out();
        // A_2220
        usb_send_in();
        return;
        }
      // A_2144
      else if (bRequest == HID_SET_IDLE)
        {
        boot_idle_config = (wValue >> 8);
        if (!(wValue >> 8))
          boot_idle_count = 0;
        // A_2220
        usb_send_in();
        return;
        }
      // A_2158
      else if (bRequest == HID_SET_PROTOCOL)
        {
        keyboard_protocol = (wValue & 0xff);
        // A_2220
        usb_send_in();
        return;
        }
      }
#endif
#if INC_IF_KBD
  #if INC_IF_BOOT
    else
  #endif
    // A_1fd4
    if (wIndex == IF_Kbd)
      {
      // A_1fdc
      if (bRequest == HID_GET_REPORT)
        {
        usb_wait_in_ready();
        switch (wValue & 0xff)
          {
          case 1 :
            // A_1fee
            UEDATX = (wValue & 0xff);
            UEDATX = keyboard_modifier_keys;
            for (i = 0; i < sizeof(kbd_data.data1); i++)
              UEDATX = kbd_data.data1[i];
            break;
          case 2 :
            // A_2012
            UEDATX = (wValue & 0xff);
            UEDATX = kbd_data.data2;
            break;
          case 3 :
            // A_2022
            UEDATX = (wValue & 0xff);
            for (i = 0; i < sizeof(kbd_data.data3); i++)
              UEDATX = kbd_data.data3[i];
            break;
          }
        // A_2220
        usb_send_in();
        return;
        }
      // A_203c
      else if (bRequest == HID_SET_REPORT)
        {
        // A_2040
        usb_wait_receive_out();
        i = UEDATX;  // some kind of "ignore 1st byte"?
        // A_2134
        keyboard_leds = UEDATX;
        usb_ack_out();
        // A_2220
        usb_send_in();
        return;
        }
      // A_204e
      else if (bRequest == HID_GET_IDLE)
        {
        usb_wait_in_ready();
        // A_2060
        i = wValue & 0xff;
        if (i)
          UEDATX = keyboard_idle_config[i - 1];
        else
          UEDATX = keyboard_idle_config[0];
        // A_2220
        usb_send_in();
        return;
        }
      // A_206e
      else if (bRequest == HID_SET_IDLE)
        {
        i = wValue & 0xff;
        if (i)
          {
          keyboard_idle_config[i - 1] = (wValue >> 8);
          if (!(wValue >> 8))
            // A_208c
            keyboard_idle_count[i - 1] = 0;
          }
        else
          {
          // A_2094
          for (i = 0; i < sizeof(keyboard_idle_config); i++)
            keyboard_idle_config[i] = (wValue >> 8);
          if (!(wValue >> 8))
            for (i = 0; i < sizeof(keyboard_idle_count); i++)
              keyboard_idle_count[i] = 0;
          }
        // A_2220
        usb_send_in();
        return;
        }
      }
#endif
#if INC_IF_DBG
  #if INC_IF_KBD || INC_IF_BOOT
    else
  #endif
    // A_2164
    if (wIndex == IF_Debug)
      {
      // A_216a
      if (bRequest == HID_GET_REPORT)
        {
        // A_2170
        len = wLength;
        do
          {
          // wait for host ready for IN packet
          do
            {
            i = UEINTX;
            } while (!(i & ((1<<TXINI)|(1<<RXOUTI))));
            if (i & (1<<RXOUTI)) return;	// abort
            // send IN packet
            n = len < ENDPOINT0_SIZE ? len : ENDPOINT0_SIZE;
            for (i = n; i; i--)
              UEDATX = 0;
            len -= n;
            usb_send_in();
          } while (len || n == ENDPOINT0_SIZE);
          return;
        }
      }
#endif
#if INC_IF_RAW
  #if INC_IF_DBG || INC_IF_KBD || INC_IF_BOOT
    else
  #endif
    // A_21b0
    if (wIndex == IF_Raw)
      {
      // A_21b4
      if (bRequest == HID_GET_REPORT)
        {
        // A_21b8
        len = RAWHID_TX_SIZE;
        do
          {
          // wait for host ready for IN packet
          do {
            i = UEINTX;
            } while (!(i & ((1<<TXINI)|(1<<RXOUTI))));
          if (i & (1<<RXOUTI)) return;	// abort
          // A_21d2
          // send IN packet
          n = len < ENDPOINT0_SIZE ? len : ENDPOINT0_SIZE;
          for (i = n; i; i--) {
            // just send zeros
            UEDATX = 0;
            }
          len -= n;
          usb_send_in();
          } while (len || n == ENDPOINT0_SIZE);
          return;
        }
      // A_21f8
      else if (bRequest == HID_SET_REPORT)
        {
        len = RAWHID_RX_SIZE;
        do {
          n = len < ENDPOINT0_SIZE ? len : ENDPOINT0_SIZE;
          usb_wait_receive_out();
          // ignore incoming bytes
          usb_ack_out();
          len -= n;
          } while (len);
        usb_wait_in_ready();
        usb_send_in();
        return;
        }
      }
#endif
    }
  }

// A_2228
UECONX = (1 << STALLRQ) | (1 << EPEN);  // stall
// A_222e
}

/*---------------------------------------------------------------------------*/
/* End of private functions                                                  */
/*---------------------------------------------------------------------------*/


/*****************************************************************************/
/* usb_rawhid_recv : receive a packet, with timeout                          */
/*****************************************************************************/
// A_2254
int8_t usb_rawhid_recv(uint8_t *buffer, uint8_t timeout)
{
#if INC_IF_RAW
uint8_t intr_state;
uint8_t i;

if (usb_configuration == 0)
  return -1;

intr_state = SREG;
cli();
rx_timeout_count = timeout;
UENUM = EP_RawRx;

// A_226c
// wait for data to be available in the FIFO
while (1)
  {
  if (UEINTX & (1<<RWAL))
    break;
  SREG = intr_state;
  if (rx_timeout_count == 0)
    return 0;
  if (!usb_configuration)
    return -1;
  intr_state = SREG;
  cli();
  UENUM = EP_RawRx;
  }
// read bytes from the FIFO
for (i = 0; i < RAWHID_RX_SIZE; i++)
  *buffer++ = UEDATX;

// release the buffer
UEINTX = 0x6B;
SREG = intr_state;
return RAWHID_RX_SIZE;
#else
return 0;
#endif
}

/*****************************************************************************/
/* usb_rawhid_send : send a packet, with timeout                             */
/*****************************************************************************/
// A_22b0
int8_t usb_rawhid_send(const uint8_t *buffer, uint8_t timeout)
{
#if INC_IF_RAW
uint8_t intr_state;
uint8_t i;

// if we're not online (enumerated and configured), error
if (!usb_configuration)
  return -1;
intr_state = SREG;
cli();
tx_timeout_count = timeout;
UENUM = EP_RawTx;
// wait for the FIFO to be ready to accept data
while (1) {
  if (UEINTX & (1<<RWAL)) break;
  SREG = intr_state;
  if (tx_timeout_count == 0) return 0;
  if (!usb_configuration)
    return -1;
  intr_state = SREG;
  cli();
  UENUM = EP_RawTx;
  }
// write bytes from the FIFO
for (i = 0; i < RAWHID_TX_SIZE; i++)
UEDATX = *buffer++;
// transmit it now
UEINTX = 0x3A;
SREG = intr_state;
return RAWHID_TX_SIZE;
#else
return -1;
#endif
}



/*****************************************************************************/
/* kbdtbls.h : keyboard scan code to USB HID scan code translation tables    */
/*****************************************************************************/

#include "intkeys.h"

/*****************************************************************************/
/* Messages coming in from the keyboard                                      */
/*****************************************************************************/

#define KBDM_BUFOVR       0x00    // Key detection error or buffer overrun
#define KBDM_BATOK        0xaa    // BAT returned OK
#define KBDM_EXTENDED     0xe0    // Extended Key is coming in
#define KBDM_EXTENDED2    0xe1    // Extended Key 2 (Pause) is coming in
#define KBDM_ECHO         0xee    // Response to ECHO command
#define KBDM_BREAK        0xf0    // Break code coming in (if missing, it's a Make)
#define KBDM_ACK          0xfa    // Acknowledgement for a command from the host
#define KBDM_ERR          0xfc    // (BAT) Error
#define KBDM_ERR2         0xfd    // BAT Selftest Failed RC2
#define KBDM_RESEND       0xfe    // Keyboard requests resend
#define KBDM_BUFOVR2      0xff    // Key detection error or buffer overrun

/*****************************************************************************/
/* Commands sent to AT/PS2 keyboards                                         */
/*****************************************************************************/

#define ATCMD_RESET       0xff    // reset request; ACK + BATOK after some time is expected
#define ATCMD_RESEND      0xfe    // resend request
// The following 6 are only required to work in Scan code set 3:
#define ATCMD_SETMK       0xfd    // Set Key Type "Make"
#define ATCMD_SETMKBK     0xfc    // Set Key Type "Make/Break" (i.e., no repeat)
#define ATCMD_SETTYPEM    0xfb    // Set Key Type "Typematic"
// The above 3 are followed by list of scan codes and an unused scan code to end the list;
// the keyboard is expected to answer with KBDM_ACK to each
#define ATCMD_SETASTD     0xfa    // Set All Keys back to their default type
#define ATCMD_SETAMK      0xf9    // Set All Keys Type "Make"
#define ATCMD_SETAMKBK    0xf8    // Set All Keys Type "Make/Break"
#define ATCMD_SETATYPEM   0xf7    // Set All Keys Type "Typematic"
#define ATCMD_SETDEFAULT  0xf6    // Reset Keyboard to Default State
#define ATCMD_DISABLE     0xf5    // Reset Keyboard to Default State and Disable scanning
#define ATCMD_ENABLE      0xf4    // (Re-)Enable Scanning after it has been disabled
#define ATCMD_SETRATE     0xf3    // Set Typematic rate/delay
#define ATCMD_READID      0xf2    // Keyboard is expected to respond with its 2-byte ID (ACK before 1st byte)
#define ATCMD_SCANSET     0xf0    // Set Scancode Set (<- ACK/Err -> [new set(1|2|3) <- ACK/Err | 0 <- ACK+current|Err])
#define ATCMD_ECHO        0xee    // Send Echo (<- ECHO)
#define ATCMD_SETLEDS     0xed    // Set LED State (<- ACK -> Caps:2+Num:1+Scroll:0 <- ACK)

/*****************************************************************************/
/* Known keyboard IDs                                                        */
/*****************************************************************************/
// gleaned from http://www.win.tue.nl/~aeb/linux/kbd/scancodes-10.html
#define KBDID_AT          0xab83  // IBM AT
#define KBDID_SKBD        0xab84  // Short Keyboard: IBM Space Saver, Thinkpad etc.
#define KBDID_HCON        0xab85  // 122-key host-connected keyboard
#define KBDID_122         0xab86  // PS/2-compatible 122-key keyboards
#define KBDID_JAPG        0xab90  // "old Japanese 'G' keyboard"
#define KBDID_JAPP        0xab91  // "old Japanese 'P' keyboard"
#define KBDID_JAPA        0xab92  // "old Japanese 'A' keyboard"
#define KBDID_IBM_RT      0xbfb0  // IBM RT PC keyboard (with "special" LED command)
#define KBDID_TERM122     0xbfbf  // 122-key IBM 1390876 without jumpers (can be reconfigured!)


/*---------------------------------------------------------------------------*/
/* The rest is only relevant for the keyboard input handler                  */
/*---------------------------------------------------------------------------*/

#ifdef INCLUDE_KBD_TRANS_TABLES
/*****************************************************************************/
/* keyboard codeset 1 -> HIDX translation table                              */
/*****************************************************************************/
// A_00ac 
uint8_t PROGMEM kbd_ttbl_set1[0x80] =
  {
  KEY_UNASSIGNED,      KEY_ESC,             KEY_1,           KEY_2,                // 00..03
  KEY_3,               KEY_4,               KEY_5,           KEY_6,                // 04..07
  KEY_7,               KEY_8,               KEY_9,           KEY_0,                // 08..0B
  KEY_MINUS,           KEY_EQUAL,           KEY_BACKSPACE,   KEY_TAB,              // 0C..0F
  KEY_Q,               KEY_W,               KEY_E,           KEY_R,                // 10..13
  KEY_T,               KEY_Y,               KEY_U,           KEY_I,                // 14..17
  KEY_O,               KEY_P,               KEY_LEFT_BRACE,  KEY_RIGHT_BRACE,      // 18..1B
  KEY_ENTER,           KEY_LCTRL,           KEY_A,           KEY_S,                // 1C..1F
  KEY_D,               KEY_F,               KEY_G,           KEY_H,                // 20..23
  KEY_J,               KEY_K,               KEY_L,           KEY_SEMICOLON,        // 24..27
  KEY_QUOTE,           KEY_BACK_QUOTE,      KEY_LSHIFT,      KEY_BACKSLASH,        // 28..2b
  KEY_Z,               KEY_X,               KEY_C,           KEY_V,                // 2c..2f
  KEY_B,               KEY_N,               KEY_M,           KEY_COMMA,            // 30..33
  KEY_PERIOD,          KEY_SLASH,           KEY_RSHIFT,      KEY_PAD_ASTERIX,      // 34..37
  KEY_LALT,            KEY_SPACE,           KEY_CAPS_LOCK,   KEY_F1,               // 38..3B
  KEY_F2,              KEY_F3,              KEY_F4,          KEY_F5,               // 3C..3F
  KEY_F6,              KEY_F7,              KEY_F8,          KEY_F9,               // 40..43
  KEY_F10,             KEY_NUM_LOCK,        KEY_SCROLL_LOCK, KEY_PAD_7,            // 44..47
  KEY_PAD_8,           KEY_PAD_9,           KEY_PAD_MINUS,   KEY_PAD_4,            // 48..4B
  KEY_PAD_5,           KEY_PAD_6,           KEY_PAD_PLUS,    KEY_PAD_1,            // 4C..4F
  KEY_PAD_2,           KEY_PAD_3,           KEY_PAD_0,       KEY_PAD_PERIOD,       // 50..53
  KEY_EXTRA_SYSRQ,     KEY_EXTRA_F8,        KEY_EUROPE_2,    KEY_F11,              // 54..57
  KEY_F12,             KEY_PAD_EQUALS,      KEY_FAKE_01,     KEY_EXTRA_PAD_PLUS,   // 58..5B
  KEY_INTERNATIONAL_6, KEY_EXTRA_F1,        KEY_EXTRA_F2,    KEY_EXTRA_F3,         // 5C..5F
  KEY_EXTRA_F4,        KEY_EXTRA_F5,        KEY_EXTRA_F6,    KEY_EXTRA_F7,         // 60..63
  KEY_F13,             KEY_F14,             KEY_F15,         KEY_F16,              // 64..67
  KEY_F17,             KEY_F18,             KEY_F19,         KEY_F20,              // 68..6B
  KEY_F21,             KEY_F22,             KEY_F23,         KEY_FAKE_18,          // 6C..6F
  KEY_INTERNATIONAL_2, KEY_EXTRA_LALT,      KEY_EXTRA_RALT,  KEY_INTERNATIONAL_1,  // 70..73
  KEY_EXTRA_EUROPE_2,  KEY_EXTRA_BACKSLASH, KEY_F24,         KEY_LANG_4,           // 74..77
  KEY_LANG_3,          KEY_INTERNATIONAL_4, KEY_EXTRA_F9,    KEY_INTERNATIONAL_5,  // 78..7B
  KEY_EXTRA_INSERT,    KEY_INTERNATIONAL_3, KEY_PAD_COMMA,   KEY_EXTRA_F10         // 7C..7F
  };

/*****************************************************************************/
/* keyboard codeset 2 -> HIDX translation table                              */
/*****************************************************************************/
// A_012c
uint8_t PROGMEM kbd_ttbl_set2[0x85] =
  {
  KEY_OVERRUN_ERROR,   KEY_F9,              KEY_UNASSIGNED,  KEY_F5,               // 00..03
  KEY_F3,              KEY_F1,              KEY_F2,          KEY_F12,              // 04..07
  KEY_F13,             KEY_F10,             KEY_F8,          KEY_F6,               // 08..0B
  KEY_F4,              KEY_TAB,             KEY_BACK_QUOTE,  KEY_PAD_EQUALS,       // 0C..0F
  KEY_F14,             KEY_LALT,            KEY_LSHIFT,      KEY_INTERNATIONAL_2,  // 10..13
  KEY_LCTRL,           KEY_Q,               KEY_1,           KEY_FAKE_01,          // 14..17
  KEY_F15,             KEY_EXTRA_LALT,      KEY_Z,           KEY_S,                // 18..1B
  KEY_A,               KEY_W,               KEY_2,           KEY_EXTRA_PAD_PLUS,   // 1C..1F
  KEY_F16,             KEY_C,               KEY_X,           KEY_D,                // 20..23
  KEY_E,               KEY_4,               KEY_3,           KEY_INTERNATIONAL_6,  // 24..27
  KEY_F17,             KEY_SPACE,           KEY_V,           KEY_F,                // 28..2B
  KEY_T,               KEY_R,               KEY_5,           KEY_EXTRA_F1,         // 2C..2F
  KEY_F18,             KEY_N,               KEY_B,           KEY_H,                // 30..33
  KEY_G,               KEY_Y,               KEY_6,           KEY_EXTRA_F2,         // 34..37
  KEY_F19,             KEY_EXTRA_RALT,      KEY_M,           KEY_J,                // 38..3B
  KEY_U,               KEY_7,               KEY_8,           KEY_EXTRA_F3,         // 3C..3F
  KEY_F20,             KEY_COMMA,           KEY_K,           KEY_I,                // 40..43
  KEY_O,               KEY_0,               KEY_9,           KEY_EXTRA_F4,         // 44..47
  KEY_F21,             KEY_PERIOD,          KEY_SLASH,       KEY_L,                // 48..4B
  KEY_SEMICOLON,       KEY_P,               KEY_MINUS,       KEY_EXTRA_F5,         // 4C..4F
  KEY_F22,             KEY_INTERNATIONAL_1, KEY_QUOTE,       KEY_EXTRA_EUROPE_2,   // 50..53
  KEY_LEFT_BRACE,      KEY_EQUAL,           KEY_EXTRA_F6,    KEY_F23,              // 54..57
  KEY_CAPS_LOCK,       KEY_RSHIFT,          KEY_ENTER,       KEY_RIGHT_BRACE,      // 58..5B
  KEY_EXTRA_BACKSLASH, KEY_BACKSLASH,       KEY_EXTRA_F7,    KEY_F24,              // 5C..5F
  KEY_EXTRA_F8,        KEY_EUROPE_2,        KEY_LANG_4,      KEY_LANG_3,           // 60..63
  KEY_INTERNATIONAL_4, KEY_EXTRA_F9,        KEY_BACKSPACE,   KEY_INTERNATIONAL_5,  // 64..67
  KEY_EXTRA_INSERT,    KEY_PAD_1,           KEY_INTERNATIONAL_3,  KEY_PAD_4,       // 68..6B
  KEY_PAD_7,           KEY_PAD_COMMA,       KEY_EXTRA_F10,   KEY_FAKE_18,          // 6C..6F
  KEY_PAD_0,           KEY_PAD_PERIOD,      KEY_PAD_2,       KEY_PAD_5,            // 70..73
  KEY_PAD_6,           KEY_PAD_8,           KEY_ESC,         KEY_NUM_LOCK,         // 74..77
  KEY_F11,             KEY_PAD_PLUS,        KEY_PAD_3,       KEY_PAD_MINUS,        // 78..7B
  KEY_PAD_ASTERIX,     KEY_PAD_9,           KEY_SCROLL_LOCK, KEY_UNASSIGNED,       // 7C..7F
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_F7,               // 80..83
  KEY_EXTRA_SYSRQ                                                                  // 84
  };

/*****************************************************************************/
/* keyboard codeset 4 (E0 + scan code) -> HIDX translation table             */
/*****************************************************************************/
// A_01b1
uint8_t PROGMEM kbd_ttbl_set2ex[0x7f] =
  {
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 00..03
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 04..07
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 08..0B
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 0C..0F
  KEY_MEDIA_WWW_SEARCH,KEY_RALT,            KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 10..13
  KEY_RCTRL,           KEY_MEDIA_PREV_TRACK,KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 14..17
  KEY_MEDIA_WWW_FAVORITES, KEY_UNASSIGNED,  KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 18..1B
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_LGUI,             // 1C..1F
  KEY_MEDIA_WWW_REFRESH,KEY_MEDIA_VOLUME_DOWN, KEY_UNASSIGNED, KEY_MEDIA_MUTE,     // 20..23
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_RGUI,             // 24..27
  KEY_MEDIA_WWW_STOP,  KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_MEDIA_CALCULATOR, // 28..2B
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_APP,              // 2C..2F
  KEY_MEDIA_WWW_FORWARD, KEY_UNASSIGNED,    KEY_MEDIA_VOLUME_UP, KEY_UNASSIGNED,   // 30..33
  KEY_MEDIA_PLAY_PAUSE,KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_POWER,            // 34..37
  KEY_MEDIA_WWW_BACK,  KEY_UNASSIGNED,      KEY_MEDIA_WWW_HOME, KEY_MEDIA_STOP,    // 38..3B
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_SYSTEM_SLEEP,     // 3C..3F
  KEY_MEDIA_MY_COMPUTER, KEY_UNASSIGNED,    KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 40..43
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 44..47
  KEY_MEDIA_MAIL,      KEY_UNASSIGNED,      KEY_PAD_SLASH,   KEY_UNASSIGNED,       // 48..4B
  KEY_UNASSIGNED,      KEY_MEDIA_NEXT_TRACK, KEY_UNASSIGNED, KEY_UNASSIGNED,       // 4C..4F
  KEY_MEDIA_MEDIA_SELECT, KEY_UNASSIGNED,   KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 50..53
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 54..57
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_PAD_ENTER,   KEY_UNASSIGNED,       // 58..5B
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_SYSTEM_WAKE, KEY_UNASSIGNED,       // 5C..5F
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 60..63
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 64..67
  KEY_UNASSIGNED,      KEY_END,             KEY_UNASSIGNED,  KEY_LEFT,             // 68..6B
  KEY_HOME,            KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 6C..6F
  KEY_INSERT,          KEY_DELETE,          KEY_DOWN,        KEY_UNASSIGNED,       // 70..73
  KEY_RIGHT,           KEY_UP,              KEY_UNASSIGNED,  KEY_UNASSIGNED,       // 74..77
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_PAGE_DOWN,   KEY_UNASSIGNED,       // 78..7B
  KEY_PRINTSCREEN,     KEY_PAGE_UP,         KEY_PAUSE                              // 7C..7E
  };

/*****************************************************************************/
/* keyboard codeset 3 -> HIDX translation table                              */
/*****************************************************************************/
// A_0230
uint8_t PROGMEM kbd_ttbl_set3[0x85] =
  {
  KEY_OVERRUN_ERROR,   KEY_EXTRA_F9,        KEY_UNASSIGNED,  KEY_EXTRA_F5,         // 00..03
  KEY_EXTRA_F3,        KEY_EXTRA_F1,        KEY_EXTRA_F2,    KEY_F1,               // 04..07
  KEY_F13,             KEY_EXTRA_F10,       KEY_EXTRA_F8,    KEY_EXTRA_F6,         // 08..0B
  KEY_EXTRA_F4,        KEY_TAB,             KEY_BACK_QUOTE,  KEY_F2,               // 0C..0F
  KEY_F14,             KEY_LCTRL,           KEY_LSHIFT,      KEY_EUROPE_2,         // 10..13
  KEY_CAPS_LOCK,       KEY_Q,               KEY_1,           KEY_F3,               // 14..17
  KEY_F15,             KEY_LALT,            KEY_Z,           KEY_S,                // 18..1B
  KEY_A,               KEY_W,               KEY_2,           KEY_F4,               // 1C..1F
  KEY_F16,             KEY_C,               KEY_X,           KEY_D,                // 20..23
  KEY_E,               KEY_4,               KEY_3,           KEY_F5,               // 24..27
  KEY_F17,             KEY_SPACE,           KEY_V,           KEY_F,                // 28..2B
  KEY_T,               KEY_R,               KEY_5,           KEY_F6,               // 2C..2F
  KEY_F18,             KEY_N,               KEY_B,           KEY_H,                // 30..33
  KEY_G,               KEY_Y,               KEY_6,           KEY_F7,               // 34..37
  KEY_F19,             KEY_RALT,            KEY_M,           KEY_J,                // 38..3B
  KEY_U,               KEY_7,               KEY_8,           KEY_F8,               // 3C..3F
  KEY_F20,             KEY_COMMA,           KEY_K,           KEY_I,                // 40..43
  KEY_O,               KEY_0,               KEY_9,           KEY_F9,               // 44..47
  KEY_F21,             KEY_PERIOD,          KEY_SLASH,       KEY_L,                // 48..4B
  KEY_SEMICOLON,       KEY_P,               KEY_MINUS,       KEY_F10,              // 4C..4F
  KEY_F22,             KEY_INTERNATIONAL_1, KEY_QUOTE,       KEY_EUROPE_1,         // 50..53
  KEY_LEFT_BRACE,      KEY_EQUAL,           KEY_F11,         KEY_F23,              // 54..57
  KEY_RCTRL,           KEY_RSHIFT,          KEY_ENTER,       KEY_RIGHT_BRACE,      // 58..5B
  KEY_BACKSLASH,       KEY_INTERNATIONAL_3, KEY_F12,         KEY_F24,              // 5C..5F
  KEY_DOWN,            KEY_LEFT,            KEY_LANG_4,      KEY_UP,               // 60..63
  KEY_DELETE,          KEY_END,             KEY_BACKSPACE,   KEY_INSERT,           // 64..67
  KEY_EXTRA_INSERT,    KEY_PAD_1,           KEY_RIGHT,       KEY_PAD_4,            // 68..6B
  KEY_PAD_7,           KEY_PAGE_DOWN,       KEY_HOME,        KEY_PAGE_UP,          // 6C..6F
  KEY_PAD_0,           KEY_PAD_PERIOD,      KEY_PAD_2,       KEY_PAD_5,            // 70..73
  KEY_PAD_6,           KEY_PAD_8,           KEY_ESC,         KEY_NUM_LOCK,         // 74..77
  KEY_EXTRA_PAD_PLUS,  KEY_PAD_PLUS,        KEY_PAD_3,       KEY_PAD_MINUS,        // 78..7B
  KEY_PAD_ASTERIX,     KEY_PAD_9,           KEY_SCROLL_LOCK, KEY_UNASSIGNED,       // 7C..7F
  KEY_UNASSIGNED,      KEY_UNASSIGNED,      KEY_UNASSIGNED,  KEY_EXTRA_F7,         // 80..83
  KEY_EXTRA_SYSRQ                                                                  // 84
  };
#endif // defined(INCLUDE_KBD_TRANS_TABLES)

/*****************************************************************************/
/* intkeys.h : internal key code names (modified HID code set 7 AKA HIDX)    */
/*****************************************************************************/

#ifndef _intkeys_h_
#define _intkeys_h_

// special codes
#define KEY_UNASSIGNED          0x00  // Unassigned
#define KEY_OVERRUN_ERROR       0x01  // Overrun error
#define KEY_POST_FAIL           0x02  // POST Fail
#define KEY_ERROR_UNDEFINED     0x03  // ErrorUndefined
// standard HID codes
#define KEY_A                   0x04  // a A
#define KEY_B                   0x05  // b B
#define KEY_C                   0x06  // c C
#define KEY_D                   0x07  // d D
#define KEY_E                   0x08  // e E
#define KEY_F                   0x09  // f F
#define KEY_G                   0x0A  // g G
#define KEY_H                   0x0B  // h H
#define KEY_I                   0x0C  // i I
#define KEY_J                   0x0D  // j J
#define KEY_K                   0x0E  // k K
#define KEY_L                   0x0F  // l L
#define KEY_M                   0x10  // m M
#define KEY_N                   0x11  // n N
#define KEY_O                   0x12  // o O
#define KEY_P                   0x13  // p P
#define KEY_Q                   0x14  // q Q
#define KEY_R                   0x15  // r R
#define KEY_S                   0x16  // s S
#define KEY_T                   0x17  // t T
#define KEY_U                   0x18  // u U
#define KEY_V                   0x19  // v V
#define KEY_W                   0x1A  // w W
#define KEY_X                   0x1B  // x X
#define KEY_Y                   0x1C  // y Y
#define KEY_Z                   0x1D  // z Z
#define KEY_1                   0x1E  // 1 !
#define KEY_2                   0x1F  // 2 @
#define KEY_3                   0x20  // 3 #
#define KEY_4                   0x21  // 4 $
#define KEY_5                   0x22  // 5 %
#define KEY_6                   0x23  // 6 ^
#define KEY_7                   0x24  // 7 &
#define KEY_8                   0x25  // 8 *
#define KEY_9                   0x26  // 9 (
#define KEY_0                   0x27  // 0 )
#define KEY_ENTER               0x28  // Return
#define KEY_ESC                 0x29  // Escape
#define KEY_BACKSPACE           0x2A  // Backspace
#define KEY_TAB                 0x2B  // Tab
#define KEY_SPACE               0x2C  // Space
#define KEY_MINUS               0x2D  // - _
#define KEY_EQUAL               0x2E  // = +
#define KEY_LEFT_BRACE          0x2F  // [ {
#define KEY_RIGHT_BRACE         0x30  // ] }
#define KEY_BACKSLASH           0x31  // \ |
#define KEY_EUROPE_1            0x32  // Europe 1 (use BACKSLASH instead)
#define KEY_SEMICOLON           0x33  // ; :
#define KEY_QUOTE               0x34  // ' "
#define KEY_BACK_QUOTE          0x35  // ` ~
#define KEY_COMMA               0x36  // , <
#define KEY_PERIOD              0x37  // . >
#define KEY_SLASH               0x38  // / ?
#define KEY_CAPS_LOCK           0x39  // Caps Lock
#define KEY_F1                  0x3A  // F1
#define KEY_F2                  0x3B  // F2
#define KEY_F3                  0x3C  // F3
#define KEY_F4                  0x3D  // F4
#define KEY_F5                  0x3E  // F5
#define KEY_F6                  0x3F  // F6
#define KEY_F7                  0x40  // F7
#define KEY_F8                  0x41  // F8
#define KEY_F9                  0x42  // F9
#define KEY_F10                 0x43  // F10
#define KEY_F11                 0x44  // F11
#define KEY_F12                 0x45  // F12
#define KEY_PRINTSCREEN         0x46  // Print Screen
#define KEY_SCROLL_LOCK         0x47  // Scroll Lock
#define KEY_PAUSE               0x48  // Pause
#define KEY_INSERT              0x49  // Insert
#define KEY_HOME                0x4A  // Home
#define KEY_PAGE_UP             0x4B  // Page Up
#define KEY_DELETE              0x4C  // Delete
#define KEY_END                 0x4D  // End
#define KEY_PAGE_DOWN           0x4E  // Page Down
#define KEY_RIGHT               0x4F  // Right Arrow
#define KEY_LEFT                0x50  // Left Arrow
#define KEY_DOWN                0x51  // Down Arrow
#define KEY_UP                  0x52  // Up Arrow
#define KEY_NUM_LOCK            0x53  // Num Lock
#define KEY_PAD_SLASH           0x54  // Keypad /
#define KEY_PAD_ASTERIX         0x55  // Keypad *
#define KEY_PAD_MINUS           0x56  // Keypad -
#define KEY_PAD_PLUS            0x57  // Keypad +
#define KEY_PAD_ENTER           0x58  // Keypad Enter
#define KEY_PAD_1               0x59  // Keypad 1 End
#define KEY_PAD_2               0x5A  // Keypad 2 Down
#define KEY_PAD_3               0x5B  // Keypad 3 PageDn
#define KEY_PAD_4               0x5C  // Keypad 4 Left
#define KEY_PAD_5               0x5D  // Keypad 5
#define KEY_PAD_6               0x5E  // Keypad 6 Right
#define KEY_PAD_7               0x5F  // Keypad 7 Home
#define KEY_PAD_8               0x60  // Keypad 8 Up
#define KEY_PAD_9               0x61  // Keypad 9 PageUp
#define KEY_PAD_0               0x62  // Keypad 0 Insert
#define KEY_PAD_PERIOD          0x63  // Keypad . Delete
#define KEY_EUROPE_2            0x64  // Europe 2
#define KEY_APP                 0x65  // App (Windows Menu)
#define KEY_POWER               0x66  // Keyboard Power
#define KEY_PAD_EQUALS          0x67  // Keypad =
#define KEY_F13                 0x68  // F13
#define KEY_F14                 0x69  // F14
#define KEY_F15                 0x6A  // F15
#define KEY_F16                 0x6B  // F16
#define KEY_F17                 0x6C  // F17
#define KEY_F18                 0x6D  // F18
#define KEY_F19                 0x6E  // F19
#define KEY_F20                 0x6F  // F20
#define KEY_F21                 0x70  // F21
#define KEY_F22                 0x71  // F22
#define KEY_F23                 0x72  // F23
#define KEY_F24                 0x73  // F24
#define KEY_EXECUTE             0x74  // Keyboard Execute
#define KEY_HELP                0x75  // Keyboard Help
#define KEY_MENU                0x76  // Keyboard Menu
#define KEY_SELECT              0x77  // Keyboard Select
#define KEY_STOP                0x78  // Keyboard Stop
#define KEY_AGAIN               0x79  // Keyboard Again
#define KEY_UNDO                0x7A  // Keyboard Undo
#define KEY_CUT                 0x7B  // Keyboard Cut
#define KEY_COPY                0x7C  // Keyboard Copy
#define KEY_PASTE               0x7D  // Keyboard Paste
#define KEY_FIND                0x7E  // Keyboard Find
#define KEY_MUTE                0x7F  // Keyboard Mute
#define KEY_VOLUME_UP           0x80  // Keyboard Volume Up
#define KEY_VOLUME_DOWN         0x81  // Keyboard Volume Dn
#define KEY_LOCKING_CAPS_LOCK   0x82  // Keyboard Locking Caps Lock
#define KEY_LOCKING_NUM_LOCK    0x83  // Keyboard Locking Num Lock
#define KEY_LOCKING_SCROLL_LOCK 0x84  // Keyboard Locking Scroll Lock
#define KEY_PAD_COMMA           0x85  // Keypad comma (Brazilian Keypad .)
#define KEY_EQUAL_SIGN          0x86  // Keyboard Equal Sign
#define KEY_INTERNATIONAL_1     0x87  // Keyboard Int'l 1 (Ro)
#define KEY_INTERNATIONAL_2     0x88  // Keyboard Intl'2 (Katakana/Hiragana)
#define KEY_INTERNATIONAL_3     0x89  // Keyboard Int'l 2 (Yen)
#define KEY_INTERNATIONAL_4     0x8A  // Keyboard Int'l 4 (Henkan)
#define KEY_INTERNATIONAL_5     0x8B  // Keyboard Int'l 5 (Muhenkan)
#define KEY_INTERNATIONAL_6     0x8C  // Keyboard Int'l 6 (PC9800 Keypad comma)
#define KEY_INTERNATIONAL_7     0x8D  // Keyboard Int'l 7
#define KEY_INTERNATIONAL_8     0x8E  // Keyboard Int'l 8
#define KEY_INTERNATIONAL_9     0x8F  // Keyboard Int'l 9
#define KEY_LANG_1              0x90  // Keyboard Lang 1 (Hangul/English)
#define KEY_LANG_2              0x91  // Keyboard Lang 2 (Hanja)
#define KEY_LANG_3              0x92  // Keyboard Lang 3 (Katakana)
#define KEY_LANG_4              0x93  // Keyboard Lang 4 (Hiragana)
#define KEY_LANG_5              0x94  // Keyboard Lang 5 (Zenkaku/Hankaku)
#define KEY_LANG_6              0x95  // Keyboard Lang 6
#define KEY_LANG_7              0x96  // Keyboard Lang 7
#define KEY_LANG_8              0x97  // Keyboard Lang 8
#define KEY_LANG_9              0x98  // Keyboard Lang 9
#define KEY_ALTERNATE_ERASE     0x99  // Keyboard Alternate Erase
#define KEY_SYSREQ_ATTN         0x9A  // Keyboard SysReq/Attention
#define KEY_CANCEL              0x9B  // Keyboard Cancel
#define KEY_CLEAR               0x9C  // Keyboard Clear (use DELETE instead)
#define KEY_PRIOR               0x9D  // Keyboard Prior
#define KEY_RETURN              0x9E  // Keyboard Return
#define KEY_SEPARATOR           0x9F  // Keyboard Separator
#define KEY_OUT                 0xA0  // Keyboard Out
#define KEY_OPER                0xA1  // Keyboard Oper
#define KEY_CLEAR_AGAIN         0xA2  // Keyboard Clear/Again
#define KEY_CRSEL_PROPS         0xA3  // Keyboard CrSel/Props
#define KEY_EXSEL               0xA4  // Keyboard ExSel
// A5-A7 are invalid
// Power code area
#define KEY_SYSTEM_POWER        0xA8  // System Power
#define KEY_SYSTEM_SLEEP        0xA9  // System Sleep
#define KEY_SYSTEM_WAKE         0xAA  // System Wake
// Internal use area - must be remapped to appear on USB out
#define KEY_AUX1                0xAB  // Auxiliary key 1
#define KEY_AUX2                0xAC  // Auxiliary key 2
#define KEY_AUX3                0xAD  // Auxiliary key 3
#define KEY_AUX4                0xAE  // Auxiliary key 4
#define KEY_AUX5                0xAF  // Auxiliary key 5
#define KEY_FAKE_01             0xB0  // legacy from earlier version?
#define KEY_EXTRA_LALT          0xB1  // AT-F extra pad lhs of space
#define KEY_EXTRA_PAD_PLUS      0xB2  // Term extra pad bottom of keypad +
#define KEY_EXTRA_RALT          0xB3  // AT-F extra pad rhs of space
#define KEY_EXTRA_EUROPE_2      0xB4  // AT-F extra pad lhs of enter
#define KEY_EXTRA_BACKSLASH     0xB5  // AT-F extra pad top of enter
#define KEY_EXTRA_INSERT        0xB6  // AT-F extra pad lhs of Insert
#define KEY_EXTRA_F1            0xB7  // 122-key Terminal lhs F1
#define KEY_EXTRA_F2            0xB8  // 122-key Terminal lhs F2
#define KEY_EXTRA_F3            0xB9  // 122-key Terminal lhs F3
#define KEY_EXTRA_F4            0xBA  // 122-key Terminal lhs F4
#define KEY_EXTRA_F5            0xBB  // 122-key Terminal lhs F5
#define KEY_EXTRA_F6            0xBC  // 122-key Terminal lhs F6
#define KEY_EXTRA_F7            0xBD  // 122-key Terminal lhs F7
#define KEY_EXTRA_F8            0xBE  // 122-key Terminal lhs F8
#define KEY_EXTRA_F9            0xBF  // 122-key Terminal lhs F9
#define KEY_EXTRA_F10           0xC0  // 122-key Terminal lhs F10
#define KEY_FAKE_18             0xC1  // legacy from earlier version?
#define KEY_EXTRA_SYSRQ         0xC2  // Sys Req (AT 84-key)
// C3-CF unused
#define KEY_FN1                 0xD0  // Function layer key 1
#define KEY_FN2                 0xD1  // Function layer key 2
#define KEY_FN3                 0xD2  // Function layer key 3
#define KEY_FN4                 0xD3  // Function layer key 4
#define KEY_FN5                 0xD4  // Function layer key 5
#define KEY_FN6                 0xD5  // Function layer key 6
#define KEY_FN7                 0xD6  // Function layer key 7
#define KEY_FN8                 0xD7  // Function layer key 8
#define KEY_SELECT_0            0xD8  // Select reset
#define KEY_SELECT_1            0xD9  // Select 1 toggle
#define KEY_SELECT_2            0xDA  // Select 2 toggle
#define KEY_SELECT_3            0xDB  // Select 3 toggle
#define KEY_SELECT_4            0xDC  // Select 4 toggle
#define KEY_SELECT_5            0xDD  // Select 5 toggle
#define KEY_SELECT_6            0xDE  // Select 6 toggle
#define KEY_SELECT_7            0xDF  // Select 7 toggle
// Modifier area
#define KEY_LCTRL               0xE0  // Left Control
#define KEY_LSHIFT              0xE1  // Left Shift
#define KEY_LALT                0xE2  // Left Alt
#define KEY_LGUI                0xE3  // Left GUI (Left Windows)
#define KEY_RCTRL               0xE4  // Right Control
#define KEY_RSHIFT              0xE5  // Right Shift
#define KEY_RALT                0xE6  // Right Alt
#define KEY_RGUI                0xE7  // Right GUI (Right Windows)
// Multimedia area
#define KEY_MEDIA_NEXT_TRACK    0xE8  // Scan Next Track
#define KEY_MEDIA_PREV_TRACK    0xE9  // Scan Previous Track
#define KEY_MEDIA_STOP          0xEA  // Stop
#define KEY_MEDIA_PLAY_PAUSE    0xEB  // Play/ Pause
#define KEY_MEDIA_MUTE          0xEC  // Mute
#define KEY_MEDIA_BASS_BOOST    0xED  // Bass Boost
#define KEY_MEDIA_LOUDNESS      0xEE  // Loudness
#define KEY_MEDIA_VOLUME_UP     0xEF  // Volume Up
#define KEY_MEDIA_VOLUME_DOWN   0xF0  // Volume Down
#define KEY_MEDIA_BASS_UP       0xF1  // Bass Up
#define KEY_MEDIA_BASS_DOWN     0xF2  // Bass Down
#define KEY_MEDIA_TREBLE_UP     0xF3  // Treble Up
#define KEY_MEDIA_TREBLE_DOWN   0xF4  // Treble Down
#define KEY_MEDIA_MEDIA_SELECT  0xF5  // Media Select
#define KEY_MEDIA_MAIL          0xF6  // Mail
#define KEY_MEDIA_CALCULATOR    0xF7  // Calculator
#define KEY_MEDIA_MY_COMPUTER   0xF8  // My Computer
#define KEY_MEDIA_WWW_SEARCH    0xF9  // WWW Search
#define KEY_MEDIA_WWW_HOME      0xFA  // WWW Home
#define KEY_MEDIA_WWW_BACK      0xFB  // WWW Back
#define KEY_MEDIA_WWW_FORWARD   0xFC  // WWW Forward
#define KEY_MEDIA_WWW_STOP      0xFD  // WWW Stop
#define KEY_MEDIA_WWW_REFRESH   0xFE  // WWW Refresh
#define KEY_MEDIA_WWW_FAVORITES 0xFF  // WWW Favorites

// Masks for the special areas
#define KEY_AREA_MASK           0xF8
#define IS_FN_KEY(keyid)        (((keyid) & KEY_AREA_MASK) == KEY_FN1)
#define IS_SELECT_KEY(keyid)    (((keyid) & KEY_AREA_MASK) == KEY_SELECT_0)
#define IS_MODIFIER_KEY(keyid)  (((keyid) & KEY_AREA_MASK) == KEY_LCTRL)

#endif /* defined _intkeys_h */

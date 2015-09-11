EEPROM Layout:
==============

Address Len  Content
0000      2  "SC"
0002      2  Length of data area starting... somewhere yet undefined
0004      1  Settings version 
0005      1  Settings sub-version (must be < 2)
0006      1  Predefined keyboard layout:
             Bits 0..3 : keyboard mode
             Bits 4..7: keyboard_codeset; if != 0
             (keyboard_codeset << 4) | keyboard_mode
             if keyboard_codeset is set, keyboard_mode is overruled:
               if keyboard_codeset == 1, keyboard mode is 2 else 1
0008      ?  Start of configuration blocks

Each configuration block starts with a header:
0000      1  Length
0001      1  Type Mask:
               Bit 2..0 : type (0=layers 1=remaps 2=macros)
               Bit 5..3 : select this is for(?check)
               Bit 6    : if set, header is followed by 1 byte bit set of codesets
               Bit 7    : if set, header (plus codesets byte if bit 6)
                          is followed by 2 bytes keyboard ID

Macro blocks contain a set of macros. Each macro has at least 5 bytes:
0000      1  HID code this is for
0001      1  Bit set of modifiers that must be set
0002      1  Bit set of modifiers that must be set OR clear
             (logic not completely understood yet - some additional mangling of upper nibble)
0003      1  Bit 0..5 : # macro commands for Make
0004      1  Bit 0..5 : # macro commands for Break
             Can contain a flag in bit 7; if set,
             the current modifier state is saved before executing the macro and restored afterwards.
             Can be suppressed by specifying norestoremeta.
             Soarer's scdis v1.10 has a bug here, BTW - it always shows "norestoremeta".
This header is followed by (0003*2) bytes for the Make macro commands
                       and (0003*2) bytes for the Break macro commands
Each macro command consists of 2 bytes:
0000      1  macro command
             one of the following:
               01 : PRESS
               02 :	MAKE
               03 :	BREAK
               04 :	ASSIGN_META
               05 :	SET_META
               06 :	CLEAR_META
               07 :	TOGGLE_META
               08 :	POP_META
               09 :	POP_ALL_META
               0A :	DELAY
               0B :	CLEAR_ALL
               0C :	BOOT
0001      1  argument (HID, modifier or other argument value, like delay in ms)
               
Keyboard IDs (http://www.win.tue.nl/~aeb/linux/kbd/scancodes-10.html)
============

Keyboards do report an ID as a reply to the command f2.
(An XT keyboard does not reply, an AT keyboard only replies with an ACK.)
An MF2 AT keyboard reports ID ab 83.

Many short keyboards, like IBM ThinkPads, and Spacesaver keyboards, send ab 84.

Several 122-key keyboards are reported to send ab 86.
Here translated and untranslated values coincide.
(Reports mention "122-Key Enhanced Keyboard", "standard 122-key keyboard",
"122 Key Mainframe Interactive (MFI) Keyboard", "122-Key Host Connected Keyboard".)

John Elliott reports on his IBM 1390876 page that this keyboard returns bf bf:
When sent an identify command (0xF2), the keyboard returns the byte sequence 0xBF 0xBF.
However, this can be changed.
On the keyboard PCB is a 12-pin header, marked as 6 pairs of pins (B2-B7).
These correspond to bits 5-0 of the second byte of the keyboard ID.
Shorting a pair of pins sets that bit to zero.
So placing a jumper on the B2 pair will change the keyboard ID to 0xBF 0x9F.
Adjacent to this header is a space on the circuit board for an identical header,
marked as pins A2-A7.
Presumably these would have the same effect on the first byte of the keyboard ID.

David Monro reports ab 85 for a NCD N-97 keyboard.

Tim Clarke reports ab 85 (instead of the usual ab 86)
for the "122-Key Host Connect(ed) Keyboard".
He also reports: Also, when playing with my KVM problems Belkin gave me a
105-key Windows keyboard which Id.s itself as 18ABh.

Linux 2.5.25 kernel source has 0xaca1 for a "NCD Sun layout keyboard".
It also mentions 0xab02 and 0xab7f,
but these arise as (mistaken) back translations from ab 41 and ab 54.

Ralph Brown's Interrupt list mentions "old Japanese 'G', 'P', 'A' keyboards",
with keyboard IDs ab 90, ab 91, ab 92.
Here translated and untranslated versions coincide. ID ab 90 was also mentioned above.

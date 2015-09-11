.NOLIST
.INCLUDE "m32U4def.inc" ;Definitions for ATmega32U4
.LIST

.org 0x0000

.def	__zero_reg__ = R1

;=================================================
; .data segment (length 0x20)
;=================================================

.equ keyboard_codeset = 0x0100   ;static uint8_t keyboard_codeset = 4;
.equ kbd_pauseseq = 0x0101		;static uint8_t kbd_pauseseq[8] = { 0xe1, 0x14, 0x77, 0xe1, 0xf0, 0x14, 0xf0, 0x77 };
.equ aux_key_timercounter = 0x0109	;uint8_t aux_key_timercounter = 10;
.equ read_pcxt_nextstate = 0x010a	;static int8_t read_pcxt_nextstate = -2;
.equ read_pcxt_state = 0x010b	;static int8_t read_pcxt_state = 1;
.equ atps2_write_parity = 0x010c	;static uint8_t atps2_write_parity = 1;
.equ atps2_write_t1state = 0x010d	;static int8_t atps2_write_t1state = -1;
.equ atps2_write_state = 0x010e	;static int8_t atps2_write_state = -1;
.equ read_atps2_parity = 0x010f	;static int8_t read_atps2_parity = 1;
.equ read_atps2_state = 0x0110		;static int8_t read_atps2_state = -1;

.equ __malloc_heap_end = 0x0115		;static uint16_t __malloc_heap_end = &__heap_end;
.equ __brkval = 0x0117			;static uint16_t __brkval = &__heap_start;
.equ keyboard_protocol = 0x0119	;static uint8_t keyboard_protocol = 1;
.equ keyboard_idle_config = 0x011a	;static uint8_t keyboard_idle_config[3] = { 125, 125, 125 };
;.equ keyboard_idle_config+1 = 0x011b
;.equ keyboard_idle_config+2 = 0x011c
.equ boot_idle_config = 0x011d	;static uint8_t boot_idle_config=125;
.equ cur_select_set = 0x011e		;uint8_t cur_select_set = 1;   // current select set
.equ req_select_set = 0x011f		;uint8_t req_select_set = 1;  // requested select set

;=================================================
; BSS Data:
;=================================================

.equ keyboard_id = 0x0120		;uint16_t keyboard_id = 0;
;.equ keyboard_id+1 = 0x0121
.equ kbd_breakcode = 0x0122      ;uint8_t kbd_breakcode = 0;
.equ kbd_extended_scancode = 0x0123 ; uint8_t kbd_extended_scancode = 0;
.equ kbd_extended2_scancode = 0x0124 ; uint8_t kbd_extended2_scancode = 0;
.equ prot_led_state = 0x0125     ;uint8_t prot_led_state = 0;
.equ old_aux_key_bits = 0x0126   ;uint8_t old_aux_key_bits = 0;
.equ aux_key_bits = 0x0127       ;uint8_t aux_key_bits = 0;
.equ tmr_aux_key_bits = 0x0128	;uint8_t tmr_aux_key_bits = 0;
.equ keyboard_mode = 0x0129      ;uint8_t keyboard_mode = 0;
.equ kbd_rcvd_byte = 0x012a		;uint8_t volatile kbd_rcvd_byte = 0;
.equ kbd_rcvd_state = 0x012b		;uint8_t volatile kbd_rcvd_state = 0;
.equ read_pcxt_shiftin = 0x012c	;uint8_t read_pcxt_shiftin = 0;
.equ read_pcxt_bits = 0x012d		;uint8_t read_pcxt_bits = 0;
.equ kbdcmd_to_send = 0x012e     ;uint8_t kbdcmd_to_send = 0;
.equ atps2_write_shiftout = 0x012f	;uint8_t atps2_write_shiftout = 0;
.equ atps2_write_bits = 0x0130		;uint8_t atps2_write_bits = 0;
.equ read_atps2_shiftin = 0x0131	;uint8_t read_atps2_shiftin = 0;
.equ read_atps2_bits = 0x0132		;uint8_t read_atps2_bits = 0;

.equ timer0_counter = 0x0136     ;uint32_t volatile timer0_counter = 0;
.equ onboard_led_counter = 0x013a ;uint16_t onboard_led_counter = 0;
.equ in_macro_tick = 0x013c      ;uint8_t volatile in_macro_tick = 0;
.equ usb_suspended = 0x013d      ;uint8_t usb_suspended = 0;
.equ usb_resuming = 0x013e        ;uint8_t usb_resuming = 0;
.equ usb_status = 0x013f			;uint8_t volatile usb_status = 0;
.equ keyboard_modifier_keys = 0x0140	;uint8_t keyboard_modifier_keys=0;
.equ keyboard_leds = 0x0141     ;uint8_t keyboard_leds = 0;
.equ usb_configuration = 0x0142	;uint8_t volatile usb_configuration=0;
.equ tx_timeout_count = 0x0143	;uint8_t volatile tx_timeout_count = 0;
.equ rx_timeout_count = 0x0144	;uint8_t volatile rx_timeout_count = 0;
.equ keyboard_idle_count = 0x0145	;uint8_t keyboard_idle_count[3] = { 0 };
.equ boot_idle_count = 0x0148	;uint8_t boot_idle_count=0;
.equ boot_keys = 0x0149          ;uint8_t boot_keys[6]={0};
.equ debug_flush_timer = 0x014f  ;uint8_t volatile debug_flush_timer=0;
.equ USB_GEN_vect__div4 = 0x0150	;uint8_t div4=0;  // in USB_GEN_vect
.equ previous_timeout = 0x0151	;uint8_t previous_timeout=0;
								;struct {
.equ kbd_data_data1 = 0x0152      ;uint8_t keys[21]={0};
.equ kbd_data_data2 = 0x0167		;uint8_t data2 = 0;  // might also be an array of size 1, or part of kbd_data_data1
.equ kbd_data_data3 = 0x0168		;uint8_t kbd_data_data3[3]={0}; // might also be a part of kbd_data_data1
.equ kbd_data_data4 = 0x016b		;uint8_t kbd_data_data4[2]={0}; // unused?
								;  } kbd_data = {0};
.equ layerdata = 0x016d          ;uint8_t *layerdata = 0;  // big layer memory array
.equ allocated_layers = 0x016f   ;uint8_t allocated_layers = 0;
.equ layer_cnt = 0x0170			;uint8_t layer_cnt = 0;
.equ layer_map = 0x0171			;uint8_t **layer_map = 0; // layer map (pointers into EEPROM)?
.equ max_used_layer = 0x0173     ;uint8_t max_used_layer = 0;
.equ fn_curset = 0x0174			;uint8_t fn_curset = 0;
.equ fn_keyset = 0x0175			;uint8_t *fn_keyset = 0;
.equ modif_curset = 0x0177		;uint8_t modif_curset = 0;   // bitmask of currently pressed modifier keys
.equ macro_data = 0x0178         ;uint8_t *macro_data = 0;
.equ allocated_macros = 0x017a   ;uint8_t allocated_macros = 0;
.equ macro_cnt = 0x017b			;uint8_t macro_cnt = 0;
.equ setup_done = 0x017c         ;uint8_t setup_done = 0;
.equ writing_eeprom_buffer = 0x017d  ;uint8_t volatile writing_eeprom_buffer = 0;
.equ layerdefs = 0x017e          ;uint8_t layerdefs = 0;
.equ max_layer = 0x017f			;uint8_t max_layer = 0;
.equ total_macros = 0x0180		;uint8_t total_macros = 0;
.equ macro_onbreaks = 0x0181		;uint8_t macro_onbreaks = 0;  // presumably
.equ proc_keyboard_codeset = 0x0182  ; uint8_t proc_keyboard_codeset = 0;
.equ proc_keyboard_id = 0x0183   ;uint16_t proc_keyboard_id = 0;
.equ tcnow_start = 0x0185		;uint32_t tcnow_start = 0;
.equ rawhid_commstate = 0x0189   ;uint8_t rawhid_commstate = 0;
.equ xfer_len = 0x018a			;uint16_t xfer_len = 0;
.equ xfer_eeaddr = 0x018c		;uint16_t xfer_eeaddr = 0;
.equ weep_word = 0x018e			;uint16_t weep_word = 0;   // data word to write into EEPROM
.equ rhidc_start = 0x0190		;uint32_t rhidc_start = 0;
.equ xfer_buf_len = 0x0194		;uint8_t xfer_buf_len = 0;
.equ key_queue_widx = 0x0195		;uint8_t key_queue_widx = 0;
.equ key_queue_ridx = 0x0196		;uint8_t key_queue_ridx = 0;
.equ modifier_keys_stack_idx = 0x0197 ; uint8_t modifier_keys_stack_idx = 0;
.equ wakeup_timeout = 0x0198     ;uint8_t wakeup_timeout = 0;
.equ flagset = 0x0199			;uint8_t flagset = 0;
.equ hidx_trans = 0x019a			;uint8_t hidx_trans[256];
.equ modif_keyset = 0x029a		;uint8_t *modif_keyset = 0;  // bitmask of modifiers for each translated key
.equ eeprom_write_eeaddr = 0x029c ;volatile uint16_t eeprom_write_eeaddr = 0;
.equ eeprom_write_cnt = 0x029e	;volatile uint8_t eeprom_write_cnt = 0;
.equ eeprom_write_flag = 0x029f	;volatile uint8_t eeprom_write_flag = 0;
.equ eeprom_write_buffer = 0x02a0	;volatile uint8_t *eeprom_write_buffer = 0;
; the next two form an unseparable unit
.equ rhcomm_sendcmd = 0x02a2     ;uint8_t rhcomm_sendcmd = 0;
.equ rhcomm_rcvbuf = 0x02a3      ;uint8_t rhcomm_rcvbuf[64] = 0;
.equ pressed_hidxs = 0x02e3      ;uint8_t pressed_hidxs[32] = {0};
.equ modifier_keys_stack = 0x0303 ; uint8_t modifier_keys_stack[8] = {0};
.equ key_queue = 0x030b			;uint16_t key_queue[80] = {0};

; BSS data area ends at 0x03ab

;=================================================
; Interrupt table
;=================================================

__vectors:
; Vector 1: Reset
	rjmp	__ctors_end		; 0x626
	nop	
; Vector 2: External Interrupt Request 0
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 3: External Interrupt Request 1
	jmp	INT1_vect	; 0x1244
; Vector 4: External Interrupt Request 2
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 5: External Interrupt Request 3
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 6: reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 7: reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 8: External Interrupt Request 6
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 9: Reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 10: Pin Change Interrupt Request 0
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 11: USB General Interrupt request
	jmp	USB_GEN_vect	; 0x1b0c
; Vector 12: USB Endpoint Interrupt request
	jmp	USB_COM_vect	; 0x1d60
; Vector 13: Watchdog Time-out Interrupt
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 14: Reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 15: Reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 16: Reserved
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 17: Timer/Counter1 Capture Event
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 18: Timer/Counter1 Compare Match A
	jmp	TIMER1_COMPA_vect	; 0x12c4
; Vector 19: Timer/Counter1 Compare Match B
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 20: Timer/Counter1 Compare Match C
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 21: Timer/Counter1 Overflow
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 22: Timer/Counter0 Compare Match A
	jmp	TIMER0_COMPA_vect	; 0x15ae
; Vector 23: Timer/Counter0 Compare match B
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 24: Timer/Counter0 Overflow
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 25: SPI Serial Transfer Complete
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 26: USART1 Rx Complete
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 27: USART1 Data Register Empty
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 28: USART1 Tx Complete
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 29: Analog Comparator
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 30: ADC Conversion Complete
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 31: EEPROM Ready
	jmp	EE_READY_vect	; 0x298c
; Vector 32: Timer/Counter3 Capture Event
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 33: Timer/Counter3 Compare Match A
	rjmp	TIMER3_COMPA_vect	; 0xc10
	nop	
; Vector 34: Timer/Counter3 Compare Match B
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 35: Timer/Counter3 Compare Match C
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 36: Timer/Counter3 Overflow
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 37: 2-wire Serial Interface
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 38: Store Program Memory Ready
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 39: Timer/Counter4 Compare Match A
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 40: Timer/Counter4 Compare Match B
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 41: Timer/Counter4 Compare Match D
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 42: Timer/Counter4 Overflow
	rjmp	__bad_interrupt	; 0x65e
	nop	
; Vector 43: Timer/Counter4 Fault Protection Interrupt
	rjmp	__bad_interrupt	; 0x65e
	nop	

; keyboard codeset 1 translation table
kbd_ttbl_set1:
A_00ac:
	.db	0x00,0x29,0x1e,0x1f,0x20,0x21,0x22,0x23
	.db	0x24,0x25,0x26,0x27,0x2d,0x2e,0x2a,0x2b
	.db	0x14,0x1a,0x08,0x15,0x17,0x1c,0x18,0x0c
	.db	0x12,0x13,0x2f,0x30,0x28,0xe0,0x04,0x16
	.db	0x07,0x09,0x0a,0x0b,0x0d,0x0e,0x0f,0x33
	.db	0x34,0x35,0xe1,0x31,0x1d,0x1b,0x06,0x19
	.db	0x05,0x11,0x10,0x36,0x37,0x38,0xe5,0x55
	.db	0xe2,0x2c,0x39,0x3a,0x3b,0x3c,0x3d,0x3e
	.db	0x3f,0x40,0x41,0x42,0x43,0x53,0x47,0x5f
	.db	0x60,0x61,0x56,0x5c,0x5d,0x5e,0x57,0x59
	.db	0x5a,0x5b,0x62,0x63,0xc2,0xbe,0x64,0x44
	.db	0x45,0x67,0xb0,0xb2,0x8c,0xb7,0xb8,0xb9
	.db	0xba,0xbb,0xbc,0xbd,0x68,0x69,0x6a,0x6b
	.db	0x6c,0x6d,0x6e,0x6f,0x70,0x71,0x72,0xc1
	.db	0x88,0xb1,0xb3,0x87,0xb4,0xb5,0x73,0x93
	.db	0x92,0x8a,0xbf,0x8b,0xb6,0x89,0x85,0xc0

; keyboard codeset 2 translation table
kbd_ttbl_set2:
A_012c:
	.db	0x01,0x42,0x00,0x3e,0x3c,0x3a,0x3b,0x45
	.db	0x68,0x43,0x41,0x3f,0x3d,0x2b,0x35,0x67
	.db	0x69,0xe2,0xe1,0x88,0xe0,0x14,0x1e,0xb0
	.db	0x6a,0xb1,0x1d,0x16,0x04,0x1a,0x1f,0xb2
	.db	0x6b,0x06,0x1b,0x07,0x08,0x21,0x20,0x8c
	.db	0x6c,0x2c,0x19,0x09,0x17,0x15,0x22,0xb7
	.db	0x6d,0x11,0x05,0x0b,0x0a,0x1c,0x23,0xb8
	.db	0x6e,0xb3,0x10,0x0d,0x18,0x24,0x25,0xb9
	.db	0x6f,0x36,0x0e,0x0c,0x12,0x27,0x26,0xba
	.db	0x70,0x37,0x38,0x0f,0x33,0x13,0x2d,0xbb
	.db	0x71,0x87,0x34,0xb4,0x2f,0x2e,0xbc,0x72
	.db	0x39,0xe5,0x28,0x30,0xb5,0x31,0xbd,0x73
	.db	0xbe,0x64,0x93,0x92,0x8a,0xbf,0x2a,0x8b
	.db	0xb6,0x59,0x89,0x5c,0x5f,0x85,0xc0,0xc1
	.db	0x62,0x63,0x5a,0x5d,0x5e,0x60,0x29,0x53
	.db	0x44,0x57,0x5b,0x56,0x55,0x61,0x47,0x00
	.db	0x00,0x00,0x00,0x40,0xc2

; keyboard codeset 4 translation table
kbd_ttbl_set2ex:
A_01b1:
	.db	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.db	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.db	0xf9,0xe6,0x00,0x00,0xe4,0xe9,0x00,0x00
	.db	0xff,0x00,0x00,0x00,0x00,0x00,0x00,0xe3
	.db	0xfe,0xf0,0x00,0xec,0x00,0x00,0x00,0xe7
	.db	0xfd,0x00,0x00,0xf7,0x00,0x00,0x00,0x65
	.db	0xfc,0x00,0xef,0x00,0xeb,0x00,0x00,0x66
	.db	0xfb,0x00,0xfa,0xea,0x00,0x00,0x00,0xa9
	.db	0xf8,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.db	0xf6,0x00,0x54,0x00,0x00,0xe8,0x00,0x00
	.db	0xf5,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.db	0x00,0x00,0x58,0x00,0x00,0x00,0xaa,0x00
	.db	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.db	0x00,0x4d,0x00,0x50,0x4a,0x00,0x00,0x00
	.db	0x49,0x4c,0x51,0x00,0x4f,0x52,0x00,0x00
	.db	0x00,0x00,0x4e,0x00,0x46,0x4b,0x48

;keyboard codeset 3 translation table
kbd_ttbl_set3:
A_0230:
	.db	0x01,0xbf,0x00,0xbb,0xb9,0xb7,0xb8,0x3a
	.db	0x68,0xc0,0xbe,0xbc,0xba,0x2b,0x35,0x3b
	.db	0x69,0xe0,0xe1,0x64,0x39,0x14,0x1e,0x3c
	.db	0x6a,0xe2,0x1d,0x16,0x04,0x1a,0x1f,0x3d
	.db	0x6b,0x06,0x1b,0x07,0x08,0x21,0x20,0x3e
	.db	0x6c,0x2c,0x19,0x09,0x17,0x15,0x22,0x3f
	.db	0x6d,0x11,0x05,0x0b,0x0a,0x1c,0x23,0x40
	.db	0x6e,0xe6,0x10,0x0d,0x18,0x24,0x25,0x41
	.db	0x6f,0x36,0x0e,0x0c,0x12,0x27,0x26,0x42
	.db	0x70,0x37,0x38,0x0f,0x33,0x13,0x2d,0x43
	.db	0x71,0x87,0x34,0x32,0x2f,0x2e,0x44,0x72
	.db	0xe4,0xe5,0x28,0x30,0x31,0x89,0x45,0x73
	.db	0x51,0x50,0x93,0x52,0x4c,0x4d,0x2a,0x49
	.db	0xb6,0x59,0x4f,0x5c,0x5f,0x4e,0x4a,0x4b
	.db	0x62,0x63,0x5a,0x5d,0x5e,0x60,0x29,0x53
	.db	0xb2,0x57,0x5b,0x56,0x55,0x61,0x47,0x00
	.db	0x00,0x00,0x00,0xbd,0xc2

 
A_02b5:
  .db "\nMode: AT/PS2\n\n",$0
A_02c5:
  .db "\nMode: PC/XT\n\n",$0
A_02d4:
  .db "unknown",$0
A_02dc:
  .db "2 (extended)",$0
A_02e9:
  .db "Code Set: ",$0
A_02f4:
  .db "Keyboard ID: ",$0

; descriptor_list[]
A_0302:   ;entry 0
    .dw 0x100     ;wValue
    .dw 0         ;wIndex
    .dw 0x036c    ;address of device_descriptor (A_036c)
    .db 18        ;sizeof(device_descriptor)
A_0309:   ;entry 1
    .dw 0x0200    ;wValue
    .dw 0         ;wIndex
    .dw 0x037e    ;address of config1_descriptor (A_037e)
    .db 0x74      ;sizeof(config1_descriptor)
A_0310:   ;entry 2
    .dw 0x02200   ;wValue
    .dw 0         ;interface index
    .dw 0x03f2    ;address of boot_hid_report_desc (A_03f2)
    .db 18        ;sizeof(boot_hid_report_desc)
A_0317:   ;entry 3
    .dw 0x2100    ;wValue
    .dw 0         ;interface index
    .dw 0x390     ;address of config1_descriptor + offset of this interface therein
    .db 9         ;sizeof(USBDESCR_HID)
A_031e:   ;entry 4
    .dw 0x2200    ;wValue
    .dw 1         ;interface index
    .dw 0x0404    ;address of debug_hid_report_desc (A_0404)
    .db 21        ;sizeof(debug_hid_report_desc)
A_0325:   ;entry 5
	.dw 0x2100    ;wValue
	.dw 1         ;interface index
	.dw 0x03a9    ;address of config1_descriptor + offset of this interface therein
	.db 9         ;sizeof(USBDESCR_HID)
A_032c:   ;entry 6
    .dw 0x2200    ;wValue
    .dw 2         ;interface index
    .dw 0x0419    ;address of keyboard_hid_report_desc (A_0419)
    .db 220       ;sizeof(keyboard_hid_report_desc)
A_0333:   ;entry 7
    .dw 0x2100    ;wValue
    .dw 2         ;interface index
    .dw 0x03c2    ;address of config1_descriptor + offset of this interface therein
    .db 9         ;sizeof(USBDESCR_HID)
A_033a:   ;entry 8
    .dw 0x2200    ;wValue
    .dw 3         ;interface index
    .dw 0x04f5    ;address of rawhid_hid_report_desc (A_04f5)
    .db 28        ;sizeof(rawhid_hid_report_desc)
A_0341:  ;entry 9
	.dw 0x2100    ;wValue
	.dw 3         ;interface index
	.dw 0x03db    ;address of config1_descriptor + offset of this interface therein
	.db 9         ;sizeof(USBDESCR_HID)
A_0348:  ;entry 10
	.dw 0x0300    ;wValue
	.dw 0			;request for string 0
	.dw 0x0511    ;address of string0
	.db 4         ;sizeof(string0)
A_034f:  ;entry 11
    .dw 0x0301    ;wValue
    .dw 0x0409    ;language?
    .dw 0x0515    ;address of string1
    .db 14        ;sizeof(string1)
A_0356:  ;entry 12
    .dw 0x0302    ;wValue
    .dw 0x0409    ;language?
    .dw 0x0525    ;address of string2
    .db 56        ;sizeof(string2)

;endpoint configuration table
endpoint_config_table;
A_035d:
    .db 1         ;this one's presumably the keyboard with KEYBOARD_SIZE=8
    .db 0xc1      ;EP_TYPE_INTERRUPT_IN
    .db 0x06      ;EP_SIZE(0..8) | EP_DOUBLE_BUFFER
A_0360:    
    .db 1         ;might be debug?
    .db 0xc1      ;EP_TYPE_INTERRUPT_IN
    .db 0x26      ;EP_SIZE(17..32) | EP_DOUBLE_BUFFER
A_0363:
    .db 1         ;or this?
    .db 0xc1      ;EP_TYPE_INTERRUPT_IN
    .db 0x26      ;EP_SIZE(17..32) | EP_DOUBLE_BUFFER
A_0366:
    .db 1         ;presumably rawhid with RAWHID_TX_SIZE=64
    .db 0xc1      ;EP_TYPE_INTERRUPT_IN
    .db 0x36      ;EP_SIZE(33..64) | EP_DOUBLE_BUFFER
A_0369:
    .db 1         ;presumably rawhid with RAWHID_RX_SIZE=64
    .db 0xc0      ;EP_TYPE_INTERRUPT_OUT
    .db 0x36      ;EP_SIZE(33..64) | EP_DOUBLE_BUFFER

; device descriptor; for VID/PID see see https://usb-ids.gowdy.us/read/UD/16c0
device_descriptor:
A_036c:
	.db 18			;bLength
	.db 1			;bDescriptorType
	.db 0x00,0x02	;bcdUSB
	.db 0			;bDeviceClass
	.db 0			;bDeviceSubClass
	.db 0			;bDeviceProtocol
	.db 32			;ENDPOINT0_SIZE
	.db 0xc0,0x16	;Vendor ID (VOTI)
	.db 0x7d,0x04	;Product ID (USB_KEYBOARD_DEBUG)
	.db 0x00,0x01	;bcdDevice
	.db 1			;iManufacturer
	.db 2			;iProduct
	.db 0			;iSerialNumber
	.db 1			;bNumConfigurations

; USB configuration descriptor
config1_descriptor:
A_037e:
  .db 9          ;sizeof(config1_descriptor): length of descriptor in bytes
  .db 2          ;USBDESCR_CONFIG,    /* descriptor type */
  .db 0x74,0     ;/* total length of data returned (including inlined descriptors) */
  .db 4          ;/* number of interfaces in this configuration */
  .db 1          ;/* index of this configuration */
  .db 0          ;/* configuration name string index */
  .db 0xa0       ;USBATTR_BUSPOWER | USBATTR_SELFPOWER
  .db 50         ;USB_CFG_MAX_BUS_POWER/2
  
/* boot device interface descriptor: */
  .db 9          ;/* sizeof(usbDescrInterface): length of descriptor in bytes */
  .db 4          ;USBDESCR_INTERFACE /* descriptor type */
  .db 0          ;/* index of this interface */
  .db 0          ;/* alternate setting for this interface */
  .db 1          ;USB_CFG_HAVE_INTRIN_ENDPOINT /* endpoints excl 0: number of endpoint descriptors to follow */
  .db 3          ;USB_CFG_INTERFACE_CLASS
  .db 1          ;USB_CFG_INTERFACE_SUBCLASS
  .db 1          ;USB_CFG_INTERFACE_PROTOCOL
  .db 0          ;/* string index for interface */
/* HID descriptor */
  .db 9          ;/* sizeof(usbDescrHID): length of descriptor in bytes */
  .db 0x21       ;USBDESCR_HID  /* descriptor type: HID */
  .db 0x11,0x01  ;/* BCD representation of HID version */
  .db 0          ;/* target country code */
  .db 1          ;/* number of HID Report (or other HID class) Descriptor infos to follow */
  .db 0x22       ;/* descriptor type: report */
  .db 0x12,0     ;USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH  /* total length of report descriptor */
/* endpoint descriptor for endpoint 1 */
  .db 7          ;/* sizeof(usbDescrEndpoint) */
  .db 5          ;USBDESCR_ENDPOINT /* descriptor type = endpoint */
  .db 0x81       ;0x81,       /* IN endpoint number 1 */
  .db 3          ;/* attrib: Interrupt endpoint */
  .db 8,0        ;/* maximum packet size */
  .db 1          ;USB_CFG_INTR_POLL_INTERVAL /* in ms */

/* 2nd interface descriptor: */
  .db 9          ;/* sizeof(usbDescrInterface): length of descriptor in bytes */
  .db 4          ;USBDESCR_INTERFACE /* descriptor type */
  .db 1          ;/* index of this interface */
  .db 0          ;/* alternate setting for this interface */
  .db 1          ;/* number of endpoint descriptors to follow */
  .db 3          ;USB_CFG_INTERFACE_CLASS
  .db 0          ;subclass
  .db 0          ;protocol
  .db 0          ;/* string index for interface */
/* HID descriptor */
  .db 9          ;/* sizeof(usbDescrHID): length of descriptor in bytes */
  .db 0x21       ;USBDESCR_HID  /* descriptor type: HID */
  .db 0x11,0x01  ;/* BCD representation of HID version */
  .db 0          ;/* target country code */
  .db 1          ;/* number of HID Report (or other HID class) Descriptor infos to follow */
  .db 0x22       ;/* descriptor type: report */
  .db 0x15,0     ;USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH  /* total length of report descriptor */
/* endpoint descriptor for endpoint 2 */
  .db 7          ;/* sizeof(usbDescrEndpoint) */
  .db 5          ;USBDESCR_ENDPOINT /* descriptor type = endpoint */
  .db 0x83       ;   /* endpoint number */
  .db 3          ;/* attrib: Interrupt endpoint */
  .db 32,0       ;/* maximum packet size */
  .db 1          ;USB_CFG_INTR_POLL_INTERVAL /* in ms */

/* 3rd interface descriptor: */
  .db 9          ;/* sizeof(usbDescrInterface): length of descriptor in bytes */
  .db 4          ;USBDESCR_INTERFACE /* descriptor type */
  .db 2          ;/* index of this interface */
  .db 0          ;/* alternate setting for this interface */
  .db 1          ;/* number of endpoint descriptors to follow */
  .db 3          ;USB_CFG_INTERFACE_CLASS
  .db 0          ;subclass
  .db 0          ;protocol
  .db 0          ;/* string index for interface */
/* HID descriptor */
  .db 9          ;/* sizeof(usbDescrHID): length of descriptor in bytes */
  .db 0x21       ;USBDESCR_HID  /* descriptor type: HID */
  .db 0x11,0x01  ;/* BCD representation of HID version */
  .db 0          ;/* target country code */
  .db 1          ;/* number of HID Report (or other HID class) Descriptor infos to follow */
  .db 0x22       ;/* descriptor type: report */
  .db 0xdc,0    ;USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH  /* total length of report descriptor */
/* endpoint descriptor for endpoint 3 */
  .db 7          ;/* sizeof(usbDescrEndpoint) */
  .db 5          ;USBDESCR_ENDPOINT /* descriptor type = endpoint */
  .db 0x82       ;   /* endpoint number */
  .db 3          ;/* attrib: Interrupt endpoint */
  .db 23,0       ;/* maximum packet size */
  .db 1          ;USB_CFG_INTR_POLL_INTERVAL /* in ms */

/* 4th interface descriptor: */
  .db 9          ;/* sizeof(usbDescrInterface): length of descriptor in bytes */
  .db 4          ;USBDESCR_INTERFACE /* descriptor type */
  .db 3          ;/* index of this interface */
  .db 0          ;/* alternate setting for this interface */
  .db 2          ; /* number of endpoint descriptors to follow */
  .db 3          ;USB_CFG_INTERFACE_CLASS
  .db 0          ;subclass
  .db 0          ;protocol
  .db 0          ;/* string index for interface */
/* HID descriptor */
  .db 9          ;/* sizeof(usbDescrHID): length of descriptor in bytes */
  .db 0x21       ;USBDESCR_HID  /* descriptor type: HID */
  .db 0x11,0x01  ;/* BCD representation of HID version */
  .db 0          ;/* target country code */
  .db 1          ;/* number of HID Report (or other HID class) Descriptor infos to follow */
  .db 0x22       ;/* descriptor type: report */
  .db 0x1c,0    ;USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH  /* total length of report descriptor */
/* 1st endpoint descriptor for interface 4 */
  .db 7          ;/* sizeof(usbDescrEndpoint) */
  .db 5          ;USBDESCR_ENDPOINT /* descriptor type = endpoint */
  .db 0x84       ;   /* endpoint number */
  .db 3          ;/* attrib: Interrupt endpoint */
  .db 64,0       ;/* maximum packet size */
  .db 2          ;USB_CFG_INTR_POLL_INTERVAL /* in ms */
/* 2nd endpoint descriptor for interface 4 */
  .db 7          ;/* sizeof(usbDescrEndpoint) */
  .db 5          ;USBDESCR_ENDPOINT /* descriptor type = endpoint */
  .db 0x05       ;   /* endpoint number */
  .db 3          ;/* attrib: Interrupt endpoint */
  .db 64,0       ;/* maximum packet size */
  .db 8          ;USB_CFG_INTR_POLL_INTERVAL /* in ms */

;===========================================================
; descriptions parsed by USB HID Descriptor Tool
;===========================================================

; assumption: boot-time device (?)
boot_hid_report_desc:
A_03f2:
	.db  5h,  1h                ; USAGE_PAGE (Generic Desktop)
	.db  9h,  6h                ; USAGE (Keyboard)
	.db a1h,  1h                ; COLLECTION (Application)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 26h, ffh,  0h           ;   LOGICAL_MAXIMUM (255)
	.db 95h,  8h                ;   REPORT_COUNT (8)
	.db 75h,  8h                ;   REPORT_SIZE (8)
	.db 81h,  3h                ;   INPUT (Cnst,Var,Abs)
	.db c0h                     ; END_COLLECTION

; description for the rawhid debug device
debug_hid_report_desc:
A_0404:
	.db  6h, 31h, ffh           ; USAGE_PAGE 0xFF31 (VendorDefined)
	.db  9h, 74h                ; USAGE 0x74
	.db a1h, 53h                ; COLLECTION (VendorDefined)
	.db 75h,  8h                ;   REPORT_SIZE (8)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 26h, ffh,  0h           ;   LOGICAL_MAXIMUM (255)
	.db 95h, 20h                ;   REPORT_COUNT (32)
	.db  9h, 75h                ;   USAGE (Undefined)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db c0h                     ; END_COLLECTION

;description for the keyboard device
keyboard_hid_report_desc:
A_0419:
	.db  5h,  1h                ; USAGE_PAGE (Generic Desktop)
	.db  9h,  6h                ; USAGE (Keyboard)
	.db a1h,  1h                ; COLLECTION (Application)
	.db 85h,  1h                ;   REPORT_ID (1)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h,  8h                ;   REPORT_COUNT (8)
	.db  5h,  7h                ;   USAGE_PAGE (Keyboard)
	.db 19h, e0h                ;   USAGE_MINIMUM (Keyboard LeftControl)
	.db 29h, e7h                ;   USAGE_MAXIMUM (Keyboard Right GUI)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h,  5h                ;   REPORT_COUNT (5)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db  5h,  8h                ;   USAGE_PAGE (LEDs)
	.db 19h,  1h                ;   USAGE_MINIMUM (Num Lock)
	.db 29h,  5h                ;   USAGE_MAXIMUM (Kana)
	.db 91h,  2h                ;   OUTPUT (Data,Var,Abs)
	.db 95h,  1h                ;   REPORT_COUNT (1)
	.db 75h,  3h                ;   REPORT_SIZE (3)
	.db 91h,  3h                ;   OUTPUT (Cnst,Var,Abs)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h, 31h                ;   REPORT_COUNT (49)
	.db  5h,  7h                ;   USAGE_PAGE (Keyboard)
	.db 19h,  1h                ;   USAGE_MINIMUM (Keyboard ErrorRollOver)
	.db 29h, 31h                ;   USAGE_MAXIMUM (Keyboard \ and |)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h,  1h                ;   REPORT_COUNT (1)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 81h,  3h                ;   INPUT (Cnst,Var,Abs)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h, 69h                ;   REPORT_COUNT (105)
	.db  5h,  7h                ;   USAGE_PAGE (Keyboard)
	.db 19h, 33h                ;   USAGE_MINIMUM (Keyboard ; and :)
	.db 29h, 9bh                ;   USAGE_MAXIMUM (Keyboard Cancel)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h,  1h                ;   REPORT_COUNT (1)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 81h,  3h                ;   INPUT (Cnst,Var,Abs)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h,  8h                ;   REPORT_COUNT (8)
	.db  5h,  7h                ;   USAGE_PAGE (Keyboard)
	.db 19h, 9dh                ;   USAGE_MINIMUM (Keyboard Prior)
	.db 29h, a4h                ;   USAGE_MAXIMUM (Keyboard ExSel)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h,  4h                ;   REPORT_COUNT (4)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 81h,  3h                ;   INPUT (Cnst,Var,Abs)
	.db c0h                     ; END_COLLECTION
	.db  5h,  1h                ; USAGE_PAGE (Generic Desktop)
	.db  9h, 80h                ; USAGE (System Control)
	.db a1h,  1h                ; COLLECTION (Application)
	.db 85h,  2h                ;   REPORT_ID (2)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h,  3h                ;   REPORT_COUNT (3)
	.db 19h, 81h                ;   USAGE_MINIMUM (System Power Down)
	.db 29h, 83h                ;   USAGE_MAXIMUM (System Wake Up)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h,  5h                ;   REPORT_COUNT (5)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 81h,  3h                ;   INPUT (Cnst,Var,Abs)
	.db c0h                     ; END_COLLECTION
	.db  5h,  ch                ; USAGE_PAGE (Consumer Devices)
	.db  9h,  1h                ; USAGE (Consumer Control)
	.db a1h,  1h                ; COLLECTION (Application)
	.db 85h,  3h                ;   REPORT_ID (3)
	.db 75h,  1h                ;   REPORT_SIZE (1)
	.db 95h, 18h                ;   REPORT_COUNT (24)
	.db  9h, b5h                ;   USAGE (Scan Next Track)
	.db  9h, b6h                ;   USAGE (Scan Previous Track)
	.db  9h, b7h                ;   USAGE (Stop)
	.db  9h, cdh                ;   USAGE (Unassigned)
	.db  9h, e2h                ;   USAGE (Mute)
	.db  9h, e5h                ;   USAGE (Bass Boost)
	.db  9h, e7h                ;   USAGE (Loudness)
	.db  9h, e9h                ;   USAGE (Volume Up)
	.db  9h, eah                ;   USAGE (Volume Down)
	.db  ah, 52h,  1h           ;   USAGE (Bass Increment)
	.db  ah, 53h,  1h           ;   USAGE (Bass Decrement)
	.db  ah, 54h,  1h           ;   USAGE (Treble Increment)
	.db  ah, 55h,  1h           ;   USAGE (Treble Decrement)
	.db  ah, 83h,  1h           ;   USAGE (AL Consumer Control Configuration)
	.db  ah, 8ah,  1h           ;   USAGE (AL Email Reader)
	.db  ah, 92h,  1h           ;   USAGE (AL Calculator)
	.db  ah, 94h,  1h           ;   USAGE (AL Local Machine Browser)
	.db  ah, 21h,  2h           ;   USAGE (AC Search)
	.db  ah, 23h,  2h           ;   USAGE (AC Home)
	.db  ah, 24h,  2h           ;   USAGE (AC Back)
	.db  ah, 25h,  2h           ;   USAGE (AC Forward)
	.db  ah, 26h,  2h           ;   USAGE (AC Stop)
	.db  ah, 27h,  2h           ;   USAGE (AC Refresh)
	.db  ah, 2ah,  2h           ;   USAGE (AC Bookmarks)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 25h,  1h                ;   LOGICAL_MAXIMUM (1)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db c0h                     ; END_COLLECTION

; whatever THIS is, it's Vendor-defined
; follows the rawhid_hid_report_desc[] layout in usb_rawhid_debug.c,
; just with a slightly different usage page
;presumably the device that Soarer uses to pass the EEPROM data with
rawhid_hid_report_desc:
A_04f5:
	.db  6h, 99h, ffh           ; USAGE_PAGE (Not Defined)
	.db  ah, 68h, 24h           ; USAGE (Undefined)
	.db a1h,  1h                ; COLLECTION (Application)
	.db 75h,  8h                ;   REPORT_SIZE (8)
	.db 15h,  0h                ;   LOGICAL_MINIMUM (0)
	.db 26h, ffh,  0h           ;   LOGICAL_MAXIMUM (255)
	.db 95h, 40h                ;   REPORT_COUNT (64)
	.db  9h,  1h                ;   USAGE (Undefined)
	.db 81h,  2h                ;   INPUT (Data,Var,Abs)
	.db 95h, 40h                ;   REPORT_COUNT (64)
	.db  9h,  2h                ;   USAGE (Undefined)
	.db 91h,  2h                ;   OUTPUT (Data,Var,Abs)
	.db c0h                     ; END_COLLECTION
	
string0:
A_0511:
	.db $04,$03,$09,$04
;Manufacturer Name
string1:
A_0515:
    db $0e,$03
    db 'S',0
    db 'o',0
    db 'a',0
    db 'r',0
    db 'e',0
    db 'r',0
    dw 0
;Product Name
string2:
A_0525:
    db $38,$03
	db 'S',0
	db 'o',0
	db 'a',0
	db 'r',0
	db 'e',0
	db 'r',0
	db ''',0
	db 's',0
	db ' ',0
	db 'K',0
	db 'e',0
	db 'y',0
	db 'b',0
	db 'o',0
	db 'a',0
	db 'r',0
	db 'd',0
	db ' ',0
	db 'C',0
	db 'o',0
	db 'n',0
	db 'v',0
	db 'e',0
	db 'r',0
	db 't',0
	db 'e',0
	db 'r',0
    dw 0
    
A_055f:
  .db "alloc ok.\n",$0
A_056a:
  .db "alloc failed.\n",$0
A_0579:
  .db "alloc failed.\n",$0
A_0588:
  .db "total_macros: ",$0
A_0597:
  .db "max_layer: ",$0
A_05a3:
  .db "layerdefs: ",$0
A_05af:
  .db "!apply\n",$0
A_05b7:
  .db "len<5\n",$0
A_05be:
  .db "\n\nremaining: ",$0
A_05cc:
  .db "error ",$0
A_05d3:
  .db "error ",$0
A_05da:
  .db "error ",$0
A_05e1:
  .db "!id ",$0
A_05e6:
  .db "!set ",$0
A_05ec:
  .db "!select ",$0
A_05f5:
  .db "macros ",$0
A_05fd:
  .db "remaps ",$0
A_0605:
  .db "layers ",0
info_templ:
A_060d:					;data package for scinfo
  .db 0x03, 0x01, 0x00, 0x01, 0x01, 0x0c, 0x02, 0x01, 0x01,
  .db 0x04, 0x00, 0x00, 0x05, 0x00, 0x0a, 0x07, 0x00
  .db 0x00, 0x06, 0x00, 0x04, 0x08, 0x00, 0x00, 0x00

;==============================================================================
; Start of avr-gcc runtime initialization
;==============================================================================
;==============================================================
; __ctors_end: Reset Interrupt
;==============================================================
__ctors_end:
A_0626:
	clr	__zero_reg__
	out	SREG, __zero_reg__
	ser	R28
	ldi	R29, 0x0a
	out	SPH, R29    ; Stack pointer = 0x0aff
	out	SPL, R28
__do_copy_data:	
	ldi	R17, 0x01
	ldi	R26, 0x00
	ldi	R27, 0x01
	ldi	R30, 0x2e
	ldi	R31, 0x38
	rjmp	.do_copy_data_start	; 0x642
.do_copy_data_loop:
	lpm	R0, Z+
	st	X+, R0
.do_copy_data_start:
	cpi	R26, 0x20
	cpc	R27, R17
	brne	.do_copy_data_loop	; 0x63e
__do_clear_bss:
	ldi	R17, 0x03
	ldi	R26, 0x20
	ldi	R27, 0x01
	rjmp	.do_clear_bss_start	; 0x652
.do_clear_bss_loop:
	st	X+, __zero_reg__
.do_clear_bss_start:
	cpi	R26, 0xab
	cpc	R27, R17
	brne	.do_clear_bss_loop	; 0x650
	
	rcall	main	; 0x7a6
	jmp	_exit	; 0x382a

;====================================================
; __bad_interrupt: Unused Interrupt - jump to reset vector
;====================================================
__bad_interrupt:
	rjmp	__vectors	; 0x0
	
;==============================================================================
; End of avr-gcc runtime initialization
;==============================================================================


;=======================================
; translate_scancode : translates incoming scancode based on keyboard codeset
;=======================================
translate_scancode:
A_0660:	lds	R25, keyboard_codeset	; 0x200
A_0664:	cpi	R25, 0x02
A_0666:	breq	A_06b0	; 0x6b0
A_0668:	cpi	R25, 0x03
A_066a:	brcc	A_0672	; 0x672
A_066c:	cpi	R25, 0x01
A_066e:	brne	A_06c0	; 0x6c0
A_0670:	rjmp	A_067c	; 0x67c
A_0672:	cpi	R25, 0x03
A_0674:	breq	A_068c	; 0x68c
A_0676:	cpi	R25, 0x04
A_0678:	brne	A_06c0	; 0x6c0
A_067a:	rjmp	A_069c	; 0x69c
A_067c:	sbrc	R24, 7
A_067e:	rjmp	A_06c0	; 0x6c0
A_0680:	mov	R30, R24
A_0682:	ldi	R31, 0x00
A_0684:	subi	R30, 0x54
A_0686:	sbci	R31, 0xff
A_0688:	lpm	R24, Z
A_068a:	ret	
A_068c:	cpi	R24, 0x85
A_068e:	brcc	A_06c0	; 0x6c0
A_0690:	mov	R30, R24
A_0692:	ldi	R31, 0x00
A_0694:	subi	R30, 0xd0
A_0696:	sbci	R31, 0xfd
A_0698:	lpm	R24, Z
A_069a:	ret	
A_069c:	and	R22, R22
A_069e:	breq	A_06b0	; 0x6b0
A_06a0:	cpi	R24, 0x7f
A_06a2:	brcc	A_06c0	; 0x6c0
A_06a4:	mov	R30, R24
A_06a6:	ldi	R31, 0x00
A_06a8:	subi	R30, 0x4f
A_06aa:	sbci	R31, 0xfe
A_06ac:	lpm	R24, Z
A_06ae:	ret	
A_06b0:	cpi	R24, 0x85
A_06b2:	brcc	A_06c0	; 0x6c0
A_06b4:	mov	R30, R24
A_06b6:	ldi	R31, 0x00
A_06b8:	subi	R30, 0xd4
A_06ba:	sbci	R31, 0xfe
A_06bc:	lpm	R24, Z
A_06be:	ret	
A_06c0:	ldi	R24, 0x00
A_06c2:	ret	

;======================================================
; reset_kbdinstate :
;======================================================
reset_kbdinstate:
A_06c4:	call	reset_macroproc	; 0x3430
A_06c8:	call	queue_reset_usb_data	; 0x3444
A_06cc:	sts	kbd_breakcode, __zero_reg__	; 0x244
A_06d0:	sts	kbd_extended_scancode, __zero_reg__	; 0x246
A_06d4:	sts	kbd_extended2_scancode, __zero_reg__	; 0x248
A_06d8:	ret	

;======================================================
; set_kbd_leds : sets the keyboard LEDs
;======================================================
set_kbd_leds:
A_06da:	push	R17
A_06dc:	mov	R17, R24
A_06de:	call	get_keyboard_protocol	; 0x3422
A_06e2:	mov	R18, R17
A_06e4:	ldi	R19, 0x00
A_06e6:	and	R24, R24
A_06e8:	breq	A_0702	; 0x702
A_06ea:	in	R24, DDRF
A_06ec:	ori	R24, 0xe0	;((1<<DDD7) | (1<<DDD6) | (1<<DDD5))
A_06ee:	out	DDRF, R24
A_06f0:	in	R24, PORTF
A_06f2:	ldi	R20, 0x05
A_06f4:	add	R18, R18
A_06f6:	adc	R19, R19
A_06f8:	dec	R20
A_06fa:	brne	A_06f4	; 0x6f4
A_06fc:	andi	R24, 0x1f
A_06fe:	or	R24, R18
A_0700:	rjmp	A_0718	; 0x718
A_0702:	in	R24, DDRF
A_0704:	ldi	R25, 0x05
A_0706:	add	R18, R18
A_0708:	adc	R19, R19
A_070a:	dec	R25
A_070c:	brne	A_0706	; 0x706
A_070e:	andi	R24, 0x1f	;~((1<<DDD7) | (1<<DDD6) | (1<<DDD5))
A_0710:	or	R24, R18
A_0712:	out	DDRF, R24
A_0714:	in	R24, 0x11
A_0716:	ori	R24, 0xe0
A_0718:	out	PORTF, R24
A_071a:	pop	R17
A_071c:	ret	

;=======================================
; incoming_kbd_breakcode : process an incoming PS/2 break code
;=======================================
incoming_kbd_breakcode:
A_071e:
	rcall	translate_scancode
	jmp	incoming_keybreak

;=======================================
; incoming_kbd_makecode : process an incoming PS/2 make code
;=======================================
incoming_kbd_makecode:
A_0724:
	rcall	translate_scancode
	jmp	incoming_keymake

;=======================================
; send_aux_key_changes : process changes in the aux key bits
;=======================================
send_aux_key_changes:
A_072a:	push	R12
A_072c:	push	R13
A_072e:	push	R14
A_0730:	push	R15
A_0732:	push	R16
A_0734:	push	R17
A_0736:	push	R28
A_0738:	push	R29
A_073a:	rcall	get_aux_key_bits	; 0xc92
A_073c:	mov	R16, R24
A_073e:	lds	R24, old_aux_key_bits	; 0x24c
A_0742:	eor	R24, R16
A_0744:	breq	A_0794	; 0x794
A_0746:	ldi	R28, 0x00
A_0748:	ldi	R29, 0x00
A_074a:	ldi	R17, 0xab
A_074c:	mov	R12, R24   ; R12 = set of changed bits
A_074e:	clr	R13
A_0750:	mov	R14, R16
A_0752:	clr	R15
A_0754:	movw	R24, R12
A_0756:	mov	R0, R28
A_0758:	rjmp	A_075e	; 0x75e
A_075a:	asr	R25
A_075c:	ror	R24
A_075e:	dec	R0
A_0760:	brpl	A_075a	; 0x75a
A_0762:	sbrs	R24, 0
A_0764:	rjmp	A_0786	; 0x786
A_0766:	movw	R24, R14
A_0768:	mov	R0, R28
A_076a:	rjmp	A_0770	; 0x770
A_076c:	asr	R25
A_076e:	ror	R24
A_0770:	dec	R0
A_0772:	brpl	A_076c	; 0x76c
A_0774:	sbrs	R24, 0
A_0776:	rjmp	A_0780	; 0x780
A_0778:	mov	R24, R17
A_077a:	call	incoming_keybreak	; 0x344a
A_077e:	rjmp	A_0786	; 0x786
A_0780:	mov	R24, R17
A_0782:	call	incoming_keymake	; 0x3488
A_0786:	adiw	R28, 0x01
A_0788:	subi	R17, 0xff
A_078a:	cpi	R17, 0xb0
A_078c:	brne	A_0754	; 0x754
A_078e:	sts	old_aux_key_bits, R16	; 0x24c
A_0792:	ldi	R24, 0x01
A_0794:	pop	R29
A_0796:	pop	R28
A_0798:	pop	R17
A_079a:	pop	R16
A_079c:	pop	R15
A_079e:	pop	R14
A_07a0:	pop	R13
A_07a2:	pop	R12
A_07a4:	ret	

;---------------------------------------------------------
; main: main program function
;---------------------------------------------------------
main:
A_07a6:
	push	R2
	push	R3
	push	R4
	push	R5
	push	R6
	push	R7
	push	R8
	push	R9
	push	R10
	push	R11
	push	R12
	push	R13
	push	R14
	push	R15
	push	R16
	push	R17
	push	R29
	push	R28
	
.def	kbd_reset_pin_reset = R3
.def	newline_after_wait = R5
.def	keyboard_determined = R8
.def	resend_requested = R9
.def	t0ct_start = R10
.def	t0ct_start_b2 = R11
.def	t0ct_start_b3 = R12
.def	t0ct_start_b4 = R13
.def	new_pled_state = R16
	
	rcall	A_07cc	; reserve 2 bytes on stack
A_07cc:
	push	R0		; and another 2
	in	R28, SPL
	in	R29, SPH
	
	ldi	R24, 0x80	;CPU_PRESCALE(0);  // set for 16 MHz clock
	sts	CLKPR, R24
	sts	CLKPR, __zero_reg__
	sbi	DDRD, 6		;DDRD |= (1 << DDD6);  // LED_CONFIG;
	ldi	R24, 0x00	;set_kbd_leds(0);  // init LEDs to out
	rcall	set_kbd_leds	; 0x6da
	ldi	R24, 0x07	;set_kbd_leds(7);  // set LEDs on
	rcall	set_kbd_leds	; 0x6da
	rcall	setup_timer0	; 0x1592
	call	proc_eeprom_mem_init	; 0x3428
	rcall	init_kbd	; 0x129a
	rcall	setup_aux_key_handler	; 0xc5c
	rcall	reset_kbdinstate	; 0x6c4
	ldi	R24, 0x00	; set_kbd_reset_pin(0);
	rcall	set_kbd_reset_pin
	
	clr	kbd_reset_pin_reset
	clr	keyboard_determined
	clr	resend_requested
	clr	newline_after_wait
	clr	t0ct_start
	clr	t0ct_start_b2
	movw	t0ct_start_b3, t0ct_start
	
	ldi	R17, 0x04
	mov	R4, R17
	ldi	R27, 0x02
	mov	R2, R27
	
; that's where the big fat main loop obviously starts
A_080c:
	and	kbd_reset_pin_reset, kbd_reset_pin_reset
	brne	A_0838	; 0x838
	in	R18, SREG	;ATOMIC_BLOCK(ATOMIC_RESTORESTATE) R24-27 = timer0_counter;
	cli	
	lds	R24, timer0_counter	; 0x26c
	lds	R25, timer0_counter+1	; 0x26e
	lds	R26, timer0_counter+2	; 0x270
	lds	R27, timer0_counter+3	; 0x272
	out	SREG, R18
	subi	R24, 0xf5	;>= 500
	sbci	R25, 0x01
	sbci	R26, 0x00
	sbci	R27, 0x00
	brcs	A_0838	; 0x838	

	ldi	R24, 0x01
	rcall	set_kbd_reset_pin	; set_kbd_reset_pin(1);
	clr	kbd_reset_pin_reset
	inc	kbd_reset_pin_reset
	
A_0838:
	and	keyboard_determined, keyboard_determined
	breq	A_083e	; 0x83e
	rjmp	A_0a08	; 0xa08
A_083e:
	in	R18, SREG	;ATOMIC_BLOCK(ATOMIC_RESTORESTATE) R24-27 = timer0_counter;
	cli	
	lds	R24, timer0_counter	; 0x26c
	lds	R25, timer0_counter+1	; 0x26e
	lds	R26, timer0_counter+2	; 0x270
	lds	R27, timer0_counter+3	; 0x272
	out	SREG, R18
	subi	R24, 0xb9	;>=3000
	sbci	R25, 0x0b
	sbci	R26, 0x00
	sbci	R27, 0x00
	brcc	A_0860	; 0x860
	rjmp	A_0a08	; 0xa08
A_0860:
	call	get_forced_keyboard_type	; 0x2b7e
	mov	R25, R24
	andi	R25, 0x0f
	breq	A_0890	; 0x890
	
	swap	R24
	andi	R24, 0x0f
	brne	A_0886	; 0x886
	sts	keyboard_codeset, R25	; 0x200
	cpi	R25, 0x01
	brne	A_087e	; 0x87e
	sts	keyboard_mode, R2	; 0x252
	rjmp	A_0940	; 0x940
A_087e:
	ldi	R24, 0x01
	sts	keyboard_mode, R24	; 0x252
	rjmp	A_0940	; 0x940
A_0886:
	sts	keyboard_mode, R24	; 0x252
	sts	keyboard_codeset, R25	; 0x200
	rjmp	A_0940	; 0x940
A_0890:
	sts	keyboard_codeset, __zero_reg__	; 0x200
	sts	keyboard_id+1, __zero_reg__	; 0x242
	sts	keyboard_id, __zero_reg__	; 0x240
	ldi	R24, 0xee				; send_kbd_command(0xee, 50); // echo request
	ldi	R22, 0x32
	rcall	send_kbd_command	; 0x133c
	cpi	R24, 0x02
	breq	A_08a8	; 0x8a8
	rjmp	A_092a	; 0x92a
A_08a8:
	ldi	R24, 0x32
	rcall	get_kbd_byte	; 0x1492
	ldi	R24, 0x01
	sts	keyboard_mode, R24	; 0x252
	lds	R24, keyboard_codeset	; 0x200
	and	R24, R24
	breq	A_08bc	; 0x8bc
	rjmp	A_0934	; 0x934
A_08bc:
	ldi	R24, 0xf2				send_kbd_command(0xf2, 50); // get ID
	ldi	R22, 0x32
	rcall	send_kbd_command	; 0x133c
	mov	R17, R24
	cpi	R24, 0x02
	brne	A_0934	; 0x934
	ldi	R24, 0x32
	rcall	get_kbd_byte	; 0x1492
	cpi	R24, 0xfa
	brne	A_0934	; 0x934
A_08d0:
	movw	R24, R28
	adiw	R24, 0x02
	ldi	R22, 0x32
	rcall	fetch_kbd_byte	; 0x13de
	cpi	R24, 0x02
	brne	A_0924	; 0x924
A_08dc:
	movw	R24, R28
	adiw	R24, 0x03
	ldi	R22, 0x32
	rcall	fetch_kbd_byte	; 0x13de
	ldd	R25, Y+2
	cpi	R24, 0x02
	brne	A_0916	; 0x916
A_08ea:
	cpi	R25, 0xab
	brne	A_08fa	; 0x8fa
A_08ee:
	ldd	R24, Y+3
	cpi	R24, 0x85
	breq	A_08fa	; 0x8fa
A_08f4:
	sts	keyboard_codeset, R4	; 0x200
	rjmp	A_0900	; 0x900
A_08fa:
	ldi	R24, 0x03
	sts	keyboard_codeset, R24	; 0x200
A_0900:
	mov	R7, R25
	clr	R6
	ldd	R24, Y+3
	ldi	R25, 0x00
	or	R24, R6
	or	R25, R7
	sts	keyboard_id+1, R25	; 0x242
	sts	keyboard_id, R24	; 0x240
	rjmp	A_0934	; 0x934
A_0916:
	sts	keyboard_codeset, R4	; 0x200
	sts	keyboard_id, R25	; 0x240
	sts	keyboard_id+1, __zero_reg__	; 0x242
	rjmp	A_0934	; 0x934
A_0924:
	sts	keyboard_codeset, R17	; 0x200
	rjmp	A_0934	; 0x934
A_092a:
	sts	keyboard_mode, R2	; 0x252
	ldi	R24, 0x01	;keyboard_codeset = 1;
	sts	keyboard_codeset, R24	; 0x200
	
A_0934:
	lds	R24, keyboard_codeset	; 0x200
	and	R24, R24
	brne	A_0940	; 0x940
A_093c:
	sts	keyboard_codeset, R4	; 0x200
A_0940:
	lds	R22, keyboard_id	; 0x240
	lds	R23, keyboard_id+1	; 0x242
	lds	R24, keyboard_codeset	; 0x200
	call	setup_proc_kbd	; 0x2b22
	call	setup_processing	; 0x2e28
	
	lds	R24, keyboard_mode	; 0x252
	cpi	R24, 0x02
	brne	A_0960	; 0x960
A_095c:
	rcall	disable_extint1	; 0xd3e
	rcall	enable_extint1_rising	; 0xd4a
A_0960:
	lds	R24, keyboard_codeset	; 0x200
	cpi	R24, 0x03
	brne	A_096c	; 0x96c
A_0968:
	ldi	R24, 0xf8
	rcall	send_kbd_command_without_parm	; 0x1538
A_096c:
	ldi	R24, 0x00	;set_kbd_leds(0);  // turn all LEDs off
	rcall	set_kbd_leds	; 0x6da
	in	R24, SREG
	cli	
	lds	t0ct_start, timer0_counter	; 0x26c
	lds	t0ct_start_b2, timer0_counter+1	; 0x26e
	lds	t0ct_start_b3, timer0_counter+2	; 0x270
	lds	t0ct_start_b4, timer0_counter+3	; 0x272
	out	SREG, R24
	ldi	R24, 0x0a	;usb_debug_putchar('\n');
	call	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0x0a	;usb_debug_putchar('\n');
	call	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0xf4	;print_P(PSTR("Keyboard ID: "));  // A_02f4
	ldi	R25, 0x02
	call	print_P	; 0x2344
	lds	R24, keyboard_id	; 0x240
	lds	R25, keyboard_id+1	; 0x242
	call	phex16	; 0x2334
	ldi	R24, 0x0a	;usb_debug_putchar('\n');
	call	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0xe9	;print_P(PSTR("Code Set: "));  // A_02e9
	ldi	R25, 0x02
	call	print_P	; 0x2344
	lds	R24, keyboard_codeset	; 0x200
	cpi	R24, 0x02
	breq	A_09d4	; 0x9d4
	cpi	R24, 0x03
	brcc	A_09c6	; 0x9c6
	cpi	R24, 0x01
	brne	A_09e6	; 0x9e6
	rjmp	A_09d0	; 0x9d0
A_09c6:
	cpi	R24, 0x03
	breq	A_09dc	; 0x9dc
	cpi	R24, 0x04
	brne	A_09e6	; 0x9e6
	rjmp	A_09e0	; 0x9e0
	
A_09d0:
	ldi	R24, 0x31	;usb_debug_putchar('1');
	rjmp	A_09d6	; 0x9d6
A_09d4:
	ldi	R24, 0x32	;usb_debug_putchar('2');
A_09d6:
	call	rjmp_usb_debug_putchar	; 0x230c
	rjmp	A_09ee	; 0x9ee
A_09dc:
	ldi	R24, 0x33	;usb_debug_putchar('3');
	rjmp	A_09d6	; 0x9d6
A_09e0:
	ldi	R24, 0xdc	;print_P(PSTR("2 (extended)"));  // A_02dc
	ldi	R25, 0x02
	rjmp	A_09ea	; 0x9ea
A_09e6:
	ldi	R24, 0xd4	;print_P(PSTR("unknown"));  // A_02d4
	ldi	R25, 0x02
A_09ea:
	call	print_P	; 0x2344
A_09ee:
	lds	R24, keyboard_mode	; 0x252
	cpi	R24, 0x02
	brne	A_09fc	; 0x9fc
	ldi	R24, 0xc5	;print_P(PSTR("\nMode: PC/XT\n\n"));  // A_02c5
	ldi	R25, 0x02
	rjmp	A_0a00	; 0xa00
A_09fc:
	ldi	R24, 0xb5	;print_P(PSTR("\nMode: AT/PS2\n\n"));  // A_02b5
	ldi	R25, 0x02
A_0a00:
	call	print_P	; 0x2344
A_0a04:
	clr	keyboard_determined
	inc	keyboard_determined
	
A_0a08:
	movw	R24, R28
	adiw	R24, 0x01
	ldi	R22, 0x00
	rcall	fetch_kbd_byte	; 0x13de
	and	keyboard_determined, keyboard_determined
	brne	A_0a16	; 0xa16
A_0a14:
	rjmp	A_0bd0	; 0xbd0
A_0a16:
	cpi	R24, 0x02
	brcc	A_0a1c	; 0xa1c
	rjmp	A_0b26	; 0xb26
A_0a1c:
	cpi	R24, 0x02
	breq	A_0a22	; 0xa22
	rjmp	A_0afc	; 0xafc
A_0a22:
	ldd	R17, Y+1
	lds	R24, keyboard_codeset	; 0x200
	cpi	R24, 0x01
	brne	A_0a46	; 0xa46
A_0a2c:
	cpi	R17, 0xff
	brne	A_0a32	; 0xa32
	rjmp	A_0ace	; 0xace
A_0a32:
	sbrs	R17, 7
	rjmp	A_0a40	; 0xa40
A_0a36:
	mov	R24, R17
	andi	R24, 0x7f
	ldi	R22, 0x00
	rcall	incoming_kbd_breakcode	; 0x71e
	rjmp	A_0b08	; 0xb08
A_0a40:
	mov	R24, R17
	ldi	R22, 0x00
	rjmp	A_0a6c	; 0xa6c
A_0a46:
	lds	R25, kbd_extended2_scancode	; 0x248
	and	R25, R25
	breq	A_0a90	; 0xa90
A_0a4e:
	mov	R30, R25
	ldi	R31, 0x00
	subi	R30, 0xff    ;R30/31 += kbd_pauseseq
	sbci	R31, 0xfe
	ld	R24, Z
	cp	R17, R24
	brne	A_0a82	; 0xa82
	
A_0a5c:
	mov	R30, R25
	subi	R30, 0xff
	sts	kbd_extended2_scancode, R30	; 0x248
	cpi	R30, 0x03
	brne	A_0a70	; 0xa70
A_0a68:
	ldi	R24, 0x7e
	ldi	R22, 0x01
A_0a6c:
	rcall	incoming_kbd_makecode	; 0x724
	rjmp	A_0b08	; 0xb08
A_0a70:
	cpi	R30, 0x08
	breq	A_0a76	; 0xa76
	rjmp	A_0b08	; 0xb08
A_0a76:
	ldi	R24, 0x7e
	ldi	R22, 0x01
	rcall	incoming_kbd_breakcode	; 0x71e
	sts	kbd_extended2_scancode, __zero_reg__	; 0x248
	rjmp	A_0b08	; 0xb08
A_0a82:
	cpi	R25, 0x03
	brcs	A_0a8c	; 0xa8c
A_0a86:
	ldi	R24, 0x7e
	ldi	R22, 0x01
	rcall	incoming_kbd_breakcode	; 0x71e
A_0a8c:	
	sts	kbd_extended2_scancode, __zero_reg__	; 0x248
A_0a90:
	cpi	R17, 0xe0
	breq	A_0ab8	; 0xab8
A_0a94:
	cpi	R17, 0xe1
	brcc	A_0aa2	; 0xaa2
A_0a98:
	and	R17, R17
	breq	A_0ace	; 0xace
A_0a9c:
	cpi	R17, 0xaa
	brne	A_0ad8	; 0xad8
	rjmp	A_0b08	; 0xb08
A_0aa2:
	cpi	R17, 0xf0
	breq	A_0ab0	; 0xab0
A_0aa6:
	cpi	R17, 0xfc
	breq	A_0ac8	; 0xac8
	cpi	R17, 0xe1
	brne	A_0ad8	; 0xad8
	rjmp	A_0ac0	; 0xac0
A_0ab0:
	ldi	R24, 0x01
	sts	kbd_breakcode, R24	; 0x244
	rjmp	A_0b08	; 0xb08
A_0ab8:
	ldi	R24, 0x01
	sts	kbd_extended_scancode, R24	; 0x246
	rjmp	A_0b08	; 0xb08
A_0ac0:
	ldi	R24, 0x01
	sts	kbd_extended2_scancode, R24	; 0x248
	rjmp	A_0b08	; 0xb08
A_0ac8:
	ldi	R24, 0x10
	ldi	R25, 0x27
	rjmp	A_0ad4	; 0xad4
A_0ace:
	rcall	reset_kbdinstate	; 0x6c4
	ldi	R24, 0x88
	ldi	R25, 0x13
A_0ad4:
	rcall	act_onboard_led	; 0x1586
	rjmp	A_0b08	; 0xb08
A_0ad8:
	lds	R24, kbd_breakcode	; 0x244
	and	R24, R24
	breq	A_0aee	; 0xaee
A_0ae0:
	mov	R24, R17
	lds	R22, kbd_extended_scancode	; 0x246
	rcall	incoming_kbd_breakcode	; 0x71e
	sts	kbd_breakcode, __zero_reg__	; 0x244
	rjmp	A_0af6	; 0xaf6
A_0aee:
	mov	R24, R17
	lds	R22, kbd_extended_scancode	; 0x246
	rcall	incoming_kbd_makecode	; 0x724
A_0af6:
	sts	kbd_extended_scancode, __zero_reg__	; 0x246
	rjmp	A_0b08	; 0xb08
	
A_0afc:
	ldi	R24, 0xfe				; send_kbd_command(0xfe, 50); // request resend of last byte
	ldi	R22, 0x32
	rcall	send_kbd_command	; 0x133c
	clr	resend_requested
	inc	resend_requested
	rjmp	A_0b0a	; 0xb0a
A_0b08:
	clr	resend_requested
A_0b0a:
	in	R24, SREG
	cli	
	lds	t0ct_start, timer0_counter	; 0x26c
	lds	t0ct_start_b2, timer0_counter+1	; 0x26e
	lds	t0ct_start_b3, timer0_counter+2	; 0x270
	lds	t0ct_start_b4, timer0_counter+3	; 0x272
	out	SREG, R24
	clr	newline_after_wait
	inc	newline_after_wait
	rjmp	A_0c08	; 0xc08
A_0b26:
	and	R24, R24
	breq	A_0b2c	; 0xb2c
	rjmp	A_0c08	; 0xc08
A_0b2c:
	and	resend_requested, resend_requested
	breq	A_0b32	; 0xb32
	rjmp	A_0c08	; 0xc08
A_0b32:
	call	get_keyboard_leds	; 0x341c
	mov	R17, R24
	call	get_keyboard_protocol	; 0x3422
	mov	new_pled_state, R24
	ror	new_pled_state
	clr	new_pled_state
	ror	new_pled_state
	or	new_pled_state, R17
	lds	R24, prot_led_state	; 0x24a
	cp	new_pled_state, R24
	brne	A_0b50	; 0xb50
	rjmp	A_0c08	; 0xc08
A_0b50:
	clr	R15
	inc	R15
	and	R15, new_pled_state
	mov	R14, new_pled_state
	lsr	R14
	ldi	R18, 0x01
	and	R14, R18
	mov	R17, new_pled_state
	lsr	R17
	lsr	R17
	andi	R17, 0x01
	lds	R24, keyboard_id	; 0x240
	lds	R25, keyboard_id+1	; 0x242
	mov	R22, R15
	ldi	R23, 0x00
	mov	R18, R14
	ldi	R19, 0x00
	subi	R24, 0xb0
	sbci	R25, 0xbf
	brne	A_0b8c	; 0xb8c
A_0b7c:
	add	R22, R22
	adc	R23, R23
	add	R22, R22
	adc	R23, R23
	or	R22, R17
	add	R18, R18
	adc	R19, R19
	rjmp	A_0b9a	; 0xb9a
A_0b8c:
	add	R22, R22
	adc	R23, R23
	or	R22, R17
	add	R18, R18
	adc	R19, R19
	add	R18, R18
	adc	R19, R19
A_0b9a:
	or	R22, R18
	ldi	R24, 0xed	; set PS/2 keyboard LEDs
	rcall	send_kbd_command_with_parm	; 0x14c6
	add	R15, R15
	or	R15, R14
	add	R17, R17
	add	R17, R17
	mov	R24, R17
	or	R24, R15
	;set new keyboard LED combination
	rcall	set_kbd_leds	; 0x6da
	sts	prot_led_state, new_pled_state	; 0x24a
	rjmp	A_0c08	; 0xc08
A_0bb4:
	in	R24, SREG
	cli	
	lds	t0ct_start, timer0_counter	; 0x26c
	lds	t0ct_start_b2, timer0_counter+1	; 0x26e
	lds	t0ct_start_b3, timer0_counter+2	; 0x270
	lds	t0ct_start_b4, timer0_counter+3	; 0x272
	out	SREG, R24
	clr	newline_after_wait
	inc	newline_after_wait
	rjmp	A_0bd4	; 0xbd4
A_0bd0:
	and	newline_after_wait, newline_after_wait
	breq	A_0c02	; 0xc02
A_0bd4:
	in	R18, SREG
	cli	
	lds	R24, timer0_counter	; 0x26c
	lds	R25, timer0_counter+1	; 0x26e
	lds	R26, timer0_counter+2	; 0x270
	lds	R27, timer0_counter+3	; 0x272
	out	SREG, R18
	sub	R24, t0ct_start
	sbc	R25, t0ct_start_b2
	sbc	R26, t0ct_start_b3
	sbc	R27, t0ct_start_b4
	sbiw	R24, 0x33
	cpc	R26, __zero_reg__
	cpc	R27, __zero_reg__
	brcs	A_0c02	; 0xc02
	ldi	R24, 0x0a	;usb_debug_putchar('\n');
	call	rjmp_usb_debug_putchar	; 0x230c
	clr	newline_after_wait
A_0c02:
	call	rawhid_comm	; 0x2f98
	rjmp	A_080c	; 0x80c

A_0c08:
	rcall	send_aux_key_changes	; 0x72a
	and	R24, R24
	brne	A_0bb4	; 0xbb4
	rjmp	A_0bd0	; 0xbd0

;==========================================
; TIMER3_COMPA_vect: Timer/Counter3 Compare Match A
;==========================================
TIMER3_COMPA_vect:
A_0c10:	push	__zero_reg__
A_0c12:	push	R0
A_0c14:	in	R0, SREG
A_0c16:	push	R0
A_0c18:	clr	__zero_reg__
A_0c1a:	push	R24
A_0c1c:	push	R25
A_0c1e:	in	R25, PINB         ; fetch Aux Key 1..5
A_0c20:	andi	R25, 0x1f
A_0c22:	lds	R24, tmr_aux_key_bits	; 0x250
A_0c26:	cp	R25, R24
A_0c28:	breq	A_0c34	; 0xc34
A_0c2a:	sts	tmr_aux_key_bits, R25	; 0x250
A_0c2e:	ldi	R24, 0x0a
A_0c30:	sts	aux_key_timercounter, R24	; 0x212
A_0c34:	lds	R24, aux_key_timercounter	; 0x212
A_0c38:	and	R24, R24
A_0c3a:	breq	A_0c4e	; 0xc4e
A_0c3c:	subi	R24, 0x01
A_0c3e:	sts	aux_key_timercounter, R24	; 0x212
A_0c42:	and	R24, R24
A_0c44:	brne	A_0c4e	; 0xc4e
A_0c46:	lds	R24, tmr_aux_key_bits	; 0x250
A_0c4a:	sts	aux_key_bits, R24	; 0x24e
A_0c4e:	pop	R25
A_0c50:	pop	R24
A_0c52:	pop	R0
A_0c54:	out	SREG, R0
A_0c56:	pop	R0
A_0c58:	pop	__zero_reg__
A_0c5a:	reti	

;==============================================
; setup_aux_key_handler : 
;==============================================
setup_aux_key_handler:
A_0c5c:	in	R24, DDRB       ; make bits 0..4 in DDRB input (Aux Key 1..5)
A_0c5e:	andi	R24, 0xe0
A_0c60:	out	DDRB, R24
A_0c62:	in	R24, PORTB      ; set pullup for these
A_0c64:	ori	R24, 0x1f
A_0c66:	out	PORTB, R24
A_0c68:	ldi	R30, TIMSK3		;TIMSK3 |= (1 << OCIE3A);
A_0c6a:	ldi	R31, 0x00
A_0c6c:	ld	R24, Z
A_0c6e:	ori	R24, 0x02
A_0c70:	st	Z, R24
A_0c72:	ldi	R24, 0xfa		
A_0c74:	ldi	R25, 0x00
A_0c76:	sts	OCR3AH, R25	; 0x132
A_0c7a:	sts	OCR3AL, R24	; 0x130
A_0c7e:	sts	TCCR3A, __zero_reg__	; 0x120
A_0c82:	ldi	R30, 0x91		;TCCR3B = (1 << WGM32);
A_0c84:	ldi	R31, 0x00
A_0c86:	ldi	R24, 0x08
A_0c88:	st	Z, R24
A_0c8a:	ld	R24, Z          ; TCCR3B |= (1 << CS31) | (1 << CS30);
A_0c8c:	ori	R24, 0x03
A_0c8e:	st	Z, R24
A_0c90:	ret	

;=============================================
; get_aux_key_bits
;=============================================
get_aux_key_bits:
A_0c92:
	lds	R24, aux_key_bits	; 0x24e
	ret	

;=============================================
; setup_timer1 : sets up timer/counter 1 for operation
;=============================================
setup_timer1:
A_0c98:	movw	R18, R24
A_0c9a:	lds	R24, TCCR1B	; 0x102
A_0c9e:	andi	R24, 0xf8  ; TCCR1B &= ~((1 << CS12)|(1 << CS11)|(1 << CS10));
A_0ca0:	sts	TCCR1B, R24	; 0x102
A_0ca4:	lds	R24, TIMSK1	; TIMSK1 &= ~(1 << OCIE1A) (?)
A_0ca8:	andi	R24, 0xfd
A_0caa:	sts	TIMSK1, R24	; 
A_0cae:	sts	TCNT1H, __zero_reg__	; TCNT1H
A_0cb2:	sts	TCNT1L, __zero_reg__	; TCNT1L
A_0cb6:	ldi	R24, 0x02
A_0cb8:	out	TIFR1, R24  ;TIFR1 = 2
A_0cba:	cp	R18, __zero_reg__
A_0cbc:	cpc	R19, __zero_reg__
A_0cbe:	breq	A_0ce0	; 0xce0
A_0cc0:	add	R18, R18
A_0cc2:	adc	R19, R19
A_0cc4:	sts	0x0089, R19	; OCR1AH
A_0cc8:	sts	0x0088, R18	; OCR1AL
A_0ccc:	lds	R24, TIMSK1	; TIMSK1 |= 1 << OCIE1A
A_0cd0:	ori	R24, 0x02
A_0cd2:	sts	TIMSK1, R24	; 
A_0cd6:	lds	R24, TCCR1B	; TCCR1B |= 1 << CS11
A_0cda:	ori	R24, 0x02
A_0cdc:	sts	TCCR1B, R24	; 0x102
A_0ce0:	ret	

;====================================================
; set_kbd_reset_pin : sets up the keyboard reset pin
;====================================================
set_kbd_reset_pin:
A_0ce2:	and	R24, R24
A_0ce4:	breq	A_0cec	; 0xcec
A_0ce6:	cbi	DDRB, 7
A_0ce8:	sbi	PORTB, 7
A_0cea:	ret	
A_0cec:	cbi	PORTB, 7
A_0cee:	sbi	DDRB, 7	
A_0cf0:	ret	

;====================================================
; set_kbd_data_pin : sets the keyboard Data pin
;====================================================
set_kbd_data_pin:
A_0cf2:	and	R24, R24
A_0cf4:	breq	A_0cfc	; 0xcfc
A_0cf6:	cbi	DDRD, 0
A_0cf8:	sbi	PORTD, 0
A_0cfa:	ret	
A_0cfc:	cbi	PORTD, 0
A_0cfe:	sbi	DDRD, 0
A_0d00:	ret	

;=====================================================
; set_kbd_clock_pin : sets the clock line and waits for it
;=====================================================
set_kbd_clock_pin:
A_0d02:	mov	R19, R24
A_0d04:	in	R20, EIMSK
A_0d06:	cbi	EIMSK, 1    ;EISMK &= ~INT1
A_0d08:	nop	
A_0d0a:	and	R24, R24
A_0d0c:	breq	A_0d14	; 0xd14
A_0d0e:	cbi	DDRD, 1     ;DDRD &= ~DDD1
A_0d10:	sbi	PORTD, 1	;PORTD |= PORTD1
A_0d12:	rjmp	A_0d18	; 0xd18
A_0d14:	sbi	DDRD, 1		;DDRD |= DDD1
A_0d16:	cbi	PORTD, 1	;PORTD &= ~PORTD1
A_0d18:	ldi	R18, 0x14
A_0d1a:	in	R24, PIND
A_0d1c:	ldi	R25, 0x00
A_0d1e:	lsr	R25
A_0d20:	ror	R24
A_0d22:	andi	R24, 0x01
A_0d24:	cp	R24, R19
A_0d26:	breq	A_0d2c	; 0xd2c
A_0d28:	subi	R18, 0x01
A_0d2a:	brne	A_0d1a	; 0xd1a

A_0d2c:	ldi	R24, 0x02	; EIFR = (1 << INTF1)
A_0d2e:	out	EIFR, R24
A_0d30:	sbrs	R20, 1
A_0d32:	rjmp	A_0d38	; 0xd38
A_0d34:	sbi	EIMSK, 1	; EIMSK |= INT1
A_0d36:	rjmp	A_0d3a	; 0xd3a
A_0d38:	cbi	EIMSK, 1	; EIMSK &= ~INT1
A_0d3a:	in	R24, EIMSK
A_0d3c:	ret	

;=====================================================
; 
;=====================================================
disable_extint1:
A_0d3e:	cli	
A_0d40:	cbi	EIMSK, 1	;EIMSK &= ~(1 << INT1)
A_0d42:	ldi	R24, 0x02
A_0d44:	out	EIFR, R24	;EIFR = INTF1
A_0d46:	sei	
A_0d48:	ret	

;=====================================================
; 
;=====================================================
enable_extint1_rising:
A_0d4a:	cli	
A_0d4c:	ldi	R30, 0x69
A_0d4e:	ldi	R31, 0x00
A_0d50:	ld	R24, Z		; EICRA |= (1 << ISC11) | (1 << ISC10)
A_0d52:	ori	R24, 0x0c
A_0d54:	st	Z, R24
A_0d56:	sbi	EIMSK, 1	; EIMSK |= INT1
A_0d58:	sei	
A_0d5a:	ret	

;=====================================================
; A_0d5c :
;=====================================================
A_0d5c:
A_0d5c:	and	R24, R24
A_0d5e:	breq	A_0d68	; 0xd68
A_0d60:	lds	R24, 0x0111	; 0x222
A_0d64:	sts	0x0112, R24	; 0x224
A_0d68:	in	R24, PIND
A_0d6a:	ldi	R25, 0x00
A_0d6c:	lsr	R25
A_0d6e:	ror	R24
A_0d70:	mov	R25, R24
A_0d72:	andi	R25, 0x01	;R25 = (PIND>>1)&1
A_0d74:	lds	R24, 0x0112	; 0x224
A_0d78:	cpi	R24, 0xff
A_0d7a:	brne	A_0d84	; 0xd84
A_0d7c:	ldi	R24, 0x01
A_0d7e:	eor	R24, R25
A_0d80:	sts	0x0112, R24	; 0x224

A_0d84:	lds	R24, 0x0112	; 0x224
A_0d88:	cpi	R24, 0x01
A_0d8a:	breq	A_0dae	; 0xdae
A_0d8c:	cpi	R24, 0x01
A_0d8e:	brcs	A_0d96	; 0xd96
A_0d90:	cpi	R24, 0xfe
A_0d92:	brne	A_0dc2	; 0xdc2
A_0d94:	rjmp	A_0dc8	; 0xdc8

;0x0112==0
A_0d96:	and	R25, R25
A_0d98:	breq	A_0dcc	; 0xdcc
A_0d9a:	ldi	R24, 0x5a
A_0d9c:	ldi	R25, 0x00
A_0d9e:	rcall	setup_timer1	; 0xc98
A_0da0:	ldi	R24, 0xfe
A_0da2:	sts	0x0111, R24	; 0x222
A_0da6:	ldi	R24, 0x01
A_0da8:	sts	0x0112, R24	; 0x224
A_0dac:	rjmp	A_0dc2	; 0xdc2	return 1;

;0x0112==1
A_0dae:	and	R25, R25
A_0db0:	brne	A_0dcc	; 0xdcc
A_0db2:	ldi	R24, 0xe8
A_0db4:	ldi	R25, 0x03
A_0db6:	rcall	setup_timer1	; 0xc98
A_0db8:	ser	R24
A_0dba:	sts	0x0111, R24	; 0x222
A_0dbe:	sts	0x0112, __zero_reg__	; 0x224
A_0dc2:	ldi	R25, 0x01
A_0dc4:	mov	R24, R25
A_0dc6:	ret	

;0x0112==0xfe
A_0dc8:	ldi	R25, 0x02
A_0dca:	rjmp	A_0dce	; 0xdce
A_0dcc:	ldi	R25, 0x04
A_0dce:	ser	R24
A_0dd0:	sts	0x0112, R24	; 0x224
A_0dd4:	rjmp	A_0dc4	; 0xdc4

;=====================================================
; pcxt_clockin :
;=====================================================
pcxt_clockin:
A_0dd6:	push	R17
A_0dd8:	in	R17, PIND
A_0dda:	andi	R17, 0x01
A_0ddc:	and	R24, R24
A_0dde:	breq	A_0de8	; 0xde8
A_0de0:	lds	R24, read_pcxt_nextstate	; 0x214
A_0de4:	sts	read_pcxt_state, R24	; 0x216
A_0de8:	lds	R24, read_pcxt_state	; 0x216
A_0dec:	cpi	R24, 0x02
A_0dee:	breq	A_0e2c	; 0xe2c
A_0df0:	cpi	R24, 0x03
A_0df2:	brcc	A_0dfc	; 0xdfc
A_0df4:	cpi	R24, 0x01
A_0df6:	breq	A_0dfa	; 0xdfa
A_0df8:	rjmp	A_0e90	; 0xe90
A_0dfa:	rjmp	A_0e08	; 0xe08
A_0dfc:	cpi	R24, 0x03
A_0dfe:	breq	A_0e5e	; 0xe5e
A_0e00:	cpi	R24, 0xfe
A_0e02:	breq	A_0e06	; 0xe06
A_0e04:	rjmp	A_0e90	; 0xe90
A_0e06:	rjmp	A_0e7c	; 0xe7c
A_0e08:	ldi	R24, 0xfe
A_0e0a:	sts	read_pcxt_nextstate, R24	; 0x214
A_0e0e:	ldi	R24, 0xb0
A_0e10:	ldi	R25, 0x04
A_0e12:	rcall	setup_timer1	; 0xc98
A_0e14:	sts	read_pcxt_shiftin, __zero_reg__	; 0x25a
A_0e18:	sts	read_pcxt_bits, __zero_reg__	; 0x258
A_0e1c:	and	R17, R17
A_0e1e:	brne	A_0e24	; 0xe24
A_0e20:	ldi	R17, 0x06
A_0e22:	rjmp	A_0e7e	; 0xe7e
A_0e24:	ldi	R24, 0x02
A_0e26:	sts	read_pcxt_state, R24	; 0x216
A_0e2a:	rjmp	A_0e90	; 0xe90
A_0e2c:	ror	R17
A_0e2e:	clr	R17
A_0e30:	ror	R17
A_0e32:	lds	R24, read_pcxt_bits	; 0x258
A_0e36:	lsr	R24
A_0e38:	or	R17, R24
A_0e3a:	sts	read_pcxt_bits, R17	; 0x258
A_0e3e:	lds	R24, read_pcxt_shiftin	; 0x25a
A_0e42:	subi	R24, 0xff
A_0e44:	sts	read_pcxt_shiftin, R24	; 0x25a
A_0e48:	cpi	R24, 0x08
A_0e4a:	brne	A_0e90	; 0xe90
A_0e4c:	ldi	R17, 0x03
A_0e4e:	sts	read_pcxt_nextstate, R17	; 0x214
A_0e52:	ldi	R24, 0x78
A_0e54:	ldi	R25, 0x00
A_0e56:	rcall	setup_timer1	; 0xc98
A_0e58:	sts	read_pcxt_state, R17	; 0x216
A_0e5c:	rjmp	A_0e90	; 0xe90
A_0e5e:	ldi	R24, 0x00
A_0e60:	ldi	R25, 0x00
A_0e62:	rcall	setup_timer1	; 0xc98
A_0e64:	lds	R24, read_pcxt_bits	; 0x258
A_0e68:	sts	kbd_rcvd_byte, R24	; 0x254
A_0e6c:	ldi	R17, 0x02
A_0e6e:	rjmp	A_0e7e	; 0xe7e
A_0e70:	ldi	R24, 0xb8
A_0e72:	ldi	R25, 0x0b
A_0e74:	rcall	act_onboard_led	; 0x1586
A_0e76:	sts	kbd_rcvd_state, R17	; 0x256
A_0e7a:	rjmp	A_0e90	; 0xe90

A_0e7c:	ldi	R17, 0x05
A_0e7e:	ldi	R24, 0x00
A_0e80:	ldi	R25, 0x00
A_0e82:	rcall	setup_timer1	; 0xc98
A_0e84:	ldi	R24, 0x01
A_0e86:	sts	read_pcxt_state, R24	; 0x216
A_0e8a:	cpi	R17, 0x02
A_0e8c:	brne	A_0e70	; 0xe70
A_0e8e:	rjmp	A_0e76	; 0xe76
A_0e90:	pop	R17
A_0e92:	ret	

;=====================================================
; 
;=====================================================
atps2_clockout:
A_0e94:	push	R16
A_0e96:	push	R17
A_0e98:	mov	R25, R24

.def	curbit = R16
.def	rc = R17

A_0e9a:	lds	R24, atps2_write_state	; 0x21c
A_0e9e:	cpi	R24, 0xff
A_0ea0:	brne	A_0ea8	; 0xea8
A_0ea2:	ldi	R24, 0x02
A_0ea4:	sts	atps2_write_state, R24	; 0x21c
A_0ea8:	and	R25, R25
A_0eaa:	breq	A_0eb4	; 0xeb4
A_0eac:	lds	R24, atps2_write_t1state	; 0x21a
A_0eb0:	sts	atps2_write_state, R24	; 0x21c

A_0eb4:	lds	R24, atps2_write_state	; 0x21c
A_0eb8:	cpi	R24, 0x07
A_0eba:	brne	A_0ebe	; 0xebe
A_0ebc:	rjmp	A_0f7e	; 0xf7e
A_0ebe:	cpi	R24, 0x08
A_0ec0:	brcc	A_0ee4	; 0xee4
A_0ec2:	cpi	R24, 0x04
A_0ec4:	brne	A_0ec8	; 0xec8
A_0ec6:	rjmp	A_0f44	; 0xf44
A_0ec8:	cpi	R24, 0x05
A_0eca:	brcc	A_0ed8	; 0xed8
A_0ecc:	cpi	R24, 0x02
A_0ece:	breq	A_0f0a	; 0xf0a
A_0ed0:	cpi	R24, 0x03
A_0ed2:	breq	A_0ed6	; 0xed6
A_0ed4:	rjmp	A_0fd8	; 0xfd8
A_0ed6:	rjmp	A_0f30	; 0xf30
A_0ed8:	cpi	R24, 0x05
A_0eda:	breq	A_0f48	; 0xf48
A_0edc:	cpi	R24, 0x06
A_0ede:	breq	A_0ee2	; 0xee2
A_0ee0:	rjmp	A_0fd8	; 0xfd8
A_0ee2:	rjmp	A_0f7a	; 0xf7a
A_0ee4:	cpi	R24, 0x0a
A_0ee6:	brne	A_0eea	; 0xeea
A_0ee8:	rjmp	A_0fa8	; 0xfa8
A_0eea:	cpi	R24, 0x0b
A_0eec:	brcc	A_0efc	; 0xefc
A_0eee:	cpi	R24, 0x08
A_0ef0:	brne	A_0ef4	; 0xef4
A_0ef2:	rjmp	A_0f92	; 0xf92
A_0ef4:	cpi	R24, 0x09
A_0ef6:	breq	A_0efa	; 0xefa
A_0ef8:	rjmp	A_0fd8	; 0xfd8
A_0efa:	rjmp	A_0f96	; 0xf96
A_0efc:	cpi	R24, 0x0b
A_0efe:	brne	A_0f02	; 0xf02
A_0f00:	rjmp	A_0fb0	; 0xfb0
A_0f02:	cpi	R24, 0xfe
A_0f04:	breq	A_0f08	; 0xf08
A_0f06:	rjmp	A_0fd8	; 0xfd8
A_0f08:	rjmp	A_0fbe	; 0xfbe

A_0f0a:	lds	R24, kbdcmd_to_send	; 0x25c
A_0f0e:	sts	atps2_write_shiftout, R24	; 0x25e
A_0f12:	ldi	R24, 0x08
A_0f14:	sts	atps2_write_bits, R24	; 0x260
A_0f18:	ldi	R24, 0x01
A_0f1a:	sts	atps2_write_parity, R24	; 0x218
A_0f1e:	ldi	R24, 0x03
A_0f20:	sts	atps2_write_t1state, R24	; 0x21a
A_0f24:	ldi	R24, 0xc8
A_0f26:	ldi	R25, 0x00
A_0f28:	rcall	setup_timer1	; 0xc98
A_0f2a:	ldi	R24, 0x00
A_0f2c:	rcall	set_kbd_clock_pin	; 0xd02
A_0f2e:	rjmp	A_0fd8	; 0xfd8

A_0f30:	ldi	R24, 0x00
A_0f32:	rcall	set_kbd_data_pin	; 0xcf2
A_0f34:	ldi	R24, 0x01
A_0f36:	rcall	set_kbd_clock_pin	; 0xd02
A_0f38:	ldi	R24, 0xfe
A_0f3a:	sts	atps2_write_t1state, R24	; 0x21a
A_0f3e:	ldi	R24, 0x20
A_0f40:	ldi	R25, 0x4e
A_0f42:	rcall	setup_timer1	; 0xc98

A_0f44:	ldi	R24, 0x05
A_0f46:	rjmp	A_0faa	; 0xfaa

A_0f48:	lds	R17, atps2_write_shiftout	; 0x25e
A_0f4c:	mov	curbit, R17
A_0f4e:	andi	curbit, 0x01
A_0f50:	mov	R24, curbit
A_0f52:	rcall	set_kbd_data_pin	; 0xcf2
A_0f54:	lsr	R17
A_0f56:	sts	atps2_write_shiftout, R17	; 0x25e
A_0f5a:	lds	R24, atps2_write_parity	; 0x218
A_0f5e:	eor	R24, curbit
A_0f60:	sts	atps2_write_parity, R24	; 0x218
A_0f64:	lds	R24, atps2_write_bits	; 0x260
A_0f68:	subi	R24, 0x01
A_0f6a:	sts	atps2_write_bits, R24	; 0x260
A_0f6e:	and	R24, R24
A_0f70:	breq	A_0f76	; 0xf76
A_0f72:	ldi	R24, 0x04
A_0f74:	rjmp	A_0faa	; 0xfaa
A_0f76:	ldi	R24, 0x06
A_0f78:	rjmp	A_0faa	; 0xfaa

A_0f7a:	ldi	R24, 0x07
A_0f7c:	rjmp	A_0faa	; 0xfaa

A_0f7e:	lds	R24, atps2_write_parity	; 0x218
A_0f82:	rcall	set_kbd_data_pin	; 0xcf2
A_0f84:	lds	R24, atps2_write_bits	; 0x260
A_0f88:	subi	R24, 0x01
A_0f8a:	sts	atps2_write_bits, R24	; 0x260
A_0f8e:	ldi	R24, 0x08
A_0f90:	rjmp	A_0faa	; 0xfaa

A_0f92:	ldi	R24, 0x09
A_0f94:	rjmp	A_0faa	; 0xfaa

A_0f96:	ldi	R24, 0x01
A_0f98:	rcall	set_kbd_data_pin	; 0xcf2
A_0f9a:	lds	R24, atps2_write_bits	; 0x260
A_0f9e:	subi	R24, 0x01
A_0fa0:	sts	atps2_write_bits, R24	; 0x260
A_0fa4:	ldi	R24, 0x0a
A_0fa6:	rjmp	A_0faa	; 0xfaa

A_0fa8:	ldi	R24, 0x0b
A_0faa:	sts	atps2_write_state, R24	; 0x21c
A_0fae:	rjmp	A_0fd8	; 0xfd8

A_0fb0:	ldi	R24, 0x00
A_0fb2:	ldi	R25, 0x00
A_0fb4:	rcall	setup_timer1	; 0xc98
A_0fb6:	sbic	PIND, 0	; skip next instruction if PIND0 is clear, i.e., if (!(PIND & PIND0))
A_0fb8:	rjmp	A_1012	; 0x1012
A_0fba:	ldi	rc, 0x02
A_0fbc:	rjmp	A_0fcc	; 0xfcc

A_0fbe:	lds	rc, atps2_write_bits	; 0x260
A_0fc2:	swap	rc
A_0fc4:	andi	rc, 0xf0
A_0fc6:	ori	rc, 0x05
A_0fc8:	cpi	rc, 0x02
A_0fca:	brcs	A_0fd8	; 0xfd8

A_0fcc:	ldi	R24, 0x01
A_0fce:	rcall	set_kbd_data_pin	; 0xcf2
A_0fd0:	ser	R24
A_0fd2:	sts	atps2_write_state, R24	; 0x21c
A_0fd6:	rjmp	A_100a	; 0x100a

A_0fd8:	in	R24, PIND
A_0fda:	lds	R18, atps2_write_state	; 0x21c
A_0fde:	ldi	R19, 0x00
A_0fe0:	andi	R18, 0x01
A_0fe2:	andi	R19, 0x00
A_0fe4:	ldi	R25, 0x00
A_0fe6:	lsr	R25
A_0fe8:	ror	R24
A_0fea:	andi	R24, 0x01
A_0fec:	andi	R25, 0x00
A_0fee:	cp	R18, R24
A_0ff0:	cpc	R19, R25
A_0ff2:	brne	A_0ff8	; 0xff8
A_0ff4:	ldi	rc, 0x01
A_0ff6:	rjmp	A_100a	; 0x100a
A_0ff8:	ldi	R24, 0x01
A_0ffa:	rcall	set_kbd_data_pin	; 0xcf2
A_0ffc:	ser	R24
A_0ffe:	sts	atps2_write_state, R24	; 0x21c
A_1002:	ldi	R24, 0xb8
A_1004:	ldi	R25, 0x0b
A_1006:	rcall	act_onboard_led	; 0x1586
A_1008:	ldi	rc, 0x04
A_100a:	mov	R24, rc
A_100c:	pop	R17
A_100e:	pop	R16
A_1010:	ret	
A_1012:	ldi	rc, 0x09
A_1014:	rjmp	A_0fcc	; 0xfcc

;=====================================================
; atps2_clockin :
;=====================================================
atps2_clockin:
A_1016:	push	R15
A_1018:	push	R16
A_101a:	push	R17

.equ	ps2data	R16

A_101c:	in	R15, PIND
A_101e:	in	R25, PIND
A_1020:	and	R24, R24
A_1022:	breq	A_102e	; 0x102e
A_1024:	ser	R24
A_1026:	sts	read_atps2_state, R24	; 0x220
A_102a:	ldi	R17, 0x05
A_102c:	rjmp	A_1128	; 0x1128

A_102e:	lds	R24, read_atps2_state	; 0x220
A_1032:	cpi	R24, 0xff
A_1034:	brne	A_103c	; 0x103c
A_1036:	ldi	R24, 0x01
A_1038:	sts	read_atps2_state, R24	; 0x220
A_103c:	mov	ps2data, R25
A_103e:	andi	ps2data, 0x01

A_1040:	lds	R17, read_atps2_state	; 0x220
A_1044:	cpi	R17, 0x06
A_1046:	breq	A_10c2	; 0x10c2
A_1048:	cpi	R17, 0x07
A_104a:	brcc	A_105c	; 0x105c
A_104c:	cpi	R17, 0x04
A_104e:	breq	A_1086	; 0x1086
A_1050:	cpi	R17, 0x05
A_1052:	brcc	A_108a	; 0x108a
A_1054:	cpi	R17, 0x01
A_1056:	breq	A_105a	; 0x105a
A_1058:	rjmp	A_10fa	; 0x10fa
A_105a:	rjmp	A_106c	; 0x106c
A_105c:	cpi	R17, 0x08
A_105e:	breq	A_10d6	; 0x10d6
A_1060:	cpi	R17, 0x08
A_1062:	brcs	A_10c6	; 0x10c6
A_1064:	cpi	R17, 0x09
A_1066:	breq	A_106a	; 0x106a
A_1068:	rjmp	A_10fa	; 0x10fa
A_106a:	rjmp	A_10da	; 0x10da

A_106c:	ldi	R24, 0xb0
A_106e:	ldi	R25, 0x04
A_1070:	rcall	setup_timer1	; 0xc98
A_1072:	sts	read_atps2_bits, __zero_reg__	; 0x264
A_1076:	sts	read_atps2_shiftin, __zero_reg__	; 0x262
A_107a:	sts	read_atps2_parity, R17	; 0x21e
A_107e:	and	ps2data, ps2data
A_1080:	breq	A_1084	; 0x1084
A_1082:	rjmp	A_1132	; 0x1132
A_1084:	rjmp	A_10be	; 0x10be

A_1086:	ldi	R24, 0x05
A_1088:	rjmp	A_10b8	; 0x10b8

A_108a:	mov	R25, ps2data
A_108c:	ror	R25
A_108e:	clr	R25
A_1090:	ror	R25
A_1092:	lds	R24, read_atps2_shiftin	; 0x262
A_1096:	lsr	R24
A_1098:	or	R25, R24
A_109a:	sts	read_atps2_shiftin, R25	; 0x262
A_109e:	lds	R24, read_atps2_parity	; 0x21e
A_10a2:	eor	R24, ps2data
A_10a4:	sts	read_atps2_parity, R24	; 0x21e
A_10a8:	lds	R24, read_atps2_bits	; 0x264
A_10ac:	subi	R24, 0xff
A_10ae:	sts	read_atps2_bits, R24	; 0x264
A_10b2:	cpi	R24, 0x08
A_10b4:	brne	A_10be	; 0x10be
A_10b6:	ldi	R24, 0x06
A_10b8:	sts	read_atps2_state, R24	; 0x220
A_10bc:	rjmp	A_10fa	; 0x10fa
A_10be:	ldi	R24, 0x04
A_10c0:	rjmp	A_10b8	; 0x10b8

A_10c2:	ldi	R24, 0x07
A_10c4:	rjmp	A_10b8	; 0x10b8

A_10c6:	lds	R24, read_atps2_parity	; 0x21e
A_10ca:	cp	R24, ps2data
A_10cc:	breq	A_10d2	; 0x10d2
A_10ce:	ldi	R17, 0x07
A_10d0:	rjmp	A_1134	; 0x1134
A_10d2:	ldi	R24, 0x08
A_10d4:	rjmp	A_10b8	; 0x10b8

A_10d6:	ldi	R24, 0x09
A_10d8:	rjmp	A_10b8	; 0x10b8

A_10da:	and	ps2data, ps2data
A_10dc:	breq	A_10f0	; 0x10f0
A_10de:	lds	R24, read_atps2_shiftin	; 0x262
A_10e2:	sts	kbd_rcvd_byte, R24	; 0x254
A_10e6:	ldi	R24, 0x01
A_10e8:	sts	keyboard_mode, R24	; 0x252
A_10ec:	ldi	R17, 0x02
A_10ee:	rjmp	A_1134	; 0x1134
A_10f0:	ldi	R24, 0xb8
A_10f2:	ldi	R25, 0x0b
A_10f4:	rcall	act_onboard_led	; 0x1586
A_10f6:	ldi	R17, 0x08
A_10f8:	rjmp	A_1134	; 0x1134

A_10fa:	lds	R18, read_atps2_state	; 0x220
A_10fe:	ldi	R19, 0x00
A_1100:	andi	R18, 0x01
A_1102:	andi	R19, 0x00
A_1104:	mov	R24, R15
A_1106:	ldi	R25, 0x00
A_1108:	lsr	R25
A_110a:	ror	R24
A_110c:	andi	R24, 0x01
A_110e:	andi	R25, 0x00
A_1110:	cp	R18, R24
A_1112:	cpc	R19, R25
A_1114:	brne	A_111a	; 0x111a
A_1116:	ldi	R17, 0x01
A_1118:	rjmp	A_1128	; 0x1128
A_111a:	ser	R24
A_111c:	sts	read_atps2_state, R24	; 0x220
A_1120:	ldi	R24, 0xb8
A_1122:	ldi	R25, 0x0b
A_1124:	rcall	act_onboard_led	; 0x1586
A_1126:	ldi	R17, 0x04
A_1128:	mov	R24, R17
A_112a:	pop	R17
A_112c:	pop	R16
A_112e:	pop	R15
A_1130:	ret	
A_1132:	ldi	R17, 0x06
A_1134:	ldi	R24, 0x00
A_1136:	ldi	R25, 0x00
A_1138:	rcall	setup_timer1	; 0xc98
A_113a:	ser	R24
A_113c:	sts	read_atps2_state, R24	; 0x220
A_1140:	rjmp	A_1128	; 0x1128

;=====================================================
; atps2_clock :
;=====================================================
atps2_clock:
A_1142:	push	R13
A_1144:	push	R14
A_1146:	push	R15
A_1148:	push	R16
A_114a:	push	R17

.equ	cmode	R16

A_114c:	mov	cmode, R24
A_114e:	cpi	R24, 0x02
A_1150:	brne	A_1190	; 0x1190

;parm==2
A_1152:	lds	R24, keyboard_mode	; 0x252
A_1156:	cpi	R24, 0x02
A_1158:	brne	A_1162	; 0x1162
A_115a:	ldi	R24, 0x03
A_115c:	sts	0x0133, R24	; 0x266
A_1160:	rjmp	A_1238	; return;
A_1162:	lds	R24, 0x0135	; 0x26a
A_1166:	cpi	R24, 0x01
A_1168:	brne	A_1188	; 0x1188
A_116a:	ldi	R24, 0x03
A_116c:	sts	0x0135, R24	; 0x26a
A_1170:	lds	R24, 0x0133	; 0x266
A_1174:	and	R24, R24
A_1176:	breq	A_117e	; 0x117e
A_1178:	ldi	R24, 0xb8
A_117a:	ldi	R25, 0x0b
A_117c:	rcall	act_onboard_led	; 0x1586
A_117e:	ldi	R24, 0x01
A_1180:	sts	0x0133, R24	; 0x266
A_1184:	ldi	cmode, 0x00
A_1186:	rjmp	A_1190	; 0x1190
A_1188:	ldi	R24, 0x01
A_118a:	sts	0x0134, R24	; 0x268
A_118e:	rjmp	A_1238	; return;

A_1190:	clr	R15
A_1192:	inc	R15
A_1194:	ldi	R26, 0x02
A_1196:	mov	R13, R26
A_1198:	ldi	R31, 0x03
A_119a:	mov	R14, R31

A_119c:	lds	R24, 0x0135	; 0x26a
A_11a0:	cpi	R24, 0x01
A_11a2:	breq	A_11f0	; 0x11f0
A_11a4:	cpi	R24, 0x01
A_11a6:	brcs	A_11b4	; 0x11b4
A_11a8:	cpi	R24, 0x02
A_11aa:	breq	A_120c	; 0x120c
A_11ac:	cpi	R24, 0x03
A_11ae:	breq	A_11b2	; 0x11b2
A_11b0:	rjmp	A_1238	; return;
A_11b2:	rjmp	A_1226	; 0x1226

A_11b4:	mov	R24, cmode
A_11b6:	rcall	A_0d5c	; 0xd5c
A_11b8:	cpi	R24, 0x02
A_11ba:	brcc	A_11be	; 0x11be
A_11bc:	rjmp	A_1238	; return;
A_11be:	cpi	R24, 0x02
A_11c0:	brne	A_119c	; 0x119c
A_11c2:	lds	R24, 0x0134	; 0x268
A_11c6:	and	R24, R24
A_11c8:	breq	A_11e8	; 0x11e8
A_11ca:	sts	0x0134, __zero_reg__	; 0x268
A_11ce:	lds	R24, 0x0133	; 0x266
A_11d2:	and	R24, R24
A_11d4:	breq	A_11dc	; 0x11dc
A_11d6:	ldi	R24, 0xb8
A_11d8:	ldi	R25, 0x0b
A_11da:	rcall	act_onboard_led	; 0x1586
A_11dc:	sts	0x0133, R15	; 0x266
A_11e0:	sts	0x0135, R14	; 0x26a
A_11e4:	ldi	cmode, 0x00
A_11e6:	rjmp	A_119c	; 0x119c
A_11e8:	ldi	R24, 0x01
A_11ea:	sts	0x0135, R24	; 0x26a
A_11ee:	rjmp	A_1238	; return;

A_11f0:	sbic	PIND, 1	; skip next instruction if PIND1 is clear, i.e., if (PIND & PIND1)
A_11f2:	rjmp	A_1232	; 0x1232
A_11f4:	lds	R24, 0x0133	; 0x266
A_11f8:	and	R24, R24
A_11fa:	breq	A_1202	; 0x1202
A_11fc:	ldi	R24, 0xb8
A_11fe:	ldi	R25, 0x0b
A_1200:	rcall	act_onboard_led	; 0x1586
A_1202:	sts	kbd_rcvd_state, R15	; 0x256
A_1206:	sts	0x0135, R13	; 0x26a
A_120a:	rjmp	A_119c	; 0x119c

A_120c:	mov	R24, cmode
A_120e:	rcall	atps2_clockin	; 0x1016
A_1210:	mov	R17, R24
A_1212:	cpi	R24, 0x02
A_1214:	brcs	A_1238	; return;
A_1216:	cpi	R24, 0x02
A_1218:	breq	A_1220	; 0x1220
A_121a:	ldi	R24, 0xb8
A_121c:	ldi	R25, 0x0b
A_121e:	rcall	act_onboard_led	; 0x1586
A_1220:	sts	kbd_rcvd_state, R17	; 0x256
A_1224:	rjmp	A_1232	; 0x1232

A_1226:	mov	R24, cmode
A_1228:	rcall	atps2_clockout	; 0xe94
A_122a:	cpi	R24, 0x02
A_122c:	brcs	A_1238	; 0x1238
A_122e:	sts	0x0133, R24	; 0x266
A_1232:	sts	0x0135, __zero_reg__	; 0x26a
A_1236:	rjmp	A_119c	; 0x119c

A_1238:	pop	R17
A_123a:	pop	R16
A_123c:	pop	R15
A_123e:	pop	R14
A_1240:	pop	R13
A_1242:	ret	

;=====================================================
;  External Interrupt Request 1
;=====================================================
INT1_vect:
A_1244:
	push	__zero_reg__
A_1246:	push	R0
A_1248:	in	R0, SREG
A_124a:	push	R0
A_124c:	clr	__zero_reg__
A_124e:	push	R18
A_1250:	push	R19
A_1252:	push	R20
A_1254:	push	R21
A_1256:	push	R22
A_1258:	push	R23
A_125a:	push	R24
A_125c:	push	R25
A_125e:	push	R26
A_1260:	push	R27
A_1262:	push	R30
A_1264:	push	R31

A_1266:	lds	R24, keyboard_mode	; 0x252
A_126a:	cpi	R24, 0x02
A_126c:	brne	A_1274	; 0x1274
A_126e:	ldi	R24, 0x00
A_1270:	rcall	pcxt_clockin	; 0xdd6
A_1272:	rjmp	A_1278	; 0x1278
A_1274:	ldi	R24, 0x00
A_1276:	rcall	atps2_clock	; 0x1142

A_1278:	pop	R31
A_127a:	pop	R30
A_127c:	pop	R27
A_127e:	pop	R26
A_1280:	pop	R25
A_1282:	pop	R24
A_1284:	pop	R23
A_1286:	pop	R22
A_1288:	pop	R21
A_128a:	pop	R20
A_128c:	pop	R19
A_128e:	pop	R18
A_1290:	pop	R0
A_1292:	out	SREG, R0
A_1294:	pop	R0
A_1296:	pop	__zero_reg__
A_1298:	reti	

;=========================================================
; init_kbd :
;=========================================================
init_kbd:
A_129a:	cli	
A_129c:	ldi	R24, 0x01
A_129e:	rcall	set_kbd_clock_pin	; 0xd02
A_12a0:	ldi	R24, 0x01
A_12a2:	rcall	set_kbd_data_pin	; 0xcf2
A_12a4:	sts	TCCR1A, __zero_reg__	; 0x100  ; TCCR1A = 0;
A_12a8:	ldi	R24, 0x08
A_12aa:	sts	TCCR1B, R24	; 0x102	; TCCR1B = (1 << WGM12);
A_12ae:	ldi	R30, 0x69			; EICRA
A_12b0:	ldi	R31, 0x00
A_12b2:	ld	R24, Z				; EICRA = (EICRA & ~((1 << ISC11) | (1 << ISC10))) | (1 << ISC10);
A_12b4:	andi	R24, 0xf3
A_12b6:	ori	R24, 0x04
A_12b8:	st	Z, R24
A_12ba:	sbi	EIMSK, 1	; EIMSK |= (1 << INT1)
A_12bc:	ldi	R24, 0x00
A_12be:	rcall	atps2_clock	; 0x1142
A_12c0:	sei	
A_12c2:	ret	

;=========================================================
; TIMER1_COMPA_vect: Timer/Counter1 Compare Match A
;=========================================================
TIMER1_COMPA_vect:
A_12c4:
	push	__zero_reg__
A_12c6:	push	R0
A_12c8:	in	R0, SREG
A_12ca:	push	R0
A_12cc:	clr	__zero_reg__
A_12ce:	push	R18
A_12d0:	push	R19
A_12d2:	push	R20
A_12d4:	push	R21
A_12d6:	push	R22
A_12d8:	push	R23
A_12da:	push	R24
A_12dc:	push	R25
A_12de:	push	R26
A_12e0:	push	R27
A_12e2:	push	R30
A_12e4:	push	R31

A_12e6:	lds	R24, TCCR1B	; TCCR1B &= ~(COM1C0 WGM11 WGM10)
A_12ea:	andi	R24, 0xf8
A_12ec:	sts	TCCR1B, R24
A_12f0:	lds	R24, TIMSK1	; TIMSK1&= ~OCIE1A
A_12f4:	andi	R24, 0xfd
A_12f6:	sts	TIMSK1, R24
A_12fa:	nop	
A_12fc:	sts	TCNT1H, __zero_reg__	; TCNT1H = TCNT1L = 0
A_1300:	sts	TCNT1L, __zero_reg__
A_1304:	ldi	R24, 0x02
A_1306:	out	TIFR1, R24				;TIFR1 = (1 << OCF1A);
A_1308:	lds	R24, keyboard_mode	; 0x252
A_130c:	cpi	R24, 0x02
A_130e:	brne	A_1316	; 0x1316
A_1310:	ldi	R24, 0x01
A_1312:	rcall	pcxt_clockin	; 0xdd6
A_1314:	rjmp	A_131a	; 0x131a
A_1316:	ldi	R24, 0x01
A_1318:	rcall	atps2_clock	; 0x1142
A_131a:	pop	R31
A_131c:	pop	R30
A_131e:	pop	R27
A_1320:	pop	R26
A_1322:	pop	R25
A_1324:	pop	R24
A_1326:	pop	R23
A_1328:	pop	R22
A_132a:	pop	R21
A_132c:	pop	R20
A_132e:	pop	R19
A_1330:	pop	R18
A_1332:	pop	R0
A_1334:	out	SREG, R0
A_1336:	pop	R0
A_1338:	pop	__zero_reg__
A_133a:	reti

;=========================================================
; send_kbd_command :
;=========================================================
send_kbd_command:
A_133c:
	push	R13
	push	R14
	push	R15
	push	R16
	push	R17
A_1346:
	mov	R17, R24
	mov	R13, R22
	lds	R24, keyboard_mode	; 0x252
	cpi	R24, 0x02
	brne	A_1356	; 0x1356
A_1352:
	ldi	R24, 0x00	; return 0;
	rjmp	A_13d2	; 0x13d2
A_1356:
	ldi	R24, 0x77	;usb_debug_putchar('w');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	mov	R24, R17
	rcall	phex	; 0x2320
	ldi	R24, 0x20	;usb_debug_putchar(' ');
	rcall	rjmp_usb_debug_putchar	; 0x230c
A_1362:
	cli	
	sts	kbdcmd_to_send, R17	; 0x25c
	sts	0x0133, __zero_reg__	; 0x266
	ldi	R24, 0x02
	rcall	atps2_clock	; 0x1142
	sei	
A_1372:
	in	R24, SREG
	cli	
	lds	R14, timer0_counter	; 0x26c
	lds	R15, timer0_counter+1	; 0x26e
	lds	R16, timer0_counter+2	; 0x270
	lds	R17, timer0_counter+3	; 0x272
	out	SREG, R24
	
A_1388:
	mov	R20, R13
	ldi	R21, 0x00
	ldi	R22, 0x00
	ldi	R23, 0x00
	rjmp	A_13c2	; 0x13c2
	
A_1392:
	and	R13, R13
	breq	A_13c2	; 0x13c2
A_1396:
	in	R18, SREG
	cli	
	lds	R24, timer0_counter	; 0x26c
	lds	R25, timer0_counter+1	; 0x26e
	lds	R26, timer0_counter+2	; 0x270
	lds	R27, timer0_counter+3	; 0x272
	out	SREG, R18
	sub	R24, R14
	sbc	R25, R15
	sbc	R26, R16
	sbc	R27, R17
	cp	R20, R24
	cpc	R21, R25
	cpc	R22, R26
	cpc	R23, R27
	brcc	A_13c2	; 0x13c2
A_13be:
	ldi	R24, 0x0a
	rjmp	A_13d2	; 0x13d2
A_13c2:
	lds	R24, 0x0133	; 0x266
	cpi	R24, 0x02
	brcs	A_1392	; 0x1392
A_13ca:
	lds	R24, 0x0133	; 0x266
	sts	0x0133, __zero_reg__	; 0x266
A_13d2:
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	pop	R13
	ret	

;=========================================================
; 
;=========================================================
fetch_kbd_byte:
A_13de:
	push	R13
	push	R14
	push	R15
	push	R16
	push	R17
	push	R28
	push	R29
	
	movw	R28, R24
	in	R24, SREG
	cli	
	lds	R14, timer0_counter	; 0x26c
	lds	R15, timer0_counter+1	; 0x26e
	lds	R16, timer0_counter+2	; 0x270
	lds	R17, timer0_counter+3	; 0x272
	out	SREG, R24
	
	lds	R13, kbd_rcvd_state	; 0x256
	and	R22, R22
	brne	A_143c	; 0x143c
	rjmp	A_144c	; 0x144c
A_140e:
	in	R18, SREG
	cli	
	lds	R24, timer0_counter	; 0x26c
	lds	R25, timer0_counter+1	; 0x26e
	lds	R26, timer0_counter+2	; 0x270
	lds	R27, timer0_counter+3	; 0x272
	out	SREG, R18
	sub	R24, R14
	sbc	R25, R15
	sbc	R26, R16
	sbc	R27, R17
	
	cp	R20, R24
	cpc	R21, R25
	cpc	R22, R26
	cpc	R23, R27
	brcs	A_1480	; return R13;
A_1436:
	lds	R13, kbd_rcvd_state	; 0x256
	rjmp	A_1444	; 0x1444
A_143c:
	mov	R20, R22
	ldi	R21, 0x00
	ldi	R22, 0x00
	ldi	R23, 0x00
A_1444:
	ldi	R24, 0x01
	cp	R24, R13
	brcc	A_140e	; 0x140e
	rjmp	A_1452	; 0x1452
A_144c:
	ldi	R24, 0x01
	cp	R24, R13
	brcc	A_1480	; return R13;
A_1452:
	lds	R17, kbd_rcvd_byte	; 0x254
	sts	kbd_rcvd_state, __zero_reg__	; 0x256
	
	ldi	R24, 0x02
	cp	R13, R24
	brne	A_1474	; 0x1474
	
	ldi	R24, 0x72	;usb_debug_putchar('r');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	mov	R24, R17
	rcall	phex	; 0x2320
	ldi	R24, 0x20	;usb_debug_putchar(' ');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	sbiw	R28, 0x00
	breq	A_1480	; return R13;
A_1470:
	st	Y, R17
	rjmp	A_1480	; 0x1480
A_1474:
	ldi	R24, 0x52	;usb_debug_putchar('R');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	mov	R24, R13
	rcall	phex	; 0x2320
	ldi	R24, 0x20	;usb_debug_putchar(' ');
	rcall	rjmp_usb_debug_putchar	; 0x230c
A_1480:
	mov	R24, R13
	pop	R29
	pop	R28
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	pop	R13
	ret	

;=========================================================
; 
;=========================================================
get_kbd_byte:
A_1492:
	push	R17
	push	R29
	push	R28
	push	R0
	
	in	R28, SPL
	in	R29, SPH
	mov	R22, R24
	movw	R24, R28
	adiw	R24, 0x01
	rcall	fetch_kbd_byte	; 0x13de
	mov	R17, R24
	cpi	R24, 0x02
	breq	A_14ba	; 0x14ba
A_14ac:
	std	Y+1, __zero_reg__
	ldi	R24, 0x52	;usb_debug_putchar('R');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0x31	;usb_debug_putchar('1');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	mov	R24, R17
	rcall	phex	; 0x2320
A_14ba:
	ldd	R24, Y+1
	pop	R0
	pop	R28
	pop	R29
	pop	R17
	ret	

;=========================================================
; send_kbd_command_with_parm(uint8_t ps2command, uint8_t ps2command2) :
;   sends a sequence of 2 commands, waits for ACK after each
;=========================================================
send_kbd_command_with_parm:
A_14c6:
	push	R14
	push	R15
	push	R16
	push	R17
	mov	R14, R24
	mov	R15, R22
	lds	R24, keyboard_mode	; 0x252
	cpi	R24, 0x02
	breq	A_152c	; 0x152c
A_14da:
	ldi	R16, 0x03
A_14dc:
	mov	R24, R14
	ldi	R22, 0x32
	rcall	send_kbd_command	; 0x133c
	mov	R17, R24
	cpi	R24, 0x02
	brne	A_151c	; 0x151c
A_14e8:
	ldi	R24, 0x32
	rcall	get_kbd_byte	; 0x1492
	mov	R17, R24
	cpi	R24, 0xfa
	brne	A_150c	; 0x150c
A_14f2:
	mov	R24, R15
	ldi	R22, 0x32
	rcall	send_kbd_command	; 0x133c
	mov	R17, R24
	cpi	R24, 0x02
	brne	A_1514	; 0x1514
A_14fe:
	ldi	R24, 0x32
	rcall	get_kbd_byte	; 0x1492
	mov	R17, R24
	cpi	R24, 0xfa
	brne	A_150c	; 0x150c
A_1508:
	ldi	R24, 0x01
	rjmp	A_152e	; 0x152e
A_150c:
	ldi	R24, 0x21	;usb_debug_putchar('!');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0x21
	rjmp	A_1522	; 0x1522
A_1514:
	ldi	R24, 0x57	;usb_debug_putchar('W');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0x32
	rjmp	A_1522	; 0x1522
A_151c:
	ldi	R24, 0x57	;usb_debug_putchar('W');
	rcall	rjmp_usb_debug_putchar	; 0x230c
	ldi	R24, 0x31	;usb_debug_putchar('1');
A_1522:
	rcall	rjmp_usb_debug_putchar	; 0x230c
	mov	R24, R17
	rcall	phex	; 0x2320
	subi	R16, 0x01
	brne	A_14dc	; 0x14dc
A_152c:
	ldi	R24, 0x00
A_152e:
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	ret	

;=========================================================
; send_kbd_command_without_parm :
;=========================================================
send_kbd_command_without_parm:
A_1538:	push	R15
A_153a:	push	R16
A_153c:	push	R17
A_153e:	mov	R15, R24
A_1540:	lds	R24, keyboard_mode	; 0x252
A_1544:	cpi	R24, 0x02
A_1546:	breq	A_157c	; 0x157c

A_1548:	ldi	R16, 0x03

A_154a:	mov	R24, R15
A_154c:	ldi	R22, 0x32
A_154e:	rcall	send_kbd_command	; 0x133c
A_1550:	mov	R17, R24
A_1552:	cpi	R24, 0x02
A_1554:	brne	A_156c	; 0x156c
A_1556:	ldi	R24, 0x32
A_1558:	rcall	get_kbd_byte	; 0x1492
A_155a:	mov	R17, R24
A_155c:	cpi	R24, 0xfa
A_155e:	brne	A_1564	; 0x1564

A_1560:	ldi	R24, 0x01
A_1562:	rjmp	A_157e	; 0x157e
A_1564:	ldi	R24, 0x21	;usb_debug_putchar('!');
A_1566:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_1568:	ldi	R24, 0x21
A_156a:	rjmp	A_1572	; 0x1572

A_156c:	ldi	R24, 0x57	;usb_debug_putchar('W');
A_156e:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_1570:	ldi	R24, 0x30	;usb_debug_putchar('0');
A_1572:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_1574:	mov	R24, R17
A_1576:	rcall	phex	; 0x2320
A_1578:	subi	R16, 0x01
A_157a:	brne	A_154a	; 0x154a
A_157c:	ldi	R24, 0x00
A_157e:	pop	R17
A_1580:	pop	R16
A_1582:	pop	R15
A_1584:	ret	

;=========================================================
; act_onboard_led : turns on Teensy LED for a given time
;=========================================================
act_onboard_led:
A_1586:	sts	onboard_led_counter+1, R25	; 0x276
A_158a:	sts	onboard_led_counter, R24	; 0x274
A_158e:	sbi	PORTD, 6	;PORTD |= PORTD6  (Teensy Onboard LED)
A_1590:	ret	

;=========================================================
; setup_timer0 : sets up timer 0
;=========================================================
setup_timer0:
A_1592:	ldi	R30, 0x6e	;Z = TIMSK0
A_1594:	ldi	R31, 0x00
A_1596:	ld	R24, Z		;TIMSK0 |= (1 << OCIE0A)
A_1598:	ori	R24, 0x02
A_159a:	st	Z, R24
A_159c:	ldi	R24, 0xfa	;OCR0A = 250;
A_159e:	out	OCR0A, R24
A_15a0:	ldi	R24, 0x02
A_15a2:	out	TCCR0A, R24
A_15a4:	out	TCCR0B, __zero_reg__
A_15a6:	in	R24, TCCR0B
A_15a8:	ori	R24, 0x03
A_15aa:	out	TCCR0B, R24    ;(TCCR0B |= (CS00|CS01)
A_15ac:	ret	

;====================================================
; TIMER0_COMPA_vect: Timer/Counter0 Compare Match A
;====================================================
TIMER0_COMPA_vect:
A_15ae:
	push	__zero_reg__
A_15b0:	push	R0
A_15b2:	in	R0, SREG
A_15b4:	push	R0
A_15b6:	clr	__zero_reg__
A_15b8:	push	R18
A_15ba:	push	R19
A_15bc:	push	R20
A_15be:	push	R21
A_15c0:	push	R22
A_15c2:	push	R23
A_15c4:	push	R24
A_15c6:	push	R25
A_15c8:	push	R26
A_15ca:	push	R27
A_15cc:	push	R30
A_15ce:	push	R31
A_15d0:	lds	R24, timer0_counter	; 0x26c
A_15d4:	lds	R25, timer0_counter+1	; 0x26e
A_15d8:	lds	R26, timer0_counter+2	; 0x270
A_15dc:	lds	R27, timer0_counter+3	; 0x272
A_15e0:	adiw	R24, 0x01
A_15e2:	adc	R26, __zero_reg__
A_15e4:	adc	R27, __zero_reg__
A_15e6:	sts	timer0_counter, R24	; 0x26c
A_15ea:	sts	timer0_counter+1, R25	; 0x26e
A_15ee:	sts	timer0_counter+2, R26	; 0x270
A_15f2:	sts	timer0_counter+3, R27	; 0x272
A_15f6:	lds	R24, onboard_led_counter	; 0x274
A_15fa:	lds	R25, onboard_led_counter+1	; 0x276
A_15fe:	sbiw	R24, 0x00
A_1600:	breq	A_160e	; 0x160e
A_1602:	sbiw	R24, 0x01
A_1604:	sts	onboard_led_counter+1, R25	; 0x276
A_1608:	sts	onboard_led_counter, R24	; 0x274
A_160c:	rjmp	A_1610	; 0x1610
A_160e:	cbi	PORTD, 6	; PORTD &= ~PORTD6  (Teensy OnBoard LED)
A_1610:	lds	R24, in_macro_tick	; 0x278
A_1614:	and	R24, R24
A_1616:	brne	A_1628	; 0x1628
A_1618:	ldi	R24, 0x01
A_161a:	sts	in_macro_tick, R24	; 0x278
A_161e:	sei	
A_1620:	call	macro_tick	; 0x355c
A_1624:	sts	in_macro_tick, __zero_reg__	; 0x278
A_1628:	pop	R31
A_162a:	pop	R30
A_162c:	pop	R27
A_162e:	pop	R26
A_1630:	pop	R25
A_1632:	pop	R24
A_1634:	pop	R23
A_1636:	pop	R22
A_1638:	pop	R21
A_163a:	pop	R20
A_163c:	pop	R19
A_163e:	pop	R18
A_1640:	pop	R0
A_1642:	out	SREG, R0
A_1644:	pop	R0
A_1646:	pop	__zero_reg__
A_1648:	reti	


;==============================================================================
; Heap memory management code
;==============================================================================

;=============================================================
; memfree : returns # free memory bytes
;=============================================================
memfree:
A_164a:	lds	R18, __malloc_heap_end	; 0x22a
A_164e:	lds	R19, __malloc_heap_end+1	; 0x22c
A_1652:	cp	R18, __zero_reg__
A_1654:	cpc	R19, __zero_reg__
A_1656:	brne	A_1660	; 0x1660
A_1658:	in	R18, SPL
A_165a:	in	R19, SPH
A_165c:	subi	R18, 0x20
A_165e:	sbci	R19, 0x00
A_1660:	lds	R24, __brkval	; 0x22e
A_1664:	lds	R25, __brkval+1	; 0x230
A_1668:	sub	R18, R24
A_166a:	sbc	R19, R25
A_166c:	movw	R24, R18
A_166e:	ret	

;=============================================================
; memalloc : allocates memory from the heap
;=============================================================
memalloc:
A_1670:
	movw	R20, R24
	lds	R18, __malloc_heap_end	; 0x22a
	lds	R19, __malloc_heap_end+1	; 0x22c
	cp	R18, __zero_reg__
	cpc	R19, __zero_reg__
	brne	A_1688	; 0x1688
A_1680:
	in	R18, SPL
	in	R19, SPH
	subi	R18, 0x20
	sbci	R19, 0x00
A_1688:
	lds	R24, __brkval	; 0x22e
	lds	R25, __brkval+1	; 0x230
	sub	R18, R24
	sbc	R19, R25
	cp	R18, R20
	cpc	R19, R21
	brcc	A_16a0	; 0x16a0
	ldi	R18, 0x00
	ldi	R19, 0x00
	rjmp	A_16ae	; 0x16ae
A_16a0:
	add	R20, R24
	adc	R21, R25
	sts	__brkval+1, R21	; 0x230
	sts	__brkval, R20	; 0x22e
	movw	R18, R24
A_16ae:
	movw	R24, R18
	ret	

;=============================================
; memreset : resets memory allocation
;=============================================
memreset:
A_16b2:	ldi	R24, 0xab	;&__heap_start
A_16b4:	ldi	R25, 0x03
A_16b6:	sts	__brkval+1, R25	; 0x230
A_16ba:	sts	__brkval, R24	; 0x22e
A_16be:	ret	


;==============================================================================
; Looks like start of USB code
;==============================================================================

;=============================================
; A_16c0 : resets the USB keyboard data area
;=============================================
reset_usb_keyboard_data:
A_16c0:
	sts	boot_keys, __zero_reg__	; 0x292
	sts	boot_keys+1, __zero_reg__	; 0x294
	sts	boot_keys+2, __zero_reg__	; 0x296
	sts	boot_keys+3, __zero_reg__	; 0x298
	sts	boot_keys+4, __zero_reg__	; 0x29a
	sts	boot_keys+5, __zero_reg__	; 0x29c
	ldi	R30, 0x52		;fill kbd_data with 0
	ldi	R31, 0x01
A_16dc:
	st	Z+, __zero_reg__
	ldi	R24, 0x01
	cpi	R30, 0x6d
	cpc	R31, R24
	brne	A_16dc	; 0x16dc
A_16e6:
	sts	keyboard_modifier_keys, __zero_reg__	; 0x280
	ldi	R24, 0x0f
	ret	

;=============================================
; usb_init: initialize USB
;=============================================
usb_init:
A_16ee:
	rcall	reset_usb_keyboard_data	; 0x16c0
	ldi	R24, 0x01
	sts	UHWCON, R24		; HW_CONFIG(); // UHWCON = (1 << UVREGE); 
	ldi	R24, 0xa0
	sts	USBCON, R24		; USB_FREEZE(); // USB_CON = USBE FRZCLK
	ldi	R24, 0x12
	out	PLLCSR, R24		; PLL_CONFIG(); // PLLCSR = 0x12;
A_1700:
	in	R0, PLLCSR
	sbrs	R0, 0		;if (PLLCSR & (1 << PLOCK)) goto A_1706;
	rjmp	A_1700	; 0x1700
A_1706:
	ldi	R24, 0x90		; USB_CONFIG(); // USBCON = USBE OTGPADE
	sts	USBCON, R24	; 0x1b0
	sts	UDCON, __zero_reg__	; UDCON = 0;
	sts	usb_configuration, __zero_reg__	; usb_configuration = 0;
	sts	usb_suspended, __zero_reg__	; 0x27a
	sts	usb_resuming, __zero_reg__	; 0x27c
	sts	usb_status, __zero_reg__	; 0x27e
	ldi	R24, 0x2d
	sts	UDIEN, R24	; UDIEN = EORSME EORSTE SOFE SUSPE
	sei	
	ret	

;=============================================
; usb_remote_wakeup
;=============================================
usb_remote_wakeup:
A_172a:
	lds	R24, usb_status	; 0x27e
	and	R24, R24
	breq	A_174a	; 0x174a
A_1732:
	lds	R24, usb_resuming	; 0x27c
	and	R24, R24
	brne	A_174a	; 0x174a
A_173a:
	lds	R24, UDCON	; 0x1c0
	ori	R24, 0x02
	sts	UDCON, R24	; 0x1c0
	ldi	R24, 0x01
	sts	usb_resuming, R24	; 0x27c
A_174a:
	ret	

;=============================================
; usb_keyboard_press
;=============================================

usb_keyboard_press:
.def	keyid = R21
.def	rc = R20
A_174c:
	mov	keyid, R24
	
	mov	R19, R24
	subi	R19, 0x01
	cpi	R19, 0xa4
	brcs	A_175a	; 0x175a
A_1756:
	ldi	rc, 0x00
	rjmp	A_1782	; 0x1782
A_175a:
	mov	R30, R19
	lsr	R30
	lsr	R30
	lsr	R30
	ldi	R31, 0x00
	subi	R30, 0xae  // Z += kbd_data_data1;  // (0x0152)
	sbci	R31, 0xfe
	mov	R18, R19
	andi	R18, 0x07
	ldi	R24, 0x01
	ldi	R25, 0x00
	rjmp	A_1776	; 0x1776
A_1772:
	add	R24, R24
	adc	R25, R25
A_1776:
	dec	R18
	brpl	A_1772	; 0x1772
A_177a:
	ld	R18, Z
	or	R18, R24
	st	Z, R18
	ldi	rc, 0x03
A_1782:
	mov	R24, keyid
	subi	R24, 0xa8
	cpi	R24, 0x03
	brcc	A_17b2	; 0x17b2
A_178a:
	mov	R30, keyid
	lsr	R30
	lsr	R30
	lsr	R30
	ldi	R31, 0x00
	subi	R30, 0xae	; Z += kbd_data_data1;  // (0x0152)
	sbci	R31, 0xfe
	mov	R18, keyid
	andi	R18, 0x07
	ldi	R24, 0x01
	ldi	R25, 0x00
	rjmp	A_17a6	; 0x17a6
A_17a2:
	add	R24, R24
	adc	R25, R25
A_17a6:
	dec	R18
	brpl	A_17a2	; 0x17a2
A_17aa:
	ld	R18, Z
	or	R18, R24
	st	Z, R18
	ori	rc, 0x04
A_17b2:
	mov	R24, keyid
	subi	R24, 0xe8
	cpi	R24, 0x18
	brcc	A_17e4	; 0x17e4
A_17ba:
	mov	R18, keyid
	subi	R18, 0x38
	mov	R30, R18		; Z = R18 >> 3;
	lsr	R30
	lsr	R30
	lsr	R30
	ldi	R31, 0x00
	subi	R30, 0xae	; Z += kbd_data_data1;  // (0x0152)
	sbci	R31, 0xfe
	andi	R18, 0x07
	ldi	R24, 0x01
	ldi	R25, 0x00
	rjmp	A_17d8	; 0x17d8
A_17d4:
	add	R24, R24
	adc	R25, R25
A_17d8:
	dec	R18
	brpl	A_17d4	; 0x17d4
A_17dc:
	ld	R18, Z
	or	R18, R24
	st	Z, R18
	ori	rc, 0x08
A_17e4:
	mov	R18, keyid
	subi	R18, 0xe0
	cpi	R18, 0x08
	brcc	A_180c	; 0x180c
A_17ec:
	ldi	R24, 0x01
	ldi	R25, 0x00
	rjmp	A_17f6	; 0x17f6
A_17f2:
	add	R24, R24
	adc	R25, R25
A_17f6:
	dec	R18
	brpl	A_17f2	; 0x17f2
A_17fa:
	mov	R25, R24
	and	R24, R24
	breq	A_180c	; 0x180c
A_1800:
	lds	R24, keyboard_modifier_keys	; 0x280
	or	R24, R25
	sts	keyboard_modifier_keys, R24	; 0x280
	rjmp	A_1836	; 0x1836
A_180c:
	cpi	R19, 0xa4
	brcc	A_1844	; 0x1844
A_1810:
	ldi	R30, 0x49
	ldi	R31, 0x01	; Z = boot_keys;  // (0x0149)
A_1814:
	ld	R24, Z
	cp	R24, keyid
	breq	A_1844	; 0x1844
A_181a:
	adiw	R30, 0x01
	ldi	R24, 0x01	; boot_keys+6
	cpi	R30, 0x4f
	cpc	R31, R24
	brne	A_1814	; 0x1814
A_1824:
	ldi	R18, 0x00
	ldi	R19, 0x00
A_1828:
	movw	R30, R18	; Z = R18
	subi	R30, 0xb7	; Z += boot_keys;  // (0x0149)
	sbci	R31, 0xfe
	ld	R24, Z
	and	R24, R24
	brne	A_183a	; 0x183a
A_1834:
	st	Z, keyid
A_1836:
	ori	rc, 0x03
	rjmp	A_1844	; 0x1844
A_183a:
	subi	R18, 0xff
	sbci	R19, 0xff
	cpi	R18, 0x06
	cpc	R19, __zero_reg__
	brne	A_1828	; 0x1828

A_1844:
	mov	R24, rc
	ret	

;============================================
; usb_keyboard_release
=============================================
usb_keyboard_release:
.def	keyid = R20
.def	rc = R19
A_1848:
	mov	keyid, R24
	mov	R18, R24
	subi	R18, 0x01

A_184e:	cpi	R18, 0xa4
A_1850:	brcs	A_1856	; 0x1856
A_1852:	ldi	rc, 0x00
A_1854:	rjmp	A_187e	; 0x187e

A_1856:	mov	R30, R18
A_1858:	lsr	R30
A_185a:	lsr	R30
A_185c:	lsr	R30
A_185e:	ldi	R31, 0x00
A_1860:	subi	R30, 0xae	; Z += kbd_data_data1;  // (0x0152)
A_1862:	sbci	R31, 0xfe
A_1864:	andi	R18, 0x07
A_1866:	ldi	R24, 0x01
A_1868:	ldi	R25, 0x00
A_186a:	rjmp	A_1870	; 0x1870
A_186c:	add	R24, R24
A_186e:	adc	R25, R25
A_1870:	dec	R18
A_1872:	brpl	A_186c	; 0x186c
A_1874:	com	R24
A_1876:	ld	R18, Z
A_1878:	and	R24, R18
A_187a:	st	Z, R24
A_187c:	ldi	rc, 0x03

A_187e:	mov	R24, keyid
A_1880:	subi	R24, 0xa8
A_1882:	cpi	R24, 0x03
A_1884:	brcc	A_18b0	; 0x18b0

A_1886:	mov	R30, keyid
A_1888:	lsr	R30
A_188a:	lsr	R30
A_188c:	lsr	R30
A_188e:	ldi	R31, 0x00
A_1890:	subi	R30, 0xae	; Z += kbd_data_data1;  // (0x0152)
A_1892:	sbci	R31, 0xfe
A_1894:	mov	R18, keyid
A_1896:	andi	R18, 0x07
A_1898:	ldi	R24, 0x01
A_189a:	ldi	R25, 0x00
A_189c:	rjmp	A_18a2	; 0x18a2
A_189e:	add	R24, R24
A_18a0:	adc	R25, R25
A_18a2:	dec	R18
A_18a4:	brpl	A_189e	; 0x189e
A_18a6:	com	R24
A_18a8:	ld	R18, Z
A_18aa:	and	R24, R18
A_18ac:	st	Z, R24
A_18ae:	ori	rc, 0x04

A_18b0:	mov	R24, keyid
A_18b2:	subi	R24, 0xe8
A_18b4:	cpi	R24, 0x18
A_18b6:	brcc	A_18e4	; 0x18e4
A_18b8:	mov	R18, keyid
A_18ba:	subi	R18, 0x38
A_18bc:	mov	R30, R18
A_18be:	lsr	R30
A_18c0:	lsr	R30
A_18c2:	lsr	R30
A_18c4:	ldi	R31, 0x00
A_18c6:	subi	R30, 0xae	; Z += kbd_data_data1;  // (0x0152)
A_18c8:	sbci	R31, 0xfe
A_18ca:	andi	R18, 0x07
A_18cc:	ldi	R24, 0x01
A_18ce:	ldi	R25, 0x00
A_18d0:	rjmp	A_18d6	; 0x18d6
A_18d2:	add	R24, R24
A_18d4:	adc	R25, R25
A_18d6:	dec	R18
A_18d8:	brpl	A_18d2	; 0x18d2
A_18da:	com	R24
A_18dc:	ld	R18, Z
A_18de:	and	R24, R18
A_18e0:	st	Z, R24
A_18e2:	ori	rc, 0x08

A_18e4:	mov	R18, keyid
A_18e6:	subi	R18, 0xe0
A_18e8:	cpi	R18, 0x08
A_18ea:	brcc	A_1900	; 0x1900

A_18ec:	ldi	R24, 0x01
A_18ee:	ldi	R25, 0x00
A_18f0:	rjmp	A_18f6	; 0x18f6
A_18f2:	add	R24, R24
A_18f4:	adc	R25, R25
A_18f6:	dec	R18
A_18f8:	brpl	A_18f2	; 0x18f2
A_18fa:	mov	R25, R24
A_18fc:	and	R24, R24
A_18fe:	brne	A_1906	; 0x1906

A_1900:	ldi	R30, 0x49	; Z = boot_keys;  // (0x0149)
A_1902:	ldi	R31, 0x01
A_1904:	rjmp	A_1916	; 0x1916

A_1906:	com	R25
A_1908:	lds	R24, keyboard_modifier_keys	; 0x280
A_190c:	and	R24, R25
A_190e:	sts	keyboard_modifier_keys, R24	; 0x280
A_1912:	ori	rc, 0x03
A_1914:	rjmp	A_192a	; 0x192a

A_1916:	ld	R24, Z
A_1918:	cp	R24, keyid
A_191a:	brne	A_1920	; 0x1920
A_191c:	st	Z, __zero_reg__
A_191e:	ori	rc, 0x03
A_1920:	adiw	R30, 0x01
A_1922:	ldi	R24, 0x01	; behind boot_keys
A_1924:	cpi	R30, 0x4f
A_1926:	cpc	R31, R24
A_1928:	brne	A_1916	; 0x1916
A_192a:	mov	R24, rc
A_192c:	ret	

;================================================
; usb_keyboard_send :
;================================================
usb_keyboard_send:
.def	flagset = R25
A_192e:
	mov	flagset, R24
	lds	R24, usb_configuration	; 0x284
	and	R24, R24
	brne	A_193a	; 0x193a
A_1938:
	rjmp	A_1a5e	; 0x1a5e
A_193a:
	sbrs	flagset, 0
	rjmp	A_199a	; 0x199a
A_193e:
	in	R18, SREG
	cli	
	ldi	R24, 0x01
	sts	UENUM, R24	; 0x1d2
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 5
	rjmp	A_1998	; 0x1998
A_1950:
	lds	R24, keyboard_modifier_keys	; 0x280
	sts	UEDATX, R24	; 0x1e2
	sts	UEDATX, __zero_reg__	; 0x1e2
	lds	R24, boot_keys	; 0x292
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+1	; 0x294
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+2	; 0x296
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+3	; 0x298
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+4	; 0x29a
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+5	; 0x29c
	sts	UEDATX, R24	; 0x1e2
	ldi	R24, 0x3a
	sts	UEINTX, R24	; 0x1d0
	sts	boot_idle_count, __zero_reg__	; 0x290
	andi	flagset, 0xfe
A_1998:
	out	SREG, R18
	
A_199a:
	lds	R24, keyboard_protocol	; 0x232
	and	R24, R24
	brne	A_19a4	; 0x19a4
	rjmp	A_1a5c	; 0x1a5c
	
A_19a4:
	sbrs	flagset, 1
	rjmp	A_19e8	; 0x19e8
A_19a8:
	in	R18, SREG
	cli	
	ldi	R24, 0x02
	sts	UENUM, R24	; 0x1d2
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 5
	rjmp	A_19e6	; 0x19e6
A_19ba:
	ldi	R24, 0x01
	sts	UEDATX, R24	; 0x1e2
	lds	R24, keyboard_modifier_keys	; 0x280
	sts	UEDATX, R24	; 0x1e2
	ldi	R30, 0x52	; Z = kbd_data_data1;
	ldi	R31, 0x01
A_19cc:
	ld	R24, Z+
	sts	UEDATX, R24	; 0x1e2
	ldi	R24, 0x01
	cpi	R30, 0x67
	cpc	R31, R24
	brne	A_19cc	; 0x19cc
A_19da:
	ldi	R24, 0x3a
	sts	UEINTX, R24	; 0x1d0
	sts	keyboard_idle_count, __zero_reg__	; 0x28a
	andi	flagset, 0xfd
A_19e6:
	out	SREG, R18

A_19e8:
	sbrs	flagset, 2
	rjmp	A_1a18	; 0x1a18
A_19ec:
	in	R19, SREG
	cli	
	ldi	R18, 0x02
	sts	UENUM, R18	; 0x1d2
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 5
	rjmp	A_1a16	; 0x1a16
A_19fe:
	sts	UEDATX, R18	; 0x1e2
	lds	R24, kbd_data_data2	; 0x2ce
	sts	UEDATX, R24	; 0x1e2
	ldi	R24, 0x3a
	sts	UEINTX, R24	; 0x1d0
	sts	keyboard_idle_count+1, __zero_reg__	; 0x28c
	andi	flagset, 0xfb
A_1a16:
	out	SREG, R19

A_1a18:
	sbrs	flagset, 3
	rjmp	A_1a5e	; 0x1a5e
A_1a1c:
	in	R18, SREG
	cli	
	ldi	R24, 0x02
	sts	UENUM, R24	; 0x1d2
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 5
	rjmp	A_1a58	; 0x1a58
A_1a2e:
	ldi	R24, 0x03
	sts	UEDATX, R24	; 0x1e2
	lds	R24, kbd_data_data3	; 0x2d0
	sts	UEDATX, R24	; 0x1e2
	lds	R24, kbd_data_data3+1	; 0x2d2
	sts	UEDATX, R24	; 0x1e2
	lds	R24, kbd_data_data3+2	; 0x2d4
	sts	UEDATX, R24	; 0x1e2
	ldi	R24, 0x3a
	sts	UEINTX, R24	; 0x1d0
	sts	keyboard_idle_count+2, __zero_reg__	; 0x28e
	andi	flagset, 0xf7
A_1a58:
	out	SREG, R18
	rjmp	A_1a5e	; 0x1a5e
A_1a5c:
	andi	flagset, 0xf1
A_1a5e:
	mov	R24, flagset
	ret	

;============================================
; usb_debug_putchar :
;============================================
usb_debug_putchar:
.def intr_state = R18
.def timeout = R25
A_1a62:	mov	R20, R24
A_1a64:	lds	R24, usb_configuration	; 0x284
A_1a68:	and	R24, R24
A_1a6a:	brne	A_1a6e	; 0x1a6e
A_1a6c:	rjmp	A_1b08	; 0x1b08
A_1a6e:	lds	R24, usb_suspended	; 0x27a
A_1a72:	and	R24, R24
A_1a74:	breq	A_1a78	; 0x1a78
A_1a76:	rjmp	A_1b08	; 0x1b08
A_1a78:	lds	R24, usb_resuming	; 0x27c
A_1a7c:	and	R24, R24
A_1a7e:	breq	A_1a82	; 0x1a82
A_1a80:	rjmp	A_1b08	; 0x1b08
A_1a82:	lds	R24, keyboard_protocol	; 0x232
A_1a86:	and	R24, R24
A_1a88:	brne	A_1a8c	; 0x1a8c
A_1a8a:	rjmp	A_1b08	; 0x1b08
A_1a8c:	in	intr_state, SREG
A_1a8e:	cli	
A_1a90:	ldi	R24, 0x03	;UENUM=DEBUG_TX_ENDPOINT;
A_1a92:	sts	UENUM, R24	; 0x1d2
A_1a96:	lds	R24, previous_timeout	; 0x2a2
A_1a9a:	and	R24, R24
A_1a9c:	breq	A_1aae	; 0x1aae
A_1a9e:	lds	R24, UEINTX	; 0x1d0
A_1aa2:	sbrc	R24, RWAL
A_1aa4:	rjmp	A_1aaa	; 0x1aaa
A_1aa6:	out	SREG, intr_state
A_1aa8:	rjmp	A_1ace	; 0x1ace
A_1aaa:	sts	previous_timeout, __zero_reg__	; 0x2a2
A_1aae:	lds	timeout, UDFNUML	; 0x1c8
A_1ab2:	subi	timeout, 0xfc
A_1ab4:	ldi	R19, 0x03
A_1ab6:	lds	R24, UEINTX	; 0x1d0
A_1aba:	sbrc	R24, RWAL
A_1abc:	rjmp	A_1ae4	; 0x1ae4
A_1abe:	out	SREG, intr_state
A_1ac0:	lds	R24, UDFNUML	; 0x1c8
A_1ac4:	cp	R24, timeout
A_1ac6:	brne	A_1ad2	; 0x1ad2
A_1ac8:	ldi	R24, 0x01
A_1aca:	sts	previous_timeout, R24	; 0x2a2
A_1ace:	ser	R24
A_1ad0:	ret	
A_1ad2:	lds	R24, usb_configuration	; 0x284
A_1ad6:	and	R24, R24
A_1ad8:	breq	A_1b08	; 0x1b08
A_1ada:	in	intr_state, SREG
A_1adc:	cli	
A_1ade:	sts	UENUM, R19	; 0x1d2
A_1ae2:	rjmp	A_1ab6	; 0x1ab6
A_1ae4:	sts	UEDATX, R20	; 0x1e2
A_1ae8:	lds	R24, UEINTX	; 0x1d0
A_1aec:	sbrc	R24, RWAL
A_1aee:	rjmp	A_1afc	; 0x1afc
A_1af0:	ldi	R24, 0x3a
A_1af2:	sts	UEINTX, R24	; 0x1d0
A_1af6:	sts	debug_flush_timer, __zero_reg__	; 0x29e
A_1afa:	rjmp	A_1b02	; 0x1b02
A_1afc:	ldi	R24, 0x02
A_1afe:	sts	debug_flush_timer, R24	; 0x29e
A_1b02:	out	SREG, intr_state
A_1b04:	ldi	R24, 0x00
A_1b06:	ret	
A_1b08:	ser	R24
A_1b0a:	ret	

;========================================
; USB_GEN_vect: USB General Interrupt request handler
;========================================
; ISR(USB_GEN_vect) {
USB_GEN_vect:
	push	__zero_reg__
	push	R0
	in	R0, SREG
	push	R0
	clr	__zero_reg__
	push	R18
	push	R24
	push	R25
	push	R30
	push	R31

.def intbits = R18		;R18: intbits

A_1b20:
	lds	R24, UDINT	; R24 = UDINT
	sts	UDINT, __zero_reg__	; UDINT = 0
	mov	intbits, R24
	sbrs	R24, EORSTI  ; if (intbits & (1<<EORSTI)) goto A_12be
	rjmp	A_1b5c	; 0x1b5c
; come here from A_1b2a if (intbits & (1<<EORSTI))
A_1b2e:
	sts	UENUM, __zero_reg__	; UENUM = 0
	ldi	R24, 1
	sts	UECONX, R24	; UECONX = 1
	sts	UECFG0X, __zero_reg__	; UECFG0X = EP_TYPE_CONTROL
	ldi	R25, 0x22
	sts	UECFG1X, R25	; UECFG1X = EP_SIZE(ENDPOINT0_SIZE) | EP_SINGLE_BUFFER;
	ldi	R25, 0x08
	sts	UEIENX, R25	; UEIENX = (1<<RXSTPE);
	sts	usb_configuration, __zero_reg__	; 0x284
	sts	usb_status, __zero_reg__	; 0x27e
	sts	usb_suspended, __zero_reg__	; 0x27a
	sts	usb_resuming, __zero_reg__	; 0x27c
	sts	keyboard_protocol, R24	; 0x232  --- keyboard_protocol is set to 1 if End Of Reset Interrupt is there

; come here from A_1b2a if (!(intbits & (1 << EORSTI)))
A_1b5c:
	sbrs	intbits, SUSPI
A_1b5e:	rjmp	A_1b70	; 0x1b70
A_1b60:	lds	R24, UDIEN	; 0x1c4
A_1b64:	ori	R24, (1 << WAKEUPE)
A_1b66:	sts	UDIEN, R24	; 0x1c4
A_1b6a:	ldi	R24, 0x01
A_1b6c:	sts	usb_suspended, R24	; 0x27a

A_1b70:	sbrs	intbits, WAKEUPI
A_1b72:	rjmp	A_1b8a	; 0x1b8a
A_1b74:	lds	R24, usb_suspended	; 0x27a
A_1b78:	and	R24, R24
A_1b7a:	breq	A_1b8a	; 0x1b8a
A_1b7c:	lds	R24, UDIEN	; 0x1c4
A_1b80:	andi	R24, ~(1<<WAKEUPE)
A_1b82:	sts	UDIEN, R24	; 0x1c4
A_1b86:	sts	usb_suspended, __zero_reg__	; 0x27a

A_1b8a:	sbrs	intbits, EORSMI
A_1b8c:	rjmp	A_1b92	; 0x1b92
A_1b8e:	sts	usb_resuming, __zero_reg__	; 0x27c

A_1b92:	sbrs	intbits, SOFI
A_1b94:	rjmp	A_1d4c	; 0x1d4c
A_1b96:	lds	R24, usb_configuration	; 0x284
A_1b9a:	and	R24, R24
A_1b9c:	brne	A_1ba0	; 0x1ba0
A_1b9e:	rjmp	A_1d4c	; 0x1d4c

;if ((intbits & (1<<SOFI)) && usb_configuration):
A_1ba0:	lds	R24, keyboard_protocol	; 0x232  keyboard_protocol
A_1ba4:	and	R24, R24
A_1ba6:	breq	A_1bd4	; 0x1bd4
A_1ba8:	lds	R24, debug_flush_timer	; 0x29e
A_1bac:	and	R24, R24
A_1bae:	breq	A_1bd4	; 0x1bd4
A_1bb0:	subi	R24, 0x01
A_1bb2:	sts	debug_flush_timer, R24	; 0x29e
A_1bb6:	and	R24, R24
A_1bb8:	brne	A_1bd4	; 0x1bd4
A_1bba:	ldi	R24, 0x03
A_1bbc:	sts	UENUM, R24	; 0x1d2
A_1bc0:	rjmp	A_1bc6	; 0x1bc6
A_1bc2:	sts	UEDATX, __zero_reg__	; 0x1e2
A_1bc6:	lds	R24, UEINTX	; 0x1d0
A_1bca:	sbrc	R24, RWAL
A_1bcc:	rjmp	A_1bc2	; 0x1bc2
A_1bce:	ldi	R24, 0x3a
A_1bd0:	sts	UEINTX, R24	; 0x1d0
A_1bd4:	lds	R24, keyboard_protocol	; 0x232  keyboard_protocol
A_1bd8:	and	R24, R24
A_1bda:	breq	A_1bf8	; 0x1bf8
A_1bdc:	lds	R24, rx_timeout_count	; 0x288
A_1be0:	and	R24, R24
A_1be2:	breq	A_1bea	; 0x1bea
A_1be4:	subi	R24, 0x01
A_1be6:	sts	rx_timeout_count, R24	; 0x288
A_1bea:	lds	R24, tx_timeout_count	; 0x286
A_1bee:	and	R24, R24
A_1bf0:	breq	A_1bf8	; 0x1bf8
A_1bf2:	subi	R24, 0x01
A_1bf4:	sts	tx_timeout_count, R24	; 0x286
A_1bf8:	lds	R24, USB_GEN_vect__div4	; 0x2a0
A_1bfc:	subi	R24, 0xff
A_1bfe:	sts	USB_GEN_vect__div4, R24	; 0x2a0
A_1c02:	ldi	R25, 0x00
A_1c04:	andi	R24, 0x03
A_1c06:	andi	R25, 0x00
A_1c08:	or	R24, R25

A_1c0a:	breq	A_1c0e	; 0x1c0e
A_1c0c:	rjmp	A_1d4c	; 0x1d4c
A_1c0e:	lds	R25, boot_idle_config	; 0x23a
A_1c12:	and	R25, R25
A_1c14:	breq	A_1c78	; 0x1c78
A_1c16:	ldi	R24, 0x01	;UENUM=BOOT_ENDPOINT;
A_1c18:	sts	UENUM, R24	; 0x1d2
A_1c1c:	lds	R24, UEINTX	; 0x1d0
A_1c20:	sbrs	R24, RWAL
A_1c22:	rjmp	A_1c78	; 0x1c78
A_1c24:	lds	R24, boot_idle_count	; 0x290
A_1c28:	subi	R24, 0xff
A_1c2a:	sts	boot_idle_count, R24	; 0x290
A_1c2e:	cp	R24, R25
A_1c30:	brcs	A_1c78	; 0x1c78
A_1c32:	sts	boot_idle_count, __zero_reg__	; 0x290
A_1c36:	lds	R24, keyboard_modifier_keys	; 0x280
A_1c3a:	sts	UEDATX, R24	; 0x1e2
A_1c3e:	sts	UEDATX, __zero_reg__	; 0x1e2
A_1c42:	lds	R24, boot_keys	; 0x292
A_1c46:	sts	UEDATX, R24	; 0x1e2
A_1c4a:	lds	R24, boot_keys+1	; 0x294
A_1c4e:	sts	UEDATX, R24	; 0x1e2
A_1c52:	lds	R24, boot_keys+2	; 0x296
A_1c56:	sts	UEDATX, R24	; 0x1e2
A_1c5a:	lds	R24, boot_keys+3	; 0x298
A_1c5e:	sts	UEDATX, R24	; 0x1e2
A_1c62:	lds	R24, boot_keys+4	; 0x29a
A_1c66:	sts	UEDATX, R24	; 0x1e2
A_1c6a:	lds	R24, boot_keys+5	; 0x29c
A_1c6e:	sts	UEDATX, R24	; 0x1e2
A_1c72:	ldi	R24, 0x3a
A_1c74:	sts	UEINTX, R24	; 0x1d0
A_1c78:	lds	R24, keyboard_protocol	; 0x232  keyboard_protocol
A_1c7c:	and	R24, R24
A_1c7e:	brne	A_1c82	; 0x1c82
A_1c80:	rjmp	A_1d4c	; 0x1d4c
A_1c82:	ldi	R24, 0x02
A_1c84:	sts	UENUM, R24	; 0x1d2
A_1c88:	lds	R25, keyboard_idle_config	; 0x234
A_1c8c:	and	R25, R25
A_1c8e:	breq	A_1cd0	; 0x1cd0
A_1c90:	lds	R24, UEINTX	; 0x1d0
A_1c94:	sbrs	R24, RWAL
A_1c96:	rjmp	A_1cd0	; 0x1cd0
A_1c98:	lds	R24, keyboard_idle_count	; 0x28a
A_1c9c:	subi	R24, 0xff
A_1c9e:	sts	keyboard_idle_count, R24	; 0x28a
A_1ca2:	cp	R24, R25
A_1ca4:	brcs	A_1cd0	; 0x1cd0
A_1ca6:	sts	keyboard_idle_count, __zero_reg__	; 0x28a
A_1caa:	ldi	R24, 0x01
A_1cac:	sts	UEDATX, R24	; 0x1e2
A_1cb0:	lds	R24, keyboard_modifier_keys	; 0x280
A_1cb4:	sts	UEDATX, R24	; 0x1e2
A_1cb8:	ldi	R30, 0x52	;Z = kbd_data_data1;
A_1cba:	ldi	R31, 0x01
A_1cbc:	ld	R24, Z+
A_1cbe:	sts	UEDATX, R24	; 0x1e2
A_1cc2:	ldi	R24, 0x01	;if (Z != kbd_data_data1 + 21)
A_1cc4:	cpi	R30, 0x67
A_1cc6:	cpc	R31, R24
A_1cc8:	brne	A_1cbc	; 0x1cbc
A_1cca:	ldi	R24, 0x3a
A_1ccc:	sts	UEINTX, R24	; 0x1d0
A_1cd0:	lds	R25, keyboard_idle_config+1	; 0x236
A_1cd4:	and	R25, R25
A_1cd6:	breq	A_1d06	; 0x1d06
A_1cd8:	lds	R24, UEINTX	; 0x1d0
A_1cdc:	sbrs	R24, RWAL
A_1cde:	rjmp	A_1d06	; 0x1d06
A_1ce0:	lds	R24, keyboard_idle_count+1	; 0x28c
A_1ce4:	subi	R24, 0xff
A_1ce6:	sts	keyboard_idle_count+1, R24	; 0x28c
A_1cea:	cp	R24, R25
A_1cec:	brcs	A_1d06	; 0x1d06
A_1cee:	sts	keyboard_idle_count+1, __zero_reg__	; 0x28c
A_1cf2:	ldi	R24, 0x02
A_1cf4:	sts	UEDATX, R24	; 0x1e2
A_1cf8:	lds	R24, kbd_data_data2	; 0x2ce
A_1cfc:	sts	UEDATX, R24	; 0x1e2
A_1d00:	ldi	R24, 0x3a
A_1d02:	sts	UEINTX, R24	; 0x1d0
A_1d06:	lds	R25, keyboard_idle_config+2	; 0x238
A_1d0a:	and	R25, R25
A_1d0c:	breq	A_1d4c	; 0x1d4c
A_1d0e:	lds	R24, UEINTX	; 0x1d0
A_1d12:	sbrs	R24, RWAL
A_1d14:	rjmp	A_1d4c	; 0x1d4c
A_1d16:	lds	R24, keyboard_idle_count+2	; 0x28e
A_1d1a:	subi	R24, 0xff
A_1d1c:	sts	keyboard_idle_count+2, R24	; 0x28e
A_1d20:	cp	R24, R25
A_1d22:	brcs	A_1d4c	; 0x1d4c
A_1d24:	sts	keyboard_idle_count+2, __zero_reg__	; 0x28e
A_1d28:	ldi	R24, 0x03
A_1d2a:	sts	UEDATX, R24	; 0x1e2
A_1d2e:	lds	R24, kbd_data_data3	; 0x2d0
A_1d32:	sts	UEDATX, R24	; 0x1e2
A_1d36:	lds	R24, kbd_data_data3+1	; 0x2d2
A_1d3a:	sts	UEDATX, R24	; 0x1e2
A_1d3e:	lds	R24, kbd_data_data3+2	; 0x2d4
A_1d42:	sts	UEDATX, R24	; 0x1e2
A_1d46:	ldi	R24, 0x3a
A_1d48:	sts	UEINTX, R24	; 0x1d0
A_1d4c:
	pop	R31
	pop	R30
	pop	R25
	pop	R24
	pop	intbits
	pop	R0
	out	SREG, R0
	pop	R0
	pop	__zero_reg__
	reti	

;=====================================================
; USB_COM_vect: USB Endpoint Interrupt request
;=====================================================
;ISR(USB_COM_vect)

.def	bmRequestType = R22
.def	bRequest = R19
.def	wValueL = R20
.def	wValueH = R21
.def	wIndexL = R26
.def	wIndexH = R27
.def	wLengthL = R28
.def	wLengthH = R29
.def	intbits = R24		;only used once, but what the hell...

USB_COM_vect:
A_1d60:
	push	__zero_reg__
	push	R0
	in	R0, SREG
	push	R0
	clr	__zero_reg__
	push	R18
	push	R19
	push	R20
	push	R21
	push	R22
	push	R23
	push	R24
	push	R25
	push	R26
	push	R27
	push	R28
	push	R29
	push	R30
	push	R31

	sts	UENUM, __zero_reg__	; 0x1d2
	lds	intbits, UEINTX	; 0x1d0
	sbrs	intbits, 3
	rjmp	A_2228	; 0x2228

A_1d92:
	lds	bmRequestType, UEDATX	; 0x1e2
	lds	bRequest, UEDATX	; 0x1e2
	lds	R24, UEDATX	; 0x1e2
	mov	wwValueL, R24
	ldi	wValueH, 0x00
	lds	R18, UEDATX	; 0x1e2
	mov	R25, R18
	ldi	R24, 0x00
	or	wwValueL, R24
	or	wValueH, R25
	lds	R24, UEDATX	; 0x1e2
	mov	wIndexL, R24
	ldi	wIndexH, 0x00
	lds	R18, UEDATX	; 0x1e2
	mov	R25, R18
	ldi	R24, 0x00
	or	wIndexL, R24
	or	wIndexH, R25
	lds	R24, UEDATX	; 0x1e2
	mov	wLengthL, R24
	ldi	wLengthH, 0x00
	lds	R18, UEDATX	; 0x1e2
	mov	R25, R18
	ldi	R24, 0x00
	or	wLengthL, R24
	or	wLengthH, R25
A_1dd6:
	ldi	R24, 0xf2	;~((1<<RXSTPI) | (1<<RXOUTI) | (1<<TXINI));
	sts	UEINTX, R24	; 0x1d0

A_1ddc:
	cpi	bRequest, 0x06
	breq	A_1de2	; 0x1de2
	rjmp	A_1e8e	; 0x1e8e
; bRequest == GET_DESCRIPTOR:
A_1de2:
	ldi	R18, 0x09	;descriptor_list + 1
	ldi	R19, 0x03
	movw	R22, R18
	subi	R22, 0x05
	sbci	R23, 0x00
A_1dec:
	movw	R30, R18
	sbiw	R30, 0x07
	lpm	R24, Z+
	lpm	R25, Z
	cp	R24, wwValueL
	cpc	R25, wValueH
	brne	A_1e32	; 0x1e32
A_1dfa:
	movw	R30, R22
	lpm	R24, Z+
	lpm	R25, Z
	cp	R24, wIndexL
	cpc	R25, wIndexH
	brne	A_1e32	; 0x1e32
A_1e06:
	movw	R18, R22
	subi	R18, 0xfe
	sbci	R19, 0xff
	movw	R30, R18
	lpm	R22, Z+
	lpm	R23, Z
	subi	R18, 0xfe
	sbci	R19, 0xff
	movw	R30, R18
	lpm	R18, Z
A_1e1a:
	movw	R24, wLengthL
	cpi	wLengthL, 0xff
	cpc	wLengthH, __zero_reg__
	breq	A_1e28	; 0x1e28
	brcs	A_1e28	; 0x1e28
A_1e24:
	ser	R24
	ldi	R25, 0x00
A_1e28:
	mov	R20, R18
	cp	R24, R18
	brcc	A_1e44	; 0x1e44
A_1e2e:
	mov	R20, R24
	rjmp	A_1e44	; 0x1e44
A_1e32:
	subi	R18, 0xf9
	sbci	R19, 0xff
	subi	R22, 0xf9
	sbci	R23, 0xff
	ldi	R31, 0x03
	cpi	R18, 0x64
	cpc	R19, R31
	brne	A_1dec	; 0x1dec
A_1e42:
	rjmp	A_2228	; 0x2228
A_1e44:
	ldi	R21, 0xfe
A_1e46:
	lds	R24, UEINTX	; 0x1d0
	mov	R18, R24
	ldi	R19, 0x00
	movw	R24, R18
	andi	R24, 0x05
	andi	R25, 0x00
	or	R24, R25
	breq	A_1e46	; 0x1e46
A_1e58:
	sbrc	R18, 2
	rjmp	A_222e	; 0x222e
A_1e5c:
	mov	R19, R20
	cpi	R20, 0x21
	brcs	A_1e64	; 0x1e64
A_1e62:
	ldi	R19, 0x20
A_1e64:
	mov	R18, R19
	movw	R24, R22
	rjmp	A_1e76	; 0x1e76
A_1e6a:
	movw	R30, R24
	adiw	R24, 0x01
	lpm	R30, Z
	sts	UEDATX, R30	; 0x1e2
	subi	R18, 0x01
A_1e76:
	and	R18, R18
	brne	A_1e6a	; 0x1e6a
A_1e7a:
	add	R22, R19
	adc	R23, __zero_reg__
	sub	R20, R19
	sts	UEINTX, R21	; 0x1d0
	and	R20, R20
	brne	A_1e46	; 0x1e46
A_1e88:
	cpi	R19, 0x20
	breq	A_1e46	; 0x1e46
	rjmp	A_222e	; 0x222e

A_1e8e:
	mov	R24, bmRequestType
	andi	R24, 0x7f
	breq	A_1e96	; 0x1e96
	rjmp	A_1f4c	; 0x1f4c

A_1e96:
	cpi	bRequest, 0x05
	brne	A_1eb2	; 0x1eb2
A_1e9a:
	ldi	R24, 0xfe	;usb_send_in();
	sts	UEINTX, R24	; 0x1d0
A_1ea0:		;usb_wait_in_ready();
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_1ea0	; 0x1ea0
A_1ea8:
	mov	R24, wwValueL
	ori	R24, 0x80
	sts	UDADDR, R24	; 0x1c6
	rjmp	A_222e	; 0x222e

A_1eb2:
	cpi	bRequest, 0x09
	brne	A_1efc	; 0x1efc
;come here if bRequest == SET_CONFIGURATION
A_1eb6:
	sts	usb_configuration, wwValueL	; 0x284
	ldi	R24, 0xfe
	sts	UEINTX, R24	; 0x1d0
	ldi	R24, 0x5d	; R25:R24 = endpoint_config_table[]
	ldi	R25, 0x03
	ldi	R18, 0x01
A_1ec6:
	sts	UENUM, R18	; 0x1d2
	movw	R30, R24
	adiw	R24, 0x01
	lpm	R30, Z
	sts	UECONX, R30	; 0x1d6
	and	R30, R30
	breq	A_1ef2	; 0x1ef2
A_1ed8:
	movw	R20, R24
	subi	R20, 0xff
	sbci	R21, 0xff
	movw	R30, R24
	lpm	R24, Z
	sts	UECFG0X, R24	; 0x1d8
	movw	R24, R20
	adiw	R24, 0x01
	movw	R30, R20
	lpm	R19, Z
	sts	UECFG1X, R19	; 0x1da
A_1ef2:
	subi	R18, 0xff
	cpi	R18, 0x06
	brne	A_1ec6	; 0x1ec6
A_1ef8:
	ldi	R24, 0x1e
	rjmp	A_1fc4	; 0x1fc4

A_1efc:
	cpi	bRequest, 0x08
	brne	A_1f0e	; 0x1f0e
;come here if bRequest == GET_CONFIGURATION
A_1f00:		; usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_1f00	; 0x1f00
A_1f08:
	lds	R24, usb_configuration	; 0x284
	rjmp	A_2122	; 0x2122

A_1f0e:
	and	bRequest, bRequest
	brne	A_1f22	; 0x1f22
;come here if bRequest == GET_STATUS
A_1f12:		; usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_1f12	; 0x1f12
A_1f1a:
	lds	R24, usb_status	; 0x27e
	add	R24, R24
	rjmp	A_1f78	; 0x1f78

A_1f22:
	cpi	bRequest, 0x01
	breq	A_1f2c	; 0x1f2c
A_1f26:
	cpi	bRequest, 0x03
	breq	A_1f2c	; 0x1f2c
A_1f2a:
	rjmp	A_2228	; 0x2228

;come here if bRequest == CLEAR_FEATURE || bRequest == SET_FEATURE
A_1f2c:
	cpi	wwValueL, 0x01
	cpc	wValueH, __zero_reg__
	breq	A_1f34	; 0x1f34
	rjmp	A_2228	; 0x2228
A_1f34:
	ldi	R24, 0xfe		; usb_send_in()
	sts	UEINTX, R24	; 0x1d0
	cpi	bRequest, 0x01
	brne	A_1f44	; 0x1f44
	sts	usb_status, __zero_reg__	; 0x27e
	rjmp	A_222e	; 0x222e
A_1f44:
	ldi	R24, 0x01
	sts	usb_status, R24	; 0x27e
	rjmp	A_222e	; 0x222e

A_1f4c:
	cpi	R24, 0x02	;(bmRequestType & 0x7f)
	breq	A_1f52	; 0x1f52
	rjmp	A_1fce	; 0x1fce
; (bmRequestType & 0x7f) == 2
A_1f52:
	and	bRequest, bRequest
	brne	A_1f82	; 0x1f82
A_1f56:		;usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_1f56	; 0x1f56
A_1f5e:
	sts	UENUM, wIndexL	; 0x1d2
	lds	R24, UECONX	; 0x1d6
	ldi	R25, 0x00
	ldi	R18, 0x05
A_1f6a:
	lsr	R25
	ror	R24
	dec	R18
	brne	A_1f6a	; 0x1f6a
A_1f72:
	andi	R24, 0x01
	sts	UENUM, __zero_reg__	; 0x1d2
A_1f78:
	sts	UEDATX, R24	; 0x1e2
	sts	UEDATX, __zero_reg__	; 0x1e2
	rjmp	A_2220	; 0x2220

A_1f82:
	cpi	bRequest, 0x01
	breq	A_1f8c	; 0x1f8c
	cpi	bRequest, 0x03
	breq	A_1f8c	; 0x1f8c
	rjmp	A_2228	; 0x2228
; (bRequest == CLEAR_FEATURE) || (bRequest == SET_FEATURE)
A_1f8c:
	or	wwValueL, wValueH
	breq	A_1f92	; 0x1f92
	rjmp	A_2228	; 0x2228
	
A_1f92:
	mov	R18, wIndexL
	andi	R18, 0x7f
	mov	R24, R18
	subi	R24, 0x01
	cpi	R24, 0x05
	brcs	A_1fa0	; 0x1fa0
	rjmp	A_2228	; 0x2228
A_1fa0:
	ldi	R24, 0xfe		;usb_send_in()
	sts	UEINTX, R24	; 0x1d0
	sts	UENUM, R18	; 0x1d2
	cpi	bRequest, 0x03
	brne	A_1fb0	; 0x1fb0
	rjmp	A_2228	; 0x2228
A_1fb0:
	ldi	R24, 0x19	; (1 << STALLRQC) | (1 << RSTDT) | (1 << EPEN)
	sts	UECONX, R24	; 0x1d6
	ldi	R24, 0x01
	ldi	R25, 0x00
	rjmp	A_1fc0	; 0x1fc0
A_1fbc:
	add	R24, R24
	adc	R25, R25
A_1fc0:
	dec	R18
	brpl	A_1fbc	; 0x1fbc
A_1fc4:
	sts	UERST, R24	; 0x1d4
	sts	UERST, __zero_reg__	; 0x1d4
	rjmp	A_222e	; 0x222e

A_1fce:
	cpi	R24, 0x21	;(bmRequestType & 0x7f)
	breq	A_1fd4	; 0x1fd4
	rjmp	A_2228	; 0x2228
; (bmRequestType & 0x7f) == 0x21
A_1fd4:
	cpi	wIndexL, 0x02
	cpc	wIndexH, __zero_reg__
	breq	A_1fdc	; 0x1fdc
	rjmp	A_20b4	; 0x20b4

A_1fdc:
	mov	R30, wwValueL
	cpi	bRequest, 0x01
	brne	A_203c	; 0x203c
A_1fe2:		; usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_1fe2	; 0x1fe2
A_1fea:
	cpi	R30, 0x01
	brne	A_200e	; 0x200e
A_1fee:
	sts	UEDATX, R30	; 0x1e2
	lds	R24, keyboard_modifier_keys	; 0x280
	sts	UEDATX, R24	; 0x1e2
	ldi	R30, 0x52	; Z = kbd_data_data1;
	ldi	R31, 0x01
A_1ffe:
	ld	R24, Z+
	sts	UEDATX, R24	; 0x1e2
	ldi	R24, 0x01
	cpi	R30, 0x67
	cpc	R31, R24
	brne	A_1ffe	; 0x1ffe
A_200c:
	rjmp	A_2220	; 0x2220
A_200e:
	cpi	R30, 0x02
	brne	A_201c	; 0x201c
A_2012:
	sts	UEDATX, R30	; 0x1e2
	lds	R24, kbd_data_data2	; 0x2ce
	rjmp	A_2122	; 0x2122
A_201c:
	cpi	R30, 0x03
	breq	A_2022	; 0x2022
	rjmp	A_2220	; 0x2220
A_2022:
	sts	UEDATX, R30	; 0x1e2
	lds	R24, kbd_data_data3	; 0x2d0
	sts	UEDATX, R24	; 0x1e2
	lds	R24, kbd_data_data3+1	; 0x2d2
	sts	UEDATX, R24	; 0x1e2
	lds	R24, kbd_data_data3+2	; 0x2d4
	rjmp	A_2122	; 0x2122

A_203c:
	cpi	bRequest, 0x09
	brne	A_204e	; 0x204e
;bRequest == HID_SET_REPORT
A_2040:		;usb_wait_receive_out()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 2
	rjmp	A_2040	; 0x2040
	lds	R24, UEDATX	; 0x1e2
	rjmp	A_2134	; 0x2134

A_204e:
	cpi	bRequest, 0x02
	brne	A_206e	; 0x206e
;bRequest == HID_GET_IDLE
A_2052:		;usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_2052	; 0x2052
A_205a:
	and	R30, R30
	breq	A_2068	; 0x2068
A_205e:
	ldi	R31, 0x00
	subi	R30, 0xe7	;+0x0119
	sbci	R31, 0xfe
	ld	R24, Z
	rjmp	A_2122	; 0x2122
A_2068:
	lds	R24, keyboard_idle_config	; 0x234
	rjmp	A_2122	; 0x2122

A_206e:
	cpi	bRequest, 0x0a
	breq	A_2074	; 0x2074
	rjmp	A_2228	; 0x2228

;bRequest == HID_SET_IDLE
A_2074:
	and	wwValueL, wwValueL
	breq	A_2094	; 0x2094
A_2078:
	mov	R26, wwValueL
	ldi	R27, 0x00
	sbiw	R26, 0x01
	movw	R30, R26
	subi	R30, 0xe6	;keyboard_idle_config
	sbci	R31, 0xfe
	st	Z, wValueH
	and	wValueH, wValueH
	breq	A_208c	; 0x208c
	rjmp	A_2220	; 0x2220
A_208c:
	subi	R26, 0xbb	;keyboard_idle_count
	sbci	R27, 0xfe
	st	X, __zero_reg__
	rjmp	A_2220	; 0x2220
A_2094:
	sts	keyboard_idle_config, wValueH	; 0x234
	sts	keyboard_idle_config+1, wValueH	; 0x236
	sts	keyboard_idle_config+2, wValueH	; 0x238
	and	wValueH, wValueH
	breq	A_20a6	; 0x20a6
A_20a4:
	rjmp	A_2220	; 0x2220
	sts	keyboard_idle_count, __zero_reg__	; 0x28a
	sts	keyboard_idle_count+1, __zero_reg__	; 0x28c
	sts	keyboard_idle_count+2, __zero_reg__	; 0x28e
	rjmp	A_2220	; 0x2220

A_20b4:
	sbiw	wIndexL, 0x00
	breq	A_20ba	; 0x20ba
	rjmp	A_2164	; 0x2164
; wIndex == BOOT_INTERFACE
A_20ba:
	cpi	bRequest, 0x01
	brne	A_2100	; 0x2100
; bRequest == HID_GET_REPORT
A_20be:		;sub_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_20be	; 0x20be
A_20c6:
	lds	R24, keyboard_modifier_keys	; 0x280
	sts	UEDATX, R24	; 0x1e2
	sts	UEDATX, __zero_reg__	; 0x1e2
	lds	R24, boot_keys	; 0x292
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+1	; 0x294
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+2	; 0x296
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+3	; 0x298
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+4	; 0x29a
	sts	UEDATX, R24	; 0x1e2
	lds	R24, boot_keys+5	; 0x29c
	rjmp	A_2122	; 0x2122
	
A_2100:
	cpi	bRequest, 0x02
	brne	A_2112	; 0x2112
; bRequest == HID_GET_IDLE
A_2104:		;usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_2104	; 0x2104
A_210c:
	lds	R24, boot_idle_config	; 0x23a
	rjmp	A_2122	; 0x2122
	
A_2112:
	cpi	bRequest, 0x03
	brne	A_2128	; 0x2128
; bRequest == HID_GET_PROTOCOL
A_2116:		; usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_2116	; 0x2116
	lds	R24, keyboard_protocol	; 0x232  keyboard_protocol
	sts	UEDATX, R24	; 0x1e2  ;UEDATX = keyboard_protocol
	rjmp	A_2220	; 0x2220
	
A_2128:
	cpi	bRequest, 0x09
	brne	A_2144	; 0x2144
; bRequest == HID_SET_REPORT
A_212c:		;usb_wait_receive_out()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 2
	rjmp	A_212c	; 0x212c
A_2134:
	lds	R24, UEDATX	; 0x1e2
	sts	keyboard_leds, R24	; 0x282
	ldi	R24, 0xfb		;usb_ack_out()
	sts	UEINTX, R24	; 0x1d0
	rjmp	A_2220	; 0x2220

A_2144:
	cpi	bRequest, 0x0a
	brne	A_2158	; 0x2158
; bRequest == HID_SET_IDLE
A_2148:
	sts	boot_idle_config, wValueH	; 0x23a
	and	wValueH, wValueH
	breq	A_2152	; 0x2152
	rjmp	A_2220	; 0x2220
A_2152:
	sts	boot_idle_count, __zero_reg__	; 0x290
	rjmp	A_2220	; 0x2220

A_2158:
	cpi	bRequest, 0x0b
	breq	A_215e	; 0x215e
	rjmp	A_2228	; 0x2228
; bRequest == HID_SET_PROTOCOL
	sts	keyboard_protocol, wwValueL	; 0x232
	rjmp	A_2220	; 0x2220

A_2164:
	cpi	wIndexL, 0x01
	cpc	wIndexH, __zero_reg__
	brne	A_21b0	; 0x21b0
; wIndex == DEBUG_INTERFACE
A_216a:
	cpi	bRequest, 0x01
	breq	A_2170	; 0x2170
	rjmp	A_2228	; 0x2228
; bRequest == HID_GET_REPORT
A_2170:
	mov	R20, wLengthL
	ldi	R21, 0xfe
A_2174:
	lds	R24, UEINTX	; 0x1d0
	mov	R18, R24
	ldi	R19, 0x00
	movw	R24, R18
	andi	R24, 0x05
	andi	R25, 0x00
	or	R24, R25
	breq	A_2174	; 0x2174
A_2186:
	sbrc	R18, 2
	rjmp	A_222e	; 0x222e
	mov	R25, R20
	cpi	R20, 0x21
	brcs	A_2192	; 0x2192
A_2190:
	ldi	R25, 0x20
A_2192:
	mov	R24, R25
	rjmp	A_219c	; 0x219c
A_2196:
	sts	UEDATX, __zero_reg__	; 0x1e2
	subi	R24, 0x01
A_219c:
	and	R24, R24
	brne	A_2196	; 0x2196
A_21a0:
	sub	R20, R25
	sts	UEINTX, R21	; 0x1d0
	and	R20, R20
	brne	A_2174	; 0x2174
A_21aa:
	cpi	R25, 0x20
	breq	A_2174	; 0x2174
	rjmp	A_222e	; 0x222e

A_21b0:
	sbiw	wIndexL, 0x03
	brne	A_2228	; 0x2228
; wIndex == RAWHID_INTERFACE
A_21b4:
	cpi	bRequest, 0x01
	brne	A_21f8	; 0x21f8
; bRequest == HID_GET_REPORT
A_21b8:
	ldi	R20, 0x40
	ldi	R21, 0xfe
A_21bc:
	lds	R24, UEINTX	; 0x1d0
	mov	R18, R24
	ldi	R19, 0x00
	movw	R24, R18
	andi	R24, 0x05
	andi	R25, 0x00
	or	R24, R25
	breq	A_21bc	; 0x21bc
A_21ce:
	sbrc	R18, 2
	rjmp	A_222e	; 0x222e
A_21d2:
	mov	R25, R20
	cpi	R20, 0x21
	brcs	A_21da	; 0x21da
	ldi	R25, 0x20
A_21da:
	mov	R24, R25
	rjmp	A_21e4	; 0x21e4
A_21de:
	sts	UEDATX, __zero_reg__	; 0x1e2
	subi	R24, 0x01
A_21e4:
	and	R24, R24
	brne	A_21de	; 0x21de
A_21e8:
	sub	R20, R25
	sts	UEINTX, R21	; 0x1d0		;usb_send_in()
	and	R20, R20
	brne	A_21bc	; 0x21bc
A_21f2:
	cpi	R25, 0x20
	breq	A_21bc	; 0x21bc
A_21f6:
	rjmp	A_222e	; 0x222e

A_21f8:
	cpi	bRequest, 0x09
	brne	A_2228	; 0x2228
; bRequest == HID_SET_REPORT
A_21fc:
	ldi	R25, 0x40
	ldi	R18, 0xfb
A_2200:		; usb_wait_receive_out()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 2
	rjmp	A_2200	; 0x2200
A_2208:
	sts	UEINTX, R18	; usb_ack_out()
	mov	R24, R25
	cpi	R25, 0x21
	brcs	A_2214	; 0x2214
A_2212:
	ldi	R24, 0x20
A_2214:
	sub	R25, R24
	brne	A_2200	; 0x2200
A_2218:		; usb_wait_in_ready()
	lds	R24, UEINTX	; 0x1d0
	sbrs	R24, 0
	rjmp	A_2218	; 0x2218
A_2220:
	ldi	R24, 0xfe		; usb_send_in()
	sts	UEINTX, R24	; 0x1d0
	rjmp	A_222e	; 0x222e
	
A_2228:
	ldi	R24, 0x21
	sts	UECONX, R24	; 0x1d6
A_222e:
	pop	R31
	pop	R30
	pop	R29
	pop	R28
	pop	R27
	pop	R26
	pop	R25
	pop	R24
	pop	R23
	pop	R22
	pop	R21
	pop	R20
	pop	R19
	pop	R18
	pop	R0
	out	SREG, R0
	pop	R0
	pop	__zero_reg__
	reti	

;===============================================
; usb_rawhid_recv 
;===============================================
usb_rawhid_recv:
A_2254:	movw	R30, R24
A_2256:	lds	R24, usb_configuration	; 0x284
A_225a:	and	R24, R24
A_225c:	breq	A_22ac	; 0x22ac
A_225e:	in	R18, SREG
A_2260:	cli	
A_2262:	sts	rx_timeout_count, R22	; 0x288
A_2266:	ldi	R24, 0x05
A_2268:	sts	UENUM, R24	; 0x1d2
A_226c:	ldi	R25, 0x05
A_226e:	lds	R24, UEINTX	; 0x1d0
A_2272:	sbrs	R24, 5
A_2274:	rjmp	A_227a	; 0x227a
A_2276:	ldi	R25, 0x40
A_2278:	rjmp	A_2296	; 0x2296
A_227a:	out	SREG, R18
A_227c:	lds	R24, rx_timeout_count	; 0x288
A_2280:	and	R24, R24
A_2282:	breq	A_22ae	; 0x22ae
A_2284:	lds	R24, usb_configuration	; 0x284
A_2288:	and	R24, R24
A_228a:	breq	A_22ac	; 0x22ac
A_228c:	in	R18, SREG
A_228e:	cli	
A_2290:	sts	UENUM, R25	; 0x1d2
A_2294:	rjmp	A_226e	; 0x226e
A_2296:	lds	R24, UEDATX	; 0x1e2
A_229a:	st	Z+, R24
A_229c:	subi	R25, 0x01
A_229e:	brne	A_2296	; 0x2296
A_22a0:	ldi	R24, 0x6b
A_22a2:	sts	UEINTX, R24	; 0x1d0
A_22a6:	out	SREG, R18
A_22a8:	ldi	R24, 0x40
A_22aa:	ret	
A_22ac:	ser	R24
A_22ae:	ret	

;==================================================
; usb_rawhid_send
;==================================================
usb_rawhid_send:
A_22b0:	movw	R30, R24
A_22b2:	lds	R24, usb_configuration	; 0x284
A_22b6:	and	R24, R24
A_22b8:	breq	A_2308	; 0x2308
A_22ba:	in	R18, SREG
A_22bc:	cli	
A_22be:	sts	tx_timeout_count, R22	; 0x286
A_22c2:	ldi	R24, 0x04
A_22c4:	sts	UENUM, R24	; 0x1d2
A_22c8:	ldi	R25, 0x04
A_22ca:	lds	R24, UEINTX	; 0x1d0
A_22ce:	sbrs	R24, 5
A_22d0:	rjmp	A_22d6	; 0x22d6
A_22d2:	ldi	R25, 0x40
A_22d4:	rjmp	A_22f2	; 0x22f2
A_22d6:	out	SREG, R18
A_22d8:	lds	R24, tx_timeout_count	; 0x286
A_22dc:	and	R24, R24
A_22de:	breq	A_230a	; 0x230a
A_22e0:	lds	R24, usb_configuration	; 0x284
A_22e4:	and	R24, R24
A_22e6:	breq	A_2308	; 0x2308
A_22e8:	in	R18, SREG
A_22ea:	cli	
A_22ec:	sts	UENUM, R25	; 0x1d2
A_22f0:	rjmp	A_22ca	; 0x22ca
A_22f2:	ld	R24, Z+
A_22f4:	sts	UEDATX, R24	; 0x1e2
A_22f8:	subi	R25, 0x01
A_22fa:	brne	A_22f2	; 0x22f2
A_22fc:	ldi	R24, 0x3a
A_22fe:	sts	UEINTX, R24	; 0x1d0
A_2302:	out	SREG, R18
A_2304:	ldi	R24, 0x40
A_2306:	ret	
A_2308:	ser	R24
A_230a:	ret	

;============================================
; rjmp_usb_debug_putchar :   presumably compiler-generated
;============================================
rjmp_usb_debug_putchar:
A_230c:
	rjmp	usb_debug_putchar	; 0x1a62

A_230e:	ret	

;=============================================================================
; print.c start
;=============================================================================

;=======================================
; phex1:
;=======================================
phex1:
A_2310:
	mov	R25, R24
	cpi	R24, 0x0a
	brcs	A_231a	; 0x231a
	ldi	R24, 0x37
	rjmp	A_231c	; 0x231c
A_231a:
	ldi	R24, 0x30
A_231c:
	add	R24, R25
	rjmp	usb_debug_putchar	; 0x1a62

;=======================================
; phex:
;=======================================
phex:
A_2320:
	push	R17
A_2322:	mov	R17, R24
A_2324:	swap	R24
A_2326:	andi	R24, 0x0f
A_2328:	rcall	phex1	; 0x2310
A_232a:	mov	R24, R17
A_232c:	andi	R24, 0x0f
A_232e:	rcall	phex1	; 0x2310
A_2330:	pop	R17
A_2332:	ret	

;=======================================
; phex16 :
;=======================================
phex16:
A_2334:
	push	R17
	mov	R17, R24
	mov	R24, R25
	rcall	phex	; 0x2320
	mov	R24, R17
	rcall	phex	; 0x2320
	pop	R17
	ret	

;=======================================
;  print_P :
;=======================================
print_P:
A_2344:
	push	R17
A_2346:	push	R28
A_2348:	push	R29
A_234a:	movw	R28, R24
A_234c:	movw	R30, R28
A_234e:	adiw	R28, 0x01
A_2350:	lpm	R17, Z
A_2352:	and	R17, R17
A_2354:	breq	A_2364	; 0x2364
A_2356:	cpi	R17, 0x0a
A_2358:	brne	A_235e	; 0x235e
A_235a:	ldi	R24, 0x0d
A_235c:	rcall	usb_debug_putchar	; 0x1a62
A_235e:	mov	R24, R17
A_2360:	rcall	usb_debug_putchar	; 0x1a62
A_2362:	rjmp	A_234c	; 0x234c
A_2364:	pop	R29
A_2366:	pop	R28
A_2368:	pop	R17
A_236a:	ret	

;=============================================================================
; print.c end
;=============================================================================

;==================================================
; get_layernum 
;==================================================
get_layernum:
A_236c:	mov	R19, R24
.def	hidx = R19
.def	i = R25
A_236e:	lds	R18, layer_cnt	; 0x2e0
A_2372:	lds	R30, layerdata	; 0x2da
A_2376:	lds	R31, layerdata+1	; 0x2dc
A_237a:	ldi	i, 0x00
A_237c:	rjmp	A_2390	; 0x2390
A_237e:	movw	R26, R30
A_2380:	ld	R24, Z
A_2382:	adiw	R30, 0x02
A_2384:	cp	R24, hidx
A_2386:	brne	A_238e	; 0x238e
A_2388:	adiw	R26, 0x01
A_238a:	ld	R24, X
A_238c:	ret	
A_238e:	subi	i, 0xff
A_2390:	cp	i, R18
A_2392:	brcs	A_237e	; 0x237e
A_2394:	ldi	R24, 0x00
A_2396:	ret	

;==================================================
; translate_hidx 
;==================================================
translate_hidx:
A_2398:	push	R16
A_239a:	push	R17
A_239c:	push	R28
A_239e:	push	R29
A_23a0:	mov	R17, R24
A_23a2:	mov	R16, R22
A_23a4:	lds	R24, max_used_layer	; 0x2e6
A_23a8:	and	R24, R24
A_23aa:	breq	A_2418	; 0x2418
A_23ac:	and	R22, R22
A_23ae:	breq	A_23c2	; 0x23c2
A_23b0:	lds	R30, fn_keyset	; 0x2ea
A_23b4:	lds	R31, fn_keyset+1	; 0x2ec
A_23b8:	add	R30, R17
A_23ba:	adc	R31, __zero_reg__
A_23bc:	lds	R24, fn_curset	; 0x2e8
A_23c0:	st	Z, R24
A_23c2:	mov	R28, R17
A_23c4:	ldi	R29, 0x00
A_23c6:	lds	R30, fn_keyset	; 0x2ea
A_23ca:	lds	R31, fn_keyset+1	; 0x2ec
A_23ce:	add	R30, R28
A_23d0:	adc	R31, R29
A_23d2:	ld	R24, Z
A_23d4:	rcall	get_layernum	; 0x236c
A_23d6:	mov	R18, R24
A_23d8:	and	R24, R24
A_23da:	breq	A_2418	; 0x2418
A_23dc:	lds	R24, max_used_layer	; 0x2e6
A_23e0:	cp	R24, R18
A_23e2:	brcs	A_2418	; 0x2418

A_23e4:	ldi	R24, 0x01
A_23e6:	ldi	R25, 0x00
A_23e8:	sub	R24, R18
A_23ea:	sbc	R25, __zero_reg__
A_23ec:	add	R24, R24
A_23ee:	adc	R25, R25
A_23f0:	lds	R30, layer_map	; 0x2e2
A_23f4:	lds	R31, layer_map+1	; 0x2e4
A_23f8:	sub	R30, R24
A_23fa:	sbc	R31, R25
A_23fc:	ld	R0, Z+
A_23fe:	ld	R31, Z
A_2400:	mov	R30, R0
A_2402:	add	R30, R28
A_2404:	adc	R31, R29
A_2406:	ld	R24, Z
A_2408:	and	R24, R24
A_240a:	breq	A_2410	; 0x2410
A_240c:	mov	R30, R24
A_240e:	rjmp	A_2422	; 0x2422
A_2410:	subi	R28, 0x66	; R28_29 += hidx_trans
A_2412:	sbci	R29, 0xfe
A_2414:	ld	R30, Y
A_2416:	rjmp	A_2422	; 0x2422
A_2418:	mov	R30, R17
A_241a:	ldi	R31, 0x00
A_241c:	subi	R30, 0x66	; Z += hidx_trans
A_241e:	sbci	R31, 0xfe
A_2420:	ld	R30, Z

A_2422:	mov	R18, R30
A_2424:	ldi	R19, 0x00
A_2426:	movw	R24, R18
A_2428:	andi	R24, 0xf8
A_242a:	andi	R25, 0x00
A_242c:	cpi	R24, 0xd0
A_242e:	cpc	R25, __zero_reg__
A_2430:	brne	A_2468	; 0x2468

A_2432:	lds	R20, fn_curset	; 0x2e8
A_2436:	andi	R18, 0x07
A_2438:	andi	R19, 0x00
A_243a:	and	R16, R16
A_243c:	breq	A_2450	; 0x2450
A_243e:	ldi	R24, 0x01
A_2440:	ldi	R25, 0x00
A_2442:	rjmp	A_2448	; 0x2448
A_2444:	add	R24, R24
A_2446:	adc	R25, R25
A_2448:	dec	R18
A_244a:	brpl	A_2444	; 0x2444
A_244c:	or	R20, R24
A_244e:	rjmp	A_2462	; 0x2462

A_2450:	ldi	R24, 0x01
A_2452:	ldi	R25, 0x00
A_2454:	rjmp	A_245a	; 0x245a
A_2456:	add	R24, R24
A_2458:	adc	R25, R25
A_245a:	dec	R18
A_245c:	brpl	A_2456	; 0x2456
A_245e:	com	R24
A_2460:	and	R20, R24
A_2462:	sts	fn_curset, R20	; 0x2e8
A_2466:	ldi	R30, 0x00
A_2468:	mov	R24, R30
A_246a:	pop	R29
A_246c:	pop	R28
A_246e:	pop	R17
A_2470:	pop	R16
A_2472:	ret	

;=========================================
; reset_layers :
;=========================================
reset_layers:
A_2474:	sts	allocated_layers, __zero_reg__	; 0x2de
A_2478:	sts	layer_cnt, __zero_reg__	; 0x2e0
A_247c:	sts	max_used_layer, __zero_reg__	; 0x2e6
A_2480:	sts	layerdata+1, __zero_reg__	; 0x2dc
A_2484:	sts	layerdata, __zero_reg__	; 0x2da
A_2488:	sts	layer_map+1, __zero_reg__	; 0x2e4
A_248c:	sts	layer_map, __zero_reg__	; 0x2e2
A_2490:	sts	fn_keyset+1, __zero_reg__	; 0x2ec
A_2494:	sts	fn_keyset, __zero_reg__	; 0x2ea
A_2498:	ret	

;=========================================
; reset_layer_trans : sets up the above and resets a 256-byte buffer
;=========================================
reset_layer_trans:
A_249a:	rcall	reset_layers	; reset data areas
A_249c:	ldi	R24, 0x00   ; inizialize a 256-byte area at 0x019a to 00..ff
A_249e:	subi	R24, 0x01
A_24a0:	mov	R30, R24
A_24a2:	ldi	R31, 0x00
A_24a4:	subi	R30, 0x66
A_24a6:	sbci	R31, 0xfe
A_24a8:	st	Z, R24
A_24aa:	and	R24, R24
A_24ac:	brne	A_249e	; 0x249e
A_24ae:	ret	

;=========================================
; setup_layer :
;=========================================
setup_layer:
A_24b0:	mov	R19, R24
A_24b2:	lds	R18, layer_cnt	; 0x2e0
A_24b6:	lds	R24, allocated_layers	; 0x2de
A_24ba:	cp	R18, R24
A_24bc:	brcc	A_24dc	; 0x24dc
A_24be:	mov	R24, R18
A_24c0:	ldi	R25, 0x00
A_24c2:	add	R24, R24
A_24c4:	adc	R25, R25
A_24c6:	lds	R30, layerdata	; 0x2da
A_24ca:	lds	R31, layerdata+1	; 0x2dc
A_24ce:	add	R30, R24
A_24d0:	adc	R31, R25
A_24d2:	st	Z, R19
A_24d4:	std	Z+1, R22
A_24d6:	subi	R18, 0xff
A_24d8:	sts	layer_cnt, R18	; 0x2e0
A_24dc:	ret	

;=========================================
; reset_fnset :
;=========================================
reset_fnset:
A_24de:	sts	fn_curset, __zero_reg__	; 0x2e8
A_24e2:	lds	R24, fn_keyset	; 0x2ea
A_24e6:	lds	R25, fn_keyset+1	; 0x2ec
A_24ea:	or	R24, R25
A_24ec:	breq	A_2504	; 0x2504
A_24ee:	ldi	R24, 0x00
A_24f0:	subi	R24, 0x01
A_24f2:	lds	R30, fn_keyset	; 0x2ea
A_24f6:	lds	R31, fn_keyset+1	; 0x2ec
A_24fa:	add	R30, R24
A_24fc:	adc	R31, __zero_reg__
A_24fe:	st	Z, __zero_reg__
A_2500:	and	R24, R24
A_2502:	brne	A_24f0	; 0x24f0
A_2504:	ret	

;=========================================
; read_remap : sets up a layer's remap table from EEPROM (?)
;=========================================
read_remap:
A_2506:	push	R10
A_2508:	push	R11
A_250a:	push	R12
A_250c:	push	R13
A_250e:	push	R14
A_2510:	push	R15
A_2512:	push	R16
A_2514:	push	R29
A_2516:	push	R28
A_2518:	rcall	A_251a	; reserve 2 bytes on stack
A_251a:	in	R28, SPL
A_251c:	in	R29, SPH
A_251e:	movw	R10, R24
A_2520:	mov	R14, R22
A_2522:	lds	R24, max_used_layer	; 0x2e6
A_2526:	cp	R24, R20
A_2528:	brcs	A_2586	; 0x2586
A_252a:	and	R20, R20
A_252c:	brne	A_2538	; 0x2538
A_252e:	ldi	R22, 0x9a	;R12/13 = hidx_trans
A_2530:	mov	R12, R22
A_2532:	ldi	R22, 0x01
A_2534:	mov	R13, R22
A_2536:	rjmp	A_2554	; 0x2554
A_2538:	ldi	R24, 0x01
A_253a:	ldi	R25, 0x00
A_253c:	sub	R24, R20
A_253e:	sbc	R25, __zero_reg__
A_2540:	add	R24, R24
A_2542:	adc	R25, R25
A_2544:	lds	R30, layer_map	; 0x2e2
A_2548:	lds	R31, layer_map+1	; 0x2e4
A_254c:	sub	R30, R24
A_254e:	sbc	R31, R25
A_2550:	ld	R12, Z
A_2552:	ldd	R13, Z+1
A_2554:	ldi	R16, 0x00
A_2556:	rjmp	A_2582	; 0x2582
A_2558:	movw	R24, R10
A_255a:	adiw	R24, 0x01
A_255c:	std	Y+2, R25
A_255e:	std	Y+1, R24
A_2560:	movw	R24, R10
A_2562:	call	eeprom_read_byte	; 0x37f4
A_2566:	mov	R15, R24
A_2568:	ldi	R30, 0x02
A_256a:	ldi	R31, 0x00
A_256c:	add	R10, R30
A_256e:	adc	R11, R31
A_2570:	ldd	R24, Y+1
A_2572:	ldd	R25, Y+2
A_2574:	call	eeprom_read_byte	; 0x37f4
A_2578:	movw	R30, R12
A_257a:	add	R30, R15
A_257c:	adc	R31, __zero_reg__
A_257e:	st	Z, R24
A_2580:	subi	R16, 0xff
A_2582:	cp	R16, R14
A_2584:	brcs	A_2558	; 0x2558
A_2586:	pop	R0
A_2588:	pop	R0
A_258a:	pop	R28
A_258c:	pop	R29
A_258e:	pop	R16
A_2590:	pop	R15
A_2592:	pop	R14
A_2594:	pop	R13
A_2596:	pop	R12
A_2598:	pop	R11
A_259a:	pop	R10
A_259c:	ret	

;=========================================
; alloc_layers :
;=========================================
alloc_layers:
A_259e:	push	R14
A_25a0:	push	R15
A_25a2:	push	R16
A_25a4:	push	R17
A_25a6:	push	R28
A_25a8:	push	R29
A_25aa:	mov	R14, R24
A_25ac:	mov	R15, R22
A_25ae:	and	R22, R22
A_25b0:	brne	A_25b4	; 0x25b4
A_25b2:	rjmp	A_2652	; 0x2652  return 1;
A_25b4:	ldi	R24, 0x00
A_25b6:	ldi	R25, 0x01
A_25b8:	rcall	memalloc	; 0x1670
A_25ba:	sts	fn_keyset+1, R25	; 0x2ec
A_25be:	sts	fn_keyset, R24	; 0x2ea
A_25c2:	rcall	reset_fnset	; 0x24de

A_25c4:	mov	R28, R15
A_25c6:	ldi	R29, 0x00
A_25c8:	mov	R16, R14
A_25ca:	ldi	R17, 0x00
A_25cc:	movw	R24, R28
A_25ce:	lsr	R25			;shift 0 into carry
A_25d0:	mov	R25, R24
A_25d2:	clr	R24
A_25d4:	ror	R25         ;R24/25 = R15 << 7
A_25d6:	ror	R24
A_25d8:	add	R24, R28    ;R24/25 += R15
A_25da:	adc	R25, R29
A_25dc:	add	R24, R16    ;R24/25 += R14
A_25de:	adc	R25, R17
A_25e0:	add	R24, R24	;R24/25 *= 2
A_25e2:	adc	R25, R25
A_25e4:	rcall	memalloc	; 0x1670
A_25e6:	movw	R18, R24
A_25e8:	sts	layerdata+1, R25	; 0x2dc
A_25ec:	sts	layerdata, R24	; 0x2da
A_25f0:	sbiw	R24, 0x00
A_25f2:	brne	A_25f8	; 0x25f8
A_25f4:	ldi	R24, 0x00
A_25f6:	rjmp	A_2654	; 0x2654  return 0;
A_25f8:	sts	allocated_layers, R14	; 0x2de
A_25fc:	sts	max_used_layer, R15	; 0x2e6
A_2600:	movw	R24, R16
A_2602:	add	R24, R24
A_2604:	adc	R25, R25
A_2606:	add	R24, R18
A_2608:	adc	R25, R19
A_260a:	sts	layer_map+1, R25	; 0x2e4
A_260e:	sts	layer_map, R24	; 0x2e2

A_2612:	movw	R18, R28	;R18/19 = max_used * 2
A_2614:	add	R18, R18
A_2616:	adc	R19, R19
A_2618:	add	R18, R24		; + layer_map
A_261a:	adc	R19, R25
A_261c:	ldi	R25, 0x00
A_261e:	ldi	R20, 0x00
A_2620:	ldi	R21, 0x00
A_2622:	rjmp	A_264e	; 0x264e

A_2624:	lds	R30, layer_map	; 0x2e2
A_2628:	lds	R31, layer_map+1	; 0x2e4
A_262c:	add	R30, R20
A_262e:	adc	R31, R21
A_2630:	std	Z+1, R19
A_2632:	st	Z, R18
A_2634:	ldi	R24, 0x00
A_2636:	subi	R24, 0x01
A_2638:	movw	R30, R18
A_263a:	add	R30, R24
A_263c:	adc	R31, __zero_reg__
A_263e:	st	Z, __zero_reg__
A_2640:	and	R24, R24
A_2642:	brne	A_2636	; 0x2636
A_2644:	subi	R18, 0x00
A_2646:	sbci	R19, 0xff
A_2648:	subi	R25, 0xff
A_264a:	subi	R20, 0xfe
A_264c:	sbci	R21, 0xff
A_264e:	cp	R25, R15
A_2650:	brcs	A_2624	; 0x2624

A_2652:	ldi	R24, 0x01
A_2654:	pop	R29
A_2656:	pop	R28
A_2658:	pop	R17
A_265a:	pop	R16
A_265c:	pop	R15
A_265e:	pop	R14
A_2660:	ret	

;=========================================
;=========================================
set_setup_done:
A_2662:
	ldi	R24, 0x01
	sts	setup_done, R24	; 0x2f8
	ret	

;=========================================
;=========================================
reset_setup_done:
A_266a:
	sts	setup_done, __zero_reg__	; 0x2f8
	ret	

;=========================================
; find_macro :
;=========================================
find_macro:
A_2670:
	mov	R21, R24
	lds	R20, macro_cnt	; 0x2f6
	lds	R30, macro_data	; 0x2f0
	lds	R31, macro_data+1	; 0x2f2
	ldi	R19, 0x00
	rjmp	A_26aa	; 0x26aa
A_2682:
	ld	R24, Z
	cp	R24, R21
	brne	A_26a6	; 0x26a6
A_2688:
	ldd	R24, Z+1
	ldd	R18, Z+2
	mov	R25, R18
	com	R25
	and	R25, R24
	and	R25, R22
	swap	R25
	andi	R25, 0x0f
	or	R22, R25
	eor	R24, R22
	and	R24, R18
	brne	A_26a6	; 0x26a6
A_26a0:
	ldd	R18, Z+3
	ldd	R19, Z+4
	rjmp	A_26b2	; 0x26b2
A_26a6:
	subi	R19, 0xff
	adiw	R30, 0x05
A_26aa:
	cp	R19, R20
	brcs	A_2682	; 0x2682
A_26ae:
	ldi	R18, 0x00
	ldi	R19, 0x00
A_26b2:
	movw	R24, R18
	ret	

;=========================================================
; reset_macro_data : Initializes some memory areas
;=========================================================
reset_macro_data:
A_26b6:
	sts	setup_done, __zero_reg__	; 0x2f8
	sts	allocated_macros, __zero_reg__	; 0x2f4
	sts	macro_cnt, __zero_reg__	; 0x2f6
	lds	R24, macro_data	; 0x2f0
	lds	R25, macro_data+1	; 0x2f2
	or	R24, R25
	breq	A_26d6	; 0x26d6
A_26ce:
	sts	macro_data+1, __zero_reg__	; 0x2f2
	sts	macro_data, __zero_reg__	; 0x2f0
A_26d6:
	ret	

;=========================================================
; jmp_reset_macro_data : Just a dispatcher
;=========================================================
jmp_reset_macro_data:
A_26d8:
	rjmp	reset_macro_data	; 0x26b6
	ret	

;=========================================================
; reset_modifset
;=========================================================
reset_modifset:
A_26dc:
	sts	modif_curset, __zero_reg__	; 0x2ee
	lds	R24, modif_keyset	; 0x534
	lds	R25, modif_keyset+1	; 0x536
	or	R24, R25
	breq	A_2702	; 0x2702
A_26ec:
	ldi	R24, 0x00
A_26ee:
	subi	R24, 0x01
	lds	R30, modif_keyset	; 0x534
	lds	R31, modif_keyset+1	; 0x536
	add	R30, R24
	adc	R31, __zero_reg__
	st	Z, __zero_reg__
	and	R24, R24
	brne	A_26ee	; 0x26ee
A_2702:
	ret	

;=========================================================
; setup_macros :
;=========================================================
setup_macros:
A_2704:
	push	R7
	push	R8
	push	R9
	push	R10
	push	R11
	push	R12
	push	R13
	push	R14
	push	R15
	push	R16
	push	R17
	push	R28
	push	R29
A_271e:
	mov	R8, R22
	lds	R9, allocated_macros	; 0x2f4
	lds	R28, macro_data	; 0x2f0
	lds	R29, macro_data+1	; 0x2f2
	clr	R10
	ldi	R18, 0x05
	mov	R7, R18
	rjmp	A_27ae	; 0x27ae
A_2734:
	lds	R11, macro_cnt	; 0x2f6
	cp	R11, R9
	breq	A_27b2	; 0x27b2
A_273c:
	mul	R11, R7
	movw	R14, R0
	clr	__zero_reg__
	add	R14, R28
	adc	R15, R29
A_2746:
	movw	R16, R24
	subi	R16, 0xff
	sbci	R17, 0xff
	call	eeprom_read_byte	; 0x37f4
	movw	R30, R14
	st	Z, R24
	movw	R12, R16
	sec	
	adc	R12, __zero_reg__
	adc	R13, __zero_reg__
A_275c:
	movw	R24, R16
	call	eeprom_read_byte	; 0x37f4
	movw	R30, R14
	std	Z+1, R24
A_2766:
	movw	R16, R12
	subi	R16, 0xff
	sbci	R17, 0xff
	movw	R24, R12
	call	eeprom_read_byte	; 0x37f4
	movw	R30, R14
	std	Z+2, R24
A_2776:
	std	Z+4, R17
	std	Z+3, R16
	movw	R14, R16
	sec	
	adc	R14, __zero_reg__
	adc	R15, __zero_reg__
	movw	R24, R16
	call	eeprom_read_byte	; 0x37f4
	mov	R17, R24
A_278a:
	movw	R24, R14
	call	eeprom_read_byte	; 0x37f4
	andi	R24, 0x3f
	andi	R17, 0x3f
	add	R24, R17
	add	R24, R24
	sec	
	adc	R14, __zero_reg__
	adc	R15, __zero_reg__
A_279e:
	movw	R18, R14
	add	R18, R24
	adc	R19, __zero_reg__
	movw	R24, R18
A_27a6:
	inc	R11
	sts	macro_cnt, R11	; 0x2f6
	inc	R10
A_27ae:
	cp	R10, R8
	brcs	A_2734	; 0x2734
A_27b2:
	pop	R29
	pop	R28
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	pop	R13
	pop	R12
	pop	R11
	pop	R10
	pop	R9
	pop	R8
	pop	R7
	ret	

;=========================================================
; alloc_macros :
;=========================================================
alloc_macros:
A_27ce:	push	R17
A_27d0:	mov	R17, R24
A_27d2:	and	R22, R22
A_27d4:	breq	A_27e8	; 0x27e8
A_27d6:	ldi	R24, 0x00
A_27d8:	ldi	R25, 0x01
A_27da:	call	memalloc	; 0x1670
A_27de:	sts	modif_keyset+1, R25	; 0x536
A_27e2:	sts	modif_keyset, R24	; 0x534
A_27e6:	rcall	reset_modifset	; 0x26dc
A_27e8:	ldi	R24, 0x05
A_27ea:	mul	R17, R24
A_27ec:	movw	R24, R0
A_27ee:	clr	__zero_reg__
A_27f0:	call	memalloc	; 0x1670
A_27f4:	sts	macro_data+1, R25	; 0x2f2
A_27f8:	sts	macro_data, R24	; 0x2f0
A_27fc:	sbiw	R24, 0x00
A_27fe:	brne	A_2804	; 0x2804
A_2800:	ldi	R24, 0x00
A_2802:	rjmp	A_280e	; 0x280e
A_2804:	sts	allocated_macros, R17	; 0x2f4
A_2808:	sts	macro_cnt, __zero_reg__	; 0x2f6
A_280c:	ldi	R24, 0x01
A_280e:	pop	R17
A_2810:	ret	

;=========================================================
; exec_macro :
;=========================================================
exec_macro:
A_2812:
	push	R11
	push	R12
	push	R13
	push	R14
	push	R15
	push	R16
	push	R17
	push	R28
	push	R29
	mov	R12, R22
	mov	R11, R20
A_2828:
	movw	R16, R24
	subi	R16, 0xff
	sbci	R17, 0xff
	rcall	eeprom_read_byte	; 0x37f4
	mov	R15, R24
	movw	R28, R16
	adiw	R28, 0x01
	movw	R24, R16
	rcall	eeprom_read_byte	; 0x37f4
	mov	R13, R24
	mov	R24, R15
	andi	R24, 0x3f
	and	R11, R11
	breq	A_2848	; 0x2848
A_2844:
	mov	R14, R24
	rjmp	A_287e	; 0x287e
A_2848:
	ldi	R20, 0x3f
	mov	R14, R20
	and	R14, R13
	ldi	R25, 0x00
	add	R24, R24
	adc	R25, R25
	add	R28, R24
	adc	R29, R25
	sbrs	R13, 7
	rjmp	A_287e	; 0x287e
A_285c:
	ldi	R24, 0x84
	mov	R22, R12
	rcall	queue_key	; 0x34dc
	rjmp	A_287e	; 0x287e
A_2864:
	movw	R16, R28
	subi	R16, 0xff
	sbci	R17, 0xff
	movw	R24, R28
	rcall	eeprom_read_byte	; 0x37f4
	mov	R15, R24
	adiw	R28, 0x02
	movw	R24, R16
	rcall	eeprom_read_byte	; 0x37f4
	mov	R22, R24
	mov	R24, R15
	rcall	queue_key	; 0x34dc
	dec	R14
A_287e:
	and	R14, R14
	brne	A_2864	; 0x2864
A_2882:
	and	R11, R11
	brne	A_2890	; 0x2890
A_2886:
	sbrs	R13, 7
	rjmp	A_2890	; 0x2890
A_288a:
	ldi	R24, 0x08
	ldi	R22, 0x00
	rcall	queue_key	; 0x34dc
A_2890:
	pop	R29
	pop	R28
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	pop	R13
	pop	R12
	pop	R11
	ret	

;===============================================
; find_exec_macro :
;===============================================
find_exec_macro:
A_28a4:	push	R15
A_28a6:	push	R16
A_28a8:	push	R17
A_28aa:	mov	R16, R24
A_28ac:	mov	R15, R22
A_28ae:	lds	R17, modif_curset	; 0x2ee
A_28b2:	lds	R30, modif_keyset	; 0x534
A_28b6:	lds	R31, modif_keyset+1	; 0x536
A_28ba:	sbiw	R30, 0x00
A_28bc:	breq	A_28d6	; 0x28d6
A_28be:	and	R22, R22
A_28c0:	breq	A_28c8	; 0x28c8
A_28c2:	add	R30, R24
A_28c4:	adc	R31, __zero_reg__
A_28c6:	st	Z, R17
A_28c8:	lds	R30, modif_keyset	; 0x534
A_28cc:	lds	R31, modif_keyset+1	; 0x536
A_28d0:	add	R30, R16
A_28d2:	adc	R31, __zero_reg__
A_28d4:	ld	R17, Z
A_28d6:	lds	R24, setup_done	; 0x2f8
A_28da:	and	R24, R24
A_28dc:	breq	A_28f2	; 0x28f2
A_28de:	mov	R24, R16
A_28e0:	mov	R22, R17
A_28e2:	rcall	find_macro	; 0x2670
A_28e4:	sbiw	R24, 0x00
A_28e6:	breq	A_28f2	; 0x28f2
A_28e8:	mov	R22, R17
A_28ea:	mov	R20, R15
A_28ec:	rcall	exec_macro	; 0x2812
A_28ee:	ldi	R21, 0x01
A_28f0:	rjmp	A_28f4	; 0x28f4
A_28f2:	ldi	R21, 0x00
A_28f4:	mov	R18, R16
A_28f6:	ldi	R19, 0x00
A_28f8:	movw	R24, R18
A_28fa:	andi	R24, 0xf8
A_28fc:	andi	R25, 0x00
A_28fe:	cpi	R24, 0xe0
A_2900:	cpc	R25, __zero_reg__
A_2902:	brne	A_2938	; 0x2938
A_2904:	lds	R20, modif_curset	; 0x2ee
A_2908:	andi	R18, 0x07
A_290a:	andi	R19, 0x00
A_290c:	and	R15, R15
A_290e:	breq	A_2922	; 0x2922
A_2910:	ldi	R24, 0x01
A_2912:	ldi	R25, 0x00
A_2914:	rjmp	A_291a	; 0x291a
A_2916:	add	R24, R24
A_2918:	adc	R25, R25
A_291a:	dec	R18
A_291c:	brpl	A_2916	; 0x2916
A_291e:	or	R20, R24
A_2920:	rjmp	A_2934	; 0x2934
A_2922:	ldi	R24, 0x01
A_2924:	ldi	R25, 0x00
A_2926:	rjmp	A_292c	; 0x292c
A_2928:	add	R24, R24
A_292a:	adc	R25, R25
A_292c:	dec	R18
A_292e:	brpl	A_2928	; 0x2928
A_2930:	com	R24
A_2932:	and	R20, R24
A_2934:	sts	modif_curset, R20	; 0x2ee
A_2938:	mov	R24, R21
A_293a:	pop	R17
A_293c:	pop	R16
A_293e:	pop	R15
A_2940:	ret	

;===============================================
; eeprom_write_ready :
;===============================================
eeprom_write_ready:
A_2942:	lds	R24, writing_eeprom_buffer	; 0x2fa
A_2946:	ldi	R25, 0x00
A_2948:	and	R24, R24
A_294a:	brne	A_294e	; 0x294e
A_294c:	ldi	R25, 0x01
A_294e:	mov	R24, R25
A_2950:	ret	

;===============================================
; write_eeprom_buffer :
;===============================================
write_eeprom_buffer:
A_2952:	movw	R18, R24
A_2954:	ldi	R21, 0x01
A_2956:	sts	eeprom_write_flag, R21	; 0x53e
A_295a:	lds	R24, writing_eeprom_buffer	; 0x2fa
A_295e:	and	R24, R24
A_2960:	breq	A_2966	; 0x2966
A_2962:	ser	R24
A_2964:	ret	
A_2966:	sbis	EECR, 1	; if (!(EECR & EEPE)) goto A_296e;
A_2968:	rjmp	A_296e	; 0x296e
A_296a:	ldi	R24, 0xfe
A_296c:	ret	
A_296e:	sts	eeprom_write_eeaddr+1, R23	; 0x53a
A_2972:	sts	eeprom_write_eeaddr, R22	; 0x538
A_2976:	sts	eeprom_write_buffer+1, R19	; 0x542
A_297a:	sts	eeprom_write_buffer, R18	; 0x540
A_297e:	sts	eeprom_write_cnt, R20	; 0x53c
A_2982:	sts	writing_eeprom_buffer, R21	; 0x2fa
A_2986:	sbi	EECR, 3		; EECR |= EERIE
A_2988:	ldi	R24, 0x00
A_298a:	ret	

;===============================================
; EE_READY_vect: EEPROM Ready Interrupt
;===============================================
EE_READY_vect:
A_298c:	push	__zero_reg__
	push	R0
	in	R0, SREG
	push	R0
	clr	__zero_reg__
	push	R18
	push	R19
	push	R20
	push	R21
	push	R22
	push	R23
	push	R24
	push	R25
	push	R26
	push	R27
	push	R30
	push	R31
A_29ae:
	lds	R24, eeprom_write_cnt	; 0x53c
	and	R24, R24
	breq	A_2a00	; 0x2a00
A_29b6:
	lds	R24, eeprom_write_flag	; 0x53e
	and	R24, R24
	breq	A_2a22	; 0x2a22
A_29be:
	lds	R24, eeprom_write_eeaddr	; 0x538
	lds	R25, eeprom_write_eeaddr+1	; 0x53a
	rcall	eeprom_read_byte	; 0x37f4
	rjmp	A_2a12	; 0x2a12
A_29ca:
	lds	R24, eeprom_write_cnt	; 0x53c
	subi	R24, 0x01
	sts	eeprom_write_cnt, R24	; 0x53c
	lds	R24, eeprom_write_buffer	; 0x540
	lds	R25, eeprom_write_buffer+1	; 0x542
	adiw	R24, 0x01
	sts	eeprom_write_buffer+1, R25	; 0x542
	sts	eeprom_write_buffer, R24	; 0x540
	lds	R24, eeprom_write_eeaddr	; 0x538
	lds	R25, eeprom_write_eeaddr+1	; 0x53a
	adiw	R24, 0x01
	sts	eeprom_write_eeaddr+1, R25	; 0x53a
	sts	eeprom_write_eeaddr, R24	; 0x538
	lds	R24, eeprom_write_cnt	; 0x53c
	and	R24, R24
	brne	A_2a08	; 0x2a08
A_2a00:
	cbi	EECR, 3		; EECR &= ~(1 << EERIE);
	sts	writing_eeprom_buffer, __zero_reg__	; 0x2fa
	rjmp	A_2a6c	; 0x2a6c
A_2a08:
	lds	R24, eeprom_write_eeaddr	; 0x538
	lds	R25, eeprom_write_eeaddr+1	; 0x53a
	rcall	eeprom_read_byte	; 0x37f4
A_2a12:	
	mov	R25, R24
	lds	R30, eeprom_write_buffer	; 0x540
	lds	R31, eeprom_write_buffer+1	; 0x542
	ld	R24, Z
	cp	R25, R24
	breq	A_29ca	; 0x29ca
A_2a22:
	lds	R24, eeprom_write_eeaddr	; 0x538
	lds	R25, eeprom_write_eeaddr+1	; 0x53a
	out	EEARH, R25
	out	EEARL, R24
	lds	R30, eeprom_write_buffer	; 0x540
	lds	R31, eeprom_write_buffer+1	; 0x542
	ld	R24, Z
	out	EEDR, R24
	sbi	EECR, 2		;EECR |= EEMPE
	sbi	EECR, 1		;EECR |= EEPE
	lds	R24, eeprom_write_cnt	; 0x53c
	subi	R24, 0x01
	sts	eeprom_write_cnt, R24	; 0x53c
	lds	R24, eeprom_write_buffer	; 0x540
	lds	R25, eeprom_write_buffer+1	; 0x542
	adiw	R24, 0x01
	sts	eeprom_write_buffer+1, R25	; 0x542
	sts	eeprom_write_buffer, R24	; 0x540
	lds	R24, eeprom_write_eeaddr	; 0x538
	lds	R25, eeprom_write_eeaddr+1	; 0x53a
	adiw	R24, 0x01
	sts	eeprom_write_eeaddr+1, R25	; 0x53a
	sts	eeprom_write_eeaddr, R24	; 0x538
A_2a6c:	
	pop	R31
	pop	R30
	pop	R27
	pop	R26
	pop	R25
	pop	R24
	pop	R23
	pop	R22
	pop	R21
	pop	R20
	pop	R19
	pop	R18
	pop	R0
	out	SREG, R0
	pop	R0
	pop	__zero_reg__
	reti	

;===============================================
; jmp_bootloader :
;===============================================
jmp_bootloader:
A_2a8e:	ldi	R30, 0x02
A_2a90:	ldi	R31, 0x00
A_2a92:	ldi	R24, 0x09
A_2a94:	sts	SPMCSR, R24	; 0xae  SPMCSR = (1 << BLBSET) | (1 << SPMEN);
A_2a98:	lpm	R24, Z
A_2a9a:	sbrc	R24, 3
A_2a9c:	rjmp	A_2b20	; 0x2b20
A_2a9e:	cli	
A_2aa0:	ldi	R24, 0x01
A_2aa2:	sts	UDCON, R24	; 0x1c0
A_2aa6:	ldi	R24, 0x20
A_2aa8:	sts	USBCON, R24	; 0x1b0
A_2aac:	sts	UCSR1B, __zero_reg__	; 0x192
A_2ab0:	ldi	R24, 0x20
A_2ab2:	ldi	R25, 0x4e
A_2ab4:	sbiw	R24, 0x01
A_2ab6:	brne	A_2ab4	; 0x2ab4
A_2ab8:	out	EIMSK, __zero_reg__
A_2aba:	sts	PCICR, __zero_reg__	; 0xd0
A_2abe:	out	SPCR, __zero_reg__
A_2ac0:	out	ACSR, __zero_reg__
A_2ac2:	out	EECR, __zero_reg__
A_2ac4:	sts	ADCSRA, __zero_reg__	; 0xf4
A_2ac8:	sts	TIMSK0, __zero_reg__	; 0xdc
A_2acc:	sts	TIMSK1, __zero_reg__	; 0xde
A_2ad0:	sts	TIMSK2, __zero_reg__	; 0xe0
A_2ad4:	sts	TIMSK3, __zero_reg__	; 0xe2
A_2ad8:	sts	UCSR1B, __zero_reg__	; 0x192
A_2adc:	sts	TWCR, __zero_reg__	; 0x178
A_2ae0:	out	DDRB, __zero_reg__
A_2ae2:	out	DDRC, __zero_reg__
A_2ae4:	out	DDRD, __zero_reg__
A_2ae6:	out	DDRE, __zero_reg__
A_2ae8:	out	DDRF, __zero_reg__
A_2aea:	out	PORTB, __zero_reg__
A_2aec:	out	PORTC, __zero_reg__
A_2aee:	out	PORTD, __zero_reg__
A_2af0:	out	PORTE, __zero_reg__
A_2af2:	out	PORTF, __zero_reg__
A_2af4:	ldi	R30, 0x03
A_2af6:	ldi	R31, 0x00
A_2af8:	ldi	R18, 0x09
A_2afa:	sts	SPMCSR, R18	; 0xae  SPMCSR = (1 << BLBSET) | (1 << SPMEN);
A_2afe:	lpm	R18, Z
A_2b00:	andi	R18, 0x06
A_2b02:	lsr	R18
A_2b04:	ldi	R24, 0x03
A_2b06:	eor	R18, R24

A_2b08:	ldi	R24, 0x00
A_2b0a:	ldi	R25, 0x02
A_2b0c:	rjmp	A_2b12	; 0x2b12
A_2b0e:	add	R24, R24
A_2b10:	adc	R25, R25
A_2b12:	dec	R18
A_2b14:	brpl	A_2b0e	; 0x2b0e

A_2b16:	ldi	R30, 0x00
A_2b18:	ldi	R31, 0x80
A_2b1a:	sub	R30, R24
A_2b1c:	sbc	R31, R25
A_2b1e:	icall	; ==> call Z
A_2b20:	ret	

;======================================================
; setup_proc_kbd :
;======================================================
setup_proc_kbd:
A_2b22:	sts	proc_keyboard_codeset, R24	; 0x304
A_2b26:	sts	proc_keyboard_id+1, R23	; 0x308
A_2b2a:	sts	proc_keyboard_id, R22	; 0x306
A_2b2e:	ret	

;======================================================
; process_select
;======================================================
process_select:
A_2b30:	mov	R18, R24
A_2b32:	subi	R18, 0xd8
A_2b34:	breq	A_2b50	; 0x2b50
A_2b36:	ldi	R24, 0x01
A_2b38:	ldi	R25, 0x00
A_2b3a:	rjmp	A_2b40	; 0x2b40
A_2b3c:	add	R24, R24
A_2b3e:	adc	R25, R25
A_2b40:	dec	R18
A_2b42:	brpl	A_2b3c	; 0x2b3c
A_2b44:	lds	R18, req_select_set	; 0x23e
A_2b48:	eor	R18, R24
A_2b4a:	sts	req_select_set, R18	; 0x23e
A_2b4e:	ret	
A_2b50:	ldi	R24, 0x01
A_2b52:	sts	req_select_set, R24	; 0x23e
A_2b56:	ret	

;===========================================
; check_eeprom_header : read EEPROM start and compare to expected constants
;===========================================
; checks for 'S' 'C' at the start of the EEPROM data
check_eeprom_header:
A_2b58:
	push	R17
	ldi	R24, 0x00
	ldi	R25, 0x00
	rcall	eeprom_read_byte	; 0x37f4
	mov	R17, R24
	ldi	R24, 0x01
	ldi	R25, 0x00
	rcall	eeprom_read_byte	; 0x37f4
	ldi	R18, 0x00
	ldi	R25, 0x43
	eor	R25, R24
	ldi	R24, 0x53
	eor	R24, R17
	or	R25, R24
	brne	A_2b78	; 0x2b78
	ldi	R18, 0x01
A_2b78:
	mov	R24, R18
	pop	R17
	ret	

;===========================================
; get_forced_keyboard_type : fetch forced keyboard type from EEPROM
;===========================================
get_forced_keyboard_type:
A_2b7e:
	rcall	check_eeprom_header	; 0x2b58
	and	R24, R24
	breq	A_2ba6	; 0x2ba6
	ldi	R24, 0x02
	ldi	R25, 0x00
	rcall	eeprom_read_word	; 0x3804
	movw	R18, R24
	
	sbiw	R24, 0x00
	breq	A_2ba6	; 0x2ba6
	
	subi	R18, 0xf7
	sbci	R19, 0x03
	brge	A_2ba6	; 0x2ba6
	
	ldi	R24, 0x04
	ldi	R25, 0x00
	rcall	eeprom_read_byte	; 0x37f4
	cpi	R24, 0x01
	brne	A_2ba6	; 0x2ba6
	ldi	R24, 0x06
	ldi	R25, 0x00
	rjmp	eeprom_read_byte	; 0x37f4
A_2ba6:
	ldi	R24, 0x00
	ret	

;===========================================
; count_macro_onbreaks :
;===========================================
count_macro_onbreaks:
A_2baa:
	push	R14
	push	R15
	push	R16
	push	R17
	push	R28
	push	R29
A_2bb6:
	mov	R14, R22
	mov	R17, R20
	ldi	R16, 0x00
	rjmp	A_2bfe	; 0x2bfe
A_2bbe:
	cpi	R17, 0x05
	brcs	A_2c06	; 0x2c06
A_2bc2:
	movw	R28, R24
	adiw	R28, 0x04
	adiw	R24, 0x03
	rcall	eeprom_read_byte	; 0x37f4
	mov	R15, R24
	movw	R24, R28
	rcall	eeprom_read_byte	; 0x37f4
	mov	R25, R24
	andi	R25, 0x3f
	breq	A_2be0	; 0x2be0
A_2bd6:
	lds	R24, macro_onbreaks	; 0x302
	subi	R24, 0xff
	sts	macro_onbreaks, R24	; 0x302
A_2be0:
	mov	R18, R15
	andi	R18, 0x3f
	add	R18, R25
	add	R18, R18
	mov	R20, R17
	subi	R20, 0x05
	cp	R20, R18
	brcs	A_2c06	; 0x2c06
A_2bf0:
	movw	R24, R28
	adiw	R24, 0x01
	add	R24, R18
	adc	R25, __zero_reg__
	mov	R17, R20
	sub	R17, R18
	subi	R16, 0xff
A_2bfe:
	cp	R16, R14
	brcs	A_2bbe	; 0x2bbe
A_2c02:
	ldi	R24, 0x01
	rjmp	A_2c08	; 0x2c08
A_2c06:
	ldi	R24, 0x00
A_2c08:
	pop	R29
	pop	R28
	pop	R17
	pop	R16
	pop	R15
	pop	R14
	ret	

;==========================================
; init_eeprom_header : write 'S' 'C' 0x00 0x00 at the start of the EEPROM
;==========================================
init_eeprom_header:
A_2c16:	ldi	R24, 0x03
A_2c18:	ldi	R25, 0x00
A_2c1a:	ldi	R22, 0x00
A_2c1c:	rcall	eeprom_write_byte	; 0x380e
A_2c1e:	ldi	R24, 0x02
A_2c20:	ldi	R25, 0x00
A_2c22:	ldi	R22, 0x00
A_2c24:	rcall	eeprom_write_byte	; 0x380e
A_2c26:	ldi	R24, 0x01
A_2c28:	ldi	R25, 0x00
A_2c2a:	ldi	R22, 0x43
A_2c2c:	rcall	eeprom_write_byte	; 0x380e
A_2c2e:	ldi	R24, 0x00
A_2c30:	ldi	R25, 0x00
A_2c32:	ldi	R22, 0x53
A_2c34:	rjmp	eeprom_write_byte	; 0x380e

;==========================================
; setup_eeprom_header : initialize EEPROM if necessary
;==========================================
setup_eeprom_header:
A_2c36:	rcall	check_eeprom_header	; 0x2b58
A_2c38:	and	R24, R24
A_2c3a:	brne	A_2c3e	; 0x2c3e
A_2c3c:	rjmp	init_eeprom_header	; 0x2c16
A_2c3e:	ret	

;==========================================
;
;==========================================
load_from_ee:
A_2c40:	push	R10
A_2c42:	push	R11
A_2c44:	push	R13
A_2c46:	push	R14
A_2c48:	push	R15
A_2c4a:	push	R16
A_2c4c:	push	R17
A_2c4e:	push	R28
A_2c50:	push	R29
A_2c52:	mov	R14, R22
A_2c54:	mov	R13, R20
A_2c56:	movw	R28, R24
A_2c58:	adiw	R28, 0x01
A_2c5a:	movw	R24, R28
A_2c5c:	rcall	eeprom_read_byte	; 0x37f4
A_2c5e:	mov	R16, R24
A_2c60:	mov	R17, R24
A_2c62:	andi	R17, 0x07
A_2c64:	and	R13, R13
A_2c66:	brne	A_2c88	; 0x2c88

A_2c68:	cpi	R17, 0x01
A_2c6a:	breq	A_2c7c	; 0x2c7c
A_2c6c:	cpi	R17, 0x01
A_2c6e:	brcs	A_2c76	; 0x2c76
A_2c70:	cpi	R17, 0x02
A_2c72:	brne	A_2c88	; 0x2c88
A_2c74:	rjmp	A_2c82	; 0x2c82
A_2c76:
	ldi	R24, 0x05	;print_P(PSTR("layers "));  // A_0605
	ldi	R25, 0x06
	rjmp	A_2c86	; 0x2c86
A_2c7c:
	ldi	R24, 0xfd	;print_P(PSTR("remaps "));  // A_05fd
	ldi	R25, 0x05
	rjmp	A_2c86	; 0x2c86
A_2c82:
	ldi	R24, 0xf5	;print_P(PSTR("macros "));  // A_05f5
	ldi	R25, 0x05
A_2c86:
	rcall	print_P	; 0x2344
	
A_2c88:	mov	R20, R16
A_2c8a:	ldi	R21, 0x00
A_2c8c:	lds	R18, req_select_set	; 0x23e
A_2c90:	ldi	R19, 0x00
A_2c92:	movw	R24, R20
A_2c94:	andi	R24, 0x38
A_2c96:	andi	R25, 0x00
A_2c98:	ldi	R30, 0x03
A_2c9a:	asr	R25
A_2c9c:	ror	R24
A_2c9e:	dec	R30
A_2ca0:	brne	A_2c9a	; 0x2c9a
A_2ca2:	rjmp	A_2ca8	; 0x2ca8
A_2ca4:	asr	R19
A_2ca6:	ror	R18
A_2ca8:	dec	R24
A_2caa:	brpl	A_2ca4	; 0x2ca4
A_2cac:	sbrc	R18, 0
A_2cae:	rjmp	A_2cbc	; 0x2cbc
A_2cb0:	and	R13, R13
A_2cb2:	breq	A_2cb6	; 0x2cb6
A_2cb4:	rjmp	A_2e12	; 0x2e12  return 1;
A_2cb6:
	ldi	R24, 0xec	;print_P(PSTR("!select ")); return 1;  // A_05ec
	ldi	R25, 0x05
	rjmp	A_2d1a_call_print_P_return_1	; 0x2d1a
A_2cbc:	adiw	R28, 0x01
A_2cbe:	ldi	R23, 0xfe
A_2cc0:	mov	R15, R23
A_2cc2:	add	R15, R14
A_2cc4:	sbrs	R16, 6
A_2cc6:	rjmp	A_2cfa	; 0x2cfa

A_2cc8:	movw	R24, R28
A_2cca:	rcall	eeprom_read_byte	; 0x37f4
A_2ccc:	ldi	R25, 0x00
A_2cce:	lds	R18, proc_keyboard_codeset	; 0x304
A_2cd2:	ldi	R19, 0x00
A_2cd4:	subi	R18, 0x01
A_2cd6:	sbci	R19, 0x00
A_2cd8:	rjmp	A_2cde	; 0x2cde
A_2cda:	asr	R25
A_2cdc:	ror	R24
A_2cde:	dec	R18
A_2ce0:	brpl	A_2cda	; 0x2cda
A_2ce2:	sbrc	R24, 0
A_2ce4:	rjmp	A_2cf2	; 0x2cf2
A_2ce6:	and	R13, R13
A_2ce8:	breq	A_2cec	; 0x2cec
A_2cea:	rjmp	A_2e12	; 0x2e12  return 1;
A_2cec:
	ldi	R24, 0xe6		;print_P(PSTR("!set "));  // A_05e6
	ldi	R25, 0x05
	rjmp	A_2d1a_call_print_P_return_1	; 0x2d1a
A_2cf2:	adiw	R28, 0x01
A_2cf4:	ldi	R22, 0xfd
A_2cf6:	mov	R15, R22
A_2cf8:	add	R15, R14
A_2cfa:	sbrs	R16, 7
A_2cfc:	rjmp	A_2d24	; 0x2d24
A_2cfe:	movw	R24, R28
A_2d00:	rcall	eeprom_read_word	; 0x3804
A_2d02:	lds	R18, proc_keyboard_id	; 0x306
A_2d06:	lds	R19, proc_keyboard_id+1	; 0x308
A_2d0a:	cp	R24, R18
A_2d0c:	cpc	R25, R19
A_2d0e:	breq	A_2d1e	; 0x2d1e
A_2d10:	and	R13, R13
A_2d12:	breq	A_2d16	; 0x2d16
A_2d14:	rjmp	A_2e12	; 0x2e12  return 1;
A_2d16:
	ldi	R24, 0xe1		;print_P(PSTR("!id "));  // A_05e1
	ldi	R25, 0x05
A_2d1a_call_print_P_return_1:
A_2d1a:
	rcall	print_P	; 0x2344
A_2d1c:	rjmp	A_2e12	; 0x2e12  return 1;
A_2d1e:	adiw	R28, 0x02
A_2d20:	ldi	R18, 0xfe
A_2d22:	add	R15, R18
A_2d24:	cpi	R17, 0x01
A_2d26:	brne	A_2d2a	; 0x2d2a
A_2d28:	rjmp	A_2da0	; 0x2da0
A_2d2a:	cpi	R17, 0x01
A_2d2c:	brcs	A_2d36	; 0x2d36
A_2d2e:	cpi	R17, 0x02
A_2d30:	breq	A_2d34	; 0x2d34
A_2d32:	rjmp	A_2e04	; 0x2e04  return 0;
A_2d34:	rjmp	A_2dda	; 0x2dda
A_2d36:	movw	R24, R28
A_2d38:	rcall	eeprom_read_byte	; 0x37f4
A_2d3a:	mov	R20, R24
A_2d3c:	mov	R10, R24
A_2d3e:	clr	R11
A_2d40:	movw	R18, R10
A_2d42:	add	R18, R18
A_2d44:	adc	R19, R19
A_2d46:	dec	R15
A_2d48:	mov	R24, R15
A_2d4a:	ldi	R25, 0x00
A_2d4c:	cp	R18, R24
A_2d4e:	cpc	R19, R25
A_2d50:	breq	A_2d58	; 0x2d58
A_2d52:	ldi	R24, 0xda	;print_P(PSTR("error ")); return 0; // A_05da
A_2d54:	ldi	R25, 0x05
A_2d56:	rjmp	A_2e02_call_print_P_return_0	; 0x2e02
A_2d58:	and	R13, R13
A_2d5a:	brne	A_2d66	; 0x2d66
A_2d5c:	lds	R24, layerdefs	; 0x2fc
A_2d60:	add	R24, R20
A_2d62:	sts	layerdefs, R24	; 0x2fc
A_2d66:	adiw	R28, 0x01
A_2d68:	ldi	R16, 0x00
A_2d6a:	ldi	R17, 0x00
A_2d6c:	rjmp	A_2d98	; 0x2d98
A_2d6e:	movw	R24, R28
A_2d70:	rcall	eeprom_read_byte	; 0x37f4
A_2d72:	mov	R15, R24
A_2d74:	movw	R24, R28
A_2d76:	adiw	R24, 0x01
A_2d78:	rcall	eeprom_read_byte	; 0x37f4
A_2d7a:	mov	R22, R24
A_2d7c:	and	R13, R13
A_2d7e:	breq	A_2d86	; 0x2d86
A_2d80:	mov	R24, R15
A_2d82:	rcall	setup_layer	; 0x24b0
A_2d84:	rjmp	A_2d92	; 0x2d92
A_2d86:	lds	R24, max_layer	; 0x2fe
A_2d8a:	cp	R24, R22
A_2d8c:	brcc	A_2d92	; 0x2d92
A_2d8e:	sts	max_layer, R22	; 0x2fe
A_2d92:	adiw	R28, 0x02
A_2d94:	subi	R16, 0xff
A_2d96:	sbci	R17, 0xff
A_2d98:	cp	R16, R10
A_2d9a:	cpc	R17, R11
A_2d9c:	brlt	A_2d6e	; 0x2d6e
A_2d9e:	rjmp	A_2e12	; 0x2e12  return 1;

A_2da0:	movw	R16, R28
A_2da2:	subi	R16, 0xff
A_2da4:	sbci	R17, 0xff
A_2da6:	movw	R24, R28
A_2da8:	rcall	eeprom_read_byte	; 0x37f4
A_2daa:	mov	R14, R24
A_2dac:	movw	R24, R16
A_2dae:	rcall	eeprom_read_byte	; 0x37f4
A_2db0:	mov	R22, R24
A_2db2:	ldi	R25, 0x00
A_2db4:	add	R24, R24
A_2db6:	adc	R25, R25
A_2db8:	ldi	R18, 0xfe
A_2dba:	add	R15, R18
A_2dbc:	mov	R18, R15
A_2dbe:	ldi	R19, 0x00
A_2dc0:	cp	R24, R18
A_2dc2:	cpc	R25, R19
A_2dc4:	breq	A_2dcc	; 0x2dcc
A_2dc6:	ldi	R24, 0xd3	;print_P(PSTR("error ")); // A_05d3
A_2dc8:	ldi	R25, 0x05
A_2dca:	rjmp	A_2e02_call_print_P_return_0	; 0x2e02
A_2dcc:	and	R13, R13
A_2dce:	breq	A_2e12	; 0x2e12  return 1;
A_2dd0:	movw	R24, R16
A_2dd2:	adiw	R24, 0x01
A_2dd4:	mov	R20, R14
A_2dd6:	rcall	read_remap	; 0x2506
A_2dd8:	rjmp	A_2e12	; 0x2e12  return 1;
A_2dda:	movw	R16, R28
A_2ddc:	subi	R16, 0xff
A_2dde:	sbci	R17, 0xff
A_2de0:	movw	R24, R28
A_2de2:	rcall	eeprom_read_byte	; 0x37f4
A_2de4:	mov	R14, R24
A_2de6:	and	R13, R13
A_2de8:	breq	A_2df2	; 0x2df2
A_2dea:	movw	R24, R16
A_2dec:	mov	R22, R14
A_2dee:	rcall	setup_macros	; 0x2704
A_2df0:	rjmp	A_2e12	; 0x2e12  return 1;
A_2df2:	movw	R24, R16
A_2df4:	mov	R22, R14
A_2df6:	mov	R20, R15
A_2df8:	rcall	count_macro_onbreaks	; 0x2baa
A_2dfa:	and	R24, R24
A_2dfc:	brne	A_2e08	; 0x2e08
	ldi	R24, 0xcc		;print_P(PSTR("error "));  // A_05cc
	ldi	R25, 0x05
A_2e02_call_print_P_return_0:
A_2e02:
	rcall	print_P	; 0x2344
A_2e04:	ldi	R24, 0x00
A_2e06:	rjmp	A_2e14	; 0x2e14
A_2e08:	lds	R24, total_macros	; 0x300
A_2e0c:	add	R24, R14
A_2e0e:	sts	total_macros, R24	; 0x300
A_2e12:	ldi	R24, 0x01
A_2e14:	pop	R29
A_2e16:	pop	R28
A_2e18:	pop	R17
A_2e1a:	pop	R16
A_2e1c:	pop	R15
A_2e1e:	pop	R14
A_2e20:	pop	R13
A_2e22:	pop	R11
A_2e24:	pop	R10
A_2e26:	ret	

;=========================================================
; setup_processing :
;=========================================================
setup_processing:
A_2e28:	push	R14
A_2e2a:	push	R15
A_2e2c:	push	R16
A_2e2e:	push	R17
A_2e30:	push	R28
A_2e32:	push	R29
A_2e34:	rcall	jmp_reset_macro_data	; 0x26d8
A_2e36:	rcall	reset_layer_trans	; 0x249a
A_2e38:	call	memreset	; 0x16b2
A_2e3c:	sts	layerdefs, __zero_reg__	; 0x2fc
A_2e40:	sts	max_layer, __zero_reg__	; 0x2fe
A_2e44:	sts	total_macros, __zero_reg__	; 0x300
A_2e48:	sts	macro_onbreaks, __zero_reg__	; 0x302
A_2e4c:	rcall	check_eeprom_header	; 0x2b58
A_2e4e:	and	R24, R24
A_2e50:	brne	A_2e54	; 0x2e54
A_2e52:	rjmp	A_2f88	; 0x2f88  return 0;
A_2e54:	ldi	R24, 0x02
A_2e56:	ldi	R25, 0x00
A_2e58:	rcall	eeprom_read_word	; 0x3804
A_2e5a:	movw	R16, R24

A_2e5c:	ldi	R31, 0xfc
A_2e5e:	mov	R14, R31
A_2e60:	ser	R31
A_2e62:	mov	R15, R31
A_2e64:	add	R14, R24
A_2e66:	adc	R15, R25
	ldi	R24, 0xbe	;print_P(PSTR("\n\nremaining: "));  // A_05be
	ldi	R25, 0x05
	rcall	print_P	; 0x2344
A_2e6e:	movw	R24, R14
A_2e70:	rcall	phex16	; 0x2334
A_2e72:	ldi	R24, 0x0a	;usb_debug_putchar('\n');
A_2e74:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2e76:	subi	R16, 0x05
A_2e78:	sbci	R17, 0x00
A_2e7a:	subi	R16, 0xf6
A_2e7c:	sbci	R17, 0x03
A_2e7e:	brcs	A_2e82	; 0x2e82
A_2e80:	rjmp	A_2f88	; 0x2f88  return 0;
A_2e82:	ldi	R24, 0x04
A_2e84:	ldi	R25, 0x00
A_2e86:	rcall	eeprom_read_byte	; 0x37f4
A_2e88:	cpi	R24, 0x01
A_2e8a:	breq	A_2e8e	; 0x2e8e
A_2e8c:	rjmp	A_2f88	; 0x2f88  return 0;
A_2e8e:	ldi	R24, 0x05
A_2e90:	ldi	R25, 0x00
A_2e92:	rcall	eeprom_read_byte	; 0x37f4
A_2e94:	cpi	R24, 0x02
A_2e96:	brcs	A_2e9a	; 0x2e9a
A_2e98:	rjmp	A_2f88	; 0x2f88  return 0;
A_2e9a:	ldi	R28, 0x08
A_2e9c:	ldi	R29, 0x00
A_2e9e:	rjmp	A_2ee0	; 0x2ee0
A_2ea0:	movw	R24, R28
A_2ea2:	rcall	eeprom_read_byte	; 0x37f4
A_2ea4:	mov	R17, R24
A_2ea6:	rcall	phex	; 0x2320
A_2ea8:	ldi	R24, 0x40	;usb_debug_putchar('@');
A_2eaa:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2eac:	movw	R24, R28
A_2eae:	rcall	phex16	; 0x2334
A_2eb0:	ldi	R24, 0x20	;usb_debug_putchar(' ');
A_2eb2:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2eb4:	cpi	R17, 0x05
A_2eb6:	brcc	A_2ebe	; 0x2ebe
A_2eb8:	ldi	R24, 0xb7	; print_P(PSTR("len<5\n")); return 0;
A_2eba:	ldi	R25, 0x05
A_2ebc:	rjmp	A_2f42	; 0x2f42
A_2ebe:	movw	R24, R28
A_2ec0:	mov	R22, R17
A_2ec2:	ldi	R20, 0x00
A_2ec4:	rcall	load_from_ee	; 0x2c40
A_2ec6:	and	R24, R24
A_2ec8:	brne	A_2ed0	; 0x2ed0
A_2eca:	ldi	R24, 0xaf	; print_P(PSTR("!apply\n")); return 0;
A_2ecc:	ldi	R25, 0x05
A_2ece:	rjmp	A_2f42	; 0x2f42
A_2ed0:	ldi	R24, 0x0a	;usb_debug_putchar('\n');
A_2ed2:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2ed4:	mov	R24, R17
A_2ed6:	ldi	R25, 0x00
A_2ed8:	add	R28, R24
A_2eda:	adc	R29, R25
A_2edc:	sub	R14, R24
A_2ede:	sbc	R15, R25
A_2ee0:	cp	__zero_reg__, R14
A_2ee2:	cpc	__zero_reg__, R15
A_2ee4:	brlt	A_2ea0	; 0x2ea0
A_2ee6:	ldi	R24, 0xa3	; print_P(PSTR("layerdefs: ")); // A_05a3
A_2ee8:	ldi	R25, 0x05
A_2eea:	rcall	print_P	; 0x2344
A_2eec:	lds	R24, layerdefs	; 0x2fc
A_2ef0:	rcall	phex	; 0x2320
A_2ef2:	ldi	R24, 0x0a	;usb_debug_putchar('\n');
A_2ef4:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2ef6:	ldi	R24, 0x97	; print_P(PSTR("max_layer: "));  // A_0597
A_2ef8:	ldi	R25, 0x05
A_2efa:	rcall	print_P	; 0x2344
A_2efc:	lds	R24, max_layer	; 0x2fe
A_2f00:	rcall	phex	; 0x2320
A_2f02:	ldi	R24, 0x0a	;usb_debug_putchar('\n');
A_2f04:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2f06:	ldi	R24, 0x88	; print_P(PSTR("total_macros: "));  // A_0588
A_2f08:	ldi	R25, 0x05
A_2f0a:	rcall	print_P	; 0x2344
A_2f0c:	lds	R24, total_macros	; 0x300
A_2f10:	rcall	phex	; 0x2320
A_2f12:	ldi	R24, 0x0a	;usb_debug_putchar('\n');
A_2f14:	rcall	rjmp_usb_debug_putchar	; 0x230c
A_2f16:	lds	R24, layerdefs	; 0x2fc
A_2f1a:	lds	R22, max_layer	; 0x2fe
A_2f1e:	rcall	alloc_layers	; 0x259e
A_2f20:	and	R24, R24
A_2f22:	brne	A_2f2a	; 0x2f2a
A_2f24:	ldi	R24, 0x79
A_2f26:	ldi	R25, 0x05
A_2f28:	rjmp	A_2f42	; 0x2f42  ;print_P(PSTR("alloc failed.\n")); return 0;
A_2f2a:	lds	R24, total_macros	; 0x300
A_2f2e:	lds	R22, macro_onbreaks	; 0x302
A_2f32:	rcall	alloc_macros	; 0x27ce
A_2f34:	and	R24, R24
A_2f36:	brne	A_2f46	; 0x2f46
A_2f38:	rcall	reset_layers	; 0x2474
A_2f3a:	call	memreset	; 0x16b2
A_2f3e:	ldi	R24, 0x6a	;print_P(PSTR("alloc failed.\n"));  // A_056a
A_2f40:	ldi	R25, 0x05
A_2f42:	rcall	print_P	; 0x2344
A_2f44:	rjmp	A_2f88	; 0x2f88  return 0;
A_2f46:	ldi	R24, 0x5f	;print_P(PSTR("alloc ok.\n"));  // A_055f
A_2f48:	ldi	R25, 0x05
A_2f4a:	rcall	print_P	; 0x2344
A_2f4c:	ldi	R24, 0x02
A_2f4e:	ldi	R25, 0x00
A_2f50:	rcall	eeprom_read_word	; 0x3804
A_2f52:	movw	R16, R24
A_2f54:	subi	R16, 0x04
A_2f56:	sbci	R17, 0x00
A_2f58:	ldi	R28, 0x08
A_2f5a:	ldi	R29, 0x00
A_2f5c:	rjmp	A_2f7c	; 0x2f7c
A_2f5e:	movw	R24, R28
A_2f60:	rcall	eeprom_read_byte	; 0x37f4
A_2f62:	mov	R15, R24
A_2f64:	movw	R24, R28
A_2f66:	mov	R22, R15
A_2f68:	ldi	R20, 0x01
A_2f6a:	rcall	load_from_ee	; 0x2c40
A_2f6c:	and	R24, R24
A_2f6e:	breq	A_2f88	; 0x2f88  return 0;
A_2f70:	mov	R24, R15
A_2f72:	ldi	R25, 0x00
A_2f74:	add	R28, R24
A_2f76:	adc	R29, R25
A_2f78:	sub	R16, R24
A_2f7a:	sbc	R17, R25
A_2f7c:	cp	__zero_reg__, R16
A_2f7e:	cpc	__zero_reg__, R17
A_2f80:	brlt	A_2f5e	; 0x2f5e
A_2f82:	rcall	set_setup_done	; 0x2662
A_2f84:	ldi	R24, 0x01
A_2f86:	rjmp	A_2f8a	; 0x2f8a
A_2f88:	ldi	R24, 0x00
A_2f8a:	pop	R29
A_2f8c:	pop	R28
A_2f8e:	pop	R17
A_2f90:	pop	R16
A_2f92:	pop	R15
A_2f94:	pop	R14
A_2f96:	ret	

;===============================================
; rawhid_comm : rawhid communication handler
;===============================================
rawhid_comm:
A_2f98:	push	R12
A_2f9a:	push	R13
A_2f9c:	push	R14
A_2f9e:	push	R15
A_2fa0:	push	R16
A_2fa2:	push	R17
A_2fa4:	push	R28
A_2fa6:	push	R29
A_2fa8:	lds	R12, rawhid_commstate	; 0x312
A_2fac:	ldi	R18, 0x03
A_2fae:	cp	R12, R18
A_2fb0:	brne	A_2fb4	; 0x2fb4
A_2fb2:	rjmp	A_31da	; 0x31da
A_2fb4:	cp	R18, R12
A_2fb6:	brcs	A_2fc8	; 0x2fc8
A_2fb8:	ldi	R24, 0x01
A_2fba:	cp	R12, R24
A_2fbc:	brne	A_2fc0	; 0x2fc0
A_2fbe:	rjmp	A_3174	; 0x3174
A_2fc0:	cp	R24, R12
A_2fc2:	brcc	A_2fc6	; 0x2fc6
A_2fc4:	rjmp	A_3180	; 0x3180
A_2fc6:	rjmp	A_2fe0	; 0x2fe0
A_2fc8:	ldi	R30, 0x05
A_2fca:	cp	R12, R30
A_2fcc:	brne	A_2fd0	; 0x2fd0
A_2fce:	rjmp	A_3272	; 0x3272
A_2fd0:	cp	R12, R30
A_2fd2:	brcc	A_2fd6	; 0x2fd6
A_2fd4:	rjmp	A_3256	; 0x3256
A_2fd6:	ldi	R31, 0x06
A_2fd8:	cp	R12, R31
A_2fda:	breq	A_2fde	; 0x2fde
A_2fdc:	rjmp	A_3336	; 0x3336
A_2fde:	rjmp	A_32f2	; 0x32f2
A_2fe0:	ldi	R24, 0xa3
A_2fe2:	ldi	R25, 0x02
A_2fe4:	ldi	R22, 0x00
A_2fe6:	rcall	usb_rawhid_recv	; 0x2254
A_2fe8:	cp	__zero_reg__, R24
A_2fea:	brlt	A_2fee	; 0x2fee
A_2fec:	rjmp	A_315a	; 0x315a
A_2fee:	lds	R17, rhcomm_sendcmd	; 0x546
A_2ff2:	cpi	R17, 0x02
A_2ff4:	brne	A_2ff8	; 0x2ff8
A_2ff6:	rjmp	A_306e	; 0x306e
A_2ff8:	cpi	R17, 0x03
A_2ffa:	brcc	A_3004	; 0x3004
A_2ffc:	cpi	R17, 0x01
A_2ffe:	breq	A_3002	; 0x3002
A_3000:	rjmp	A_315a	; 0x315a
A_3002:	rjmp	A_3012	; 0x3012
A_3004:	cpi	R17, 0x03
A_3006:	brne	A_300a	; 0x300a
A_3008:	rjmp	A_30d0	; 0x30d0
A_300a:	cpi	R17, 0x04
A_300c:	breq	A_3010	; 0x3010
A_300e:	rjmp	A_315a	; 0x315a
A_3010:	rjmp	A_3124	; 0x3124
A_3012:	ldi	R30, 0x0d	;info_templ
A_3014:	ldi	R31, 0x06
A_3016:	ldi	R26, 0xa3	;rhcomm_rcvbuf
A_3018:	ldi	R27, 0x02
A_301a:	lpm	R24, Z
A_301c:	st	X+, R24
A_301e:	adiw	R30, 0x01
A_3020:	ldi	R18, 0x06
A_3022:	cpi	R30, 0x26
A_3024:	cpc	R31, R18
A_3026:	brne	A_301a	; 0x301a
A_3028:	ldi	R24, 0x02
A_302a:	ldi	R25, 0x00
A_302c:	rcall	eeprom_read_word	; 0x3804
A_302e:	movw	R28, R24
A_3030:	sbiw	R24, 0x00
A_3032:	breq	A_304a	; 0x304a
A_3034:	ldi	R24, 0x04
A_3036:	ldi	R25, 0x00
A_3038:	rcall	eeprom_read_byte	; 0x37f4
A_303a:	mov	R17, R24
A_303c:	ldi	R24, 0x05
A_303e:	ldi	R25, 0x00
A_3040:	rcall	eeprom_read_byte	; 0x37f4
A_3042:	sts	0x02ad, R17	; 0x55a
A_3046:	sts	0x02ae, R24	; 0x55c
A_304a:	clr	R24
A_304c:	clr	R25
A_304e:	sub	R24, R28
A_3050:	sbc	R25, R29
A_3052:	subi	R24, 0x04
A_3054:	sbci	R25, 0xfc
A_3056:	sts	0x02b9, R24	; 0x572
A_305a:	sts	0x02ba, R25	; 0x574
A_305e:	call	memfree	; 0x164a
A_3062:	sts	0x02b3, R24	; 0x566
A_3066:	sts	0x02b4, R25	; 0x568
A_306a:	ldi	R24, 0x02
A_306c:	rjmp	A_30c2	; 0x30c2
A_306e:	lds	R19, rhcomm_rcvbuf+2
A_3072:	ldi	R18, 0x00
A_3074:	lds	R24, rhcomm_rcvbuf+1
A_3078:	ldi	R25, 0x00
A_307a:	or	R24, R18
A_307c:	or	R25, R19
A_307e:	sts	xfer_len+1, R25	; 0x316
A_3082:	sts	xfer_len, R24	; 0x314
A_3086:	subi	R24, 0xf7
A_3088:	sbci	R25, 0x03
A_308a:	brcc	A_30c0	; 0x30c0
A_308c:	ldi	R24, 0x04
A_308e:	ldi	R25, 0x00
A_3090:	sts	xfer_eeaddr+1, R25	; 0x31a
A_3094:	sts	xfer_eeaddr, R24	; 0x318
A_3098:	sts	weep_word+1, __zero_reg__	; 0x31e
A_309c:	sts	weep_word, __zero_reg__	; 0x31c
A_30a0:	ldi	R24, 0x8e
A_30a2:	ldi	R25, 0x01
A_30a4:	ldi	R22, 0x02
A_30a6:	ldi	R23, 0x00
A_30a8:	ldi	R20, 0x02
A_30aa:	rcall	write_eeprom_buffer	; 0x2952
A_30ac:	and	R24, R24
A_30ae:	brne	A_30c0	; 0x30c0
A_30b0:	sts	rhcomm_sendcmd, R17	; 0x544
A_30b4:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_30b6:	ldi	R25, 0x02
A_30b8:	ldi	R22, 0x00
A_30ba:	rcall	usb_rawhid_send	; 0x22b0
A_30bc:	rcall	reset_setup_done	; 0x266a
A_30be:	rjmp	A_317c	; 0x317c
A_30c0:	ldi	R24, 0x01
A_30c2:	sts	rhcomm_sendcmd, R24	; 0x544
A_30c6:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_30c8:	ldi	R25, 0x02
A_30ca:	ldi	R22, 0x00
A_30cc:	rcall	usb_rawhid_send	; 0x22b0
A_30ce:	rjmp	A_315a	; 0x315a
A_30d0:	ldi	R24, 0x02
A_30d2:	ldi	R25, 0x00
A_30d4:	sts	xfer_eeaddr+1, R25	; 0x31a
A_30d8:	sts	xfer_eeaddr, R24	; 0x318
A_30dc:	ldi	R24, 0x8a	;xfer_len
A_30de:	ldi	R25, 0x01
A_30e0:	ldi	R22, 0x02
A_30e2:	ldi	R23, 0x00
A_30e4:	ldi	R20, 0x02
A_30e6:	ldi	R21, 0x00
A_30e8:	rcall	eeprom_read_block	; 0x37d4
A_30ea:	lds	R18, xfer_len	; 0x314
A_30ee:	lds	R19, xfer_len+1	; 0x316
A_30f2:	ldi	R31, 0x03
A_30f4:	cpi	R18, 0xf7
A_30f6:	cpc	R19, R31
A_30f8:	brcc	A_30c0	; 0x30c0
A_30fa:	lds	R24, xfer_eeaddr	; 0x318
A_30fe:	lds	R25, xfer_eeaddr+1	; 0x31a
A_3102:	adiw	R24, 0x02
A_3104:	sts	xfer_eeaddr+1, R25	; 0x31a
A_3108:	sts	xfer_eeaddr, R24	; 0x318
A_310c:	sts	rhcomm_sendcmd, R18	; 0x546
A_3110:	sts	rhcomm_rcvbuf+1, R19	; 0x548
A_3114:	ldi	R24, 0x02
A_3116:	sts	rhcomm_sendcmd, R24	; 0x544
A_311a:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_311c:	ldi	R25, 0x02
A_311e:	ldi	R22, 0x00
A_3120:	rcall	usb_rawhid_send	; 0x22b0
A_3122:	rjmp	A_32ee	; 0x32ee
A_3124:	in	R24, SREG
A_3126:	cli	
A_3128:	lds	R18, timer0_counter	; 0x26c
A_312c:	lds	R19, timer0_counter+1	; 0x26e
A_3130:	lds	R20, timer0_counter+2	; 0x270
A_3134:	lds	R21, timer0_counter+3	; 0x272
A_3138:	out	SREG, R24
A_313a:	sts	rhidc_start, R18	; 0x320
A_313e:	sts	rhidc_start+1, R19	; 0x322
A_3142:	sts	rhidc_start+2, R20	; 0x324
A_3146:	sts	rhidc_start+3, R21	; 0x326
A_314a:	ldi	R24, 0x02
A_314c:	sts	rhcomm_sendcmd, R24	; 0x544
A_3150:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_3152:	ldi	R25, 0x02
A_3154:	ldi	R22, 0x00
A_3156:	rcall	usb_rawhid_send	; 0x22b0
A_3158:	rjmp	A_332a	; 0x332a
A_315a:	lds	R25, req_select_set	; 0x23e
A_315e:	lds	R24, cur_select_set	; 0x23c
A_3162:	cp	R25, R24
A_3164:	brne	A_3168	; 0x3168
A_3166:	rjmp	A_3330	; 0x3330
A_3168:	rcall	setup_processing	; 0x2e28
A_316a:	lds	R24, req_select_set	; 0x23e
A_316e:	sts	cur_select_set, R24	; 0x23c
A_3172:	rjmp	A_3330	; 0x3330
A_3174:	rcall	eeprom_write_ready	; 0x2942
A_3176:	and	R24, R24
A_3178:	breq	A_317c	; 0x317c
A_317a:	rjmp	A_3218	; 0x3218
A_317c:	ldi	R24, 0x01
A_317e:	rjmp	A_3332	; 0x3332
A_3180:	ldi	R24, 0xa3
A_3182:	ldi	R25, 0x02
A_3184:	ldi	R22, 0x00
A_3186:	rcall	usb_rawhid_recv	; 0x2254
A_3188:	cp	__zero_reg__, R24
A_318a:	brlt	A_318e	; 0x318e
A_318c:	rjmp	A_3226	; 0x3226
A_318e:	lds	R24, rhcomm_sendcmd	; 0x546
A_3192:	cpi	R24, 0x82
A_3194:	breq	A_3198	; 0x3198
A_3196:	rjmp	A_3246	; 0x3246
A_3198:	lds	R17, rhcomm_rcvbuf+1	; 0x548
A_319c:	mov	R18, R17
A_319e:	ldi	R19, 0x00
A_31a0:	lds	R24, xfer_len	; 0x314
A_31a4:	lds	R25, xfer_len+1	; 0x316
A_31a8:	cp	R24, R18
A_31aa:	cpc	R25, R19
A_31ac:	brcc	A_31b0	; 0x31b0
A_31ae:	rjmp	A_3246	; 0x3246
A_31b0:	lds	R22, xfer_eeaddr	; 0x318
A_31b4:	lds	R23, xfer_eeaddr+1	; 0x31a
A_31b8:	ldi	R24, 0xa7
A_31ba:	ldi	R25, 0x02
A_31bc:	mov	R20, R17
A_31be:	rcall	write_eeprom_buffer	; 0x2952
A_31c0:	and	R24, R24
A_31c2:	breq	A_31c6	; 0x31c6
A_31c4:	rjmp	A_3246	; 0x3246
A_31c6:	sts	xfer_buf_len, R17	; 0x328
A_31ca:	ldi	R24, 0x02
A_31cc:	sts	rhcomm_sendcmd, R24	; 0x544
A_31d0:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_31d2:	ldi	R25, 0x02
A_31d4:	ldi	R22, 0x00
A_31d6:	rcall	usb_rawhid_send	; 0x22b0
A_31d8:	rjmp	A_31e0	; 0x31e0
A_31da:	rcall	eeprom_write_ready	; 0x2942
A_31dc:	and	R24, R24
A_31de:	brne	A_31e4	; 0x31e4
A_31e0:	ldi	R24, 0x03
A_31e2:	rjmp	A_3332	; 0x3332
A_31e4:	lds	R28, xfer_eeaddr	; 0x318
A_31e8:	lds	R29, xfer_eeaddr+1	; 0x31a
A_31ec:	lds	R13, xfer_buf_len	; 0x328
A_31f0:	ldi	R26, 0xa7
A_31f2:	mov	R14, R26
A_31f4:	ldi	R26, 0x02
A_31f6:	mov	R15, R26
A_31f8:	movw	R16, R28
A_31fa:	rjmp	A_320e	; 0x320e
A_31fc:	movw	R24, R16
A_31fe:	rcall	eeprom_read_byte	; 0x37f4
A_3200:	movw	R30, R14
A_3202:	ld	R25, Z+
A_3204:	movw	R14, R30
A_3206:	cp	R24, R25
A_3208:	brne	A_3246	; 0x3246
A_320a:	subi	R16, 0xff
A_320c:	sbci	R17, 0xff
A_320e:	mov	R24, R16
A_3210:	sub	R24, R28
A_3212:	cp	R24, R13
A_3214:	brcs	A_31fc	; 0x31fc
A_3216:	rjmp	A_3392	; 0x3392
A_3218:	ldi	R24, 0x03
A_321a:	sts	rhcomm_sendcmd, R24	; 0x544
A_321e:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_3220:	ldi	R25, 0x02
A_3222:	ldi	R22, 0x00
A_3224:	rcall	usb_rawhid_send	; 0x22b0
A_3226:	ldi	R24, 0x02
A_3228:	rjmp	A_3332	; 0x3332
A_322a:	subi	R18, 0x04
A_322c:	sbci	R19, 0x00
A_322e:	sts	weep_word+1, R19	; 0x31e
A_3232:	sts	weep_word, R18	; 0x31c
A_3236:	ldi	R24, 0x8e	;&weep_word
A_3238:	ldi	R25, 0x01
A_323a:	ldi	R22, 0x02
A_323c:	ldi	R23, 0x00
A_323e:	ldi	R20, 0x02
A_3240:	rcall	write_eeprom_buffer	; 0x2952
A_3242:	and	R24, R24
A_3244:	breq	A_325c	; 0x325c
A_3246:	ldi	R24, 0x01
A_3248:	sts	rhcomm_sendcmd, R24	; 0x544
A_324c:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_324e:	ldi	R25, 0x02
A_3250:	ldi	R22, 0x00
A_3252:	rcall	usb_rawhid_send	; 0x22b0
A_3254:	rjmp	A_3330	; 0x3330
A_3256:	rcall	eeprom_write_ready	; 0x2942
A_3258:	and	R24, R24
A_325a:	brne	A_3260	; 0x3260
A_325c:	ldi	R24, 0x04
A_325e:	rjmp	A_3332	; 0x3332
A_3260:	ldi	R24, 0x04
A_3262:	sts	rhcomm_sendcmd, R24	; 0x544
A_3266:	ldi	R24, 0xa2	;rhcomm_sendcmd
A_3268:	ldi	R25, 0x02
A_326a:	ldi	R22, 0x00
A_326c:	rcall	usb_rawhid_send	; 0x22b0
A_326e:	rcall	setup_processing	; 0x2e28
A_3270:	rjmp	A_3330	; 0x3330
A_3272:	ldi	R24, 0xa3
A_3274:	ldi	R25, 0x02
A_3276:	ldi	R22, 0x00
A_3278:	call	usb_rawhid_recv	; 0x2254
A_327c:	cp	__zero_reg__, R24
A_327e:	brge	A_32ee	; 0x32ee
A_3280:	lds	R24, rhcomm_sendcmd	; 0x546
A_3284:	cpi	R24, 0x03
A_3286:	breq	A_3294	; 0x3294
A_3288:	cpi	R24, 0x04
A_328a:	brne	A_328e	; 0x328e
A_328c:	rjmp	A_3330	; 0x3330
A_328e:	cpi	R24, 0x01
A_3290:	brne	A_32ee	; 0x32ee
A_3292:	rjmp	A_3330	; 0x3330
A_3294:	lds	R16, xfer_len	; 0x314
A_3298:	lds	R17, xfer_len+1	; 0x316
A_329c:	cp	R16, __zero_reg__
A_329e:	cpc	R17, __zero_reg__
A_32a0:	breq	A_32ee	; 0x32ee
A_32a2:	cpi	R16, 0x41
A_32a4:	cpc	R17, __zero_reg__
A_32a6:	brcs	A_32aa	; 0x32aa
A_32a8:	ldi	R16, 0x40
A_32aa:	ldi	R17, 0x00
A_32ac:	lds	R22, xfer_eeaddr	; 0x318
A_32b0:	lds	R23, xfer_eeaddr+1	; 0x31a
A_32b4:	ldi	R24, 0xa3
A_32b6:	ldi	R25, 0x02
A_32b8:	movw	R20, R16
A_32ba:	rcall	eeprom_read_block	; 0x37d4
A_32bc:	ldi	R24, 0xa3
A_32be:	ldi	R25, 0x02
A_32c0:	ldi	R22, 0x00
A_32c2:	call	usb_rawhid_send	; 0x22b0
A_32c6:	lds	R24, xfer_len	; 0x314
A_32ca:	lds	R25, xfer_len+1	; 0x316
A_32ce:	sub	R24, R16
A_32d0:	sbc	R25, R17
A_32d2:	sts	xfer_len+1, R25	; 0x316
A_32d6:	sts	xfer_len, R24	; 0x314
A_32da:	lds	R24, xfer_eeaddr	; 0x318
A_32de:	lds	R25, xfer_eeaddr+1	; 0x31a
A_32e2:	add	R24, R16
A_32e4:	adc	R25, R17
A_32e6:	sts	xfer_eeaddr+1, R25	; 0x31a
A_32ea:	sts	xfer_eeaddr, R24	; 0x318
A_32ee:	ldi	R24, 0x05
A_32f0:	rjmp	A_3332	; 0x3332
A_32f2:	in	R24, SREG
A_32f4:	cli	
A_32f6:	lds	R18, timer0_counter	; 0x26c
A_32fa:	lds	R19, timer0_counter+1	; 0x26e
A_32fe:	lds	R20, timer0_counter+2	; 0x270
A_3302:	lds	R21, timer0_counter+3	; 0x272
A_3306:	out	SREG, R24
A_3308:	lds	R24, rhidc_start	; 0x320
A_330c:	lds	R25, rhidc_start+1	; 0x322
A_3310:	lds	R26, rhidc_start+2	; 0x324
A_3314:	lds	R27, rhidc_start+3	; 0x326
A_3318:	sub	R18, R24
A_331a:	sbc	R19, R25
A_331c:	sbc	R20, R26
A_331e:	sbc	R21, R27
A_3320:	subi	R18, 0xe9
A_3322:	sbci	R19, 0x03
A_3324:	sbci	R20, 0x00
A_3326:	sbci	R21, 0x00
A_3328:	brcc	A_332e	; 0x332e
A_332a:	ldi	R24, 0x06
A_332c:	rjmp	A_3332	; 0x3332
A_332e:	rcall	jmp_bootloader	; 0x2a8e
A_3330:	ldi	R24, 0x00
A_3332:	sts	rawhid_commstate, R24	; 0x312
A_3336:	in	R24, SREG
A_3338:	cli	
A_333a:	lds	R18, timer0_counter	; 0x26c
A_333e:	lds	R19, timer0_counter+1	; 0x26e
A_3342:	lds	R20, timer0_counter+2	; 0x270
A_3346:	lds	R21, timer0_counter+3	; 0x272
A_334a:	out	SREG, R24
A_334c:	lds	R24, rawhid_commstate	; 0x312
A_3350:	and	R24, R24
A_3352:	breq	A_3358	; 0x3358
A_3354:	cp	R24, R12
A_3356:	breq	A_336a	; 0x336a
A_3358:	sts	tcnow_start, R18	; 0x30a
A_335c:	sts	tcnow_start+1, R19	; 0x30c
A_3360:	sts	tcnow_start+2, R20	; 0x30e
A_3364:	sts	tcnow_start+3, R21	; 0x310
A_3368:	rjmp	A_33be	; 0x33be  return;
A_336a:	lds	R24, tcnow_start	; 0x30a
A_336e:	lds	R25, tcnow_start+1	; 0x30c
A_3372:	lds	R26, tcnow_start+2	; 0x30e
A_3376:	lds	R27, tcnow_start+3	; 0x310
A_337a:	sub	R18, R24
A_337c:	sbc	R19, R25
A_337e:	sbc	R20, R26
A_3380:	sbc	R21, R27
A_3382:	subi	R18, 0x89
A_3384:	sbci	R19, 0x13
A_3386:	sbci	R20, 0x00
A_3388:	sbci	R21, 0x00
A_338a:	brcs	A_33be	; 0x33be	if carry set return;
A_338c:	sts	rawhid_commstate, __zero_reg__	; 0x312
A_3390:	rjmp	A_33be	; 0x33be  return;
A_3392:	mov	R18, R13	;xfer_len -= xfer_buf_len
A_3394:	ldi	R19, 0x00
A_3396:	lds	R24, xfer_len	; 0x314
A_339a:	lds	R25, xfer_len+1	; 0x316
A_339e:	sub	R24, R18
A_33a0:	sbc	R25, R19
A_33a2:	sts	xfer_len+1, R25	; 0x316
A_33a6:	sts	xfer_len, R24	; 0x314
A_33aa:	add	R18, R28	;xfer_eeaddr += xfer_buf_len
A_33ac:	adc	R19, R29
A_33ae:	sts	xfer_eeaddr+1, R19	; 0x31a
A_33b2:	sts	xfer_eeaddr, R18	; 0x318
A_33b6:	or	R24, R25	;if (!xfer_len)
A_33b8:	breq	A_33bc	;  goto A_322a;
A_33ba:	rjmp	A_3218	; else goto A_3218;
A_33bc:	rjmp	A_322a	; 0x322a
A_33be:	pop	R29
A_33c0:	pop	R28
A_33c2:	pop	R17
A_33c4:	pop	R16
A_33c6:	pop	R15
A_33c8:	pop	R14
A_33ca:	pop	R13
A_33cc:	pop	R12
A_33ce:	ret	

;===============================================
; setup_keybit :
;===============================================
setup_keybit:
A_33d0:	mov	R25, R24
A_33d2:	andi	R25, 0x07
A_33d4:	ldi	R18, 0x01
A_33d6:	ldi	R19, 0x00
A_33d8:	rjmp	A_33dc	; 0x33dc
A_33da:	add	R18, R18
A_33dc:	dec	R25
A_33de:	brpl	A_33da	; 0x33da
A_33e0:	lsr	R24
A_33e2:	lsr	R24
A_33e4:	lsr	R24
A_33e6:	ldi	R25, 0x00
A_33e8:	and	R22, R22
A_33ea:	breq	A_3400	; 0x3400
A_33ec:	movw	R30, R24
A_33ee:	subi	R30, 0x1d  ; Z += pressed_hidxs
A_33f0:	sbci	R31, 0xfd
A_33f2:	ld	R25, Z
A_33f4:	mov	R24, R18
A_33f6:	and	R24, R25
A_33f8:	brne	A_3418	; 0x3418
A_33fa:	or	R18, R25
A_33fc:	st	Z, R18
A_33fe:	ret	

A_3400:	movw	R30, R24
A_3402:	subi	R30, 0x1d  ; Z += pressed_hidxs
A_3404:	sbci	R31, 0xfd
A_3406:	ld	R25, Z
A_3408:	mov	R24, R18
A_340a:	and	R24, R25
A_340c:	breq	A_3418	; 0x3418
A_340e:	com	R18
A_3410:	and	R18, R25
A_3412:	st	Z, R18
A_3414:	ldi	R24, 0x00
A_3416:	ret	
A_3418:	ldi	R24, 0x01
A_341a:	ret	

;=========================================
; get_keyboard_leds : returns the LED state set from the host
;=========================================
get_keyboard_leds:
A_341c:
	lds	R24, keyboard_leds	; 0x282
	ret	

;=========================================
; get_keyboard_protocol : returns keyboard_protocol
;=========================================

get_keyboard_protocol:
A_3422:
	lds	R24, keyboard_protocol	; 0x232
	ret	

;=========================================
; proc_eeprom_mem_init : 
;=========================================
proc_eeprom_mem_init:
A_3428:	call	usb_init	; 0x16ee
A_342c:	rcall	setup_eeprom_header	; 0x2c36
A_342e:	rjmp	reset_layer_trans	; clean memory areas used in USB comm.

;=========================================
; reset_macroproc
;=========================================
reset_macroproc:
A_3430:	ldi	R30, 0xe3
A_3432:	ldi	R31, 0x02
A_3434:	st	Z+, __zero_reg__
A_3436:	ldi	R24, 0x03
A_3438:	cpi	R30, 0x03
A_343a:	cpc	R31, R24
A_343c:	brne	A_3434	; 0x3434
A_343e:	rcall	reset_fnset	; 0x24de
A_3440:	rcall	reset_modifset	; 0x26dc
A_3442:	rjmp	empty_key_queue	; 0x3552

;=========================================
; queue_reset_usb_data :
;=========================================
queue_reset_usb_data:
A_3444:	ldi	R24, 0x0b
A_3446:	ldi	R22, 0x00
A_3448:	rjmp	queue_key	; 0x34dc

;=========================================
; incoming_keybreak : 
;=========================================
incoming_keybreak:
A_344a:	push	R17
A_344c:	mov	R17, R24
A_344e:	ldi	R22, 0x00
A_3450:	rcall	setup_keybit	; 0x33d0
A_3452:	and	R24, R24
A_3454:	brne	A_3484	; 0x3484
A_3456:	ldi	R24, 0x2d	;usb_debug_putchar('-');
A_3458:	call	rjmp_usb_debug_putchar	; 0x230c
A_345c:	mov	R24, R17
A_345e:	call	phex	; 0x2320
A_3462:	ldi	R24, 0x20	;usb_debug_putchar(' ');
A_3464:	call	rjmp_usb_debug_putchar	; 0x230c
A_3468:	mov	R24, R17
A_346a:	ldi	R22, 0x00
A_346c:	call	translate_hidx	; 0x2398
A_3470:	mov	R17, R24
A_3472:	and	R24, R24
A_3474:	breq	A_3484	; 0x3484
A_3476:	ldi	R22, 0x00
A_3478:	rcall	find_exec_macro	; 0x28a4
A_347a:	and	R24, R24
A_347c:	brne	A_3484	; 0x3484
A_347e:	ldi	R24, 0x03
A_3480:	mov	R22, R17
A_3482:	rcall	queue_key	; 0x34dc
A_3484:	pop	R17
A_3486:	ret	

;===============================================
; incoming_keymake:
;===============================================
incoming_keymake:
A_3488:	push	R17
A_348a:	mov	R17, R24
A_348c:	ldi	R22, 0x01
A_348e:	rcall	setup_keybit	; 0x33d0
A_3490:	and	R24, R24
A_3492:	brne	A_34c2	; 0x34c2
A_3494:	ldi	R24, 0x2b	;usb_debug_putchar('+');
A_3496:	call	rjmp_usb_debug_putchar	; 0x230c
A_349a:	mov	R24, R17
A_349c:	call	phex	; 0x2320
A_34a0:	ldi	R24, 0x20	;usb_debug_putchar(' ');
A_34a2:	call	rjmp_usb_debug_putchar	; 0x230c
A_34a6:	mov	R24, R17
A_34a8:	ldi	R22, 0x01
A_34aa:	call	translate_hidx	; 0x2398
A_34ae:	mov	R17, R24
A_34b0:	and	R24, R24
A_34b2:	breq	A_34c2	; 0x34c2
A_34b4:	ldi	R22, 0x01
A_34b6:	rcall	find_exec_macro	; 0x28a4
A_34b8:	and	R24, R24
A_34ba:	brne	A_34c2	; 0x34c2
A_34bc:	ldi	R24, 0x02
A_34be:	mov	R22, R17
A_34c0:	rcall	queue_key	; 0x34dc
A_34c2:	pop	R17
A_34c4:	ret	

;===============================================
; queue_free
;===============================================
queue_free:
A_34c6:	lds	R24, key_queue_ridx	; 0x32c
A_34ca:	ldi	R25, 0x00
A_34cc:	sbiw	R24, 0x01
A_34ce:	lds	R18, key_queue_widx	; 0x32a
A_34d2:	sub	R24, R18
A_34d4:	sbc	R25, __zero_reg__
A_34d6:	ldi	R22, 0x50
A_34d8:	ldi	R23, 0x00
A_34da:	rjmp	__divmodhi4	; 0x3786  ; return R2425 % 80;

;===============================================
; queue_key
;===============================================
queue_key:
A_34dc:	push	R16
A_34de:	push	R17
A_34e0:	mov	R16, R24
A_34e2:	mov	R17, R22
A_34e4:	rcall	queue_free	; 0x34c6
A_34e6:	and	R24, R24
A_34e8:	breq	A_3516	; 0x3516
A_34ea:	lds	R24, key_queue_widx	; 0x32a
A_34ee:	ldi	R25, 0x00
A_34f0:	movw	R30, R24
A_34f2:	add	R30, R30
A_34f4:	adc	R31, R31
A_34f6:	subi	R30, 0xf5	; key_queue
A_34f8:	sbci	R31, 0xfc
A_34fa:	mov	R20, R17
A_34fc:	ldi	R21, 0x00
A_34fe:	mov	R19, R16
A_3500:	ldi	R18, 0x00
A_3502:	or	R20, R18
A_3504:	or	R21, R19
A_3506:	std	Z+1, R21
A_3508:	st	Z, R20
A_350a:	adiw	R24, 0x01
A_350c:	ldi	R22, 0x50
A_350e:	ldi	R23, 0x00
A_3510:	rcall	__divmodhi4	; 0x3786  ; data_0x195 = R2425 % 80;
A_3512:	sts	key_queue_widx, R24	; 0x32a
A_3516:	pop	R17
A_3518:	pop	R16
A_351a:	ret	

;===============================================
; dequeue_key
;===============================================
dequeue_key:
A_351c:	lds	R25, key_queue_ridx	; 0x32c
A_3520:	lds	R24, key_queue_widx	; 0x32a
A_3524:	cp	R24, R25
A_3526:	brne	A_352e	; 0x352e
A_3528:	ldi	R30, 0x00
A_352c:	rjmp	A_354e	; 0x354e
A_352e:	mov	R24, R25
A_3530:	ldi	R25, 0x00
A_3532:	movw	R30, R24
A_3534:	add	R30, R30
A_3536:	adc	R31, R31
A_3538:	subi	R30, 0xf5	; key_queue
A_353a:	sbci	R31, 0xfc
A_353c:	ld	R0, Z+
A_353e:	ld	R31, Z
A_3540:	mov	R30, R0
A_3542:	adiw	R24, 0x01
A_3544:	ldi	R22, 0x50
A_3546:	ldi	R23, 0x00
A_3548:	rcall	__divmodhi4	; 0x3786  ; data_0x0196 = R2425 % 80;
A_354a:	sts	key_queue_ridx, R24	; 0x32c
A_354e:	movw	R24, R30
A_3550:	ret	

;===========================================
; empty_key_queue :
;===========================================
empty_key_queue:
A_3552:	lds	R24, key_queue_widx	; 0x32a
A_3556:	sts	key_queue_ridx, R24	; 0x32c
A_355a:	ret	

;===========================================
; macro_tick
;===========================================
macro_tick:
A_355c:	push	R16
A_355e:	push	R17
A_3560:	lds	R24, usb_suspended	; 0x27a
A_3564:	and	R24, R24
A_3566:	brne	A_3570	; 0x3570
A_3568:	lds	R24, usb_resuming	; 0x27c
A_356c:	and	R24, R24
A_356e:	breq	A_3594	; 0x3594
A_3570:	lds	R24, usb_resuming	; 0x27c
A_3574:	and	R24, R24
A_3576:	breq	A_357a	; 0x357a
A_3578:	rjmp	A_3780	; 0x3780  return;
A_357a:	lds	R25, key_queue_widx	; 0x32a
A_357e:	lds	R24, key_queue_ridx	; 0x32c
A_3582:	cp	R25, R24
A_3584:	brne	A_3588	; 0x3588
A_3586:	rjmp	A_3780	; 0x3780  return;
A_3588:	call	usb_remote_wakeup	; 0x172a
A_358c:	ldi	R24, 0x0a
A_358e:	sts	wakeup_timeout, R24	; 0x330
A_3592:	rjmp	A_3780	; 0x3780  return;
A_3594:	lds	R24, wakeup_timeout	; 0x330
A_3598:	and	R24, R24
A_359a:	breq	A_35b4	; 0x35b4
A_359c:	subi	R24, 0x01
A_359e:	sts	wakeup_timeout, R24	; 0x330
A_35a2:	and	R24, R24
A_35a4:	breq	A_35a8	; 0x35a8
A_35a6:	rjmp	A_3780	; 0x3780  return;
A_35a8:	rcall	reset_macroproc	; 0x3430
A_35aa:	call	reset_usb_keyboard_data	; 0x16c0
A_35ae:	sts	flagset, R24	; 0x332
A_35b2:	rjmp	A_3780	; 0x3780  return;
A_35b4:	lds	R30, key_queue_ridx	; 0x32c
A_35b8:	lds	R24, key_queue_widx	; 0x32a
A_35bc:	cp	R24, R30
A_35be:	brne	A_35c6	; 0x35c6
A_35c0:	ldi	R30, 0x00
A_35c2:	ldi	R31, 0x00
A_35c4:	rjmp	A_35d6	; 0x35d6
A_35c6:	ldi	R31, 0x00
A_35c8:	add	R30, R30
A_35ca:	adc	R31, R31
A_35cc:	subi	R30, 0xf5	; key_queue
A_35ce:	sbci	R31, 0xfc
A_35d0:	ld	R0, Z+
A_35d2:	ld	R31, Z
A_35d4:	mov	R30, R0
A_35d6:	movw	R16, R30
A_35d8:	sbrs	R31, 7
A_35da:	rjmp	A_35fa	; 0x35fa
A_35dc:	lds	R25, modifier_keys_stack_idx	; 0x32e
A_35e0:	cpi	R25, 0x08
A_35e2:	brcc	A_35f8	; 0x35f8
A_35e4:	mov	R30, R25
A_35e6:	ldi	R31, 0x00
A_35e8:	subi	R30, 0xfd	;modifier_keys_stack
A_35ea:	sbci	R31, 0xfc
A_35ec:	lds	R24, keyboard_modifier_keys	; 0x280
A_35f0:	st	Z, R24
A_35f2:	subi	R25, 0xff
A_35f4:	sts	modifier_keys_stack_idx, R25	; 0x32e
A_35f8:	andi	R17, 0x7f
A_35fa:	cpi	R17, 0x01
A_35fc:	breq	A_3662	; 0x3662
A_35fe:	cpi	R17, 0x0a
A_3600:	brne	A_3604	; 0x3604
A_3602:	rjmp	A_3720	; 0x3720
A_3604:	rcall	dequeue_key	; 0x351c
A_3606:	cpi	R17, 0x06
A_3608:	brne	A_360c	; 0x360c
A_360a:	rjmp	A_36de	; 0x36de
A_360c:	cpi	R17, 0x07
A_360e:	brcc	A_3634	; 0x3634
A_3610:	cpi	R17, 0x03
A_3612:	brne	A_3616	; 0x3616
A_3614:	rjmp	A_36aa	; 0x36aa
A_3616:	cpi	R17, 0x04
A_3618:	brcc	A_3626	; 0x3626
A_361a:	cpi	R17, 0x01
A_361c:	breq	A_3662	; 0x3662
A_361e:	cpi	R17, 0x02
A_3620:	breq	A_3624	; 0x3624
A_3622:	rjmp	A_3758	; 0x3758
A_3624:	rjmp	A_3682	; 0x3682
A_3626:	cpi	R17, 0x04
A_3628:	brne	A_362c	; 0x362c
A_362a:	rjmp	A_36d0	; 0x36d0
A_362c:	cpi	R17, 0x05	; senseless comparison; it IS 5 if we come here!
A_362e:	breq	A_3632	; 0x3632
A_3630:	rjmp	A_3758	; 0x3758
A_3632:	rjmp	A_36d6	; 0x36d6
A_3634:	cpi	R17, 0x09
A_3636:	brne	A_363a	; 0x363a
A_3638:	rjmp	A_3708	; 0x3708
A_363a:	cpi	R17, 0x0a
A_363c:	brcc	A_364c	; 0x364c
A_363e:	cpi	R17, 0x07
A_3640:	brne	A_3644	; 0x3644
A_3642:	rjmp	A_36e8	; 0x36e8
A_3644:	cpi	R17, 0x08
A_3646:	breq	A_364a	; 0x364a
A_3648:	rjmp	A_3758	; 0x3758
A_364a:	rjmp	A_36f0	; 0x36f0
A_364c:	cpi	R17, 0x0b
A_364e:	breq	A_365e	; 0x365e
A_3650:	cpi	R17, 0x0b
A_3652:	brcc	A_3656	; 0x3656
A_3654:	rjmp	A_3720	; 0x3720
A_3656:	cpi	R17, 0x0c
A_3658:	breq	A_365c	; 0x365c
A_365a:	rjmp	A_3758	; 0x3758
A_365c:	rjmp	A_374c	; 0x374c
A_365e:	ldi	R17, 0x00
A_3660:	rjmp	A_3750	; 0x3750

A_3662:	lds	R30, key_queue_ridx	; 0x32c
A_3666:	lds	R24, key_queue_widx	; 0x32a
A_366a:	cp	R24, R30

A_366c:	breq	A_3682	; 0x3682
A_366e:	ldi	R31, 0x00
A_3670:	add	R30, R30
A_3672:	adc	R31, R31
A_3674:	subi	R30, 0xf5	; key_queue
A_3676:	sbci	R31, 0xfc
A_3678:	mov	R24, R16
A_367a:	ldi	R25, 0x00
A_367c:	ori	R25, 0x03
A_367e:	std	Z+1, R25
A_3680:	st	Z, R24
A_3682:	mov	R24, R16
A_3684:	andi	R24, 0xf8
A_3686:	cpi	R24, 0xd8
A_3688:	brne	A_3690	; 0x3690
A_368a:	mov	R24, R16
A_368c:	rcall	process_select	; 0x2b30
A_368e:	rjmp	A_3758	; 0x3758
A_3690:	ldi	R24, 0x64	;usb_debug_putchar('d');
A_3692:	call	rjmp_usb_debug_putchar	; 0x230c
A_3696:	mov	R24, R16
A_3698:	call	phex	; 0x2320
A_369c:	ldi	R24, 0x20	;usb_debug_putchar(' ');
A_369e:	call	rjmp_usb_debug_putchar	; 0x230c
A_36a2:	mov	R24, R16
A_36a4:	call	usb_keyboard_press	; 0x174c
A_36a8:	rjmp	A_36cc	; 0x36cc
A_36aa:	mov	R24, R16
A_36ac:	andi	R24, 0xf8
A_36ae:	cpi	R24, 0xd8
A_36b0:	brne	A_36b4	; 0x36b4
A_36b2:	rjmp	A_3758	; 0x3758
A_36b4:	ldi	R24, 0x75	;usb_debug_putchar('u');
A_36b6:	call	rjmp_usb_debug_putchar	; 0x230c
A_36ba:	mov	R24, R16
A_36bc:	call	phex	; 0x2320
A_36c0:	ldi	R24, 0x20	;usb_debug_putchar(' ');
A_36c2:	call	rjmp_usb_debug_putchar	; 0x230c
A_36c6:	mov	R24, R16
A_36c8:	call	usb_keyboard_release	; 0x1848
A_36cc:	mov	R25, R24
A_36ce:	rjmp	A_375a	; 0x375a
A_36d0:	sts	keyboard_modifier_keys, R16	; 0x280
A_36d4:	rjmp	A_371c	; 0x371c
A_36d6:	lds	R24, keyboard_modifier_keys	; 0x280
A_36da:	or	R24, R16
A_36dc:	rjmp	A_3718	; 0x3718
A_36de:	com	R16
A_36e0:	lds	R24, keyboard_modifier_keys	; 0x280
A_36e4:	and	R24, R16
A_36e6:	rjmp	A_3718	; 0x3718
A_36e8:	lds	R24, keyboard_modifier_keys	; 0x280
A_36ec:	eor	R24, R16
A_36ee:	rjmp	A_3718	; 0x3718
A_36f0:	lds	R30, modifier_keys_stack_idx	; 0x32e
A_36f4:	and	R30, R30
A_36f6:	breq	A_3758	; 0x3758
A_36f8:	subi	R30, 0x01
A_36fa:	sts	modifier_keys_stack_idx, R30	; 0x32e
A_36fe:	ldi	R31, 0x00
A_3700:	subi	R30, 0xfd	; modifier_keys_stack
A_3702:	sbci	R31, 0xfc
A_3704:	ld	R24, Z
A_3706:	rjmp	A_3718	; 0x3718
A_3708:	lds	R24, modifier_keys_stack_idx	; 0x32e
A_370c:	and	R24, R24
A_370e:	breq	A_3758	; 0x3758
A_3710:	sts	modifier_keys_stack_idx, __zero_reg__	; 0x32e
A_3714:	lds	R24, modifier_keys_stack	; 0x606
A_3718:	sts	keyboard_modifier_keys, R24	; 0x280
A_371c:	ldi	R25, 0x03
A_371e:	rjmp	A_375a	; 0x375a
A_3720:	mov	R25, R16
A_3722:	subi	R25, 0x01
A_3724:	breq	A_3748	; 0x3748
A_3726:	lds	R30, key_queue_ridx	; 0x32c
A_372a:	lds	R24, key_queue_widx	; 0x32a
A_372e:	cp	R24, R30
A_3730:	breq	A_3758	; 0x3758
A_3732:	ldi	R31, 0x00
A_3734:	add	R30, R30
A_3736:	adc	R31, R31
A_3738:	subi	R30, 0xf5	; key_queue
A_373a:	sbci	R31, 0xfc
A_373c:	mov	R24, R25
A_373e:	ldi	R25, 0x00
A_3740:	ori	R25, 0x0a
A_3742:	std	Z+1, R25
A_3744:	st	Z, R24
A_3746:	rjmp	A_3758	; 0x3758
A_3748:	rcall	dequeue_key	; 0x351c
A_374a:	rjmp	A_3758	; 0x3758
A_374c:	rcall	reset_macroproc	; 0x3430
A_374e:	ldi	R17, 0x01
A_3750:	call	reset_usb_keyboard_data	; 0x16c0
A_3754:	mov	R25, R24
A_3756:	rjmp	A_375c	; 0x375c
A_3758:	ldi	R25, 0x00
A_375a:	ldi	R17, 0x00
A_375c:	lds	R24, flagset	; 0x332
A_3760:	or	R24, R25
A_3762:	sts	flagset, R24	; 0x332
A_3766:	and	R24, R24
A_3768:	breq	A_3772	; 0x3772
A_376a:	call	usb_keyboard_send	; 0x192e
A_376e:	sts	flagset, R24	; 0x332
A_3772:	and	R17, R17
A_3774:	breq	A_3780	; 0x3780  if (!R17) return;
A_3776:	ldi	R24, 0x20
A_3778:	ldi	R25, 0x4e
A_377a:	sbiw	R24, 0x01
A_377c:	brne	A_377a	; 0x377a
A_377e:	rcall	jmp_bootloader	; 0x2a8e
A_3780:	pop	R17
A_3782:	pop	R16
A_3784:	ret	

;===========================================
; __divmodhi4 : signed 16-bit integer division
;               returns rest in R2425 and result in R2223
;===========================================
__divmodhi4:
A_3786:	bst	R25, 7
A_3788:	mov	R0, R25
A_378a:	eor	R0, R23
A_378c:	rcall	A_37a2	; 0x37a2
A_378e:	sbrc	R23, 7
A_3790:	rcall	A_379a	; 0x379a
A_3792:	rcall	A_37ac	; 0x37ac
A_3794:	rcall	A_37a2	; 0x37a2
A_3796:	and	R0, R0
A_3798:	brpl	A_37a0	; 0x37a0
A_379a:	com	R23
A_379c:	neg	R22
A_379e:	sbci	R23, 0xff
A_37a0:	ret	
A_37a2:	brtc	A_37a0	; 0x37a0
A_37a4:	com	R25
A_37a6:	neg	R24
A_37a8:	sbci	R25, 0xff
A_37aa:	ret	
A_37ac:	sub	R26, R26
A_37ae:	sub	R27, R27
A_37b0:	ldi	R21, 0x11
A_37b2:	rjmp	A_37c2	; 0x37c2
A_37b4:	adc	R26, R26
A_37b6:	adc	R27, R27
A_37b8:	cp	R26, R22
A_37ba:	cpc	R27, R23
A_37bc:	brcs	A_37c2	; 0x37c2
A_37be:	sub	R26, R22
A_37c0:	sbc	R27, R23
A_37c2:	adc	R24, R24
A_37c4:	adc	R25, R25
A_37c6:	dec	R21
A_37c8:	brne	A_37b4	; 0x37b4
A_37ca:	com	R24
A_37cc:	com	R25
A_37ce:	movw	R22, R24
A_37d0:	movw	R24, R26
A_37d2:	ret	

;=============================================================================
; functions taken from eeprom library code start
;=============================================================================

;==========================================
; eeprom_read_block : reads a block from the EEPROM
;==========================================
eeprom_read_block:
A_37d4:
	movw	R26, R24
	movw	R24, R22
; alternate entry point (see A_380c!)
A_37d8:
	movw	R30, R24
A_37da:
	sbic	EECR, 1	; while (! (EECR & EEPE)) ;
	rjmp	A_37da	; 0x37da
A_37de:
	rjmp	A_37ec	; 0x37ec
A_37e0:
	out	EEARH, R31
	out	EEARL, R30
	sbi	EECR, 0		;EECR |= EERE
	adiw	R30, 0x01
	in	R0, EEDR
	st	X+, R0
A_37ec:
	subi	R20, 0x01
	sbci	R21, 0x00
	brcc	A_37e0	; 0x37e0
A_37f2:
	ret	

;==========================================
; eeprom_read_byte :
;==========================================
eeprom_read_byte:
A_37f4:	sbic	EECR, 1	; while (!(EECR & EEPE)) ;
A_37f6:	rjmp	A_37f4	; 0x37f4
A_37f8:	out	EEARH, R25
A_37fa:	out	EEARL, R24
A_37fc:	sbi	EECR, 0		;EECR |= EERE
A_37fe:	clr	R25
A_3800:	in	R24, EEDR
A_3802:	ret	

;==========================================
; eeprom_read_word : reads a word from EEPROM (tricky)
;==========================================
eeprom_read_word:
A_3804:	ldi	R26, 0x18
A_3806:	ldi	R27, 0x00
A_3808:	ldi	R20, 0x02
A_380a:	ldi	R21, 0x00
A_380c:	rjmp	A_37d8	; 0x37d8

;==========================================
; eeprom_write_byte
;==========================================
eeprom_write_byte:
A_380e:	mov	R18, R22
A_3810:	sbic	EECR, 1	; while (!(EECR & EEPE)) ;
A_3812:	rjmp	A_3810	; 0x3810
A_3814:	out	EECR, __zero_reg__
A_3816:	out	EEARH, R25
A_3818:	out	EEARL, R24
A_381a:	out	EEDR, R18
A_381c:	in	R0, SREG
A_381e:	cli	
A_3820:	sbi	EECR, 2		;EECR |= EEMPE
A_3822:	sbi	EECR, 1		;EECR |= EEPE
A_3824:	out	SREG, R0
A_3826:	adiw	R24, 0x01
A_3828:	ret	

;=============================================================================
; functions taken from eeprom library code end
;=============================================================================

;==============================================================================
; avr-gcc termination functionality
;==============================================================================

; disable interrupts and go into endless loop
_exit:
A_382a:
	cli	
__stop_program:
A_382c:
	rjmp	__stop_program

;==============================================================================
; initialized data area contents
;==============================================================================

A_382e:
	.db $04,$e1				; -> 0x100/1  keyboard_codeset / pause key sequence
	.db $14,$77
	.db	$e1,$f0
	.db $14,$f0
	.db	$77,$0a				; -> 0x108/9
	.db	$fe,$01				; -> 0x10a/b
	.db $01,$ff				; -> 0x10c/d
	.db	$ff,$01				; -> 0x10e/f
	.db $ff,$ff             ; -> 0x110/1
A_3840:
	.db	$ff,$ff				; -> 0x112/3
	.db $7f,$00				; -> 0x114/5
	.db	$00,$ab				; -> 0x116/7
	.db $03,$01				; -> 0x118/9  ? / keyboard_protocol
	.db $7d,$7d				; -> 0x11a/b  4 idle configs for the interfaces? (all 125)
	.db	$7d,$7d				; -> 0x11c/d  ? / boot_idle_config(?)
	.db $01,$01				; -> 0x11e/f


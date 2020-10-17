;; Midi2ay playback code for Amstrad CPC
;;
;; Uses firmware functions to allow music to play
;; while BASIC is active.
;;
;; CALL &8000 to setup interrupt and to play music
;; CALL &8003 to stop music
;; 
;;
;; Code assembles using wincpc's assembler.
;;
;; To use this:
;; 1. Use Midi2ay to convert a .mid file and output as asm.
;; 2. Delete the data after notas in this file.
;; 3. Copy and paste the notas from the new asm file to the end of this code
;; 4. Assemble and enjoy.
;;
;; NOTE: The tone data stored here is for the Spectrum which
;; has an AY sound chip running at 1.77Mhz.
;;
;; The CPC has an AY sound chip running at 1.0Mhz, so the tones will not 
;; be correct.

;;--------------------------------------------------------------------------------------------

;run start

kl_new_frame_fly equ &bcd7
mc_sound_register equ &bd34
kl_del_frame_fly equ &bcdd
;;--------------------------------------------------------------------------------------------

org	#8000

;.start
;;--------------------------------------------------------------------------------------------

JP play_music		;; +0
JP stop_music		;; +3

;;--------------------------------------------------------------------------------------------

play_music:
xor a
ld (counter),a
ld (count_active),a

;; setup an interrupt to be executed every frame flyback 
;; (50hz)
ld hl,ff_event_block
ld b,&81
ld c,0
ld de,ff_event_routine
call kl_new_frame_fly
ret

;;--------------------------------------------------------------------------------------------

stop_music:
ld hl,ff_event_block
call kl_del_frame_fly
ret

;;--------------------------------------------------------------------------------------------

ff_event_block:
defs 10

;;--------------------------------------------------------------------------------------------

ff_event_routine:
;; counter is active?

ld a,(count_active)
or a
;; no, do next packet
jr z,packet_begin

;; yes it's active
;; count down
ld a,(counter)
dec a
ld (counter),a

;; if counter is not zero, we quit and continue
or a
ret nz

;; counter is not active any more
xor a
ld (count_active),a

;; we now continue from counter and read remaining data in packet
ld hl,(pos)
jr cont_from_counter

;;--------------------------------------------------------------------------------------------

;; read a complete packet 
packet_begin:
ld	hl,(pos)

;; continue with part of a packet
packet_cont:

;; counter?
ld	a,(hl)
or	a
jr	nz,counter_set

;; continue after doing a counter
cont_from_counter:
inc	hl
ld	a,(hl)
cp	#ff		;; end
jr	z,music_end
cp	#fe		;; skip?
jr	z,skip
	
;; write to ay
ld a,(hl)
inc hl
ld c,(hl)
inc hl
call mc_sound_register
		
jr	packet_cont

;;--------------------------------------------------------------------------------------------
;; start the counter

counter_set:
ld	(pos),hl
ld (counter),a
ld (count_active),a

ret

;;--------------------------------------------------------------------------------------------
;; skip data

skip:	
inc	hl
inc	hl
ld	(pos),hl
ret

;;--------------------------------------------------------------------------------------------
;; music end

music_end:
;; loop
ld hl,notas
ld (pos),hl
jr packet_cont

;;--------------------------------------------------------------------------------------------

count_active: defb 0
counter: defb 0
pos:	dw	notas

;;--------------------------------------------------------------------------------------------


;; data

notas:
	db	#00, #07, #38, #00, #08, #00, #00, #09, #00
	db	#00, #10, #00, #00, #00, #fc, #00, #01, #00
;	db	000, 008, 00f, 019, 000, 07e, 000, 002, 0fc
;	db	000, 003, 000, 00d, 000, 0a8, 000, 002, 07e
;	db	000, 004, 0fc, 000, 005, 000, 019, 000, 0fc
;	db	000, 002, 0a8, 000, 004, 07e, 019, 000, 08d
;	db	000, 002, 0fc, 000, 004, 0a8, 019, 000, 0fc
;	db	000, 002, 08d, 000, 004, 0fc, 00d, 000, 0bd
;	db	000, 002, 0fc, 000, 004, 08d, 019, 002, 0bd
;	db	000, 004, 0fc, 019, 000, 08d, 000, 002, 0a8
;	db	000, 009, 00f, 000, 004, 0bd, 019, 000, 0fc
;	db	000, 002, 08d, 000, 009, 000, 000, 004, 0a8
;	db	00d, 002, 0fc, 000, 004, 08d, 00d, 000, 07e
;	db	000, 002, 0a8, 000, 009, 00f, 000, 004, 0fc
;	db	00d, 008, 000, 000, 009, 000, 00d, 008, 00f
;	db	000, 009, 00f, 000, 004, 07e, 019, 000, 0fc
;	db	000, 002, 07e, 000, 009, 000, 000, 004, 0a8
;	db	00d, 000, 08d, 000, 002, 0a8, 000, 009, 00f
;	db	000, 004, 0fc, 00d, 008, 000, 000, 009, 000
;	db	00d, 008, 00f, 000, 002, 0bd, 000, 009, 00f
;	db	000, 004, 08d, 00d, 008, 000, 000, 009, 000
;	db	00d, 000, 096, 000, 008, 00f, 000, 009, 00f
;	db	00d, 008, 000, 000, 009, 000, 00d, 000, 0fc
;	db	000, 008, 00f, 000, 002, 096, 000, 004, 0bd
;	db	00d, 000, 0a8, 000, 001, 001, 000, 002, 0fc
;	db	000, 004, 096, 003, 002, 0a8, 000, 003, 001
;	db	000, 004, 0fc, 003, 004, 0a8, 000, 005, 001
;	db	013, 000, 0f8, 00d, 000, 0fc, 000, 001, 000
;	db	000, 002, 050, 000, 009, 00f, 000, 004, 0f8
;	db	00d, 008, 000, 000, 009, 000, 00d, 008, 00f
;	db	000, 009, 00f, 000, 004, 0fc, 000, 005, 000
;	db	00d, 008, 000, 000, 009, 000, 026, 000, 0a8
;	db	000, 008, 00f, 000, 002, 0d4, 000, 003, 000
;	db	000, 009, 00f, 000, 004, 01b, 000, 005, 001
;	db	000, 00a, 00f, 019, 004, 0fc, 000, 005, 000
;	db	00d, 004, 01b, 000, 005, 001, 00d, 004, 0fc
;	db	000, 005, 000, 00d, 004, 01b, 000, 005, 001
;	db	026, 000, 096, 000, 002, 0bd, 000, 004, 0a8
;	db	00d, 000, 0f8, 000, 001, 001, 000, 002, 096
;	db	000, 009, 000, 000, 004, 0bd, 000, 005, 000
;	db	000, 00a, 000, 00d, 000, 096, 000, 001, 000
;	db	000, 002, 0bd, 000, 009, 00f, 000, 004, 0fc
;	db	000, 00a, 00f, 00d, 004, 096, 000, 00a, 000
;	db	00d, 004, 0fc, 000, 00a, 00f, 00d, 004, 096
;	db	000, 00a, 000, 019, 000, 0a8, 000, 002, 0d4
;	db	002, 004, 0a8, 00b, 000, 0fc, 000, 002, 0a8
;	db	000, 009, 000, 000, 004, 0d4, 003, 002, 0fc
;	db	000, 004, 0a8, 003, 004, 0fc, 006, 002, 0f8
;	db	000, 003, 001, 000, 009, 00f, 00d, 002, 0fc
;	db	000, 003, 000, 000, 004, 050, 000, 005, 001
;	db	000, 00a, 00f, 00d, 009, 000, 000, 004, 0fc
;	db	000, 005, 000, 000, 00a, 000, 00d, 009, 00f
;	db	000, 004, 050, 000, 005, 001, 000, 00a, 00f
;	db	00d, 009, 000, 000, 004, 0fc, 000, 005, 000
;	db	000, 00a, 000, 00d, 002, 0f8, 000, 003, 001
;	db	000, 009, 00f, 00d, 002, 0a8, 019, 008, 000
;	db	000, 009, 000, 000, 0ff, 000

;; end
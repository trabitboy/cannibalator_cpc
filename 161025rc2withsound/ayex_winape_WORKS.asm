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

kl_new_frame_fly equ &bcd7
mc_sound_register equ &bd34
kl_del_frame_fly equ &bcdd
;;--------------------------------------------------------------------------------------------

org    &8000


;;--------------------------------------------------------------------------------------------

JP play_music        ;; +0
JP stop_music        ;; +3

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
ld    hl,(pos)

;; continue with part of a packet
packet_cont:

;; counter?
ld    a,(hl)
or    a
jr    nz,counter_set

;; continue after doing a counter
cont_from_counter:
inc    hl
ld    a,(hl)
cp    &ff        ;; end
jr    z,music_end
cp    &fe        ;; skip?
jr    z,skip
   
;; write to ay
ld a,(hl)
inc hl
ld c,(hl)
inc hl
call mc_sound_register
       
jr    packet_cont

;;--------------------------------------------------------------------------------------------
;; start the counter

counter_set:
ld    (pos),hl
ld (counter),a
ld (count_active),a

ret

;;--------------------------------------------------------------------------------------------
;; skip data

skip:   
inc    hl
inc    hl
ld    (pos),hl
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
pos:    dw    notas

;;--------------------------------------------------------------------------------------------


;; data

notas:
    db &00, &07, &38, &00, &08, &00, &00, &09, &00
    db &00, &10, &00, &00, &00, &fc, &00, &01, &00
    db &00, &08, &0f, &19, &00, &7e, &00, &02, &fc
    db &00, &03, &00, &0d, &00, &a8, &00, &02, &7e
    db &00, &04, &fc, &00, &05, &00, &19, &00, &fc
    db &00, &02, &a8, &00, &04, &7e, &19, &00, &8d
    db &00, &02, &fc, &00, &04, &a8, &19, &00, &fc
    db &00, &02, &8d, &00, &04, &fc, &0d, &00, &bd
    db &00, &02, &fc, &00, &04, &8d, &19, &02, &bd
    db &00, &04, &fc, &19, &00, &8d, &00, &02, &a8
    db &00, &09, &0f, &00, &04, &bd, &19, &00, &fc
    db &00, &02, &8d, &00, &09, &00, &00, &04, &a8
    db &0d, &02, &fc, &00, &04, &8d, &0d, &00, &7e
    db &00, &02, &a8, &00, &09, &0f, &00, &04, &fc
    db &0d, &08, &00, &00, &09, &00, &0d, &08, &0f
    db &00, &09, &0f, &00, &04, &7e, &19, &00, &fc
    db &00, &02, &7e, &00, &09, &00, &00, &04, &a8
    db &0d, &00, &8d, &00, &02, &a8, &00, &09, &0f
    db &00, &04, &fc, &0d, &08, &00, &00, &09, &00
    db &0d, &08, &0f, &00, &02, &bd, &00, &09, &0f
    db &00, &04, &8d, &0d, &08, &00, &00, &09, &00
    db &0d, &00, &96, &00, &08, &0f, &00, &09, &0f
    db &0d, &08, &00, &00, &09, &00, &0d, &00, &fc
    db &00, &08, &0f, &00, &02, &96, &00, &04, &bd
    db &0d, &00, &a8, &00, &01, &01, &00, &02, &fc
    db  &00, &04, &96, &03, &02, &a8, &00, &03, &01
    db  &00, &04, &fc, &03, &04, &a8, &00, &05, &01
    db  &13, &00, &f8, &0d, &00, &fc, &00, &01, &00
    db  &00, &02, &50, &00, &09, &0f, &00, &04, &f8
    db  &0d, &08, &00, &00, &09, &00, &0d, &08, &0f
    db  &00, &09, &0f, &00, &04, &fc, &00, &05, &00
    db  &0d, &08, &00, &00, &09, &00, &26, &00, &a8
    db  &00, &08, &0f, &00, &02, &d4, &00, &03, &00
    db  &00, &09, &0f, &00, &04, &1b, &00, &05, &01
    db  &00, &0a, &0f, &19, &04, &fc, &00, &05, &00
    db  &0d, &04, &1b, &00, &05, &01, &0d, &04, &fc
    db  &00, &05, &00, &0d, &04, &1b, &00, &05, &01
    db  &26, &00, &96, &00, &02, &bd, &00, &04, &a8
    db  &0d, &00, &f8, &00, &01, &01, &00, &02, &96
    db  &00, &09, &00, &00, &04, &bd, &00, &05, &00
    db  &00, &0a, &00, &0d, &00, &96, &00, &01, &00
    db  &00, &02, &bd, &00, &09, &0f, &00, &04, &fc
    db  &00, &0a, &0f, &0d, &04, &96, &00, &0a, &00
    db  &0d, &04, &fc, &00, &0a, &0f, &0d, &04, &96
    db  &00, &0a, &00, &19, &00, &a8, &00, &02, &d4
    db  &02, &04, &a8, &0b, &00, &fc, &00, &02, &a8
    db  &00, &09, &00, &00, &04, &d4, &03, &02, &fc
    db  &00, &04, &a8, &03, &04, &fc, &06, &02, &f8
    db  &00, &03, &01, &00, &09, &0f, &0d, &02, &fc
    db  &00, &03, &00, &00, &04, &50, &00, &05, &01
    db  &00, &0a, &0f, &0d, &09, &00, &00, &04, &fc
    db  &00, &05, &00, &00, &0a, &00, &0d, &09, &0f
    db  &00, &04, &50, &00, &05, &01, &00, &0a, &0f
    db  &0d, &09, &00, &00, &04, &fc, &00, &05, &00
    db  &00, &0a, &00, &0d, &02, &f8, &00, &03, &01
    db  &00, &09, &0f, &0d, &02, &a8, &19, &08, &00
    db  &00, &09, &00, &00, &ff, &00

;; end
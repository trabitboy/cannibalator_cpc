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
    db &00, &10, &00, &00, &00, &c1, &00, &01, &01
    db &00, &08, &0c, &01, &02, &c1, &00, &03, &01
    db &01, &04, &c1, &00, &05, &01, &26, &00, &a8
    db &00, &01, &00, &00, &02, &a8, &00, &03, &00
    db &00, &09, &0c, &00, &04, &1b, &00, &0a, &0c
    db &36, &00, &96, &00, &02, &96, &28, &00, &8d
    db &00, &02, &8d, &0d, &00, &b2, &00, &02, &b2
    db &6b, &00, &a8, &00, &02, &a8, &36, &00, &96
    db &00, &02, &96, &28, &00, &8d, &00, &02, &8d
    db &0d, &00, &b2, &00, &02, &b2, &6b, &00, &a8
    db &00, &02, &a8, &36, &00, &96, &00, &02, &96
    db &28, &00, &8d, &00, &02, &8d, &0d, &00, &b2
    db &00, &02, &b2, &6b, &00, &a8, &00, &02, &a8
    db &36, &00, &96, &00, &02, &96, &28, &00, &8d
    db &00, &02, &8d, &0d, &00, &85, &00, &02, &85
    db &00, &04, &e0, &00, &05, &00, &5e, &00, &7e
    db &00, &04, &85, &03, &00, &70, &03, &00, &64
    db &03, &00, &5e, &03, &00, &54, &00, &02, &54
    db &00, &04, &7e, &03, &00, &4b, &03, &00, &43
    db &03, &00, &3f, &03, &00, &38, &03, &00, &32
    db &03, &00, &2f, &03, &00, &54, &00, &02, &7e
    db &02, &00, &2a, &00, &02, &54, &1c, &04, &70
    db &1a, &00, &54, &00, &02, &70, &0f, &02, &64
    db &00, &04, &64, &0d, &00, &59, &00, &02, &8d
    db &00, &04, &8d, &6b, &00, &54, &00, &02, &7e
    db &00, &04, &7e, &36, &02, &70, &00, &04, &70
    db &28, &02, &64, &00, &04, &64, &0d, &00, &59
    db &00, &02, &8d, &00, &04, &8d, &6b, &00, &3b
    db &00, &02, &77, &00, &04, &77, &36, &04, &7e
    db &28, &04, &9f, &0d, &00, &38, &00, &02, &70
    db &00, &04, &85, &6b, &00, &77, &00, &08, &0f
    db &00, &02, &3b, &00, &04, &77, &36, &00, &5e
    db &28, &00, &4f, &0d, &00, &43, &00, &02, &38
    db &00, &04, &70, &6b, &00, &7e, &00, &08, &0d
    db &00, &02, &6a, &00, &04, &7e, &36, &00, &70
    db &00, &04, &70, &28, &00, &6a, &00, &04, &6a
    db &0d, &00, &85, &00, &02, &85, &00, &04, &9f
    db &1b, &00, &28, &00, &08, &0c, &00, &02, &28
    db &00, &04, &85, &00, &0a, &0d, &1b, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &04, &00, &1f
    db &00, &02, &1f, &04, &00, &21, &00, &02, &21
    db &04, &00, &1f, &00, &02, &1f, &04, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &04, &00, &1f
    db &00, &02, &1f, &04, &00, &21, &00, &02, &21
    db &09, &00, &7e, &00, &08, &0d, &00, &02, &7e
    db &00, &04, &7e, &00, &0a, &0c, &36, &00, &70
    db &00, &02, &70, &28, &00, &6a, &00, &02, &6a
    db &0d, &00, &85, &00, &02, &85, &00, &04, &9f
    db &1b, &00, &28, &00, &08, &0c, &00, &02, &28
    db &00, &04, &85, &00, &0a, &0d, &1b, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &04, &00, &1f
    db &00, &02, &1f, &04, &00, &21, &00, &02, &21
    db &04, &00, &1f, &00, &02, &1f, &04, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &04, &00, &1f
    db &00, &02, &1f, &04, &00, &21, &00, &02, &21
    db &09, &00, &7e, &00, &08, &0d, &00, &02, &7e
    db &00, &04, &7e, &00, &0a, &0c, &09, &02, &70
    db &09, &02, &6a, &12, &02, &5e, &09, &00, &54
    db &00, &08, &0c, &00, &02, &7e, &00, &09, &0d
    db &09, &00, &70, &00, &08, &0d, &00, &02, &54
    db &00, &09, &0c, &09, &02, &4b, &09, &00, &43
    db &00, &08, &0c, &00, &02, &70, &00, &09, &0d
    db &09, &00, &3f, &09, &00, &38, &04, &02, &6a
    db &04, &00, &35, &09, &02, &85, &00, &04, &9f
    db &1b, &00, &28, &00, &02, &28, &00, &09, &0c
    db &00, &04, &35, &1b, &00, &21, &00, &02, &21
    db &04, &00, &1f, &00, &02, &1f, &04, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &04, &00, &1f
    db &00, &02, &1f, &04, &00, &21, &00, &02, &21
    db &04, &00, &1f, &00, &02, &1f, &04, &00, &21
    db &00, &02, &21, &04, &00, &1f, &00, &02, &1f
    db &04, &00, &21, &00, &02, &21, &09, &00, &7e
    db &00, &08, &0d, &00, &02, &7e, &00, &04, &7e
    db &09, &02, &70, &09, &02, &6a, &12, &02, &5e
    db &09, &00, &54, &00, &08, &0c, &00, &02, &7e
    db &00, &09, &0d, &09, &00, &70, &00, &08, &0d
    db &00, &02, &54, &00, &09, &0c, &09, &02, &4b
    db &09, &00, &43, &00, &08, &0c, &00, &02, &70
    db &00, &09, &0d, &09, &00, &3f, &09, &00, &38
    db &04, &02, &6a, &04, &00, &35, &09, &00, &32
    db &00, &02, &64, &00, &04, &85, &36, &04, &64
    db &36, &00, &2f, &00, &02, &5e, &00, &04, &5e
    db &36, &00, &2a, &00, &02, &54, &00, &04, &54
    db &28, &00, &25, &00, &02, &4b, &00, &04, &4b
    db &0d, &00, &35, &00, &02, &6a, &00, &04, &6a
    db &21, &02, &43, &00, &09, &0c, &00, &0a, &0d
    db &03, &02, &3b, &03, &02, &35, &03, &00, &2f
    db &03, &00, &2a, &03, &00, &25, &03, &00, &21
    db &00, &08, &0f, &03, &00, &25, &00, &08, &0c
    db &03, &00, &2a, &03, &00, &2f, &03, &00, &35
    db &03, &02, &3b, &03, &02, &43, &03, &02, &6a
    db &00, &09, &0d, &00, &0a, &0c, &1e, &00, &2f
    db &00, &02, &5e, &00, &04, &5e, &36, &00, &2a
    db &00, &02, &54, &00, &04, &54, &28, &00, &25
    db &00, &02, &4b, &00, &04, &4b, &0d, &00, &35
    db &00, &02, &6a, &00, &04, &6a, &21, &02, &43
    db &00, &09, &0c, &00, &0a, &0d, &03, &02, &3b
    db &03, &02, &35, &03, &00, &2f, &03, &00, &2a
    db &03, &00, &25, &03, &00, &21, &00, &08, &0f
    db &03, &00, &25, &00, &08, &0c, &03, &00, &2a
    db &03, &00, &2f, &03, &00, &35, &03, &02, &3b
    db &03, &02, &43, &03, &02, &6a, &00, &09, &0d
    db &00, &0a, &0c, &1e, &00, &32, &00, &02, &64
    db &00, &04, &64, &36, &00, &35, &00, &02, &6a
    db &00, &04, &6a, &28, &00, &43, &00, &02, &85
    db &00, &04, &85, &0d, &00, &38, &00, &02, &70
    db &00, &04, &70, &21, &02, &47, &00, &09, &0c
    db &00, &0a, &0d, &03, &02, &3f, &03, &02, &38
    db &03, &00, &32, &03, &00, &2d, &03, &00, &28
    db &03, &00, &23, &00, &08, &0f, &03, &00, &28
    db &00, &08, &0c, &03, &00, &2d, &03, &00, &32
    db &03, &00, &38, &03, &02, &3f, &03, &02, &47
    db &03, &02, &70, &00, &09, &0d, &00, &0a, &0c
    db &1e, &00, &32, &00, &02, &64, &00, &04, &64
    db &3a, &00, &35, &00, &02, &6a, &00, &04, &6a
    db &2e, &00, &43, &00, &02, &85, &00, &04, &85
    db &10, &00, &70, &00, &08, &0f, &00, &02, &38
    db &00, &09, &0c, &00, &04, &70, &21, &04, &47
    db &03, &04, &3f, &03, &04, &38, &03, &02, &32
    db &03, &02, &2d, &03, &02, &28, &03, &00, &23
    db &00, &02, &70, &00, &09, &0f, &03, &00, &70
    db &00, &02, &28, &00, &09, &0c, &03, &02, &2d
    db &03, &02, &32, &03, &02, &38, &03, &04, &3f
    db &03, &04, &47, &03, &04, &70, &89, &02, &8d
    db &00, &04, &e0, &00, &0a, &0d, &00, &08, &00
    db &00, &09, &00, &00, &0a, &00, &00, &ff, &00
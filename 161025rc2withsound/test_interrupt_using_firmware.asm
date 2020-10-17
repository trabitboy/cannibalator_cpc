; \o/ wooooooooooooooooorks
	CONOUT EQU &BB5A

;;-----------------------------------------------------------------------------
;; This example initialise a firmware frame flyback (vsync/50Hz)
;; interrupt.
;; 
;; This kind of interrupt runs with the firmware.
;;

.kl_new_frame_fly equ &bcd7
.kl_init_event equ &bcef

;;-----------------------------------------------------------------------------

org &8000
nolist

;; setup an interrupt to be executed every frame flyback 
;; (50hz)
ld hl,ff_event_block
ld b,&81					;; class (asynchronous, near address)
ld c,0						;; rom select
ld de,fw_interrupt_callback
call kl_new_frame_fly
ret

;;-----------------------------------------------------------------------------

.ff_event_block 
defs 10

;;-----------------------------------------------------------------------------


interrupt_counter:
	db 0
pal_counter:
	db 0


fw_interrupt_callback:


	;real interrupt code

	ld a,(interrupt_counter)
	inc a
	ld (interrupt_counter),a
	cp 255
	;if 255 we do something and return 0	
	jp nz,exit_interrupt

	;255 reached !
	ld a,0
	ld (interrupt_counter),a
	;do something visual

	ld a,'x'
	call conout

	;if bit counter is 0 we set a color and increment,
	ld a,(pal_counter)
	cp a,0
	jp nz, setColor1

	;if pal_counter is 0, we continue through this
	inc a ; to 1
	ld (pal_counter),a
	ld a,&58
	call setColor
	jp exit_interrupt

	;if bit counter is 1 we set another color and decrement
	setColor1:
	ld a,(pal_counter)
	dec a ; to 0
	ld (pal_counter),a
	ld a,&5D
	call setColor
	

	;end interrupt code
	exit_interrupt:

ret





setColor:
ld bc, &7f00
out (c), c
out (c), a
ld bc, &7f10
out (c), c
out (c), a
ret




ret

;;-----------------------------------------------------------------------------
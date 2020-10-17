;set an interrupt ticking a global counter for model updates

;;-----------------------------------------------------------------------------
;; initialise a firmware frame flyback (vsync/50Hz)
;; interrupt.
;; 
;; This kind of interrupt runs with the firmware.
;;

.kl_new_frame_fly equ &bcd7
.kl_init_event equ &bcef

;;-----------------------------------------------------------------------------



;; setup an interrupt to be executed every frame flyback 
;; (50hz)
.setup_timer_interrupt
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

	push af

	ld a,(playing)
	cp 1
	call z,player


	;double buffer
;DBG trying to call switch screen manually 
;	call switchscreen

	;real interrupt code

	ld a,(interrupt_counter)
	inc a
	ld (interrupt_counter),a
;TODO should be a define, controls how fast game runs
;	cp 2
	cp 4 
;	cp 7
	;if 255 we do something and return 0	
	jp nz,exit_interrupt

	;nb interrupt reached !
	ld a,0
	ld (interrupt_counter),a
	;do something visual, handle timer

	;handling timer
	ld a,(mod_upd)
	inc a
	ld (mod_upd),a

;TODO play sound here	

	;end interrupt code
	exit_interrupt:

	pop af
ret





setColor:
ld bc, &7f00
out (c), c
out (c), a
ld bc, &7f10
out (c), c
out (c), a
ret
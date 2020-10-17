;try to wire it with blit demo


;WIP doesn't work


TXT_CLR_WDW EQU &BB6C

	nolist
	org &4000

run start

start:
	call TXT_CLR_WDW
	call install_interrupts

	jp $

	ret

install_interrupts:
	di
	ld hl, interrupt_callback
	ld ( &39 ), hl
	ei
	ret

interrupt_counter:
	db 0
pal_counter:
	db 0


interrupt_callback:

	di
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
;	ei
;	ret
	;trying to JUMP to firmware interrupt for keyboard poll
	jp &B941




setColor:
ld bc, &7f00
out (c), c
out (c), a
ld bc, &7f10
out (c), c
out (c), a
ret
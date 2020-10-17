;trying to locate only first interrupt of screen

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



interrupt_callback:


	;real interrupt code

	;VBL check ( first interrupt )

ld b, &f5
in a, ( c )
rrca
jr nc, not_vbl	
; here this is 1st interrupt of VBL
	ld a,&58
	call setColor
	jp exit_interrupt
not_vbl:
; this is not 1st interrupt of VBL	
	ld a,&5D
	call setColor
	
	;end interrupt code
	exit_interrupt:
	ei
	ret





setColor:
ld bc, &7f00
out (c), c
out (c), a
ld bc, &7f10
out (c), c
out (c), a
ret

.w_blit
db 0 ; 60 octets for 120 pxs

.h_blit
db 0

.local_gen_blit_x
db 0


.clear_screen
	LD HL,(current_screen)
;	ld HL,VIDEO
;TODO clear mentions 4000
	ld DE,#4000
	add HL,DE
	ld D,H
	ld E,L
	;now adress after end of video memory is in DE

;	ld HL,VIDEO
	LD HL,(current_screen)

	.it_clr
	ld A,#00
	ld (HL),A
	inc HL
	;check for end of video memory
	LD A,H
;	CP H_END_VID ;should be computed
	CP D
	JP NZ,it_clr	
ret


.copy_any_size_blit
	
;corrupts A , B, hl
; determining the line in hardware sense by dividing y by 8
;D is x on screen
;E is y on screen
;B width blit,
;c h blit 
;IX is the adress of the zone to be copied 

LD A,B
LD (w_blit),A
LD A,C
LD (h_blit),A

;OUT OF REGISTERS >we store the x in ram
LD A,D
LD (local_gen_blit_x),A

ld A,(h_blit)
LD B,A ;for the djnz on blit hght 

;start y in A
LD A,E
.draw_any_loop

;let's preserve EVERYTHING 
PUSH AF
PUSH BC
PUSH DE
call draw_any_spr_line
POP DE
POP BC
POP AF

INC A
INC A ;quick line double

;next line of sprite

DJNZ draw_any_loop

ret



;true subroutine
;in A, height of the line to be drawn, all corrupted
;in IX the line of the sprite img to be copied 
.draw_any_spr_line
LD E,A ;saving current line for later

SRL A ;/2
SRL A ;/2
SRL A ;/2

LD D,A ; D contains hw line number now

;modulo of A /8 gives us row number
LD A,E
AND %00000111
;we put hw row number in E
LD E,A

;we want to fill the line of Y_OFF
; line adress is &C000 + D * #50
;LD HL ,VIDEO
LD HL,(current_screen)

LD B,#00
LD C,#50
;we need to increase if cd ok
LD A,D
.any_increase_line
;end while condition
CP 0
JP Z,end_any_increase_line
ADD HL,BC
DEC A
JP any_increase_line
.end_any_increase_line


LD B,#08
LD C,#00
;row address is line adress + E * #0800
LD A,E
.any_increase_row
CP 0
JP Z,end_any_increase_row
ADD HL,BC
DEC A
JP any_increase_row
.end_any_increase_row

LD A,(local_gen_blit_x)
;0 case
CP 0
JP Z,finally_any_blit

;A is at least 1
LD B,A
.any_shift_x
INC HL ;+1 pixel
DJNZ any_shift_x


;now we draw the sprite line
.finally_any_blit 
LD A,(w_blit)
LD B,A  ; copying 4 bytes will fill 8 pixels ( 4 bits per pix )
.any_draw_pix
LD A,(IX)   ;src in IX
LD (HL),A   ;dest in HL
INC IX
INC HL
DJNZ any_draw_pix

ret





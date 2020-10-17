

;we try to blit 8x8 image data
.local_blit_x
db 0

.copy_8_8_blit
	
;corrupts A , B, hl
; determining the line in hardware sense by dividing y by 8
;D is x on screen
;E is y on screen
;IX is the adress of the zone to be copied ( 64 pxs, 32 bytes )
;DE preserved
;OUT OF REGISTERS >we store the x in ram
LD A,D
LD (local_blit_x),A

ld B,8

LD A,E
sla a
.draw_loop

;let's preserve EVERYTHING 
PUSH AF
PUSH BC
PUSH DE
call draw_spr_line
POP DE
POP BC
POP AF

INC A
inc a
;next line of sprite

DJNZ draw_loop

ret



;TODO pass parameter with D and E
;TODO pass D ( x ) in ram to save it for blit time
;true subroutine
;in A, height of the line to be drawn, all corrupted
;in IX the line of the sprite img to be copied 
.draw_spr_line
;LD D,A
LD E,A

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
.increase_line
;end while condition
CP 0
JP Z,end_increase_line
ADD HL,BC
DEC A
JP increase_line
.end_increase_line


LD B,#08
LD C,#00
;row address is line adress + E * #0800
LD A,E
.increase_row
CP 0
JP Z,end_increase_row
ADD HL,BC
DEC A
JP increase_row
.end_increase_row

LD A,(local_blit_x)
;0 case
CP 0
JP Z,finally_blit

;A is at list 1
LD B,A
.shift_x
INC HL ;+1 pixel
DJNZ shift_x


;now we draw the sprite line
.finally_blit 
LD B,4  ; copying 4 bytes will fill 8 pixels ( 4 bits per pix )
.draw_pix
LD A,(IX)   ;src in IX
LD (HL),A   ;dest in HL
INC IX
INC HL
DJNZ draw_pix

ret





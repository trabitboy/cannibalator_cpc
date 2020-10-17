;TODO tools and palette setup

VIDEO EQU &C000
ENDVIDEO EQU &FFFF
CHANGE_MODE EQU &BC0E
TXT_CUR_DISABLE EQU &BB7E

Y_OFF EQU 40
X_OFF EQU 40

SPR_WDTH EQU 8
SPR_HGHT EQU 8


org #4000
run start


.start
LD A,0
call CHANGE_MODE
call TXT_CUR_DISABLE

;pen 0
ld a,0
 ; pal color
ld b, 0
 ld c, b
call &BC32

;pen 1
ld a,1
 ; pal color
ld b, 2
 ld c, b
call &BC32

;pen 2
ld a,2
 ; pal color
ld b, 3
 ld c, b
call &BC32

;pen 3
ld a,3
 ; pal color
ld b, 6
 ld c, b
call &BC32

;pen 4
ld a,4
 ; pal color
ld b, 15
 ld c, b
call &BC32

;pen 5
ld a,5
 ; pal color
ld b, 16
 ld c, b
call &BC32

;pen 6
ld a,6
 ; pal color
ld b, 24
 ld c, b
call &BC32

;pen 7
ld a,7
 ; pal color
ld b, 26
 ld c, b
call &BC32

;putting bright yellow 24 ,to pen 15
ld a,15
 ; pal color
ld b, 26
 ld c, b
call &BC32



LD B,100

.move_loop

PUSH BC

LD D,40
LD A,(Y);y blit
LD E,A
LD IX,img_clear
call copy_8_8_blit

LD A,(Y);y blit
INC A
LD (Y),A

LD D,40
LD A,(Y);y blit
LD E,A
LD IX,img_ply
;LD IX,img_cross
call copy_8_8_blit

POP BC

DJNZ move_loop

;to see the result
.endless_loop


jp endless_loop


read "copy_8_8_sprite.asm"
.img_round
db #00,#33,#33,#00
db #33,#33,#33,#33
db #33,#33,#33,#33
db #33,#33,#33,#33
db #33,#33,#33,#33
db #33,#33,#33,#33
db #33,#33,#33,#33
db #00,#33,#33,#00

.img_cross
db #3c,#00,#00,#3c
db #3c,#00,#00,#3c
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #3c,#00,#00,#3c
db #3c,#00,#00,#3c

.img_clear
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00
db #00,#00,#00,#00

.img_ply
db #00,#3c,#3c,#00
db #14,#3c,#3c,#28
db #14,#f0,#f0,#28
db #00,#f0,#f0,#00
db #cc,#cc,#cc,#cc
db #a0,#cc,#cc,#50
db #00,#c0,#c0,#00
db #00,#80,#40,#00

.Y db 30


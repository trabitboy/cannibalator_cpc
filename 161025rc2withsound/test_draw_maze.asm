;TODO tools and palette setup


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
ld b, 7
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




.move_loop


LD D,28
LD E,32
LD IX,img_ply
call copy_8_8_blit

LD D,16
LD E,24
LD IX,img_bad
call copy_8_8_blit

LD D,16
LD E,80
LD IX,img_door
call copy_8_8_blit

LD D,8
LD E,16
LD IX,img_key
call copy_8_8_blit


;test init lab pointer
ld HL,lev2_map
ld (current_lab),HL
;LD E,2
;call draw_lab_line_gfx
call draw_lab_all_gfx

;to see the result
.endless_loop


jp endless_loop

read "Levels.asm"
read "Gfx_display.asm"
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


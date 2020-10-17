;TODO parameter pass
;TODO try with smaller size to debut ( 4x4 8x8 )


nolist

read "defines.asm"
org #4000
run start


.start
LD A,0
call CHANGE_MODE

call set_pal



LD D,10
LD E,40
LD B,60
LD C,100
LD IX,title_gfx
;LD IX,img_ply
;LD IX,img_cross
call copy_any_size_blit


;to see the result
.endless_loop


jp endless_loop
read "copy_any_size.asm"
read "setpal.asm"
read "title_gfx.asm"
read "gfxdata.asm"

.img_cross
db #3c,#00,#00,#3c
db #3c,#00,#00,#3c
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #00,#3c,#3c,#00
db #3c,#00,#00,#3c
db #3c,#00,#00,#3c

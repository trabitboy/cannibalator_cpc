
;clears screen
;displays level up
;waits for x cycles
.inter_screen

call clear_screen
;display title, then wait for key
;LD D,10 ;x
;LD E,40 ;y
;LD B,4 ;width ( number of bytes )
;LD C,96 ;height
;LD IX,title_gfx
LD D,30 ;x
LD E,40 ;y
LD B,20 ;width ( number of bytes )
LD C,16 ;height
LD IX,img_level_up
call copy_any_size_blit
call justswitch


ld hl,lvlup_tune
ld (tune_pt),hl
ld a,1
ld (playing),a


;wait n cycles
ld a,0
ld (mod_upd),a

.inter_wait
ld a,(mod_upd)
cp INTER_CYCLES
jp z,exit_inter
;if not yet enough TODO maybe greater than
jp inter_wait
.exit_inter

ld a,0
ld (playing),a

call srst


ret



;clears screen
;displays you won !
;waits for x cycles
.won_screen

call clear_screen
;display title, then wait for key
;LD D,10 ;x
;LD E,40 ;y
;LD B,4 ;width ( number of bytes )
;LD C,96 ;height
;LD IX,title_gfx
LD D,30 ;x
LD E,40 ;y
LD B,12 ;width ( number of bytes )
LD C,16 ;height
LD IX,img_you_won
call copy_any_size_blit
call justswitch

;wait n cycles
ld a,0
ld (mod_upd),a

.won_wait
ld a,(mod_upd)
cp INTER_CYCLES
jp z,exit_won
;if not yet enough TODO maybe greater than
jp won_wait
.exit_won
jp title
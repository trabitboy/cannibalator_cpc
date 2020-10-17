;fal level to fix


;generate working dsk:  

;good direction for hammer
;esc to restart level ?
;minimal fx
;level up music?

;test cdt
; success ful line , bin extracted manually from winape dsk  $ ./2cdt.exe -n -X "&8000" -L "&8000" -r cnb cnb.bin cnb.cdt
;test jump into wall physic on all levels


;lvl
;add first with just one chicken and a clear tutorial  "welcome" in bricks
;path

;first little wih one chicken,that is limited by holes
;2- jumping up
;3- falling down between 2 ennemies
;4- very closed labyrinth
;5- different ennemies on same platform ( long platforms with 3 ennemies )
; isolated chicken on "one bricks", maybe between 2 ranges of platforms


;TODO delay for activity hammer

;TODO victory screen

;TODO level up screen

;TODO change keys

;TODO dbl y blit



;assemble to emu
;music player


;TODO time render of 
;TODO global player pixel perfect check to remove?
;TODO blit 2x vertical*******
;input lag pbef
;DONE hit from ply and pickup transformation
;DONE do a "stun state" for baddies with a "function pointer"
;DONE ply bad coll, if stun eat it ( function pointer again )
;TODO ply pickup and health bar

;TODO jump traversable not checked, just 16 pxs jump up
;DONE animated fall , fall state
;DONE weapon to eat baddies
;TODO directional weapon

;TODO clear screen mentions &4000

;TODO integrate minimal sound

nolist
read "defines.asm"

;origine du prgc

org #8000
run #8000
;run start
;.start
;the following works :
;write direct "cnb.bin"

;write "cnb.bin" this generation doesn't work

LD A,0
call CHANGE_MODE

call set_pal

;move visible screen
ld a,(current_base)
ld hl,&0000
call mc_screen_offset

call setup_timer_interrupt


;DEBUG in dev we do not want to get title all the time
;jp from_title



.title
call clear_screen
;display title, then wait for key
LD D,10 ;x
LD E,0 ;y
LD B,4 ;width ( number of bytes )
LD C,96 ;height
LD IX,title_gfx
call copy_any_size_blit
LD D,18 ;x
LD E,20 ;y
LD B,16 ;width ( number of bytes )
LD C,48 ;height
LD IX,img_help
call copy_any_size_blit
call justswitch

ld hl,title_tune
ld (tune_pt),hl
ld a,1
ld (playing),a

;todo add wait because press space on music corrupts gfx
;or no music?

;wait n cycles
ld a,0
ld (mod_upd),a

.ttl_wait
ld a,(mod_upd)
cp TITLE_WAIT_CYCLES
jp z,exit_ttlwt
;if not yet enough TODO maybe greater than
jp ttl_wait
.exit_ttlwt

ld a,0
ld (playing),a

call srst



;to see the result
.title_loop
	call WAIT_CHAR
	;call KM_READ_CHAR
;	CP #65;s key
;	JP Z, from_title
;	CP #66;f key
;	JP Z, from_title
;	CP #64;d key
;	JP Z, from_title
;	CP #73;s key
;	JP Z, from_title
	CP #20;space
	JP Z, from_title
jp title_loop


.from_title

;still,entions non para,mem adress

ld A,0 ; first level
;dbg
;ld A,7 ; test  level
ld (LVL_NB),A

;DEBUG when ply bad/exit coll , we jump there to restart level
.level_reset

;test init lab pointer
ld IX,level_list  ;right now positioned on first level
;from there we assume ix is on a "step" of the jump table
;TEST go to level 2, we need to advance IX from LVL_CFG_SZ
ld B,0
ld C,LVL_CFG_SZ

.chck_lvl
ld A,(LVL_NB)

.itlvl
cp 0
jp z,lvl_ok
dec A

add IX,BC;lvl + 1

jp itlvl
.lvl_ok

ld A,(IX+LEV_MAP_H)
ld B,A
ld A,(IX+LEV_MAP_L)
ld C,A

push BC
pop HL

;ld HL,lev2_map
ld (current_lab),HL
;ld HL,bad2

ld A,(IX+LEV_BDS_H)
ld B,A
ld A,(IX+LEV_BDS_L)
ld C,A

push BC
pop HL

ld (current_bd_src),HL


;ld HL,lev2_conf
ld A,(IX+LEV_CONF_H)
ld B,A
ld A,(IX+LEV_CONF_L)
ld C,A

push BC
pop HL


ld (current_lvl_conf),HL


;DEBUG TEST testing new col func
;x is half coordinate


;LD A,17
;LD (SCR_X),A
;LD A,8
;LD (SCR_Y),A
;call msk88_to_map_col
;result in A
;ld a,0
;call reset_dmg_map
;ld d,2
;ld e,2
;call exdmg
;END DEBUG TEST


call init_ply_bad



;forcing a full display by setting all map dirty
call clear_screen ;not whole area under map
ld a,1
call reset_dmg_map
call draw_all_damaged_tiles
;ld a,0
;call reset_dmg_map
call draw_ply_bad_gfx
LD D,68 ;x
LD E,4 ;y
LD B,4 ;width ( number of bytes )
LD C,96 ;height
LD IX,title_gfx
call copy_any_size_blit



;end unit
call justswitch
call clear_screen ;not whole area under map
ld a,1
call reset_dmg_map
call draw_all_damaged_tiles
;ld a,0
;call reset_dmg_map
;call draw_ply_bad_gfx

LD D,68 ;x
LD E,4 ;y
LD B,4 ;width ( number of bytes )
LD C,96 ;height
LD IX,title_gfx
call copy_any_size_blit


;MAIN LOOP

;should be drawn on both buffers
;call draw_lab_all_gfx
;wait flyback one time ? maybe one little flicker
;call justswitch
;call draw_lab_all_gfx


;maybe reset timer here? ( first blips will come from setup time )
ld a,0
ld (mod_upd),a

.game_loop

;we always read keyboard to buffer input
;this fw func doesn't work properly from an interrupt
; #?! blocks even if not supposed to
;call KM_READ_CHAR
;jp c,treat_input
;.input_polled; probably not used right now



ld a,(mod_upd)
cp 0
jp z,wait_for_timer

;if there is a model update to consume ( should be a proper while , just testing )
dec a
ld (mod_upd),a


;maybe put a bloc here ( signify no swap explicitely )
;normally set by interrupt but I am not sure
;ld a,0
;ld (buf_avail),a

;we draw damaged tiles from last draw ops to this buffer
;DEBUG COMMENTED
call draw_all_damaged_tiles
ld a,0
;debug test:
;ld a,1
call reset_dmg_map

;this functions now tracks damaged tiles
;DBG COMMENT
call draw_ply_bad_gfx
;we blitted ply and erased 2 coords ago, let's back scr_coords for next time
; ( before game logic overwrite scr p x and scr_bd x
;call back_scr_coords
;we say draw is finished to interrupt routine
;ld a,1
;ld (buf_avail),a
;dbg , test to see if glitching is because of interrupt call
call justswitch

call manage_anim_flag

call update_baddies
call upd_ply_flags_from_input
call moveply
;TODO wictory checked on ennemy pickup ( if last one, won )
;call check_victory
;checking victory here because don't want to mess the stack with jp
ld a,(bad_counter)
cp 0
jp z,level_up

;TODO check ply bad coll ; in step logic now
;call check_ply_bad_col ;not implemented
ld a,(lost_life_flag)
cp 1
jp z,life_lost

.wait_for_timer
jp game_loop

.exit
RET
;END OF MAIN

.manage_anim_flag
;flag has been consumed if generated last cycle
ld A,0
ld (ANIM_CHANGE),A

;we check anim timer, if 0 from last cycle, we reinit and pass message
ld A,(ANIM_TIMER)
cp 0
jp nz,dec_anim_tim

;0 case ! we put up the flag for frame change
ld A,1
ld (ANIM_CHANGE),A

;we manage the "flick" of the anim state
jp set_anim_state
.aft_anim_state

;we reset anim timer
ld A,ANIM_CYCLES
ld (ANIM_TIMER),A
.dec_anim_tim
dec A
ld (ANIM_TIMER),A

ret

;we flick the anim state 1 <-> 2
.set_anim_state
ld A,(ANIM_STATE)
CP 1
jp z,set_second
ld A,1
ld (ANIM_STATE),A
jp exit_anim_state
.set_second
ld A,2
ld (ANIM_STATE),A
.exit_anim_state
jp aft_anim_state

.lost_life_flag db 0

.life_lost
;reset flag
ld a,0
ld (lost_life_flag),a
;so far we just restart level

jp level_reset



.level_up
ld A,(LVL_NB)
;we do increase the lvl nb
inc A

cp WON_LVL_NB 
;if past last level, we go to title / victory
;jp z,title
jp z,won_screen
;if not we jump to level init with new lvl nb

;first inter level
call inter_screen

;then we jump to next level
ld A,(LVL_NB)
;we do increase the lvl nb
inc A
ld (LVL_NB),a
jp level_reset

.subswitch
;reseting flag 
ld a,0
ld (buf_avail),a
.justswitch
;switch screen proper
ld a,(current_base)
;current base becomes visible screen
ld hl,&0000
call mc_screen_offset

;switch to other ref
ld a,(current_base)
cp #40
jp z,to_c

cp #C0
jp z,to_4
;normally never reached, ret in jp
ret

;these 2 functions change the target screen area
;AND the target dmg maps

.to_c
ld a,#C0
ld (current_base),a
;switching dmg map

ld HL,adr_dmg_c0
ld c,(hl)
inc hl
ld b,(hl)
push BC
pop HL
ld (dmg_map),HL
jp switched

.to_4
ld a,#40
ld (current_base),a
;ld HL,dmg_map
;ld (HL),dmg_map40
ld HL,adr_dmg_40
ld c,(hl)
inc hl
ld b,(hl)
push BC
pop HL
ld (dmg_map),HL
jp switched


;called from interrupt only
;called for interrupt, if buf available, switch screens
;and dmg map
.switchscreen
ld a,(buf_avail)
cp 1
jp z,subswitch
.switched
RET

;is the write to back buffer complete ?
.buf_avail
db #00

;current back buffer screen adress
.current_screen 
;db #00,#c0
db #00
.current_base
;db #40
db #C0
;db #C0

;techn, real coord to erase and redraw, maintained by logic
.SCR_PREV_P_X BYTE 0
.SCR_PREV_P_Y BYTE 0
.SCR_P_X BYTE 0
.SCR_P_Y BYTE 0

;weapon
.SCR_WEAP_X BYTE 0
.SCR_WEAP_Y BYTE 0

;fire flag, just passes the message around  
.FIRE_FLAG BYTE 0
.FIRE_ACTIVE BYTE 0 ;needs to be 1 for display, or coll
.FIRE_TIMER BYTE 0 ; hammer only appears for a number of cycles
.FIRE_FACING BYTE RIGHT; which direction ( cosmetic , copied from ply on fire )

;anim
.ANIM_CHANGE BYTE 0; msg passing flag to change anim of everyone when 1
.ANIM_TIMER BYTE 0; number of cycles remaining until change
.ANIM_STATE BYTE 1; can be 1 or 2, global frame indicator for all animated object

;current move speed of ply
;( it is in fact buffered input, name should be changed )
.P_V_X db 0
.P_V_Y db 0
.PLY_IMG_L db 0
.PLY_IMG_H db 0


;current level, used on lvl init -> transition
.LVL_NB db 0

;active,X,Y,pvx,pvy,VX,VY, copied here on lvl init
.baddies RMEM BD_BUF

.dmg_mapc0 RMEM MAP_BYTES
.dmg_map40 RMEM MAP_BYTES

.BD_M_STP db 0 ; global ! all move together

.buf_inp db 0

;we work in a copy not to get interrupted
.input_treated db 0

read "set_timer_interrupt.asm"
read "levels.asm"
read "walkable_moveply.asm"
;read "Txt_display.asm"
read "gfx_display.asm"
read "Baddieia.asm"
read "ply_step_logic.asm"
read "slow_clear_screen.asm"
read "collision.asm"
read "inter_screen.asm"
read "sounds.asm"

.mod_upd db 0


.bad_counter db 0 ;incremented on level init, decreased when a baddie is picked up; victory condition

.init_ply_bad

	;inactivating hammer
	ld A,0
	ld (FIRE_ACTIVE),A	

	ld A,ANIM_CYCLES
	ld (ANIM_TIMER),A

	;ply pic
	;setting pickup img
	ld BC,img_ply1_l
	ld A,B
	ld (PLY_IMG_H),A
	ld A,C
	ld (PLY_IMG_L),A




;ply pos first
	LD IX,(current_lvl_conf)
	LD A,(IX+INI_PX)
	;LD (MZ_P_X),A
	;SCR_X alwys /2
	SLA A
	SLA A
	LD (SCR_P_X),A
	;not used but glitch if removed
	LD (SCR_PREV_P_X),A

	LD A,(IX+INI_PY)
	;LD (MZ_P_Y),A
	SLA A
	SLA A
	SLA A
	LD (SCR_P_Y),A
	;not used but glitch if removed
	LD (SCR_PREV_P_Y),A

	

	;filling ennemies area with 00s
	; active x y vx vy 
	LD B,BD_BUF
	LD HL,baddies
	.reset_ennemies
	LD (HL),0
	INC HL
	DJNZ reset_ennemies
	
	ld A,0
	ld (bad_counter),A


;use LDIR to copy ennemy by ennemy until first ( active ) byte is 0
	LD HL,(current_bd_src)
	LD DE,baddies


	.copy_baddy
	;we are adding one ennemy, setting up ennemy counter ( for win )
	ld A,(bad_counter)
	inc a
	ld (bad_counter),a

	LD C,BD_SIZE
	LD B,0
		
	DI
	LDIR 

	EI

	;HL pointer is on first slot of next row
	;? active

	LD A,(HL)
	CP 1
	JP Z,copy_baddy	
	
RET


;TODO redo with direct hw acc
;.treat_input

	;char is in A

;	ld (buf_inp),a

	;debug purpose
;	call CONOUT	
.measure ; just to see bin size
;jp input_polled


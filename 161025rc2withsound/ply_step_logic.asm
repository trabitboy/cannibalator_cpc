;instruction buffered in p_vx, p_vy
;TODO state logic ( jump, walk, fall )
;( jump = fall ? ) 

;start walking, if walking state just keep left or right vx
;if jump, keep vx vor duration of jump
;make jump super quick to begin with ( like instant )
;if end of jump in void > fall state, else walk state

;player pos in labyrinth( scaled down )
.TGT_SCR_X BYTE 0
.TGT_SCR_Y BYTE 0

.X_TILE_COORDS BYTE 0
.Y_TILE_COORDS BYTE 0

.not_tc_x
LD A,0
LD (X_TILE_COORDS),A
jp aft_tc_x

.not_tc_y
LD A,0
LD (Y_TILE_COORDS),A
jp aft_tc_y


WALK equ 0
JUMP equ 0
FALL equ 0
; current player state, default walk state
.P_STATE BYTE 0


.execute_jump
LD A,0
LD (P_V_X),A
LD (P_V_Y),A
; we consume this input and execute jump
LD A,(SCR_P_Y)
LD B,16
SUB B
LD (SCR_P_Y),A
jp after_state_filtering


;we look if ceiling is traversible, and if target is empty,
;if yes we go to jump state and reset jump "timer"
.JUMP_OK Byte 0
.assess_jump
;to begin with nothing blocking
;TODO if simplified jump stays, JUMP_OK not necessary
LD A,0
LD (JUMP_OK),A

;we need to check the 1 tile on top, and next one if x not div by 8
;they should be t ( or empty ? )
LD A,(SCR_P_X)
LD (SCR_X),A
LD A,(SCR_P_Y)
;we need to remove 8 to go up one tile
LD B,16
SUB B
LD (SCR_Y),A
call msk88_to_map_col
;result in A
;TODO assess jumps into walls ?

;we need to assess the 1 or 2 tiles toptop destination to see if empty/ valid target

;if yes we set state to jump, reset vx and vy
;TODO we jump in one go not switching state
cp 0
jp z,execute_jump

jp after_state_filtering

;execute fall
.execute_fall
LD A,0
LD (P_V_X),A
LD (P_V_Y),A
; we consume this input and execute jump
LD A,(SCR_P_Y)
LD B,8
ADD B
LD (SCR_P_Y),A
;if we fall we do nothing else
jp after_state_filtering

;fall check
.fall_check

LD A,(SCR_P_X)
LD (SCR_X),A
LD A,(SCR_P_Y)
;we need to add 8 to go up one tile
LD B,8
ADD B
LD (SCR_Y),A
call msk88_to_map_col
;result in A
cp 0
jp z,execute_fall

;if not we do other walk checks
jp aft_fall_check


;MAIN WALK METHOD
.walk_filter

;we flick animation if necessary
jp flick_ply
.aft_flick_ply


;if WALK check below for fall
jp fall_check

.aft_fall_check
;if WALK y speed can only be -1, which goes to JUMP state
;you can only go to jump state if block on top is empty or traversable
LD A,(P_V_Y)
CP A,-1
jp z,assess_jump

jp after_state_filtering
;walk_filter end


.left_fire
	ld A,(SCR_P_X)
	;debug
	ld B,4
	sub B
	ld (SCR_WEAP_X),A
jp after_x_fire

;we take the buffered fire input and position/enable fire
.enable_fire
	ld A,0
	ld (FIRE_FLAG),A

	;active flag for disply
	ld A,1
	ld (FIRE_ACTIVE),A


	;we copy the currently faced direction, to blit correct pic
	ld A,(FACING)
	ld (FIRE_FACING),A

	;we display this time
	ld A,FIRE_CYCLES
	ld (FIRE_TIMER),A	

	ld A,(SCR_P_Y)
	ld (SCR_WEAP_Y),A
	ld A,(FACING)
	cp A,LEFT
	jp z,left_fire
	ld A,(SCR_P_X)
	;debug
	ld B,4
	add B
	ld (SCR_WEAP_X),A
	.after_x_fire

jp after_enable_fire


.disable_fire
ld A,0
ld (FIRE_ACTIVE),A
jp aft_fire_timer_dec


.moveply

LD A,(P_STATE)
CP A,WALK
JP Z,walk_filter


;if JUMP STATE we erase input with vy -1 until end of jump
;if end of jump we check if FALL or GROUND again

;we might not need all the stuff below


;TODO normally not necessary anymore with new sub states, remove
.after_state_filtering


call check_ply_bad_col
;there is 1 in A if col
ld (lost_life_flag),a
;TODO change state to fall before life lost flag, 
; but prototyping


;conversion of target coord to grid coord

;at the mo we can fire in any state
LD A,(FIRE_FLAG)
CP 1
jp z,enable_fire

.after_enable_fire

;we manage time out of hammer blow
ld A,(FIRE_TIMER)
cp 0 ; if already 0 nothing to decrease, disable
jp z,aft_fire_timer_dec

dec a
ld (FIRE_TIMER),A
cp 0 ; if now we are 0 after decrease
; we need to disable fire ( timer exhausted )
jp z,disable_fire
.aft_fire_timer_dec


;TODO we need to extract this logic in function that get scr x scr y as input


;TST DBG
;LD A,(P_V_X)
;LD B,A
;LD A,(SCR_P_X)
;ADD A,B
;LD (TGT_SCR_X),A
;LD A,(P_V_Y)
;SLA A ;increment is 2 px vert )
;LD B,A
;LD A,(SCR_P_Y)
;ADD A,B
;LD (TGT_SCR_Y),A
;END TST DBG

;WIP following logic is duplicated in states,
; kinda commenting test here ( remove if works)
;161018 without this test jumping in double wall puts 
;player in the ground , maybe disable flag for fall state?

;jp dbg_skip_tst
LD A,1
LD (X_TILE_COORDS),A

LD A,(P_V_X)
LD B,A

LD A,(SCR_P_X)
ADD A,B
LD (TGT_SCR_X),A
;we need to know if divisible by 4
;by default we say it is
BIT 0,A
JP NZ,not_tc_x
BIT 1,A
JP NZ,not_tc_x

.aft_tc_x
LD A,(TGT_SCR_X)
;TODO SLA AND RLA MULTIPLY by 2 ???
SRA A
SRA A; dividing x coords to get maze map coords
LD D,A ;MP X in D
 
;if vx == 1 and we are not just on a tile( coord div by 4 ), we need to add 1 for target, pb for just on the spot ?
LD A,B
CP A,1
jp nz,x_treated

;additional check to see if we are just on tile ( coords just divisible by tile map )
ld a,(X_TILE_COORDS)
cp a,1
JP Z,x_treated ;we are on tile coords, we do not adjust

;we need to add 1 if here
ld A,D
inc A
ld D,A
.x_treated

LD A,1
LD (Y_TILE_COORDS),A

LD A,(P_V_Y)
SLA A ;increment is 2 px vert )
LD B,A

LD A,(SCR_P_Y)
ADD A,B
LD (TGT_SCR_Y),A
;we need to know if divisible by 8
;by default we say it is
BIT 0,A
JP NZ,not_tc_y
BIT 1,A
JP NZ,not_tc_y
BIT 2,A
JP NZ,not_tc_y

.aft_tc_y
LD A,(TGT_SCR_Y)
;TODO SLA AND RLA MULTIPLY by 2 ???

SRA A 
SRA A 
SRA A
LD E,A ; MP X in E

;if vy == 2, (because of shift higher) we need to add 1 for target, pb for just on the spot ?
LD A,B
CP A,2
jp nz,y_treated
;additional check to see if we are just on tile ( coords just divisible by tile map )
ld a,(Y_TILE_COORDS)
cp a,1
JP Z,y_treated ;we are on tile coords, we do not adjust
;we need to add 1 if here
ld A,E
inc A
ld E,A
.y_treated


;TODO call walkable and jump conditionally
;TODO we should check next block, not current, ( we are already there )
call walkable

cp A,1
jp z,reset_speed
.dbg_skip_tst

;if no blocking coll
.commit_move
;TODO assuming tgt still in D and E
LD A,(TGT_SCR_X)
LD (SCR_P_X),A
LD A,(TGT_SCR_Y)
LD (SCR_P_Y),A

;reset speed
.reset_speed
LD A,0
LD (P_V_X),A

LD (P_V_Y),A

ret
;###




;TODO vu que plus de notion de directionalite,
;TODO si pas exactement sur tile faut faire walkable x et walkable x+1
;parameter in SCR , return in a
;collision from scr x scr y to tile map,
;returns 1 if x + 8 y + 8 touches a non traversable tile
;parameters:
.SCR_X BYTE 0
.SCR_Y BYTE 0
;local vars
.ISX_TILE_COORDS BYTE 0
;TODO not used yet
.ISY_TILE_COORDS BYTE 0
.BUF_RET BYTE 0

.gnot_tc_x
LD A,0
LD (ISX_TILE_COORDS),A
jp gaft_tc_x

.gnot_tc_y
LD A,0
LD (ISY_TILE_COORDS),A
jp gaft_tc_y


.msk88_to_map_col
LD A,1
LD (ISX_TILE_COORDS),A

LD A,(SCR_X)
;we need to know if divisible by 4
;by default we say it is
BIT 0,A
JP NZ,gnot_tc_x
BIT 1,A
JP NZ,gnot_tc_x

.gaft_tc_x
LD A,(SCR_X)
SRA A
SRA A; dividing x coords to get maze map coords
LD D,A ;MP X in D
 
;LD A,(SCR_Y)
;we need to know if divisible by 8
;by default we say it is
;BIT 0,A
;JP NZ,gnot_tc_y
;BIT 1,A
;JP NZ,gnot_tc_y
;BIT 2,A
;JP NZ,gnot_tc_y
.gaft_tc_y

LD A,(SCR_Y)


SRA A 
SRA A 
SRA A
LD E,A ; MP Y in E

call walkable ;check for xy

;DE restored
LD (BUF_RET),A
LD A,(ISX_TILE_COORDS)
CP A,1
JP Z,gaft_x
;if not x tile coord we need to check x + 1 y
INC D
call walkable ; check for x+1 y
LD B,A
LD A,(BUF_RET)
or b
ld (BUF_RET),A
;current ret is in a
;we need to and the result
.gaft_x

;TODO if y not tile coord we need to do something too
;collisiont is in a ? not sure
ld A,(BUF_RET)
ret
;# END collision scr x scr y to tilemap


.flick_ply
ld a,(ANIM_CHANGE)
cp 1
jp z,change_ply
jp aft_flick_ply

;flag is up, we change the picture of player based on left / right 
.change_ply
ld a,(facing)
cp RIGHT
;jp z,set_frame_right
call z,set_frame_right

ld a,(facing) ;if was right, will do nothing
cp LEFT
;other wise we set frame left
;jp set_frame_left
call z,set_frame_left

jp aft_flick_ply
;end

;set ply anim frame based on anim counter
.set_frame_right
	ld A,(ANIM_STATE)
	CP 2; if 2 we go set frame 2
	jp z,fr2
	ld BC,img_ply1_r
	jp push_bc_to_ply_frame
	.fr2
	ld BC,img_ply2_r
	jp push_bc_to_ply_frame

;set ply anim frame based on anim counter
.set_frame_left
	ld A,(ANIM_STATE)
	CP 2; if 2 we go set frame 2
	jp z,fl2
	ld BC,img_ply1_l
	jp push_bc_to_ply_frame
	.fl2
	ld BC,img_ply2_l
	jp push_bc_to_ply_frame

jp push_bc_to_ply_frame

.push_bc_to_ply_frame
	ld A,B
	ld (PLY_IMG_H),A
	ld A,C
	ld (PLY_IMG_L),A
	ret
;	jp aft_flick_ply
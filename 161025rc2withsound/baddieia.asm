;moves baddies nd updte their speed
.update_baddies



	LD HL,baddies
	LD B,BD_BUF ;length of baddies chunck, we shall not check further

	.ia_check_bad
	;exit check on inactive
	LD A,(HL)
	CP 0
	JP Z,ia_next_bad
	;here we do treatment then we are on next bad
		
		;locally we use BC and HL
		push BC
		push HL
		;the subroutine preserves HL 
		call single_baddie_upd
		pop HL
		pop BC

	;runs into ia_next_bad

	.ia_next_bad
	LD D,0
	LD E,BD_SIZE
	ADD HL,DE
	;we are on next "active" slot only if we didn't go too far
	LD A,B
	SUB A,BD_SIZE
	LD B,A
	CP 0   ; is the memory 0 even after inited baddies ????????
	JP Z,exit_bad_ia ;we finished baddy array
	JP ia_check_bad
	.exit_bad_ia

RET

;applies speed and check coll for next big step
;if result not walkable, invert speed 
;parameter is HL ( baddie struct ) , preserved
;CORRUPTS IX, AF, BC , DE
.single_baddie_upd

	;to copy to ix
	PUSH HL
	POP IX	

	LD H,(IX+BD_STATE_H)
	LD L,(IX+BD_STATE_L)

	;TODO get adress from struct
;	jp bd_walk_state
	jp (HL)	

	.exit_ifbw

RET



;#### BEGIN normal baddy walk state
.bd_walk_state

	;in this state anim is flicking
	jp flick_bad
	.aft_flick_bad

	;we check if collision with player weapon
	ld a,(FIRE_ACTIVE)
	cp 1;we only check coll if fire is active
	jp z,weap_check
	.aft_weap_check	

	;vx
	LD B,(IX+BD_VX)
	;vy
	;LD C,(IX+BD_VY)

	; manage SCR_BD_X SCR_BD_Y
	; let's calculate target x,
	;and check if target is falling position
	;( means turn around )
	
	LD A,(IX+SCR_BD_X)
	ADD B
	;feeding params of coll function )
	LD (SCR_X),A
	
	;we check the squares below
	LD A,(IX+SCR_BD_Y)
	LD B,8
	ADD B
	LD (SCR_Y),A

	;we call coll
	call msk88_to_map_col

	CP A,1
	
	;if coll ok we execute move
	;DEBUG simple test
	jp z, commit_bad

	;jp  commit_bad


	;if not we reverse x speed then commit
	LD A,(IX+BD_VX)
	NEG
	LD (IX+BD_VX),A
	jp commit_bad


jp exit_ifbw


;##
.commit_bad
	LD A,(IX+SCR_BD_X)
	LD B,(IX+BD_VX)
	ADD B
	LD (IX+SCR_BD_X),A

jp exit_ifbw

;baddie gets stunned 
.baddie_hit

jp exit_ifbw

.weap_check
	;TODO maybe y not exactly the same 
;	LD B,(IX+SCR_BD_X)
;	LD A,(SCR_WEAP_X)

ld A,(ix+scr_bd_x)
ld (coll_x1),a
ld A,(ix+scr_bd_y)
ld (coll_y1),a
ld A,(scr_weap_x)
ld (coll_x2),a
ld A,(scr_weap_y)
ld (coll_y2),a

call collision88
cp A,1
jp z,bad_hit


jp aft_weap_check



.bad_hit


;let's initialize stun counter
ld A,STUN_CYCLES
ld (IX+BD_STUN_WAIT),A

ld HL,bdstun
;TODO make ennemy stun
;TODO transition to stun ennemy state
ld (IX+BD_STATE_H),h
ld (IX+BD_STATE_L),l

;setting pickup img
ld HL,img_pickup
ld (IX+BD_IMG_H),H
ld (IX+BD_IMG_L),L
;jp aft_weap_check

;dmg flat
ld a,0
ld (IX+BD_DMG),a


jp exit_ifbw

;#### END normal baddy walk state

;### BEGIN stun

.bd_back_to_walk
ld HL,bd_walk_state
ld (IX+BD_STATE_H),h
ld (IX+BD_STATE_L),l

;setting img
ld HL,img_chick1
ld (IX+BD_IMG_H),H
ld (IX+BD_IMG_L),L
;dmg flat
ld a,1
ld (IX+BD_DMG),a
jp exit_ifbw


.bdstun

;TODO dec counter and go back to state if not picked
ld a,(IX+BD_STUN_WAIT)
dec a
cp 0
jp z,bd_back_to_walk

;otherwise we continue
ld (IX+BD_STUN_WAIT),a

;TODO if ply coll go to fall from screen
ld A,(ix+scr_bd_x)
ld (coll_x1),a
ld A,(ix+scr_bd_y)
ld (coll_y1),a
ld A,(scr_p_x)
ld (coll_x2),a
ld A,(scr_p_y)
ld (coll_y2),a

call collision88
cp A,1
jp z,to_bad_fall


jp exit_ifbw

.to_bad_fall

push ix

ld hl,pickup
call sqe

pop ix

ld HL,bd_fall
ld (IX+BD_STATE_H),h
ld (IX+BD_STATE_L),l

;setting img
ld HL,img_bone
ld (IX+BD_IMG_H),H
ld (IX+BD_IMG_L),L



jp exit_ifbw

;### END stun

;### BEGIN fall
.bd_fall

ld A,(IX+scr_bd_y)

cp a,90
jp nc,to_inactive ;> to TODO not sure c or nc
ld b,4
add b
ld (IX+scr_bd_y),a

jp exit_ifbw
;### END fall

;### beg inactive

.to_inactive
ld HL,bd_inact
ld (IX+BD_STATE_H),h
ld (IX+BD_STATE_L),l

;changing vic counter
ld a,(bad_counter)
dec a
ld (bad_counter),a

jp exit_ifbw

.bd_inact

jp exit_ifbw


;### end inactive

;animation code,baddie struc in IX
.flick_bad
ld a,(ANIM_CHANGE)
cp 1
jp z,set_frame_bad
jp aft_flick_bad

.set_frame_bad
	ld A,(ANIM_STATE)
	CP 2; if 2 we go set frame 2
	jp z,bfr2
	ld BC,img_chick1
	jp push_bc_to_bad_frame
	.bfr2
	ld BC,img_chick2
	jp push_bc_to_bad_frame

.push_bc_to_bad_frame
	ld A,B
	ld (IX+BD_IMG_H),A
	ld A,C
	ld (IX+BD_IMG_L),A
	jp aft_flick_bad
	
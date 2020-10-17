

;dependency
read "copy_8_8_sprite.asm"
read "copy_any_size.asm"
read "setpal.asm"
read "gfxdata.asm"
read "title_gfx.asm"

;uses the current dmg map set,
;it restores the tiles flagged in it
.draw_all_damaged_tiles
ld hl,(dmg_map)
ld d,0 ;x
ld e,0 ;y
;we curse the damage map keeping track of x and y,
;when we encounter a 1 = damage, we blit
.iterate

ld a,(HL)
cp 1
call z,blit_tile ;we actually blit the 
;TODO sub routine that gets the correct image 
; to be blitted


;TODO exit condition
inc hl
inc d
ld a,d
cp a,L_W
jp z,res_col
.aft_col_check
ld a,e
cp a,L_H
jp nz,iterate

ret

.res_col
ld a,0
ld d,a
inc e
jp aft_col_check

.bt_img_clear
	LD IX,img_clear
jp bt_img_set

;x in d, y in e,
; gets image from current tile map
.blit_tile
push HL
	ld HL,(current_lab)
	;we need to advance on x 
	ld b,0
	ld c,d
	add hl,bc
;we need to add rows
	ld c,L_W
	ld a,e; last line already treated we don't add one
	.bt_loop	
	add hl,bc
	dec a
	cp a,0
	jp nz,bt_loop

	;hl is on current tile data
	ld a,(hl)

	;tile def in hl, x in d, y in e,
	;TODO mutualize blit
	CP A,' '
	JP Z,bt_img_clear
	LD IX,img_wall
	.bt_img_set
		push de ;might not be necessary
		;calculate x
		LD A,d
		;multiply by 4
		SLA A
		SLA A

		LD D,A ;screen x/2  is in D (mode 0 pixel format )

		;calculate y
		LD A,E
		;multiply by 8
		SLA A
		SLA A
		SLA A

		LD E,A ;screen y is in E
		
		;TODO preset earlier to clean also empty
		;which gfx is needed
		;		LD IX,img_wall

		push BC
		push HL
		call copy_8_8_blit
		pop HL
		pop BC

		pop de ;might not be necessary


pop HL
ret



;probably dead code
.draw_lab_all_gfx

	LD B,L_H

	LD A,0

	.gfx_row_loop

	push AF
	push BC

	;PARAM PASS
	LD E,A
	call draw_lab_line_gfx
	
	pop BC
	pop AF

	INC A
	DJNZ gfx_row_loop	

	;TODO also draw key
	LD IX,(current_lvl_conf)
	LD A,(IX+KEY_X)	
	SLA A
	SLA A
	LD D,A	

	LD A,(IX+KEY_Y)	
	SLA A 
	SLA A
	SLA A
	LD E,A
;	LD IX,img_key

;	call copy_8_8_blit
	;very last blit, not preserving ath	
RET



;unoptimized > storing d and e here while passing to real screen coord
.cur_row_num BYTE 0
.cur_col_num BYTE 0

;draws one line reading memory of current_lab, row is in E
;corrupts BC HL AF DE
.draw_lab_line_gfx

	LD HL,(current_lab)

	;calculate line offset in the matrix ( D * lab_w ) then add to HL
	;probably easier to add lab_w until D reached, using accumulator?
	LD B,0
	LD C,L_W

	LD A,0
	.while_gfx_lnr	
	CP E 
	JP Z, end_while_gfx_lnr
	;actual work
	ADD HL,BC
	INC A
	JP while_gfx_lnr
	.end_while_gfx_lnr

	;matrix y is in E
	LD D,0 ;matrix x is in D
	
	;data will be restored from here for calculation at each step of loop
	LD A,D
	LD (cur_col_num),A
	LD A,E
	LD (cur_row_num),A

	LD B, L_W
;incrementing HL and decrementing B til lab line is traversed 
	.gfx_col_loop
	LD A,(HL)
	;WARNING duplicated in blit tile
	CP A,' '
	JP Z,set_img_clear
	CP A,'t'
	JP Z,set_img_traversable
	LD IX,img_wall
	.lab_img_set
		;calculate x
		LD A,(cur_col_num)
		;multiply by 4
		SLA A
		SLA A

		LD D,A ;screen x/2  is in D (mode 0 pixel format )

		;calculate y
		LD A,(cur_row_num)
		;multiply by 8
		SLA A
		SLA A
		SLA A

		LD E,A ;screen y is in E
		
		;TODO preset earlier to clean also empty
		;which gfx is needed
		;		LD IX,img_wall

		push BC
		push HL
		call copy_8_8_blit
		pop HL
		pop BC

;	.skip_wall_display
	;incrementing x matrix
	LD A,(cur_col_num)
	INC A
	LD (cur_col_num),A

	INC HL
	DJNZ gfx_col_loop

RET

;TODO add drawing of traversable platform as a 'case'

;### draw lab line sub
.set_img_traversable
	LD IX,img_door
jp lab_img_set
.set_img_clear
	LD IX,img_clear
jp lab_img_set
;###

.draw_ply_bad_gfx


	;we only blit if active
	ld a,(FIRE_ACTIVE)
	cp a,0 ; if not active we jump
	jp z,aft_weap_blit


	;we blit either right image or left image of weapon
	ld a,(FIRE_FACING)
	cp RIGHT
	jp z,load_right
	;load left
	ld IX,img_hammer_l
	jp aft_weap_img_load
	.load_right
	ld IX,img_hammer_r
	.aft_weap_img_load

	LD A,(SCR_WEAP_X)
	LD D,A ;screen x/2  is in D (mode 0 pixel format )
	LD A,(SCR_WEAP_Y)
	LD E,A ;screen y is in E
;	LD IX,img_key
		push BC;TODO popping not necessary?
		push HL
		call copy_8_8_blit
		pop HL
		pop BC

	; x y still in d and e ( preserved )
	;corrupts hl
	push hl
	push bc
	call exdmg
	pop bc
	pop hl

	.aft_weap_blit


	LD A,(SCR_P_X)
	LD D,A ;screen x/2  is in D (mode 0 pixel format )
	LD A,(SCR_P_Y)
	LD E,A ;screen y is in E

		push BC
 
		ld A,(PLY_IMG_H)
		ld B,A
		ld A,(PLY_IMG_L)
		ld C,A
		push BC
		pop IX

		pop BC



		;LD IX,img_ply1_r
		push BC;TODO popping not necessary?
		push HL
		call copy_8_8_blit
		pop HL
		pop BC

	push hl
	push bc
	call exdmg
	pop bc
	pop hl



	;draw baddies cursing data
	LD HL,baddies	
	LD B,BD_BUF ;length of baddies chunck, we shall not check further

	.check_bad_gfx
	;exit check

	PUSH HL
	POP IX

	LD A,(IX+BD_ACTIVE)
	CP 0
	JP Z,next_bad_gfx
	;here we do treatment then we are on next bad


	;x
	LD A,(IX+SCR_BD_X) 
	LD D,A ;screen x/2  is in D (mode 0 pixel format )
	LD A,(IX+SCR_BD_Y)
	LD E,A ;screen y is in E
	; we can display!
	push IX
		;TODO according to baddie state pointer, blit different pic
		;TODO or maybe maintain pic in struct

		push HL 

		ld L,(IX+BD_IMG_L)
		ld H,(IX+BD_IMG_H)
		push HL
		pop IX
;		LD IX,img_bad

		pop HL

		;TODO everything seems preserved in
		;routine
		push DE
		push BC
		push HL
		call copy_8_8_blit
		pop HL
		pop BC
		pop DE
	pop IX
	; x y still in d and e ( preserved )
	;corrupts hl
	push hl
	push bc
	call exdmg
	pop bc
	pop hl
	;we run into next_bad, which advances HL

	.next_bad_gfx
	LD D,0
	LD E,BD_SIZE
	ADD HL,DE
	;we are on next "active" slot only if we didn't go too far
	LD A,B
	SUB A,BD_SIZE
	LD B,A
	CP 0
	JP Z,exit_bad_display_gfx ;we finished baddy array
	JP check_bad_gfx
	.exit_bad_display_gfx

RET



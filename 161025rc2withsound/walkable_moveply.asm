
;parameters are passed in DE
;return is in A, boolean 0 (walkable, traversable) or 1 (wall)
.walkable
PUSH HL
PUSH BC
PUSH DE
;we need to curse the labyrinth memory to go at 
;the slot of the coordinates x(D) y (E), and compare with "space" hex code


;first we add x
LD HL,(current_lab)
LD B,0
LD C,D
ADD HL,BC

;PB WITH B=0
;now we need to have line width up to y
LD A,E
CP 0
JP Z,b_0_case

;b is more than 0
LD B,E
;we add line width until B is 0
LD D,0
LD E,L_W
.add_width
ADD HL,DE
DJNZ add_width

.b_0_case

;HL points to the slot we try to walk to
LD A,(HL)
;comparing to space character ( that is walkable)
CP #20
JP Z,ret_walkable

;comparing to traversable platform
CP 't'
;TODO eventually condition the traversable  to parameter
JP Z,ret_walkable

;otherwise not walkable
LD A,1
JP exit_walkable

;by default walkable
.ret_walkable
LD A,0

.exit_walkable
POP DE
POP BC 
POP HL
RET
;WE ALWAYS ASSUME LAST STEP IS NOT WALKABLE
;( we do not check we are in the grid )




;sub parts of move_ply
.facing db RIGHT
.inc_px
	;ply pic
	;setting pickup img
;	ld BC,img_ply1_r
;	ld A,B
;	ld (PLY_IMG_H),A
;	ld A,C
;	ld (PLY_IMG_L),A


	LD A,RIGHT
	LD (facing),A

	call set_frame_right


	LD A,1
	LD (P_V_X),A
	LD A,0
	LD (P_V_Y),A
JP exit_upd_flags_ply

;.inc_py
;	LD A,0
;	LD (P_V_X),A
;	LD A,1
;	LD (P_V_Y),A
;JP exit_upd_flags_ply

.dec_px

	;ply pic
	;setting pickup img
;	ld BC,img_ply1_l
;	ld A,B
;	ld (PLY_IMG_H),A
;	ld A,C
;	ld (PLY_IMG_L),A


	LD A,LEFT
	LD (facing),A
	
	call set_frame_left

	LD A,-1
	LD (P_V_X),A
	LD A,0
	LD (P_V_Y),A
JP exit_upd_flags_ply

.dec_py
	LD A,0
	LD (P_V_X),A
	LD A,-1
	LD (P_V_Y),A
JP exit_upd_flags_ply

.set_fire_flag
	LD A,1
	ld (FIRE_FLAG),A
	push ix
	ld hl,hammer
	call sqe
	pop ix
JP exit_upd_flags_ply


;polls keyboard and move ply accordingly
.upd_ply_flags_from_input

	;TODO change to read buffered input fed from interrupt

	;for some reason wiat is not blocking since I use fw interrupt,
	;AND READ IS !
	call WAIT_CHAR
	;TODO maybe space press should not jump to exit afterwards
	cp #20;space
	JP Z,set_fire_flag
;	CP #65;s key
	CP #64;e key
	JP Z, dec_py 
	CP #66;f key
	JP Z, inc_px 
;	CP #64;e key
;	JP Z, inc_py
	CP #73;s key
	JP Z, dec_px
.exit_upd_flags_ply
RET


.zeroes_lvl
ld A,0
ld (LVL_NB),A
call clear_screen
;TODO game over
jp title

;sub part where we check x coll for one baddie
.one_bd_col
ld A,(ix+scr_bd_x)
ld (coll_x1),a
ld A,(ix+scr_bd_y)
ld (coll_y1),a
ld A,(scr_p_x)
ld (coll_x2),a
ld A,(scr_p_y)
ld (coll_y2),a

;test on coll pb
;push ix

;cracra , external iterator uses b that is corrupted 
;in coll88
push bc
call collision88
pop bc
;pop ix

cp A,1
;jp z,at_least_one_hit
jp z,dbg_hit

;else
jp check_next_bd

.dbg_hit
;just for breakpoint
;in fact we need to check if baddy is in damage state
ld a,(IX+BD_DMG)
cp 0
jp z,check_next_bd ;if not damage state we jump
;other wise a is 1, we escape with 1

;not sure necessary, late 
;push ix
ld hl,death
call sqe
;pop ix

;return value indicating hit
ld a,1
jp at_least_one_hit

;to propagate in state,
;should be called from ply state managment
;checks collisions of player with baddies,
; on collision life lost, level restart / game over
;ret in A, 1 if coll
.check_ply_bad_col

LD HL,baddies
;incorrect, we iterate on non reset memory
;normally memory reset on level init?
LD B,BD_TOTAL

.check_one_baddie
;copying HL in IX for struct managment
PUSH HL
POP IX
LD A,(IX+BD_ACTIVE)
CP 1
;if baddie active we compare x and y
JP Z,one_bd_col


.check_next_bd
;else we decrement b and jumb back
LD D,0
LD E,BD_SIZE
ADD HL,DE
DJNZ check_one_baddie

;exit label ( might not be needed ? since goto for level restart ) 
.no_ply_bad_col_exit
ld A,0
.at_least_one_hit ;if we jump here 1 is in A
RET
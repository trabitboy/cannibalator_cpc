
.draw_lab_all_txt

	call TXT_CLR_WDW

	LD B,L_H
	LD C,0

	LD A,0

	.row_loop
	LD DE,00 ;DE corrupted by sub routine
	LD D,A
	;just pushing the parameter will mess the RET ( needs to be consumed )
	PUSH DE ; parameter pass
	call draw_lab_line
	
	INC A
	DJNZ row_loop	


	;also draw key
	LD IX,(current_lvl_conf)
	LD D,(IX+KEY_X)	
	LD E,(IX+KEY_Y)	
	LD A,'y'
	call drw_with_offset
	
	
RET

;gloval var adr( store return address while PUSHING registers to preserve )
.ret_adr WORD 00
.param_dll WORD 00
;NOT RECURSIVE
;CORRUPTS DE
;draws one line reading memory
.draw_lab_line
	;preserving RET adress
	POP DE
	LD (ret_adr),DE

	;we need to take the parameter  before stacking to preserve
	POP DE
	LD (param_dll),DE

	PUSH HL
	PUSH AF
	PUSH BC 
	
	;now we can work

	;we need the line number ( in D )
	LD DE,(param_dll)	


	;position cursor at beginning of line D

	LD A,X_BEG_OFFSET
	CALL TXT_SET_COL
	LD A,D
	ADD A,Y_BEG_OFFSET
	CALL TXT_SET_ROW

	;LD HL,level_test16_16
	LD HL,(current_lab)

	;calculate line offset in the matrix ( D * lab_w ) then add to HL
	;probably easier to add lab_w until D reached, using accumulator?
	LD B,0
	LD C,L_W

	LD A,0
	.while_lnr	
	;TODO cp is just true all the time ??? debug
	CP D 
	JP Z, end_while_lnr
	;actual work
	ADD HL,BC
	INC A
	JP while_lnr
	.end_while_lnr
	

	LD B, L_W
;incrementing HL and decrementing B til lab line is traversed 
	.col_loop
	LD A,(HL)
	call CONOUT
	INC HL
	DJNZ col_loop

	POP BC
	POP AF
	POP HL

	;restoring ret adress
	LD DE,(ret_adr)	
	PUSH DE
RET

.draw_ply_bad_txt

;drawing exit each time as it can be "erased" by player
	;also draw exit
	LD IX,(current_lvl_conf)
	LD D,(IX+EXIT_X)	
	LD E,(IX+EXIT_Y)	
	LD A,'#'
	call drw_with_offset

;erasing then drawing player
	LD A,(PREV_P_X) ;TODO is it the right adressing mode?
	LD D,A
	LD A,(PREV_P_Y)
	LD E,A
	LD A,' '
	call drw_with_offset

	LD A,(P_X)
	LD D,A
	LD A,(P_Y)
	LD E,A
	LD A,'o'
	call drw_with_offset


	;draw baddies cursing data
	LD HL,baddies	
	LD B,BD_BUF ;length of baddies chunck, we shall not check further

	.check_bad
	;exit check

	PUSH HL
	POP IX

	LD A,(IX+BD_ACTIVE)
	CP 0
	JP Z,next_bad
	;here we do treatment then we are on next bad

	;PB loop with IX, as we need to clear BEFORE draw	
	;prev x
	LD D,(IX+PREV_BD_X) 
	;prev y
	LD E,(IX+PREV_BD_Y) 
	;clear prev
	LD A,' '
	PUSH HL
	PUSH IX
	call drw_with_offset
	POP IX
	POP HL

	;x
	LD D,(IX+BD_X) 
	;y
	LD E,(IX+BD_Y)
	; we can display!
	LD A,'i'
	;fw funcs kill HL
	PUSH HL
	PUSH IX
	call drw_with_offset
	POP IX
	POP HL

	;we run into next_bad, which advances HL

	.next_bad
	LD D,0
	LD E,BD_SIZE
	ADD HL,DE
	;we are on next "active" slot only if we didn't go too far
	LD A,B
	SUB A,BD_SIZE
	LD B,A
	CP 0
	JP Z,exit_bad_display ;we finished baddy array
	JP check_bad
	.exit_bad_display

RET

;draws char with offset
;D,E as params
;corrupts A
;A is char to be drawn
.drw_with_offset

	;we need extra var 
	PUSH BC
	LD B,A ;saving for after calculation

	ld A,D
	ADD A,X_BEG_OFFSET
	CALL TXT_SET_COL
	ld A,E
	ADD A,Y_BEG_OFFSET
	CALL TXT_SET_ROW
	ld A,B
	CALL CONOUT

	POP BC
RET

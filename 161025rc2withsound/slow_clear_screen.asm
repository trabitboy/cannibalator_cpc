;slow clear screen ( in between levels )
;clear allscreens by 8x8 blocks ( pretty bad )
.slow_clear_screen

;	LD A,(SCR_PREV_P_X) ;TODO OPTIMIZE WITH FASTER ERASE
;	LD D,A ;screen x/2  is in D (mode 0 pixel format )
;	LD A,(SCR_PREV_P_Y)
;	LD E,A ;screen y is in E
;	LD IX,img_clear
;		push BC;TODO popping not necessary?
;		push HL
;		call copy_8_8_blit
;		pop HL
;		pop BC




ret
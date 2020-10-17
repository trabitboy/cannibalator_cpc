X_BEG_OFFSET EQU 3
Y_BEG_OFFSET EQU 3
L_W EQU 16
L_H EQU 12

;adress of the currently played labyrinth
.current_lab WORD 00
.current_bd_src WORD 00
.current_lvl_conf WORD 00

LVL_CFG_SZ EQU 6
LEV_MAP_L EQU 0
LEV_MAP_H EQU 1
LEV_CONF_L EQU 2
LEV_CONF_H EQU 3
LEV_BDS_L EQU 4
LEV_BDS_H EQU 5

;to determine if game is won
;WON_LVL_NB EQU 1 ; dbg
WON_LVL_NB EQU 8;we begin at 0, each stage increase by one, when we have number of max stage, won

;jumptable to levels ( conf has different size for ennemies for isntance )
.level_list
dw levclimb_map
dw levclimb_conf
dw badclimb
dw lev1_map
dw lev1_conf
dw bad1
dw lev2_map
dw lev2_conf
dw bad2
dw levislands_map
dw levislands_conf
dw badislands
dw levsnail_map
dw levsnail_conf
dw badsnail
dw levbb_map
dw levbb_conf
dw badbb
dw lev4_map
dw lev4_conf
dw bad4
dw lev5_map
dw lev5_conf
dw bad5


;lev conf defines
INI_PX equ 0
INI_PY equ 1
KEY_X equ 2
KEY_Y equ 3
EXIT_X equ 4
EXIT_Y equ 5

.levsnail_map 
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x',' ',' ',' ',' ',' ',' ',' ',' ',' ','x','x','x','x','x'
db 'x',' ','x','x','x','x','x','x','x','x',' ','x','x','x','x','x'
db 'x','x',' ','x',' ',' ',' ',' ',' ','x',' ','x','x','x','x','x'
db 'x','x','x',' ','x','x','x','x',' ','x',' ','x','x','x','x','x'
db 'x','x',' ','x',' ','x',' ',' ',' ','x',' ','x','x','x','x','x'
db 'x',' ','x','x','x',' ','x','x','x',' ',' ','x','x','x','x','x'
db 'x',' ',' ','x',' ',' ',' ',' ',' ',' ','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
.levsnail_conf
db 1,9
;db 1,5 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.badsnail   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
db 1,1,0,28,56
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,28,24
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,28,40
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker



.levclimb_map 
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x',' ','x','x','x','x','x','x','x','x','x','x',' ','x','x'
db 'x',' ',' ',' ','x',' ',' ',' ',' ',' ',' ','x',' ',' ',' ','x'
db ' ','x',' ','x',' ','x','x','x','x','x','x',' ','x',' ','x',' '
db 'x','x',' ','x',' ',' ',' ',' ',' ',' ',' ',' ','x',' ','x','x'
db 'x','x',' ','x',' ','x','x','x','x','x','x',' ','x',' ','x','x'
db 'x','x',' ','x',' ',' ',' ',' ',' ',' ',' ',' ','x',' ','x','x'
db 'x','x',' ',' ','x','x','x','x','x','x','x','x',' ',' ','x','x'
db 'x','x','x','x','x',' ',' ',' ',' ',' ',' ','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
.levclimb_conf
db 6,10
;db 1,5 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.badclimb   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
.leftenm
db 1,1,0,16,32
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,48
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,64
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
;db 1,1,0,16,32
;dw bd_walk_state;bdstate
;db 255 ;stun counter
;dw img_chick2
;db 1,1,0,16,48
;dw bd_walk_state;bdstate
;db 255 ;stun counter
;db 1,1,0,16,64
;dw bd_walk_state;bdstate
;db 255 ;stun counter
;right ennemies
;db 1,1,0,44,16
;dw bd_walk_state ;bdstate
;db 255 ;stun counter
;db 1,1,0,44,32
;dw bd_walk_state ;bdstate
;db 255 ;stun counter
;db 1,1,0,44,48
;dw bd_walk_state ;bdstate
;db 255 ;stun counter
;db 1,1,0,44,64
;dw bd_walk_state ;bdstate
;db 255 ;stun counter
db 0 ; stop marker


; se laisser tomber du haut
.lev1_map 
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x',' ',' ',' ','x'
db 'x','x','x','x','x','x','x','x','x',' ',' ','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x',' ','x','x','x'
db 'x',' ',' ',' ',' ','x','x','x','x','x',' ','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x',' ','x','x','x'
db 'x',' ',' ',' ','x','x','x','x','x',' ',' ','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x',' ',' ',' ','x'
db 'x',' ',' ',' ',' ','x','x','x','x','x',' ','x','x','x',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x',' ',' ',' ','x'
db ' ','x','x','x','x','x','x','x','x','x','x',' ','x','x','x','x'
.lev1_conf
db 1,2 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.bad1   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,32,32
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,32,48
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,32,64
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

;tete de mort grimper se laisser tomber par le cote
.lev2_map 
;db 'x',' ',' ',' ','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x',' ',' ',' ',' ',' ',' ','x','x','x','x','x','x',' '
db 'x',' ',' ',' ',' ',' ',' ',' ',' ','x',' ','x',' ','x',' ','x'
db 'x','x',' ','x','x','x','x','x',' ','x','x','x','x','x','x','x'
db 'x',' ',' ','x',' ','x',' ','x',' ',' ','x',' ','x',' ',' ','x'
db 'x','x',' ','x','x','x','x','x',' ',' ',' ',' ',' ',' ','x','x'
db 'x',' ',' ',' ','x','x','x',' ','x',' ',' ',' ',' ',' ',' ','x'
db 'x','x',' ',' ','x','x','x',' ','x',' ',' ',' ',' ',' ','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ','x',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x','x','x','x','x','x',' ','x','x','x','x','x','x',' '
.lev2_conf
db 5,10 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.bad2   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,36,16
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,32
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,36,80
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

;max ennemy test
.levbb_map 
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ','x','x','x','x','x',' ','x','x','x','x',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ','x','x','x','x','x','x',' ','x','x','x',' ','x'
db 'x','x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ','x','x','x','x','x',' ','x','x','x','x',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ','x','x','x','x','x','x',' ','x','x','x',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
.levbb_conf
db 1,5 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.badbb   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,16,16
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,48
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,32
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
;right ennemies
db 1,1,0,44,16
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,44,32
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,44,48
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,44,64
dw bd_walk_state ;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

;umbrella shape
.lev4_map 
db ' ','x','x','x','x','x','x','x','x','x','x','x','x','x','x',' '
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x',' ',' ',' ','x','x','x','x',' ',' ',' ','x','x','x'
db 'x',' ',' ',' ',' ',' ','x','x','x','x',' ',' ',' ',' ',' ','x'
db 'x','x',' ','x','x','x',' ','x','x',' ','x','x','x',' ','x','x'
db 'x',' ',' ','x','x','x','x','x','x','x','x','x','x',' ',' ','x'
db 'x','x',' ',' ',' ',' ',' ','x','x',' ',' ',' ',' ',' ','x','x'
db 'x',' ',' ',' ',' ',' ',' ','x','x',' ',' ',' ',' ',' ',' ','x'
db 'x','x',' ',' ',' ',' ',' ','x','x',' ',' ',' ',' ','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db ' ','x','x','x','x','x','x','x','x','x','x','x','x','x','x',' '
db ' ','x','x','x','x','x','x','x','x','x','x','x','x','x','x',' '
.lev4_conf
db 7,1 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.bad4   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,16,24
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,36,24
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,36,72
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

;high falls
.lev5_map 
db 'x','x','x','x','x','x',' ',' ','x','x',' ',' ',' ','x','x','x'
db 'x',' ',' ','x',' ',' ',' ','x','x','x',' ',' ',' ',' ',' ','x'
db 'x','x',' ','x',' ',' ','x','x','x','x',' ',' ',' ','x','x','x'
db 'x','x',' ',' ',' ',' ',' ','x','x',' ','x','x','x',' ',' ','x'
db 'x','x',' ','x','x',' ',' ','x','x',' ','x','x','x',' ','x','x'
db 'x','x',' ',' ','x',' ','x','x','x','x','x','x','x',' ',' ','x'
db 'x','x',' ','x','x',' ',' ','x',' ','x',' ','x',' ',' ','x','x'
db 'x','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x',' ','x',' ','x','x','x',' ',' ',' ',' ',' ','x','x','x'
db 'x',' ',' ',' ',' ',' ','x','x',' ','x','x',' ',' ',' ',' ','x'
db ' ','x','x','x','x','x',' ',' ',' ',' ',' ','x','x','x','x','x'
db 'x','x','x','x','x',' ','x','x','x','x','x',' ','x','x','x','x'
.lev5_conf
db 1,1 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.bad5   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,8,72
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,24,56
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,44,16
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,20,80
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

;high falls
.levislands_map 
;db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ','x',' ','x',' ','x',' ','x',' ','x',' ','x',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ','x',' ','x',' ','x',' ','x',' ','x',' ','x',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x',' ','x',' ','x',' ','x',' ','x',' ','x',' ','x',' ',' ','x'
db 'x',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','x'
db 'x','x','x','x','x','x','x','x','x','x','x','x','x','x','x','x'
.levislands_conf
db 1,10 ; initial ply pos
;db 1,1 ; dbg ply pos
db 3,2 ; keypos
db 3,8 ; exit pos
.badislands   ;active vx vy scr_x scr_y p_scr_x p_src_y  pp_scr_x pp_src_y
;.leftenm
db 1,1,0,8,48
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,32
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,16,64
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
;middle set
db 1,1,0,24,48
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,32,32
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 1,1,0,32,64
dw bd_walk_state;bdstate
db 255 ;stun counter
dw img_chick2
db 1 ; dmg 
db 0 ; stop marker

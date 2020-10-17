mc_screen_offset equ &bd1f
CONOUT EQU &BB5A
TXT_CLR_WDW EQU &BB6C
TXT_SET_ROW EQU &BB72
TXT_SET_COL EQU &BB6F
KM_READ_CHAR EQU &BB06  ; need to test carry for valid read
WAIT_CHAR EQU &BB09
CHANGE_MODE EQU &BC0E
;BD_SIZE EQU 11 ;bytes for a baddie
;BD_BUF EQU 55 ;5 baddies, multiple of BD_SIZE
;TODO increasing BD size leaves only one baddie?
BD_SIZE EQU 11 ;bytes for a baddie
BD_TOTAL EQU 8
BD_BUF EQU  BD_SIZE*BD_TOTAL;5 baddies, multiple of BD_SIZE
;struct jumps
BD_ACTIVE EQU 0 ;not use at the mo
;MZ_BD_X EQU 1
;MZ_BD_Y EQU 2
;TODO reorder defs ( v before )
BD_VX EQU 1
BD_VY EQU 2
SCR_BD_X EQU 3
SCR_BD_Y EQU 4
BD_STATE_L equ 5 ;2 byte wide, address of function state
BD_STATE_H equ 6
BD_STUN_WAIT equ 7
BD_IMG_L equ 8
BD_IMG_H equ 9
BD_DMG equ 10; if the current state of baddie does damage to ply 
;easier than fetching routine pointer 


MAP_BYTES equ 16*12
;-2 ;TODO check length ( -2 for safety on djnz )
;tried to dec b

;WHAT not used yet probably?
;ply dir ;down 0 up 1 left 2 right 3
DOWN EQU 0
UP EQU 1

;used for facing DEFINITELY USED
LEFT EQU 2
RIGHT EQU 3

FIRE_CYCLES EQU 10 ; number of cycles hammer is displayed

;anim, number of cycles before pic change
ANIM_CYCLES EQU 10

;inter cycle
INTER_CYCLES EQU 30

WON_CYCLES EQU 120

;time for stun period of chicken
STUN_CYCLES EQU 40

;workaround for corrupt gfx if press during jingle
TITLE_WAIT_CYCLES EQU 40

;VIDEO EQU &C000
;END_VID EQU &0000 ;this is the byte directly after video memory end

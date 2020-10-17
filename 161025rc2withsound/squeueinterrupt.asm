.ffly equ &bd19c
.sqe equ &bcaa
.schk equ &bcad

kl_new_frame_fly equ &bcd7
mc_sound_register equ &bd34
kl_del_frame_fly equ &bcdd


org &4000
;run start


.start
;set up interrupt player
ld hl,ff_event_block
ld b,&81
ld c,0
ld de,ff_event_routine
call kl_new_frame_fly


ret

.tune_pt defw tune

;;--------------------------------------------------------------------------------------------

ff_event_block:
defs 10

;;--------------------------------------------------------------------------------------------

ff_event_routine:
;; 

LD A,(1)
call schk
;keeping only bits 0 to 2
res 3,A
res 4,A
res 5,A
res 6,A
res 7,A

;VIOLENT
cp 0
jp z,no_free_slot

ld hl,(tune_pt)
ld e,(hl)
inc hl
ld d,(hl)

;WIP end check doesn't work for some reason
ld a,d
cp 0
jp z,no_free_slot ; simple test to assess tune finished

push de
pop hl
;ld hl,(hl)
;ld hl,do
call sqe

ld hl,(tune_pt)
inc hl
inc hl
ld (tune_pt),hl

.no_free_slot

;;
ret

;.sdata defb 1,0,0,142,0,0,12,#90,#00
.no defb 1,0,0,239,0,0,0,#20,#00
.do defb 1,0,0,239,0,0,12,#20,#00
.re defb 1,0,0,213,0,0,12,#20,#00
.mi defb 1,0,0,190,0,0,12,#20,#00
.fa defb 1,0,0,179,0,0,12,#20,#00
.sol defb 1,0,0,159,0,0,12,#20,#00
.la defb 1,0,0,142,0,0,12,#20,#00
.si defb 1,0,0,127,0,0,12,#20,#00

.tune
;defw do,re,mi,do,re,mi,do,re,mi,do,re,mi,do,re,mi
defw do,no,do,no,do,no,re,no,mi,no,mi,no,re,no,mi,no,fa,no,sol
defb 0,0 ;end mark

;239 do
;225 do#
;213 re
;201 re#
;190 mi
;179 fa
;169 fa#
;159 sol 
;150 sol#
;142 la
;134 la#
;127 si

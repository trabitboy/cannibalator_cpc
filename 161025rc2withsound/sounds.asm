.sqe equ &bcaa
.schk equ &bcad
.srst equ &bca7

;hammer sound (do )
.hammer defb 1,0,0,239,0,0,12,#02,#00

;pickup sound ( mi )
.pickup defb 1,0,0,190,0,0,12,#02,#00

.death defb 1,0,0,127,0,0,12,#02,#00

;.death defb 1,0,0,190,0,0,12,#02,#00


;.sdata defb 1,0,0,142,0,0,12,#90,#00
.no defb 1,0,0,239,0,0,0,#01,#00
.do defb 1,0,0,239,0,0,12,#10,#00
.re defb 1,0,0,213,0,0,12,#10,#00
.mi defb 1,0,0,190,0,0,12,#10,#00
.fa defb 1,0,0,179,0,0,12,#10,#00
.sol defb 1,0,0,159,0,0,12,#10,#00
.la defb 1,0,0,142,0,0,12,#10,#00
.si defb 1,0,0,127,0,0,12,#10,#00


.tune_pt defw title_tune

.title_tune
;defw do,re,mi,do,re,mi,do,re,mi,do,re,mi,do,re,mi
defw do,no,do,no,do,no,re,no,mi,no,mi,no,re,no,mi,no,fa,no,sol
defb 0,0 ;end mark

.lvlup_tune
;defw do,re,mi,do,re,mi,do,re,mi,do,re,mi,do,re,mi
defw do,no,mi,no,re,no
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


.playing db 0 ;if 1 interrupt player should play ( sound stop done from "app" code )

;call from interrupt, rudimentary player

.player

LD A,1
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


;ay test
org #4000

MC EQU &BD34

;run start


.start
ld A,#07
ld C,#38
call MC
ld A,#08
ld C,#00
call MC
ld A,#09
ld C,#00
call MC
ld A,#10
ld C,#00
call MC
ld A,#00
ld C,#FC
call MC
ld A,#01
ld C,#00
call MC
ld A,#08
ld C,#0F
call MC


;007E
;02FC
;0300
ld A,#00
ld C,#7E
call MC
ld A,#02
ld C,#FC
call MC
ld A,#08
ld C,#0F
call MC


ret
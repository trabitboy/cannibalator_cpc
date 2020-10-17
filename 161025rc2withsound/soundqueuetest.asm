.ffly equ &bd19c
.sqe equ &bcaa
.schk equ &bcad

org &4000
;run start

;TODO use sound check wait until more sounds can be fed
;blocked at 4 right now

.start
;ld hl,sdata
ld hl,do
call sqe
call ffly

call wait_free_slot

ld hl,no
call sqe
call ffly

call wait_free_slot

ld hl,do
call sqe
call ffly

call wait_free_slot

ld hl,no
call sqe
call ffly

call wait_free_slot

ld hl,do
call sqe
call ffly

call wait_free_slot

ld hl,re
call sqe
call ffly

call wait_free_slot

ld hl,mi
call sqe
call ffly

call wait_free_slot

ld hl,no
call sqe
call ffly

call wait_free_slot

ld hl,mi
call sqe
call ffly

call wait_free_slot

ld hl,re
call sqe
call ffly

call wait_free_slot

ld hl,mi
call sqe
call ffly

call wait_free_slot


ld hl,fa
call sqe
call ffly

call wait_free_slot

ld hl,sol
call sqe
call ffly

call wait_free_slot

ld hl,la
call sqe
call ffly

call wait_free_slot

ld hl,si
call sqe
call ffly

ret


;sub to check if a sound slot is usable
.wait_free_slot

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
jp z,wait_free_slot

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

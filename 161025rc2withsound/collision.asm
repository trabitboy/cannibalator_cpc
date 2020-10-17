;global param for dmg maps
.dmg_map dw dmg_mapc0

;to switch the adresses we need to have the adresses in memory
.adr_dmg_c0 dw dmg_mapc0
.adr_dmg_40 dw dmg_map40
;can be reset to 1 or 0, passing it in A
;resets dmg map
.reset_dmg_map
ld hl,(dmg_map)
ld b,MAP_BYTES
dec b ; or iterates to much
;ld a,0
.null_next
ld (hl),a
inc hl
djnz null_next
ret



.over_x db 0
.over_y db 0

.set_over_x
ld a,1
ld (over_x),a
jp aft_over_x

.set_over_y
ld a,1
ld (over_y),a
jp aft_over_y

;corrupts A,HL
;x y in DE
;8x8 tiles; which dmg_map slots are "colored 
.exdmg
ld a,0
ld (over_x),a
ld (over_y),a

ld a,d
bit 0,a
jp nz,set_over_x
bit 1,a
jp nz,set_over_x

.aft_over_x
ld a,d
sra a
sra a
;tile coord in a
ld d,a

ld a,e

bit 0,a
jp nz,set_over_y
bit 1,a
jp nz,set_over_y
bit 2,a
jp nz,set_over_y

.aft_over_y
ld a,e
sra a
sra a
sra a
;tile coord in a 
ld e,a


;if not exactly multiple of 4 on x,
;( bit 0 set or bit 1 set )


;or 8 on Y, we know that tile + 1 is also dirty
;(bit 0 1 2 set )

call set_dmg_map


ret

;sub set dmg map
.add_row
ld b,0
ld c,L_W
add hl,bc
dec a
jp row_check



;set dmg map
;d x tile
;e y tile
;TODO 
;.over_x x+1 also damaged
;.over_y y+1 also damaged
.set_dmg_map
ld HL,(dmg_map)
ld a,e
.row_check
cp a,0
jp nz,add_row
;rows added, now we need to add x
ld b,0
ld c,d
add hl,bc
;hl is on the byte of the dmg map we need to set
ld (HL),1

;treating over x
inc HL
ld a,(over_x)
cp 1
call z,treat_over_xy ;next to the left set
ld a,(over_y)
cp 1
jp nz,exit_set_dmg_map
;over y not escaped, next line
ld b,0
ld c,L_W
add hl,bc
;we are on the line below at x+1
ld a,(over_x)
cp a,1
call z,treat_over_xy
;let's go back to x on the line below
dec hl
;if we are here, over_y is 1
call z,treat_over_xy
.exit_set_dmg_map
ret

.treat_over_xy
ld a,1
ld (HL),a
ret


;main collision function 
;params
COLL_X1 byte 0
COLL_Y1 byte 0
COLL_X2 byte 0
COLL_Y2 byte 0

COLL byte 0


;.x28_g

;jp aft_x_coll


.no_coll
ld a,0
ld (COLL),a
jp aft_coll

;returns collision in A ( returns A if collision )
;first 8x8 colls
;in fact 8x4, because we have 4 bytes for 8 pixels
;( x precision is halved )
.collision88

;by default coll until we escape a blocking condition
ld a,1
LD (COLL),a

;looking if coll on x
;if x1+8< x2 and x2+8<x1,no coll x

ld A,(COLL_X2)
ld D,A

LD A,(COLL_X1)
;LD B,8
ld b,4;x preision is halv 8 pixs = 4 coords
ADD B

ld B,D

cp A,B

;TODO not an AND, but an OR
;if B>A, already not x_coll
jp C,no_coll

;is x2<x1+8?

ld A,(COLL_X1)
ld D,A

LD A,(COLL_X2)
;LD B,8
ld b,4 ;x precision is halved, 4 coords = 8 pixs
ADD B

ld B,D
; x2+8 -x1
cp A,B
;if x1 >
jp c, no_coll

;if one of the y condition is false, exit no coll
;if y1 > y2+8
ld A,(COLL_Y1)
ld D,A

LD A,(COLL_Y2)
LD B,8
ADD B

ld B,D

cp A,B

;if y1 > y2+8 already not coll
jp C,no_coll

;if y2 > y1+8
ld A,(COLL_Y2)
ld D,A

LD A,(COLL_Y1)
LD B,8
ADD B

ld B,D

cp A,B

;if y2 > y1+8
jp C,no_coll


;if y2>y1+8

.aft_coll
ld A,(COLL)


.exit_coll
ret
;test read char non blocking

KM_READ_CHAR EQU &BB06	
CONOUT EQU &BB5A
TXT_CLR_WDW EQU &BB6C

org #4000 

run start

.start
call TXT_CLR_WDW

.main_loop

call KM_READ_CHAR
jp c,treat_input

.input_treated

jp main_loop




.treat_input

;char is in A
call CONOUT

ld a,'x'
call CONOUT

jp input_treated


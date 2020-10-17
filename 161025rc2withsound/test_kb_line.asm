;TODO put code snippet in a main loop and test bits
;TODO not working 
;TODO test result with bit instructions




LD A,kbdline ; from 0 to 9 with bdir/bc1=01
LD BC,#F782 ; PPI port A out /C out 
OUT (C),C 
LD BC,#F40E ; Select Ay reg 14 on ppi port A 
OUT (C),C 
LD BC,#F6CO ; This value is an AY index (R14) 
OUT (C),C 
OUT (C),0 ; Validate!!
LD BC,#F792 ; PPI port A in/C out 
OUT (C),C 
DEC B 
OUT (C),A ; Send KbdLine on reg 14 AY through ppi port A
LD B,#F4 ; Read ppi port A 
IN A,(C) ; e.g. AY R14 (AY port A) 
LD BC,#F782 ; PPI port A out / C out 
OUT (C),C 
DEC B ; Reset PPI Write 
OUT (C),0
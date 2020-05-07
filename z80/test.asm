Preamble:
	call Start
	include math.asm;

Start:
	ld bc,1
loop:
	call random
	ld d,a
	ld e,9
	call div_d_e
	halt
	call random
	ld d,a
	ld e,9
	call div_d_e
	halt
	call random
	ld d,a
	ld e,9
	call div_d_e
	halt
	ret



WelcomeBanner:
	defm 'testing!'
	defb 10,0


String1: defs 64
String2: defs 64

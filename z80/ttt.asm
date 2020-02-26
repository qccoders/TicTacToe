Preamble:
	ld hl,WelcomeBanner
	call Println
	call NewGame	
	ret

	include io.asm
	include strings.asm
	include math.asm
	include board.asm
	include game.asm

WelcomeBanner:
	defm 'Welcome to QC Coders'
	defb 27H
	defm ' Tic Tac Toe! You'
	defb 27H
	defm 're '
	defb 27H
	defm 'X'
	defb 27H
	defm ' and you'
	defb 27H
	defm 'll go first!'
	defb 10,0

NewGame:
	ld a,0
	call FillBoard

	ld ix,GameState
	ld (ix+0),0
	ld (ix+1),0
	ld (ix+2),0

	call PlayGame
	ld hl,PlayAgain
	call Println
	ld hl,Choice
	call Readln
	ld ix,NoString
	call StringEqual
	cp 1
	ret z
	jr NewGame

;in: hl, the address of userput
;out: a = 0,1,2 for the first row or column found, 9 if there's a problem
NextInNum:
	ld a,(hl)
	cp 0
	jr z,endofstring
	sub 30h
	jp m,outofbounds
	ld a,(hl)
	sub 33h
	jp p,outofbounds
	ld a,(hl)
	inc hl
	sub 30h
	ret
outofbounds:
	inc hl
	jr NextInNum
endofstring:
	ld a,9
	ret


GetAssertion:
	ld hl,UserInput
	call NextInNum
	cp 9
	jr z,gotanine
	ld b,a
	ld c,3
	call multiply
	ld ix,GameState
	ld (ix+2),a
	ld a,(hl)
	call NextInNum
	cp 9
	jr z,gotanine
	add a,(ix+2)
	ld (ix+2),a	
	ret
gotanine:
	ld a,9	
	ld (ix+2),a
	ret


;out : a, a random cell
PickAnyCell:
	push de
	call random
	ld d,a
	ld e,9
	call div_d_e
	pop de
	ret

C_omputerTurn:
	push bc
	push hl
compmove:
	ld hl,Board
	call PickAnyCell
	ld b,a
compnextcell:
	inc hl
	djnz compnextcell
	dec hl
compcellfound
	ld a,(hl)
	cp 0
	jr nz,compmove
	ld (hl),2
	pop hl
	pop bc
	ret

;out a, 1 for success, 0 for fail
HumanTurn:
	push bc
	push ix
	ld ix,GameState
	call GetAssertion
	ld a,(ix+2)
	cp 9
	jr z,bad
	ld b,a
	ld hl,Board
movetocell:
	ld a,b
	cp 0
	jr z,foundcell
	inc hl
	dec b
	jr movetocell
foundcell:
	ld a,(hl)
	cp 0
	jr nz,alreadytaken
	ld (hl),1
	ld (ix+2),0
	jr turnover
alreadytaken:
	ld (ix+2),1
	jp turnover
bad:
	ld (ix+2),2
turnover:
	ld a,(ix+2)
	pop ix
	pop bc
	ret


PlayGame:
	call PrintBoard	
	ld ix,GameState
	ld (ix+0),0
	ld (ix+1),1
	ld (ix+2),0
	ld hl,UserInput
	call Readln
	ld ix,QuitString
	call StringEqual
	cp 1
	jr z,Quit
	call HumanTurn
	cp 0
	jr z,keepgoing
	jr PlayGame
keepgoing:
	call FindWinner
	cp 0
	jr nz,Quit
	ld ix,GameState
	ld (ix+1),2
	call C_omputerTurn
	call FindWinner
	cp 0
	jr nz,Quit
	jr PlayGame


Quit:
	ld ix,GameState
	ld (ix+0),1
	call PrintBoard
	ret	


;GameState[0] - game over?
;GameState[1] - whose turn it is (or winner, if game over)
;GameState[2] - attempted move


GameState: defs 3
UserInput: defs 32

YourTurn:
	defm 'Enter your choice in the format '
	defb 27H
	defm 'x,y'
	defb 27H
	defm ' (zero based, left to right, top to bottom):'

Choice:
	defb 0

PlayAgain:
	defm 'Do you want to play again (y/n)?'
	defb 0

QuitString: defm 'q'
			defb 0

NoString: defm 'n'
			defb 0
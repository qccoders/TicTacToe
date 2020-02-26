;in: hl 
;out: a.  
;	 a space if hl==0 into a space, a 1 into an X and a 2 into an O
;	 an X if hl==1
;	 an O if hl==2
FigureChar:
	ld a,(hl)
	cp 0
	jr nz,NotZero
	ld a,20H
	ret
NotZero:
	cp 1
	jr nz,NotOne
	ld a,58H
	ret
NotOne:
	ld a,4FH
	ret


MergeData:
	ld hl,Board
	ld ix,Display
	call FigureChar
	ld (ix+30),a
	inc hl
	call FigureChar
	ld (ix+34),a
	inc hl
	call FigureChar
	ld (ix+38),a
	inc hl
	call FigureChar
	ld (ix+86),a
	inc hl
	call FigureChar
	ld (ix+90),a
	inc hl
	call FigureChar
	ld (ix+94),a
	inc hl
	ld BC,112
	add ix,bc
	call FigureChar
	ld (ix+30),a
	inc hl
	call FigureChar
	ld (ix+34),a
	inc hl
	call FigureChar
	ld (ix+38),a
	ret


PrintBoard:
	call ClearScreen
	call PrintError
	ld ix,GameState
	ld a,(ix+0)
	cp 0
	jr z,playingheader
	ld a,(ix+1)
	cp 1
	jr z,youwon
	ld hl,Compu_terWonHeader
	call Println
	jr DumpBoard
youwon:
	ld hl,YouWonHeader
	call Println
	jr DumpBoard
computerwon:
	ld hl,Compu_terWonHeader
	call Println
	jr DumpBoard
playingheader:	
	ld hl,HereHeader
	call Println
dumpboard:
	call MergeData
	ld hl,Display
	call Println
	ret


PrintError:
	ld ix,GameState
	ld a,(ix+2)
	cp 0
	ret z
	ld a,(ix+2)
	cp 1
	jr nz,bierror
	ld hl,SpotTaken
	jr dumperror
bierror:
	ld hl,BadInput
dumperror:
	call Println
	ret


FillBoard:
	ld ix,Board
	ld (ix+0),a
	ld (ix+1),a
	ld (ix+2),a
	ld (ix+3),a
	ld (ix+4),a
	ld (ix+5),a
	ld (ix+6),a
	ld (ix+7),a
	ld (ix+8),a
	ret


;out: a.  0 if no winner, 1 if x, 2 if o
FindWinner:
	push ix
	ld ix,Board
	ld a,(ix+0)
	and (ix+1)
	and (ix+2)
	jr nz,DoneWinners
	ld a,(ix+3)
	and (ix+4)
	and (ix+5)
	jr nz,DoneWinners
	ld a,(ix+6)
	and (ix+7)
	and (ix+8)
	jr nz,DoneWinners
	ld a,(ix+0)
	and (ix+4)
	and (ix+8)
	jr nz,DoneWinners
	ld a,(ix+2)
	and (ix+4)
	and (ix+6)
	jr nz,DoneWinners
	ld a,(ix+0)
	and (ix+3)
	and (ix+6)
	jr nz,DoneWinners
	ld a,(ix+1)
	and (ix+4)
	and (ix+7)
	jr nz,DoneWinners
	ld a,(ix+2)
	and (ix+5)
	and (ix+8)
	jr nz,DoneWinners
	ld a,0
DoneWinners:
	pop ix
	ret


HereHeader:
	defm 'Here'
	defb 27H
	defm 's the current board:'
	defb 10,0

YouWonHeader:
	defm 'You win!'
	defb 10,0

Compu_terWonHeader:
	defm 'The Computer won.  :('
	defb 10,0


SpotTaken:
	defm 'This spot is already taken.  Please select another.'
	defb 10,0

BadInput:
	defm 'Please enter valid coordinates'
	defb 10,0

Board: 	defs 9 ; the board is 9 bytes in memory

Display: 
	defm '+---+---+---+'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '+---+---+---+'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '+---+---+---+'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '|   |   |   |'
	defb 10
	defm '+---+---+---+'
	defb 10,0

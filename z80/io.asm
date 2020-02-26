Println:
	call Print
	ld hl,NL
	call Print
	ret

Print:
	ld a,(hl)
	and a
	ret z
	out (1), a
	inc hl
	jr Print

;in HL, preserved: address to store data
Readln:
	push hl
ReadChar:	
	in a,(1)
	cp 0AH
	jr z,LastChar
	ld (hl),a
	inc hl
	jr ReadChar
LastChar:
	ld (hl),0
	pop hl
	ret


ClearScreen:
	ld hl,ClrScr
	call Println
	ret


NL: defb 10,0
ClrScr: defb 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,0

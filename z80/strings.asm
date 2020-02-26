;in: HL (preserved)
;out: A
Strlen:
	push hl
	push bc
	ld b,0
NextChar:
	ld a,(hl)
	cp 0
	jr z,DoneLen
	inc b
	inc hl
	jr NextChar
DoneLen:
	ld a,b
	pop bc
	pop hl
	ret


;in HL (preserved) and IX (preserved)
;out A
SameLen:
	push hl
	push ix
	push bc
	call Strlen
	ld b,a
	push ix
	pop hl
	call Strlen
	cp b
	jr nz,difflen
	ld a,1
	jr donesamelen
difflen:
	ld a,0
donesamelen:
	pop bc
	pop ix
	pop hl
	ret

;in HL (preserved) and IX (preserved)
;out A
StringEqual:
	push hl
	push ix
	push bc
	call SameLen
	cp 1
	jr z,bychar
	ld a,0
	jr donequ
bychar: ;now we know they're the same length
	call Strlen
	ld b,a
nexttest:
	ld a,(hl)
	cp (ix+0)
	jr nz,founddiff
	dec b
	ld a,b
	cp 0
	jr z,areequal
	inc hl
	inc ix
	jr nexttest
founddiff:
	ld a,0
areequal:
	ld a,1
donequ:
	pop bc
	pop ix
	pop hl
	ret


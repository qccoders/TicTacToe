;in bc (preserved)
;out a, which is b multiplied by c
multiply:
	push de ;d is the initial b, e is the accumulated
	push bc ;multiply b times x
	ld d,b
	ld e,c
	cp 0
	jr z,zero
	ld a,b
	cp 0
	jr z,zero
multloop:
	ld a,b
	cp 1
	jr z,donemult
	ld a,e
	add a,c
	ld e,a
	dec b
	jr multloop
zero:
	ld e,0
donemult:
	ld a,e
	pop bc
	pop de
	ret

;http://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division
div_d_e:
   xor	a
   ld	b, 8
divloop:
   sla	d
   rla
   cp	e
   jr	c, $+4
   sub	e
   inc	d
   djnz	divloop
   ret

;http://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random
random:
    push hl
    push de
    ld a,r
    ld hl,randData
    ld (hl),a
    ld hl,(randData)

    ld a,r
    ld d,a
    ld e,(hl)
    add hl,de
    add a,l
    xor h
    ld (randData),hl
    pop de
    pop hl
    ret

randData: defb 0,0
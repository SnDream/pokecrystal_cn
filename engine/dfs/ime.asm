imeInput::
	ld a, [de]
	ld hl, wAttrmap - wTilemap
	add hl, de
	ld b, [hl]
	bit 3, b
	jr nz, .notpg
	cp a, $61
	jr z, .pgup
	cp a, $EE
	jr z, .pgdn
.notpg
	bit 7, a
	jr z, .normal
	cp a, DFS_CODE_SINGLE_STA_1
	jr c, .code
	bit 3, b
	jr z, .normal
.code
	ld c, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDFSCache)
	ldh [rSVBK], a
	ld a, c
	and a, %01111110
	rlca
	ld l, a
	ld h, HIGH(wDFSCache)
	bit 3, b
	jr nz, .is_vram1
	inc h
.is_vram1
	ld a, [hli]
	and a, DFS_MASK_DOUBLE
	jr z, .eng
	ld l, [hl]
	ld h, a
	ld a, h
	ld [wIMEChar], a
	ld a, l
	ld [wIMEChar + 1], a
	ld hl, wIMEPinyin
	ld [hl], "@"
	hlcoord 13, 10
	ld de, SixUnderLine
	ld a, [wcf64]
	bit 0, a
	call z, PlaceString
	pop af
	ldh [rSVBK], a
	ld b, 1
	ret
.eng
	bit 0, c
	jr z, .iseng0
	inc hl
	inc hl
.iseng0
	ld b, [hl]
	pop af
	ldh [rSVBK], a
	ld a, [wcf64]
	bit 0, a
	jr z, InputPinyin
	ret
.normal
	ld b, a
	ret
.pgup
	ld a, [wIMELine]
	and a
	jr z, .end
	dec a
	ld [wIMELine], a
	call PrintIMELines
.end
	ld b, 0
	ret
.pgdn
	ld a, [wIMEMaxLine]
	ld b, a
	ld a, [wIMELine]
	inc a
	cp a, b
	jr z, .end
	ld [wIMELine], a
	call PrintIMELines
	ld b, 0
	ret

InputPinyin:
	ld hl, wIMEPinyin
	ld c, 6
.ccloop
	ld a, [hl]
	cp a, "@"
	jr z, .ccend
	inc hl
	dec c
	jr nz, .ccloop
	jr .full
.ccend
	ld [hl], b
	inc hl
	ld [hl], "@"
	call SetPinyin
.full:
	ld b, 0
	ret

SetPinyin::
;	 hlcoord 13, 10
;	 lb bc, 1, 6
;	 call ClearBox
	hlcoord 13, 10
	ld de, SixUnderLine
	call PlaceString
	hlcoord 13, 10
	ld de, wIMEPinyin
	call PlaceString
	xor a
	ld [wIMELine], a
	call GetPinyinNo
	call GetPinyinEntry
	call PrintIMELines
	ret
	
GetPinyinNo:
	ld bc, $0000
	ld hl, PinyinTB
	jr .start
.miss
	pop hl
	ld de, $0007
	add hl, de
	inc bc
.start
	push hl
	ld de, wIMEPinyin
.trynext
	ld a, [de]
	cp a, "@"
	jr z, .succeed
	cp a, [hl]
	jr c, .failed
	jr nz, .miss
	inc hl
	inc de
	jr .trynext
.failed
	ld bc, $0000
.succeed
	pop hl
	ret


GetPinyinEntry:
	ld hl, CharTBEntry
rept 4
	add hl, bc
endr
	ld a, [hli]
	ld [wIMEMaxLine], a
	ld a, [hli]
	ld [wIMEBank], a
	ld a, [hli]
	ld [wIMEAddr], a
	ld a, [hl]
	ld [wIMEAddr + 1], a
	ret

PrintIMELines::
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	hlcoord 3, 11
	lb bc, 4, 16
	call ClearBox
	ld a, [wIMELine]
	hlcoord 3, 12
	call PrintIMELine
	ld a, [wIMELine]
	inc a
	hlcoord 3, 14
	call PrintIMELine
	pop af
	ld [hBGMapMode], a
	ret

PrintIMELine:
	ld c, a
	ld a, [wIMEMaxLine]
	cp c
	ret z
	ret c
	push hl
	swap c
	ld a, c
	and a, $0F
	ld b, a
	ld a, c
	and a ,$F0
	ld c, a
	ld a, [wIMEAddr]
	ld l, a
	ld a, [wIMEAddr + 1]
	ld h, a
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, "@"
	ld [wDFSCode + 2], a
	ld b, 8
.loop
	push bc
	push hl
	ld h, d
	ld l, e
	ld a, [wIMEBank]
	call GetFarWord
	ld a, l
	cp a, "@"
	jr z, .end
	ld [wDFSCode], a
	ld a, h
	ld [wDFSCode + 1], a
	pop hl
	push hl
	push de
	call PlaceDFSChar
	pop de
	pop hl
	inc hl
	inc hl
	inc de
	inc de
	pop bc
	dec b
	jr nz, .loop
	ret
.end
	pop hl
	pop bc
	ret

SixUnderLine:
	db $F2, $F2, $F2, $F2, $F2, $F2, $50

INCLUDE "data/ime/ime_entry.asm"

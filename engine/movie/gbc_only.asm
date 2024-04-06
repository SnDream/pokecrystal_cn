GBCOnlyScreen:
	ldh a, [hCGB]
	and a
	ret nz

	ld de, MUSIC_NONE
	call PlayMusic

	call ClearTilemap

	ld hl, GBCOnlyGFX
	ld de, wGBCOnlyDecompressBuffer
	ldh a, [rSVBK]
	push af
	ld a, 0 ; this has the same effect as selecting bank 1
	ldh [rSVBK], a
	call Decompress
	pop af
	ldh [rSVBK], a

	ld de, wGBCOnlyDecompressBuffer
	ld hl, vTiles2
	lb bc, BANK(GBCOnlyGFX), 84
	call Get2bpp

	; ld de, Font
	; ld hl, vTiles1
	; lb bc, BANK(Font), $80
	; call Get1bpp

	call DrawGBCOnlyScreen

	call WaitBGMap

; better luck next time
.loop
	call DelayFrame
	jr .loop

DrawGBCOnlyScreen:
	call DrawGBCOnlyBorder

	; Pokemon
	hlcoord 3, 2
	ld b, 14
	ld c, 4
	ld a, $8
	call DrawGBCOnlyGraphic

	; Crystal
	hlcoord 5, 6
	ld b, 10
	ld c, 2
	ld a, $40
	call DrawGBCOnlyGraphic

	ld a, $80
	ld [wDFSCode + 2], a
	ld de, GBCOnlyString
	hlcoord 3, 10
	; call PlaceString
	call PlaceString_GB
	; ld a, 4
	; ldcoord_a 19, 11
	; ldcoord_a 19, 12
	ret

DrawGBCOnlyBorder:
	hlcoord 0, 0
	ld [hl], 0 ; top-left

	inc hl
	ld a, 1 ; top
	call .FillRow

	ld [hl], 2 ; top-right

	hlcoord 0, 1
	ld a, 3 ; left
	call .FillColumn

	hlcoord 19, 1
	ld a, 4 ; right
	call .FillColumn

	hlcoord 0, 17
	ld [hl], 5 ; bottom-left

	inc hl
	ld a, 6 ; bottom
	call .FillRow

	ld [hl], 7 ; bottom-right
	ret

.FillRow:
	ld c, SCREEN_WIDTH - 2
.next_column
	ld [hli], a
	dec c
	jr nz, .next_column
	ret

.FillColumn:
	ld de, SCREEN_WIDTH
	ld c, SCREEN_HEIGHT - 2
.next_row
	ld [hl], a
	add hl, de
	dec c
	jr nz, .next_row
	ret

DrawGBCOnlyGraphic:
	ld de, SCREEN_WIDTH
.y
	push bc
	push hl
.x
	ld [hli], a
	inc a
	dec b
	jr nz, .x
	pop hl
	add hl, de
	pop bc
	dec c
	jr nz, .y
	ret

GBCOnlyString: ; 4eb38
	db_w "此游戏卡为任天堂"
	next "彩色袖珍游戏机专用。"
	next "请在任天堂彩色袖珍"
	next "游戏机上进行游戏。@"

PlaceString_GB:
	push hl

PlaceNextChar_GB:
	ld a, [de]
	cp "@"
	jr nz, CheckDict_GB
	ld b, h
	ld c, l
	pop hl
	ret

NextChar_GB:
	inc de
	jr PlaceNextChar_GB
	
CheckDict_GB:
	cp "<NEXT>"
	jr z, NextLineChar_GB
	push hl
	ld hl, wDFSCode
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	dec de
	pop hl
	call dfsUnion_GB
	jr NextChar_GB
	
NextLineChar_GB:
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	push hl
	xor a
	ld [wDFSCombineCode], a
	jr NextChar_GB
	
dfsUnion_GB:
	push de
	push hl
	ld hl, wDFSCode
	ld a, [hli]
	cp a, $80
	jr nc, SingleCode_GB
	cp a, $30
	jr nc, StaticSingleCode_GB
	ld a, [wDFSCombineCode]
	and a
	jr nz, CombineDoubleCode_GB
	ld a, [wDFSCode]
	ld [wDFSCombineCode], a
	ld b, a
	set 6, a
	ld d, a
	ld a, [wDFSCode + 1]
	ld [wDFSCombineCode + 1], a
	ld c, a
	ld e, a
	call DoubleCodeMain_GB
	pop hl
	call DoubleCodeDrawMap_GB
	push hl
	ld a, [wDFSCode]
	set 7, a
	ld b, a
	ld a, [wDFSCode + 1]
	ld c, a
	ld de, $0000
	call DoubleCodeMain_GB
	pop hl
	call DoubleCodeDrawMap_GB
	pop de
	inc de
	ret

StaticSingleCode_GB:
	pop hl
	ld [hli], a
	pop de
	xor a
	ld [wDFSCombineCode], a
	ret

SingleCode_GB:
	call SingleCodeMain_GB
	pop hl
	call SingleCodeDrawMap_GB
	pop de
	xor a
	ld [wDFSCombineCode], a
	ret

CombineDoubleCode_GB:
	ld a, [wDFSCode + 2]
	sub 2
	ld [wDFSCode + 2], a
	ld hl, wDFSCombineCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld c, [hl]
	ld hl, wDFSCode
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call DoubleCodeMain_GB
	pop hl
	dec hl
	call DoubleCodeDrawMap_GB
	push hl
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, b
	set 7, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain_GB
	pop hl
	call DoubleCodeDrawMap_GB
	pop de
	inc de
	xor a
	ld [wDFSCombineCode], a
	ret

SingleCodeMain_GB:
	ld b, a
	ld a, [wDFSCode + 2]
	call GetVramAddr_GB
	ld a, [wDFSCode + 2]
	call SendRom8FontToVram_GB
	ret
	
DoubleCodeMain_GB:
	ld a, [wDFSCode + 2]
	call Send8FontToWRAM_GB
	ld a, [wDFSCode + 2]
	call GetVramAddr_GB
	ld c, $2
	call SendWRAM8FontToVram_GB
	ret

Send8FontToWRAM_GB:
	push de
	call Get4RawFontAddr_GB
	ld hl, wGBCOnlyDecompressBuffer
	call DecompressRaw4FontTo8FontLeft
	pop bc
	ld a, b
	or c
	ret z
	call Get4RawFontAddr_GB
	ld hl, wGBCOnlyDecompressBuffer + LEN_2BPP_TILE / 2
	call DecompressRaw4FontTo8FontRight
	ret

; 送4px裸字体片到内存
; Get4RawFontAddr
Get4RawFontAddr_GB:
	ld a, b
	push af

	and a, DFS_MASK_DOUBLE
	sla c
	rla
	ld b, 0
	ld d, b
	ld e, a
	ld hl, FontPointer_GB
rept 3
	add hl, de
endr
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	ld d, a
	pop af

	ld c, DFS_RAW_4FONT_SIZE
	jr .entry
.loop
	add hl, bc
.entry
	sub a, 1 << 6
	jr nc, .loop

	ld a, d
	ld d, h
	ld e, l
	ret

GetVramAddr_GB:
	swap a
	ld h, a
	and a, $F0
	ld l, a
	ld a, h
	and a, $0F
	add a, $80
	ld h, a
	ret
	
SendWRAM8FontToVram_GB:
	ld de, wGBCOnlyDecompressBuffer
	ld b, BANK(GBCOnlyGFX)
	call Get2bpp
	ret
	
SendRom8FontToVram_GB:
	push hl
	ld h, 0
	ld l, b
	res 7, l
rept 3
	add hl, hl
endr
	ld bc, Font
	add hl, bc
	ld d, h
	ld e, l
	lb bc, BANK(Font), $01
	pop hl
	call Get1bpp
	ret

SingleCodeDrawMap_GB:
	ld a, [wDFSCode + 2]
	ld [hli], a
	inc a
	ld [wDFSCode + 2], a
	ret
DoubleCodeDrawMap_GB:
	ld a, [wDFSCode + 2]
	ld bc, - SCREEN_WIDTH
	add hl, bc
	ld [hl], a
	inc a
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hli], a
	inc a
	ld [wDFSCode + 2], a
	ret

MACRO dfontab_GB
rept _NARG
	dwb DFS_C_\1_L, BANK(DFS_C_\1_L)
	dwb DFS_C_\1_H, BANK(DFS_C_\1_H)
	shift
endr
ENDM

FontPointer_GB:
	dfontab_GB FF, 01, 02, 03, 04, 05, 06, 07, 08, 09, 0A, 0B, 0C, 0D, 0E, 0F
	dfontab_GB 10, 11, 12, 13, FF, FF, FF, FF, 18, 19, 1A, 1B, 1C, 1D, 1E, 1F
	dfontab_GB FF, FF, FF, FF, FF, FF, FF, FF, 28, 29, 2A, 2B, 2C, 2D, 2E, FF

GBCOnlyGFX:
INCBIN "gfx/sgb/gbc_only.2bpp.lz"

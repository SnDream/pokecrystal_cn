_UpdateBGMap::

	ldh a, [hBGMapMode]

; BG Map 0
	dec a ; 1
	jr z, .Tiles
	dec a ; 2
	jr z, .Attr

; BG Map 1
	dec a

	ldh a, [hBGMapAddress]
	ld l, a
	ldh a, [hBGMapAddress + 1]
	ld h, a
	push hl

	xor a ; LOW(vBGMap1)
	ldh [hBGMapAddress], a
	ld a, HIGH(vBGMap1)
	ldh [hBGMapAddress + 1], a

	ldh a, [hBGMapMode]
	push af
	cp 3
	call z, .Tiles
	pop af
	cp 4
	call z, .Attr

	pop hl
	ld a, l
	ldh [hBGMapAddress], a
	ld a, h
	ldh [hBGMapAddress + 1], a
	ret


.Attr:
	ld a, 1
	ldh [rVBK], a

	hlcoord 0, 0, wAttrmap
	call .update

	xor a ; ld a, 0
	ldh [rVBK], a
	ret


.Tiles:
	hlcoord 0, 0
	call .update

	ldh a, [hCGB]
	and a
	ret z
	ldh a, [rKEY1]
	and a, %10000000
	ret z

	ld a, 1
	ldh [rVBK], a

	; hlcoord 0, 0, wAttrmap
	call .fontattrupdate

	xor a ; ld a, 0
	ldh [rVBK], a
	ret

.update
	ld [hSPBuffer], sp

; Which third?
	ldh a, [hBGMapThird]
	and a ; 0
	jr z, .top
	dec a ; 1
	jr z, .middle
	; 2


DEF THIRD_HEIGHT EQU SCREEN_HEIGHT / 3


.bottom
	ld de, 2 * THIRD_HEIGHT * SCREEN_WIDTH
	add hl, de
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

	ld de, 2 * THIRD_HEIGHT * BG_MAP_WIDTH
	add hl, de

; Next time: top third
	xor a
	jr .start


.middle
	ld de, THIRD_HEIGHT * SCREEN_WIDTH
	add hl, de
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

	ld de, THIRD_HEIGHT * BG_MAP_WIDTH
	add hl, de

; Next time: bottom third
	ld a, 2
	jr .start


.top
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

; Next time: middle third
	ld a, 1


.start
; Which third to update next time
	ldh [hBGMapThird], a

; Rows of tiles in a third
	ld a, SCREEN_HEIGHT / 3

; Discrepancy between Tilemap and BGMap
	ld bc, BG_MAP_WIDTH - (SCREEN_WIDTH - 1)


.row
; Copy a row of 20 tiles
rept SCREEN_WIDTH / 2 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
endr
	pop de
	ld [hl], e
	inc l
	ld [hl], d

	add hl, bc
	dec a
	jr nz, .row


	ldh a, [hSPBuffer]
	ld l, a
	ldh a, [hSPBuffer + 1]
	ld h, a
	ld sp, hl
	ret

.fontattrupdate
	; ldh a, [rLY]
	; cp a, $94
	; ret nc
	; ld a, [hCGB]
	; and a
	; ret z
	ld [hSPBuffer], sp

; Which third?
	ldh a, [hBGMapThird]
	and a ; 0
	jr z, .fontattrbottom
	dec a ; 1
	jr z, .fontattrtop

	; 2


.fontattrmiddle
	; ld de, THIRD_HEIGHT * SCREEN_WIDTH
	; add hl, de
	hlcoord 0, 1 * THIRD_HEIGHT, wAttrmap
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

	ld de, THIRD_HEIGHT * BG_MAP_WIDTH
	add hl, de

; Next time: bottom third
; 	ld a, 2
	jr .fontattrstart


.fontattrbottom
	; ld de, 2 * THIRD_HEIGHT * SCREEN_WIDTH
	; add hl, de
	hlcoord 0, 2 * THIRD_HEIGHT, wAttrmap
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

	ld de, 2 * THIRD_HEIGHT * BG_MAP_WIDTH
	add hl, de

; Next time: top third
; 	xor a
	jr .fontattrstart

.fontattrtop
	hlcoord 0, 0 * THIRD_HEIGHT, wAttrmap
	ld sp, hl

	ldh a, [hBGMapAddress + 1]
	ld h, a
	ldh a, [hBGMapAddress]
	ld l, a

; Next time: middle third
; 	ld a, 1


.fontattrstart
; Which third to update next time
; 	ldh [hBGMapThird], a

; Rows of tiles in a third
	ld b, SCREEN_HEIGHT / 3
	ld c, PALETTE_MASK

.fontattrrow
; Copy a row of 20 tiles
rept SCREEN_WIDTH / 2
	pop de
	ld a, [hl]
	xor e
	and c
	xor e
	ld [hli], a
	ld a, [hl]
	xor d
	and c
	xor d
	ld [hli], a
endr

	ld de, BG_MAP_WIDTH - SCREEN_WIDTH

	add hl, de
	dec b
	jr nz, .fontattrrow

	ldh a, [hSPBuffer]
	ld l, a
	ldh a, [hSPBuffer + 1]
	ld h, a
	ld sp, hl
	ret

_TextScroll::
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY 
	decoord TEXTBOX_INNERX, TEXTBOX_INNERY - 1
	ld bc, TEXTBOX_WIDTH * 3 - 1
	call CopyBytes
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY	, wAttrmap
	decoord TEXTBOX_INNERX, TEXTBOX_INNERY - 1, wAttrmap
	ld bc, TEXTBOX_WIDTH * 3 - 1
	call CopyBytes
	hlcoord TEXTBOX_INNERX - 1, TEXTBOX_INNERY + 2
	ld a, "│"
	ld [hli], a
	ld bc, TEXTBOX_INNERW
	ld a, " "
	call ByteFill
	ld [hl], "│"
	hlcoord TEXTBOX_INNERX - 1, TEXTBOX_INNERY + 2, wAttrmap
	ld bc, TEXTBOX_INNERW + 2
	call ClearVramNo
	ld c, 5
	call DelayFrames
	ret

_RestoreTileBackup::
	call MenuBoxCoord2Tile

.copy
	call GetMenuBoxDims
	inc b
	inc c

.row
	push bc
	push hl

.col
	push bc
	ld a, BANK(wDFSCodeStack)
	ldh [rSVBK], a
	ld a, [de]
	and a
	jr z, .single
	cp a, DFS_MASK_CLEAR
	jr z, .normal

	dec de
	push de
	push hl
	ld b, a

	ld h, d
	ld l, e
	ld a, [hli]
	ld d, a
	ld a, BANK(wWindowStack)
	ldh [rSVBK], a
	ld a, [hld]
	ld c, a
	ld e, [hl]
	pop hl

	ld a, BANK(wDFSCache)
	ldh [rSVBK], a

	ld a, b

	; 恢复右半对应汉字片
	; CCHHHHHH ICHHHHHH -> CCHHHHHH CCHHHHHH
	; 左半00 -> 右半01 / 左半01 -> 右半10 / 左半10 -> 右半00
	; 因此，右半CC的高位 == 左半CC的低位
	sla d ; cy = I
	rla
	rla   ; 左半CC低位 -> cy 同时 a = XXXXXXIX
	rr d  ; cy -> 右半CC高位
	rrca  ; a = XXXXXXXI
	and 1 ; a = 0000000I
	
	call DoubleCode_Restore
	pop de
	dec de
	jr .next

.single
	dec de
	ld a, [de]
	bit 7, a
	ld a, BANK(wWindowStack)
	ldh [rSVBK], a
	ld a, [de]
	jr nz, .single_end
	inc de
	ld a, [de]
	dec de
.single_end
	dec de
	push de
	ld b, a
	ld a, BANK(wDFSCache)
	ldh [rSVBK], a
	ld a, b
	call SingleCode_Restore
	pop de
	jr .next

.normal
	ld a, BANK(wWindowStack)
	ldh [rSVBK], a
	ld a, [de]
	ld [hl], a
	dec de
	ld bc, wAttrmap - wTilemap
	add hl, bc
	ld a, [de]
	ld [hl], a
	dec de
	ld bc, wTilemap - wAttrmap + 1
	add hl, bc
.next
	pop bc
	dec c
	jr nz, .col

	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row

	ld a, BANK(wWindowStack)
	ldh [rSVBK], a
	ret

_LoadTilemapToTempTilemap::
; Load Tilemap into TempTilemap
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDFSComplexTempTilemap) ; also BANK(wDFSCache)
	ldh [rSVBK], a

	decoord 0, 0, wDFSComplexTempTilemap
	hlcoord 0, 0

	ld bc, wTilemapEnd - wTilemap + $0100 ; 正常+$0101再跳dec c
.loop
	push bc
	push hl

	ld a, [hl]
	cp DFS_TILENO_VRAM0_START
	jr c, .normal
	ld bc, wAttrmap - wTilemap
	add hl, bc
	cp DFS_TILENO_VRAM0_END + 1
	bit OAM_TILE_BANK, [hl] ; bit keep cy

ASSERT LOW(wDFSCache) == 0, "Error wDFSCache is not $XX00 !"
	ld h, HIGH(wDFSCache)
	jr nz, .dfs_code
	inc h                   ; inc keep cy
	jr c, .dfs_code
.normal
	ld b, a
	ld a, DFS_MASK_CLEAR
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	inc de
	inc de
	jr .next

.dfs_code
	push af

	and a, %01111110
	rlca
	ld l, a ; l = 图块号（过滤最高位） * DFS_CACHE_SIZE

	pop bc ; push af
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]

	; CCHHHHHH -> ICHHHHHH
	; I用于标志使用缓存块中的哪部分，覆盖的C通过前面的CC还原
	rla
	rr b
	rra

	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
.next
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

_LoadTempTilemapToTilemap::
; Load TempTilemap into Tilemap
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDFSComplexTempTilemap) ; also BANK(wDFSCache)
	ldh [rSVBK], a
	hlcoord 0, 0
	decoord 0, 0, wDFSComplexTempTilemap
	ld bc, wTilemapEnd - wTilemap + $0100 ; 正常+$0101再跳dec c
.loop
	push bc
	ld a, [de]
	and a
	jr z, .single
	cp a, DFS_MASK_CLEAR
	jr z, .normal

	inc de
	push de
	push hl
	ld b, a

	ld h, d
	ld l, e
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop hl

	ld a, b

	; 恢复右半对应汉字片
	; CCHHHHHH ICHHHHHH -> CCHHHHHH CCHHHHHH
	; 左半00 -> 右半01 / 左半01 -> 右半10 / 左半10 -> 右半00
	; 因此，右半CC的高位 == 左半CC的低位
	sla d ; cy = I
	rla
	rla   ; 左半CC低位 -> cy 同时 a = XXXXXXIX
	rr d  ; cy -> 右半CC高位
	rrca  ; a = XXXXXXXI
	and 1 ; a = 0000000I

	call DoubleCode_TempTilemap
	pop de
	jr .next

.single
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	inc de
	bit 7, a
	ld a, b
	jr z, .single_end
	ld a, [de]
.single_end
	push de
	call SingleCode_TempTilemap
	pop de
	jr .next_2

.normal
	inc de
	call ResetVramNo
	ld a, [de]
	ld [hli], a
.next
	inc de
	inc de
.next_2
	inc de
	pop bc
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

dfsClearCache::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDFSCache)
	ldh [rSVBK], a
	ld a, DFS_MASK_CLEAR
	ld [wDFSFreeEng], a
	xor a
	ld [wDFSCombineCode], a

	ld hl, wDFSUsed
	ld b, DFS_CACHE_NUM ; $80
.loop1
	; res 0, [hl]
	; inc l ; wDFSUsed is XX00
	ld [hli], a
	dec b
	jr nz, .loop1
	ld hl, wDFSCache
	ld b, DFS_CACHE_NUM
	ld de, DFS_CACHE_SIZE
	ld a, DFS_MASK_CLEAR
.loop2
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop2
	pop af
	ldh [rSVBK], a
	ret

_dfsUnion::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDFSCache)
	ldh [rSVBK], a

	push de
	push hl
	ld b, h
	ld c, l

	ld hl, wDFSCode
	ld a, [hli]
	cp a, DFS_CODE_SINGLE_STA_1
	jr nc, StaticSingleCode
	cp a, DFS_CODE_SINGLE_DYN_0
	jr nc, SingleCode
	cp a, DFS_CODE_CONTRL_2
	jr nc, StaticSingleCode
	ld a, [hli]
	cp "@"
	jr z, StaticSingleCode

	ld a, [wDFSCombineCode]
	and a
	jr z, .not_combine
	ld a, [wDFSCombineAddr]
	cp c
	jr nz, .not_combine
	ld a, [wDFSCombineAddr + 1]
	cp b
	jp z, CombineDoubleCode
.not_combine
	ld a, [hli]
	ld b, a
	ld a, [hl]
	cp "@"
	jr z, DoubleCode
	ld a, b

	; DFS_CODE_NULL
	and a
	jr z, DoubleCode

	; DFS_CODE_DOUBLE_0       ~ DFS_CODE_DOUBLE_0_END
	cp a, DFS_CODE_CONTRL_0
	jp c, QuadrupleCode

	; DFS_CODE_CONTRL_2       ~ DFS_CODE_SINGLE_STA_1_END
	cp a, DFS_CODE_CONTRL_2
	jr nc, DoubleCode

	; %xxxx1000         ($x8) ~ %xxxx1111             ($xF)
	; DFS_CODE_DOUBLE_1 ($18) ~ DFS_CODE_DOUBLE_1_END ($1f)
	; DFS_CODE_DOUBLE_2 ($28) ~ DFS_CODE_DOUBLE_2_END ($2f)
	bit 3, a
	jp nz, QuadrupleCode
	; DFS_CODE_CONTRL_0       ~ DFS_CODE_CONTRL_0_END
	jr DoubleCode

StaticSingleCode:
	pop hl
	ld bc, wAttrmap - wTilemap
	add hl, bc
	res OAM_TILE_BANK, [hl]
	ld bc, wTilemap - wAttrmap
	add hl, bc
	ld [hli], a
	call PrintLetterDelay
	pop de
	xor a
	ld [wDFSCombineCode], a
	pop af
	ldh [rSVBK], a
	ret

SingleCode:
	call SingleCodeMain
	pop hl
	call SingleCodeDrawMap
	call PrintLetterDelay
	pop de
	xor a
	ld [wDFSCombineCode], a
	pop af
	ldh [rSVBK], a
	ret
SingleCode_Restore:
	push hl
	call SingleCodeMain
	pop hl
	jp SingleCodeDrawMap_Restore
SingleCode_TempTilemap:
	push hl
	call SingleCodeMain
	pop hl
	jp SingleCodeDrawMap_TempTilemap

DoubleCode:
	; bc: 00HHHHHH LLLLLLLL
	; de: 01HHHHHH LLLLLLLL
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	push hl
	; bc: 10HHHHHH LLLLLLLL
	; de: 00000000 00000000
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld c, [hl]
	ld de, $0000
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	pop de
	inc de
	ld a, [wDFSCode]
	ld [wDFSCombineCode], a
	ld a, [wDFSCode + 1]
	ld [wDFSCombineCode + 1], a
	ld a, l
	ld [wDFSCombineAddr], a
	ld a, h
	ld [wDFSCombineAddr + 1], a
.not_combine
	pop af
	ldh [rSVBK], a
	ret
DoubleCode_Restore:
	push af
	push hl
	call DoubleCodeMain
	pop hl
	pop bc
	jp DoubleCodeDrawMap_Restore
DoubleCode_TempTilemap:
	push af
	push hl
	call DoubleCodeMain
	pop hl
	pop bc
	jp DoubleCodeDrawMap_TempTilemap

CombineDoubleCode:
	; bc: 10HHHHHH LLLLLLLL
	; de: 00HHHHHH LLLLLLLL
	ld hl, wDFSCombineCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld c, [hl]
	ld hl, wDFSCode
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call DoubleCodeMain
	pop hl
	dec hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	push hl
	; bc: 01HHHHHH LLLLLLLL
	; de: 10HHHHHH LLLLLLLL
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, b
	set 7, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	pop de
	inc de
	xor a
	ld [wDFSCombineCode], a
	pop af
	ldh [rSVBK], a
	ret

QuadrupleCode:
	; bc: 00HHHHHH LLLLLLLL
	; de: 01HHHHHH LLLLLLLL
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	push hl
	; bc: 10HHHHHH LLLLLLLL
	; de: 00HHHHHH LLLLLLLL
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	push hl
	; bc: 01HHHHHH LLLLLLLL
	; de: 10HHHHHH LLLLLLLL
	ld hl, wDFSCode + 2
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, b
	set 7, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay

	pop de
	inc de
	inc de
	inc de
	xor a
	ld [wDFSCombineCode], a
	pop af
	ldh [rSVBK], a
	ret

SingleCodeMain:
	ld b, a
	call FindDfsCacheEng
	ret nc
	call FindFreeDfsCacheEng
	jr nc, .hitfree
	call dfsRecoverFreeCache
	call FindFreeDfsCacheEng
.hitfree
	push af
	call Send8FontToWRAMEng
	pop af
	push af
	call GetVramAddr
	ld c, 1 - 1
	call SendWRAM8FontToVram
	pop af
	ret
DoubleCodeMain:
	call FindDfsCache
	ret nc
	call FindFreeDfsCache
	jr nc, .hitfree
	call dfsRecoverFreeCache
	call FindFreeDfsCache
.hitfree
	push af
	call Send8FontToWRAM
	pop af
	push af
	call GetVramAddr
	ld c, 2 - 1
	call SendWRAM8FontToVram
	pop af
	ret

FindDfsCache:
	ld a, [wDFSVramLimit]
	and DFS_VRAM_LIMIT_VRAM0 | DFS_VRAM_LIMIT_VRAM1 ; 0
	jr z, .normal
	dec a ; 1
	jr z, .v0only
.v1only
	ld hl, wDFSCache ; v1 offset
	ld a, DFS_CACHE_NUM_VRAM1
	push af
	jr .loop
.v0only
	ld hl, wDFSCache + DFS_CACHE_NUM_VRAM1 * DFS_CACHE_SIZE ; v0 offset
	ld a, DFS_CACHE_NUM_VRAM0 + DFS_CACHE_NUM_VRAM1 ; 需要加上 V1 本身偏移
	push af
	ld a, DFS_CACHE_NUM_VRAM0
	jr .loop
.normal
	ld hl, wDFSCache
	ld a, DFS_CACHE_NUM
	push af
.loop
	push af
	ld a, [hli]
	cp b
	jr nz, .next1
	ld a, [hli]
	cp c
	jr nz, .next2
	ld a, [hli]
	cp d
	jr nz, .next3
	ld a, [hl]
	cp e
	jr nz, .next3

	; wDFSCache跳转到wDFSUsed , 等价于 hl /= 4
	; 方案很恶心，与wDFSCache和wDFSUsed地址强行绑定
	; 注意到 h 仅右移一位，但是 l 右移两位
	; 因为假定wDFSCache范围是 $D3XX ~ $D4XX, h 低两位数值一致
	; pop af
	; srl h       ; cy = h & 1 , h = h >> 1
	; ccf         ; cy ^= 1  ->  UGLY
	; rr l
	; srl l       ; l = l >> 2 | cy << 6

	; 目前的方案，根据数据差值来直接计算
	; 对wDFSUsed假定为 $XX00 的限制依然存在，如果地址变动需要处理
ASSERT LOW(wDFSUsed) == 0, "Error wDFSUsed is not $XX00 !"
	pop hl  ; h 为当前计数
	pop af  ; 前面压入的数字量
	sub h   ; 减去计数
	ld l, a ; 与 h 拼凑为wDFSUsed

	ld h, HIGH(wDFSUsed)
	set 0, [hl]
	; ld a, l
	rlca ; 将缓存块号转为Tile值(*2) , 同时 cy = 0
	ret
.next1
	inc hl
.next2
	inc hl
.next3
	inc hl
	pop af
	dec a
	jr nz, .loop
	pop af
	scf ; cy = 1
	ret

FindDfsCacheEng:
	ld a, [wDFSVramLimit]
	and DFS_VRAM_LIMIT_VRAM0 | DFS_VRAM_LIMIT_VRAM1
	jr z, .normal
	dec a
	jr z, .v0only
	ld hl, wDFSCache
	ld c, DFS_CACHE_NUM_VRAM1
	jr .loop
.v0only
	ld hl, wDFSCache + DFS_CACHE_NUM_VRAM1 * DFS_CACHE_SIZE ; v0 offset
	ld c, DFS_CACHE_NUM_VRAM0
	jr .loop
.normal
	ld hl, wDFSCache
	ld c, DFS_CACHE_NUM
.loop
	ld a, [hli]
	and a
	jr nz, .next1
	ld a, [hli]
	cp b
	jr z, .target
	ld a, [hli]
	and a
	jr nz, .next3
	ld a, [hl]
	cp b
	jr nz, .next3
.target
	; TODO: 备注或修订位运算逻辑
	srl h
	ccf
	rr l
	push af
	srl l
	ld h, HIGH(wDFSUsed)
	set 0, [hl]
	sla l
	pop af
	ld a, 0
	adc a, l
	and a
	ret
.next1
	inc hl
	inc hl
.next3
	inc hl
	dec c
	jr nz, .loop
	scf
	ret

FindFreeDfsCache:
	ld a, [wDFSVramLimit]
	and DFS_VRAM_LIMIT_VRAM0 | DFS_VRAM_LIMIT_VRAM1 ; 0
	jr z, .normal
	dec a ; 1
	jr z, .v0only
.v1only
	ld hl, wDFSUsed ; v1 offset
	ld a, DFS_CACHE_NUM_VRAM1
	jr .loop
.v0only
	ld hl, wDFSUsed + DFS_CACHE_NUM_VRAM1 ; v0 offset
	ld a, DFS_CACHE_NUM_VRAM0
	jr .loop
.normal
	ld hl, wDFSUsed
	ld a, DFS_CACHE_NUM
.loop
	bit 0, [hl]
	jr nz, .notfound
	set 0, [hl]
	push hl

	; TODO: 备注或修订位运算逻辑
	xor a
	sla l
	rla
	sla l
	rla
	add a, HIGH(wDFSCache)
	ld h, a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	pop hl
	ld a, l
	rlca
	ret
.notfound
	inc hl
	dec a
	jr nz, .loop
	scf
	ret

ASSERT DFS_MASK_CLEAR == $ff, "Error DFS_MASK_CLEAR != $ff"
FindFreeDfsCacheEng:
	ld a, [wDFSVramLimit]
	and DFS_VRAM_LIMIT_VRAM0 | DFS_VRAM_LIMIT_VRAM1 ; 0
	ld l, a
	ld a, [wDFSFreeEng]
	jr z, .normal
	dec l ; 1
	jr z, .v0only
.v1only
	inc a                            ; wDFSFreeEng 是清除状态？
	jr z, .v1only_2
	cp a, DFS_TILENO_VRAM0_START - 1 ; wDFSFreeEng 在 v1 范围内？
	jr c, .hitFreeEng
	ld a, DFS_MASK_CLEAR             ; 不在范围内，清除标记
	ld [wDFSFreeEng], a
.v1only_2
	ld hl, wDFSUsed ; v1 offset
	ld a, DFS_CACHE_NUM_VRAM1
	jr .loop
.v0only
	inc a                            ; wDFSFreeEng 是清除状态？
	jr z, .v0only_2
	cp a, DFS_TILENO_VRAM0_START - 1 ; wDFSFreeEng 在 v0 范围内？
	jr nc, .hitFreeEng
	ld a, DFS_MASK_CLEAR             ; 不在范围内，清除标记
	ld [wDFSFreeEng], a
.v0only_2
	ld hl, wDFSUsed + DFS_CACHE_NUM_VRAM1 ; v0 offset
	ld a, DFS_CACHE_NUM_VRAM0
	jr .loop
.normal
	inc a                            ; wDFSFreeEng 不是清除状态？
	jr nz, .hitFreeEng
	ld hl, wDFSUsed
	ld a, DFS_CACHE_NUM
.loop
	bit 0, [hl]
	jr z, .found
	inc hl
	dec a
	jr nz, .loop
	scf ; cy == 1
	ret
.found
	set 0, [hl]
	push hl

	; TODO: 备注或修订位运算逻辑
	xor a
	sla l
	rla
	sla l
	rla
	add a, HIGH(wDFSCache)
	ld h, a
	xor a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], DFS_MASK_CLEAR
	pop hl
	sla l
	xor a ; cy == 0
	ld a, l
	ld [wDFSFreeEng], a
	ret
.hitFreeEng
	push af
	ld l, a
	xor a
	sla l
	rla
	add a, HIGH(wDFSCache)
	ld h, a
	xor a
	ld [hli], a
	ld [hl], b
	ld hl, wDFSFreeEng
	ld [hl], DFS_MASK_CLEAR
	pop af
	and a ; cy == 0
	ret

ASSERT DFS_MASK_CLEAR == $ff, "Error DFS_MASK_CLEAR != $ff"

; 回收缓存
; 破坏 af hl
dfsRecoverFreeCache:
	push bc
	push de
	ld c, DFS_CACHE_NUM
	ld hl, wDFSUsed
	xor a
.loop1
	ld [hli], a
	dec c
	jr nz, .loop1

	ld de, wTilemap
	ld hl, wAttrmap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT + $0100 ; 正常+$0101再跳dec c
.loop2
	ld a, [de] ; a = 图块号 TDDDDDDD
	bit 7, a
	jr z, .next ; 非字符
	and a, %01111110
	rrca               ; a = 00DDDDDD 即还未计算在哪块显存的缓存块号
	bit OAM_TILE_BANK, [hl]
	jr nz, .is_not_vram0
	set 6, a
.is_not_vram0          ; a = 0CDDDDDD 显存块号，注意C为1是显存0，C为0时是显存1
	push hl
ASSERT LOW(wDFSUsed) == 0, "Error LOW(wDFSUsed) != 0"
	ld h, HIGH(wDFSUsed)
	ld l, a
	ld [hl], 1
	pop hl
.next
	inc hl
	inc de
	dec c
	jr nz, .loop2
	dec b
	jr nz, .loop2

	ld a, [wDFSFreeEng] ; wDFSFreeEng存的是缓存号 * 2的值，对应实际图块号
	inc a ; DFS_MASK_CLEAR
	jr z, .end
	srl a ; a >>= 1 ，前面inc整体被消除，a变为缓存号
	ld h, HIGH(wDFSUsed)
	ld l, a
	bit 0, [hl]
	jr nz, .end
	ld a, DFS_MASK_CLEAR
	ld [wDFSFreeEng], a
.end
	pop de
	pop bc
	ret

; 送汉字字符到内存
; bc: 字符左半片编码
; de: 字符右半片编码
; 破坏 af bc de
Send8FontToWRAM:
	push de
	call Get4RawFontAddr
	ld hl, wDFS8Font
	call DecompressRaw4FontTo8FontLeft
	pop bc
	ld a, b
	or c ; bc == $0000 ?
	jr z, SetFontStyle
	call Get4RawFontAddr
	ld hl, wDFS8Font + LEN_2BPP_TILE / 2 ; 跳过高半字符
	call DecompressRaw4FontTo8FontRight
	jr SetFontStyle

; 送英文字符到内存
; b : 英文字符编码
; 破坏 af c de hl
Send8FontToWRAMEng:
	ld h, 0
	ld l, b
	res 7, l
rept 3
	add hl, hl
endr
	ld bc, Font
	add hl, bc
	ld a, BANK(Font)
	ld bc, LEN_1BPP_TILE
	ld de, wDFS8Font
	call FarCopyBytesDouble
	jr SetFontStyle

; 获取字体片地址
; a : 返回字体片所在页
; bc: IIHHHHHH LLLLLLLL
; de: 返回字体片所在地址
; 破坏 bc hl
; II: 字体片在字符中的位置 00左 01中 10右
; HL: 字符编码
Get4RawFontAddr:
	ld a, b
	push af

	and a, DFS_MASK_DOUBLE ; a = 00HHHHHH
	sla c                  ; c = LLLLLLL0
	rla                    ; a = 0HHHHHHL
	ld b, 0
	ld d, b
	ld e, a                ; de = 00000000 0HHHHHHL
	ld hl, FontPointer
rept 3
	add hl, de
endr
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a                ; de = 字符所在字库地址
	ld a, [hl]             ; a =  字符所在字库页
	ld h, b
	ld l, c                ; hl = 00000000 LLLLLLL0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de             ; hl = 0LLLLLLL * 18 + 字符所在字库地址
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

; 设置字体风格
; wDFS8Font: 字体位置
; wDFSFontSytle: 字体风格
; 破坏 af b hl
SetFontStyle:
	ld a, [wDFSFontSytle]
	and a ; DFS_FONT_STYLE_STANDARD
	ret z
	ld hl, wDFS8Font
	dec a ; DFS_FONT_STYLE_DEX
	jr nz, .OverworldSytle8Font
.DexStyle8Font
	ld b, DFS_8FONT_SIZE
.dexloop
	ld a, [hl]
	cpl ; xor $FF
	ld [hli], a
	dec b
	jr nz, .dexloop
	ret
.OverworldSytle8Font
	ld b, DFS_8FONT_SIZE / 2
	ld a, $FF
.owloop
	ld [hli], a
	inc hl
	dec b
	jr nz, .owloop
	ret

; 获取显存地址
; a : BEEEEEEE
; b : 返回显存页
; hl: 返回图块在显存的地址
; 破坏 af de
; B : 显存所在页，0为显存1，1为显存0
; EE: 字符Tile号低7位（最高位必定为1）
GetVramAddr:
	sla a   ; cy = B
	ccf     ; B ^= 1 0为显存1，1为显存0
	ld b, 0
	rl b    ; b = B
	rrca    ; a = 0EEEEEEE
	swap a
	ld e, a
	and a, $0F
	ld d, a
	ld a, e
	and a, $F0
	ld e, a
	ld hl, vTiles1 ; vTiles4
	add hl, de
	ret

; 内存8px字体送显存
; 因为是GBC Only，使用DHMA传输
; wDFS8Font: 图块来源
; hl: 图块目标地址
; b : 显存页
; c : 图块数量 - 1。传输1个图块，填写0
SendWRAM8FontToVram:
	ld a, HIGH(wDFS8Font)
	ldh [rHDMA1], a
	ld a, LOW(wDFS8Font)
	ldh [rHDMA2], a
	ld a, h
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ldh a, [rLCDC]
	bit rLCDC_ENABLE, a
	jr nz, .wait1
; 场消隐 HDMA，LCDC关闭时使用
	ld a, b
	di
	ldh [rVBK], a
	ld a, c
	ldh [rHDMA5], a
	xor a
	ldh [rVBK], a
	reti
; 行消隐 HDMA，LCDC开启时使用
.wait1
	ldh a, [rLY]
	cp a, LY_VBLANK - 4 ; 快发生行消隐时直接跑空
	jr nc, .wait1
	ld a, b
	set 7, c ; 设置行消隐 HDMA
	di
	ldh [rVBK], a
.wait2
	ldh a, [rSTAT]
	and a, 3
	jr nz, .wait2
.wait3
	ldh a, [rSTAT]
	and a, 3
	jr z, .wait3
	ld a, c
	ldh [rHDMA5], a
.wait4
	ldh a, [rHDMA5]
	cp a, -1 ; end of HBlank
	jr nz, .wait4
	xor a
	ldh [rVBK], a
	reti

; TempTilemap恢复时汉字画到背景
; a : BCCCCCCC
; b : 0为字符上半 1为字符下半
; hl: 写入wTilemap的位置，结果自增
; 破坏 bc
; B : 显存所在页，0为显存1，1为显存0
; CC: 字符上半Tile号低7位（最高位必定为1）
DoubleCodeDrawMap_TempTilemap:
	add a, b
	; fall through

; TempTilemap恢复时英文画到背景
; 等同于SingleCodeDrawMap
SingleCodeDrawMap_TempTilemap:
	; fall through

; 英文画到背景
; a : BEEEEEEE
; hl: 写入wTilemap的位置，结果自增
; 破坏 bc
; B : 显存所在页，0为显存1，1为显存0
; EE: 字符Tile号低7位（最高位必定为1）
SingleCodeDrawMap:
	ld b, a
	ld a, [wDFSVramLimit]
	ld c, a
	ld a, b
	set 7, a
	ld [hli], a
	bit DFS_VRAM_LIMIT_NOATTR_BIT, c
	ret nz
	bit 7, b
	ld bc, wAttrmap - (wTilemap + 1)
	add hl, bc ; add hl, rr keep zy
	jr z, .is_vram1
	res OAM_TILE_BANK, [hl]
	ld bc, (wTilemap + 1) - wAttrmap
	add hl, bc
	ret
.is_vram1
	set OAM_TILE_BANK, [hl]
	ld bc, (wTilemap + 1) - wAttrmap
	add hl, bc
	ret

; 汉字画到背景
; a : BCCCCCCC
; hl: 写入wTilemap的位置，结果自增
; 破坏 bc de
; B : 显存所在页，0为显存1，1为显存0
; EE: 字符上半Tile号低7位（最高位必定为1）
DoubleCodeDrawMap:
	ld d, a
	ld a, [wDFSVramLimit]
	ld e, a
	ld a, d
	set 7, a
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld [hl], a
	inc a
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hli], a
	bit DFS_VRAM_LIMIT_NOATTR_BIT, e
	ret nz
	ld bc, wAttrmap - (wTilemap + 1) - SCREEN_WIDTH
	add hl, bc
	bit 7, d
	jr z, .is_vram1
	res OAM_TILE_BANK, [hl]
	ld bc, SCREEN_WIDTH
	add hl, bc
	res OAM_TILE_BANK, [hl]
	ld bc, (wTilemap + 1) - wAttrmap
	add hl, bc
	ret
.is_vram1
	set OAM_TILE_BANK, [hl]
	ld bc, SCREEN_WIDTH
	add hl, bc
	set OAM_TILE_BANK, [hl]
	ld bc, (wTilemap + 1) - wAttrmap
	add hl, bc
	ret

; 菜单恢复时字符画到背景
; a : BCCCCCCC 或 BEEEEEEE
; b : 0为字符上半 1为字符下半，英文无此参数
; hl: 写入wTilemap的位置，结果自增
; 破坏 bc
; B : 显存所在页，0为显存1，1为显存0
; CC/EE: 字符上半Tile号低7位（最高位必定为1）
DoubleCodeDrawMap_Restore:
	add a, b
SingleCodeDrawMap_Restore:
	; 不检测wDFSVramLimit，因为菜单恢复总伴随Attr更新
	ld bc, wAttrmap - wTilemap
	add hl, bc
	bit 7, a
	jr z, .is_vram1
	ld [hl], PAL_BG_TEXT ; 所有恢复的字符都会被视为是7号调色板
	jr .end
.is_vram1
	ld [hl], PAL_BG_TEXT | VRAM_BANK_1
	set 7, a
.end
	ld bc, wTilemap - wAttrmap
	add hl, bc
	ld [hli], a
	ret

MACRO dfontab
rept _NARG
	dwb DFS_C_\1_L, BANK(DFS_C_\1_L)
	dwb DFS_C_\1_H, BANK(DFS_C_\1_H)
	shift
endr
ENDM

; 字符串首字母右对齐
; b : 英文起始的字符，返回是否右移hl 0: 不移动 1:移动
; c : 字符串首字母，用于判断英文起始
; de: 字符串位置
; hl: 返回最终字符串位置，可能存在偏移
dfsFirstCharRightAlign::
	ld h, d
	ld l, e
	ld a, c
	cp "@" ; terminator
	jr z, .singlechar ; .done
	and a
	jr z, .singlechar
	cp DFS_CODE_CONTRL_0
	jr c, .doublechar
	cp DFS_CODE_CONTRL_2
	jr nc, .singlechar
	bit 3, a
	jr z, .singlechar
.doublechar
	inc hl
	getchar_w "　"
	ld a, HIGH(CHARMAP_W_CHAR)
	ld [wDFSCombineCode], a
if HIGH(CHARMAP_W_CHAR) != LOW(CHARMAP_W_CHAR)
	ld a, LOW(CHARMAP_W_CHAR)
endc
	ld [wDFSCombineCode + 1], a
	ldh a, [rSVBK]
	ld b, a
	ld a, BANK(wDFSCombineAddr)
	ldh [rSVBK], a
	ld a, l
	ld [wDFSCombineAddr], a
	ld a, h
	ld [wDFSCombineAddr + 1], a
	ld a, b
	ldh [rSVBK], a
	ret

.singlechar
	bit 0, b
	ret z
	inc hl
	ret

FontPointer:
	dfontab FF, 01, 02, 03, 04, 05, 06, 07, 08, 09, 0A, 0B, 0C, 0D, 0E, 0F
	dfontab 10, 11, 12, 13, FF, FF, FF, FF, 18, 19, 1A, 1B, 1C, 1D, 1E, 1F
	dfontab FF, FF, FF, FF, FF, FF, FF, FF, 28, 29, 2A, 2B, 2C, 2D, 2E, FF

; CheckStringForErrors_Debug::
; 	di
; 	ld a, BANK(CheckStringForErrors_Debug)
; 	ldh [hROMBank], a
; 	ld bc, .TestStringEnd - .TestString1
; 	ld hl, .TestString1
; 	ld de, wStringBuffer1
; 	call CopyBytes
; 	; 半截汉字，定长检测
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString1
; 	ld c, 1
; 	farcall CheckStringForErrors
; 	ld a, 0
; 	call nc, .Broken ; Fail
; 	; 完整汉字，定长检测
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString1
; 	ld c, 2
; 	farcall CheckStringForErrors
; 	ld a, 1
; 	call c,  .Broken ; Pass
; 	; 完整字符串，结束符检测
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString1
; 	ld c, 17
; 	farcall CheckStringForErrors
; 	ld a, 2
; 	call c,  .Broken ; Pass
; 	; 完整字符串，结束符忽略，监测到后续错误
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString1
; 	ld c, 17
; 	farcall CheckStringForErrors_IgnoreTerminator
; 	ld a, 3
; 	call nc, .Broken ; Fail
; 	; 不完整汉字字符串
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString2
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 4
; 	call nc, .Broken ; Fail
; 	; 中英混杂
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString3
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 5
; 	call c,  .Broken ; Pass
; 	; 超出汉字范围 $01FF
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString4
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 6
; 	call nc, .Broken ; Fail
; 	; 单个 $00 混杂
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString5
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 7
; 	call nc, .Broken ; Fail
; 	; 超出汉字范围 $0001
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString6
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 8
; 	call nc, .Broken ; Fail
; 	; 超出汉字范围 $01FD
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString7
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 9
; 	call nc, .Broken ; Fail
; 	; 汉字上下界
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString8
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 10
; 	call c,  .Broken ; Pass
; 	; 结束符忽略
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString9
; 	ld c, 10
; 	farcall CheckStringForErrors_IgnoreTerminator
; 	ld a, 11
; 	call c,  .Broken ; Pass
; 	; 控制符
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString10
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 12
; 	call nc, .Broken ; Fail
; 	; 中文低字节控制符
; 	ld de, wStringBuffer1 -  .TestString1 + .TestString10
; 	ld c, 20
; 	farcall CheckStringForErrors
; 	ld a, 13
; 	call nc, .Broken ; Fail

; .AllPass
; 	jr .AllPass
; .Broken
; 	jr .Broken

; .TestString1
; 	db_w "测试文本@"
; .TestString2
;	getchar_w("本")
; 	db_w "测试文", HIGH(CHARMAP_W_CHAR), "@"
; .TestString3
; 	db_w "中Aa混Zz@"
; .TestString4
; 	db_w "中", $01, $FF, "@"
; .TestString5
; 	db_w "中", $00, "文@"
; .TestString6
; 	db_w "中", $00, $01, "文@"
; .TestString7
; 	db_w "中", $01, $FD, "文@"
; .TestString8
; 	db_w $01, $01, $01, $FC, $13, $01, $13, $FC
; 	db_w $18, $01, $18, $FC, $28, $01, $28, $FC
; 	db_w $2E, $01, $2E, $FC
; 	db_w $60, $70, $FC, $FD, $FE, $FF
; 	db_w "@"
; .TestString9
; 	db_w "中文@@测试"
; .TestString10
; 	db_w "这是A<CONT>控制符文本@"
; .TestString11
; 	db_w "这是", $01, "<CONT>控制符@"
; .TestStringEnd

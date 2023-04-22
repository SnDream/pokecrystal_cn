_Diploma:
	call PlaceDiplomaOnScreen
	call WaitPressAorB_BlinkCursor
	ret

PlaceDiplomaOnScreen:
	call ClearBGPalettes
	call ClearTilemap
	call ClearSprites
	call DisableLCD
	farcall dfsClearCache
	ld a, DFS_VRAM_LIMIT_VRAM0
	ld [wDFSVramLimit], a
	ld hl, DiplomaGFX
	ld de, vTiles2
	call Decompress
	ld hl, DiplomaPage1Tilemap
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyBytes
	ld de, .Player
	hlcoord 2, 5
	call PlaceString
	; ld de, .EmptyString
	; hlcoord 15, 5
	; call PlaceString
	ld de, wPlayerName
	hlcoord 6, 5
	call PlaceString
	ld h, b
	ld l, c
	ld de, .EmptyString
	call PlaceString
	ld de, .Certification
	hlcoord 2, 8
	call PlaceString
	call EnableLCD
	call WaitBGMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetPalettes
	call DelayFrame
	xor a ; DFS_VRAM_LIMIT_NOLIMIT
	ld [wDFSVramLimit], a
	ret

.Player:
	db "玩家@"

.EmptyString:
	db "@"

.Certification:
	db   "恭喜您完成"
	next "新型宝可梦图鉴！"
	next ""
	next "特发此状，以资鼓励！"
	next "      GAME FREAK"
	db   "@"

PrintDiplomaPage2:
	ld a, DFS_VRAM_LIMIT_VRAM0
	ld [wDFSVramLimit], a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	call ByteFill
	ld hl, DiplomaPage2Tilemap
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyBytes
	; ld de, .GameFreak
	; hlcoord 8, 0
	; call PlaceString
	ld de, .PlayTime
	hlcoord 3, 15
	call PlaceString
	hlcoord 10, 15
	ld de, wGameTimeHours
	lb bc, 2, 4
	call PrintNum
	ld [hl], $67 ; colon
	inc hl
	ld de, wGameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	xor a ; DFS_VRAM_LIMIT_NOLIMIT
	ld [wDFSVramLimit], a
	ret

.PlayTime: db "游戏时间@"
.GameFreak: db "GAME FREAK@"

DiplomaGFX:
INCBIN "gfx/diploma/diploma.2bpp.lz"

DiplomaPage1Tilemap:
INCBIN "gfx/diploma/page1.tilemap"

DiplomaPage2Tilemap:
INCBIN "gfx/diploma/page2.tilemap"

Diploma_DummyFunction: ; unreferenced
	ret

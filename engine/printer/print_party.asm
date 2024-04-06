DEF PRINTPARTY_HP EQU "◀" ; $71

PrintPage1:
	farcall dfsClearCache
	hlcoord 0, 0
	decoord 0, 0, wPrinterTilemapBuffer
	ld bc, 10 * SCREEN_WIDTH
	call CopyBytes
	hlcoord 9, 6, wPrinterTilemapBuffer
	ld de, .Height
	call PlaceString
	hlcoord 9, 8, wPrinterTilemapBuffer
	ld de, .Weight
	call PlaceString
	call GetPokemonName
	hlcoord 9, 2, wPrinterTilemapBuffer
	call PlaceString ; mon species
	ld a, [wTempSpecies]
	ld b, a
	farcall GetDexEntryPointer
	ld a, b
	call IncreaseDFSCombineLevel
	hlcoord 9, 4, wPrinterTilemapBuffer
	call PlaceFarString ; dex species
	ld h, b
	ld l, c
	ld de, .PokemonStr
	call PlaceString
	call DecreaseDFSCombineLevel
	hlcoord 17, 1, wPrinterTilemapBuffer
	ld a, $62
	ld [hli], a
	inc a ; $63
	ld [hl], a
	hlcoord 17, 2, wPrinterTilemapBuffer
	ld a, $64
	ld [hli], a
	inc a ; $65
	ld [hl], a
	; hlcoord 1, 9, wPrinterTilemapBuffer
	; ld a, " "
	; ld [hli], a
	; ld [hl], a
	; hlcoord 1, 10, wPrinterTilemapBuffer
	; ld a, $61
	; ld [hli], a
	; ld [hl], a
	; hlcoord 2, 11, wPrinterTilemapBuffer
	; lb bc, 5, 18
	; call ClearBox
	; ld a, [wTempSpecies]
	; dec a
	; call CheckCaughtMon
	; push af
	; ld a, [wTempSpecies]
	; ld b, a
	; ld c, 1 ; get page 1
	; farcall GetDexEntryPagePointer
	; pop af
	; ld a, b
	; hlcoord 1, 11, wPrinterTilemapBuffer
	; call nz, PlaceFarString
	hlcoord 19, 0, wPrinterTilemapBuffer
	ld [hl], $35
	ld de, SCREEN_WIDTH
	add hl, de
	ld b, $f
.column_loop
	ld [hl], $37
	add hl, de
	dec b
	jr nz, .column_loop
	ld [hl], $3a
	ret

.Height:
	db_w "身高@"
.Weight:
	db_w "体重@"
.PokemonStr
	db_w "宝可梦@"

PrintPage2:
	farcall dfsClearCache
	hlcoord 0, 0, wPrinterTilemapBuffer
	ld bc, 8 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	hlcoord 0, 0, wPrinterTilemapBuffer
	ld a, $36
	ld b, 6
	call .FillColumn
	hlcoord 19, 0, wPrinterTilemapBuffer
	ld a, $37
	ld b, 6
	call .FillColumn
	hlcoord 0, 6, wPrinterTilemapBuffer
	ld [hl], $38
	inc hl
	ld a, $39
	ld bc, SCREEN_HEIGHT
	call ByteFill
	ld [hl], $3a
	hlcoord 0, 7, wPrinterTilemapBuffer
	ld bc, SCREEN_WIDTH
	ld a, $32
	call ByteFill
	ld a, [wTempSpecies]
	dec a
	call CheckCaughtMon
	push af
	ld a, [wTempSpecies]
	ld b, a
	ld c, 1 ; get page 1
	farcall GetDexEntryPagePointer
	pop af
	hlcoord 1, 1, wPrinterTilemapBuffer
	ld a, b
	call nz, PlaceFarString
	ret

.FillColumn:
	push de
	ld de, SCREEN_WIDTH
.column_loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .column_loop
	pop de
	ret

GBPrinterStrings: ; used only for BANK(GBPrinterStrings)
GBPrinterString_Null: db_w "@"
GBPrinterString_CheckingLink: next " 正在检查连接...@"
GBPrinterString_Transmitting: next "  正在传输...@"
GBPrinterString_Printing:     next "  正在打印...@"
GBPrinterString_PrinterError1:
	db_w " 打印错误  错误1"
	next ""
	next "请阅读袖珍打印机的"
	next "说明书。"
	db_w "@"
GBPrinterString_PrinterError2:
	db_w " 打印错误  错误2"
	next ""
	next "请阅读袖珍打印机的"
	next "说明书。"
	db_w "@"
GBPrinterString_PrinterError3:
	db_w " 打印错误  错误3"
	next ""
	next "请阅读袖珍打印机的"
	next "说明书。"
	db_w "@"
GBPrinterString_PrinterError4:
	db_w " 打印错误  错误4"
	next ""
	next "请阅读袖珍打印机的"
	next "说明书。"
	db_w "@"

PrintPartyMonPage1:
	call ClearBGPalettes
	call ClearTilemap
	call ClearSprites
	farcall dfsClearCache
	xor a
	ldh [hBGMapMode], a
	call LoadFontsBattleExtra

	ld de, GBPrinterHPIcon
	ld hl, vTiles2 tile PRINTPARTY_HP
	lb bc, BANK(GBPrinterHPIcon), 1
	call Request1bpp

	ld de, GBPrinterLvIcon
	ld hl, vTiles2 tile "<LV>"
	lb bc, BANK(GBPrinterLvIcon), 1
	call Request1bpp

	ld de, StatsScreenPageTilesGFX + 14 tiles ; shiny icon
	ld hl, vTiles2 tile "⁂"
	lb bc, BANK(StatsScreenPageTilesGFX), 1
	call Get2bpp

	ld a, DFS_VRAM_LIMIT_VRAM0
	ld [wDFSVramLimit], a

	xor a
	ld [wMonType], a
	farcall CopyMonToTempMon
	hlcoord 7, 0
	ld b, 16
	ld c, 11
	call Textbox
	hlcoord 0, 8
	lb bc, 8, 8
	call Textbox
	call PrinterPlaceStringToStaticArea
	hlcoord 8, 1
	ld a, [wTempMonLevel]
	call PrintLevel_Force3Digits
	hlcoord 12, 1
	ld [hl], PRINTPARTY_HP
	inc hl
	ld de, wTempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndex], a
	; ld [wCurSpecies], a
	; ld hl, wPartyMonNicknames
	; call GetCurPartyMonName
	; hlcoord 8, 4
	; call PlaceString
	; hlcoord 9, 6
	; ld [hl], "/"
	hlcoord 8, 3
	ld de, PrintParty_MoveString
	call PlaceString
	call GetPokemonName
	hlcoord 11, 3
	call PlaceString
	hlcoord 1, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	ld de, wNamedObjectIndex
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	hlcoord 8, 5
	ld de, PrintParty_OTString
	call PlaceString
	ld hl, wPartyMonOTs
	call GetCurPartyMonName
	hlcoord 12, 5
	call PlaceString
	hlcoord 11, 6
	ld de, PrintParty_IDNoString
	call PlaceString
	hlcoord 14, 6
	ld de, wTempMonID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	hlcoord 16, 8
	ld de, wTempMonAttack
	call .PrintTempMonStats
	hlcoord 16, 10
	ld de, wTempMonDefense
	call .PrintTempMonStats
	hlcoord 16, 12
	ld de, wTempMonSpclAtk
	call .PrintTempMonStats
	hlcoord 16, 14
	ld de, wTempMonSpclDef
	call .PrintTempMonStats
	hlcoord 16, 16
	ld de, wTempMonSpeed
	call .PrintTempMonStats

	; hlcoord 1, 14
	; ld de, PrintParty_MoveString
	; call PlaceString
	hlcoord 1, 10
	ld a, [wTempMonMoves + 0]
	call PlaceMoveNameString
	hlcoord 1, 12
	ld a, [wTempMonMoves + 1]
	call PlaceMoveNameString
	hlcoord 1, 14
	ld a, [wTempMonMoves + 2]
	call PlaceMoveNameString
	hlcoord 1, 16
	ld a, [wTempMonMoves + 3]
	call PlaceMoveNameString
	call PlaceGenderAndShininess
	ld hl, wTempMonDVs
	predef GetUnownLetter
	ld hl, wBoxAlignment
	xor a
	ld [hl], a
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr z, .got_alignment
	inc [hl]
.got_alignment
	hlcoord 0, 1
	call _PrepMonFrontpic
	call WaitBGMap
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call SetPalettes
	xor a ; DFS_VRAM_LIMIT_NOLIMIT
	ld [wDFSVramLimit], a
	ret

; PrintPartyMonPage2:
	; call ClearBGPalettes
	; call ClearTilemap
	; call ClearSprites
	; xor a
	; ldh [hBGMapMode], a
	; call LoadFontsBattleExtra
	; xor a
	; ld [wMonType], a
	; farcall CopyMonToTempMon
	; hlcoord 0, 0
	; ld b, 15
	; ld c, 18
	; call Textbox
	; ld bc, SCREEN_WIDTH
	; decoord 0, 0
	; hlcoord 0, 1
	; call CopyBytes
	; hlcoord 7, 0
	; ld a, [wTempMonMoves + 1]
	; call PlaceMoveNameString
	; hlcoord 7, 2
	; ld a, [wTempMonMoves + 2]
	; call PlaceMoveNameString
	; hlcoord 7, 4
	; ld a, [wTempMonMoves + 3]
	; call PlaceMoveNameString
	; hlcoord 7, 7
	; ld de, PrintParty_StatsString
	; call PlaceString
	; hlcoord 16, 7
	; ld de, wTempMonAttack
	; call .PrintTempMonStats
	; hlcoord 16, 9
	; ld de, wTempMonDefense
	; call .PrintTempMonStats
	; hlcoord 16, 11
	; ld de, wTempMonSpclAtk
	; call .PrintTempMonStats
	; hlcoord 16, 13
	; ld de, wTempMonSpclDef
	; call .PrintTempMonStats
	; hlcoord 16, 15
	; ld de, wTempMonSpeed
	; call .PrintTempMonStats
	; call WaitBGMap
	; ld b, SCGB_STATS_SCREEN_HP_PALS
	; call GetSGBLayout
	; call SetPalettes
	; ret

.PrintTempMonStats:
	lb bc, 2, 3
	call PrintNum
	ret

PrinterPlaceStringToStaticArea:
	hlcoord 10, 8
	ld de, PrintParty_StatsString
	call PlaceString
	ld hl, vTiles1
	ld de, vTiles2 tile $40
	ld bc, (5 * 6) tiles + $0100 ; 正常+$0101再跳dec c
.loop0
	ldh a, [rSTAT]
	bit 1, a
	jr nz, .loop0
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop0
	dec b
	jr nz, .loop0

	hlcoord 0, 8
	ld bc, 10 * SCREEN_WIDTH + $0100 ; 正常+$0101再跳dec c
.loop1
	ld a, [hl]
	cp a, DFS_TILENO_VRAM0_START
	jr c, .skip
	sub a, DFS_TILENO_VRAM0_START - $40
.skip
	ld [hli], a
	dec c
	jr nz, .loop1
	dec b
	jr nz, .loop1
	ret

GetCurPartyMonName:
	ld bc, NAME_LENGTH
	ld a, [wCurPartyMon]
	call AddNTimes
	ld e, l
	ld d, h
	ret

PlaceMoveNameString:
	and a
	jr z, .no_move

	ld [wNamedObjectIndex], a
	call GetMoveName
	jr .got_string

.no_move
	ld de, PrintParty_NoMoveString

.got_string
	call PlaceString
	ret

PlaceGenderAndShininess:
	farcall GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 17, 1
	ld [hl], a
	ld bc, wTempMonDVs
	farcall CheckShininess
	ret nc
	hlcoord 18, 1
	ld [hl], "⁂"
	ret

PrintParty_OTString:
	db_w "初训/@"

PrintParty_MoveString:
	db_w "名/@"

PrintParty_IDNoString:
	db_w "<ID>№.@"

PrintParty_StatsString:
	db_w "攻击"
	next "防御"
	next "特攻"
	next "特防"
	next "速度"
	db_w "@"

PrintParty_NoMoveString:
	db_w "--------@"

GBPrinterHPIcon:
INCBIN "gfx/printer/hp.1bpp"

GBPrinterLvIcon:
INCBIN "gfx/printer/lv.1bpp"

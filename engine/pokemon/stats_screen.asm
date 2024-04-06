	const_def 1
	const PINK_PAGE  ; 1
	const GREEN_PAGE ; 2
	const BLUE_PAGE  ; 3
DEF NUM_STAT_PAGES EQU const_value - 1

DEF STAT_PAGE_MASK EQU %00000011

BattleStatsScreenInit:
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jr nz, StatsScreenInit

	ld a, [wBattleMode]
	and a
	jr z, StatsScreenInit
	jr _MobileStatsScreenInit

StatsScreenInit:
	ld hl, StatsScreenMain
	jr StatsScreenInit_gotaddress

_MobileStatsScreenInit:
	ld hl, StatsScreenMobile
	jr StatsScreenInit_gotaddress

StatsScreenInit_gotaddress:
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a ; disable overworld tile animations
	ld a, [wBoxAlignment] ; whether sprite is to be mirrorred
	push af
	ld a, [wJumptableIndex]
	ld b, a
	ld a, [wStatsScreenFlags]
	ld c, a

	push bc
	push hl
	call ClearBGPalettes
	call ClearTilemap
	call UpdateSprites
	farcall StatsScreen_LoadFont
	pop hl
	call _hl_
	call ClearBGPalettes
	call ClearTilemap
	pop bc

	; restore old values
	ld a, b
	ld [wJumptableIndex], a
	ld a, c
	ld [wStatsScreenFlags], a
	pop af
	ld [wBoxAlignment], a
	pop af
	ldh [hMapAnims], a
	ret

StatsScreenMain:
	xor a
	ld [wJumptableIndex], a
; ???
	ld [wStatsScreenFlags], a
	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or PINK_PAGE ; first_page
	ld [wStatsScreenFlags], a
.loop
	ld a, [wJumptableIndex]
	and ~(1 << 7)
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
	ret

StatsScreenMobile:
	xor a
	ld [wJumptableIndex], a
; ???
	ld [wStatsScreenFlags], a
	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or PINK_PAGE ; first_page
	ld [wStatsScreenFlags], a
.loop
	farcall Mobile_SetOverworldDelay
	ld a, [wJumptableIndex]
	and $7f
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call StatsScreen_WaitAnim
	farcall MobileComms_CheckInactivityTimer
	jr c, .exit
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop

.exit
	ret

StatsScreenPointerTable:
	dw MonStatsInit       ; regular pokémon
	dw EggStatsInit       ; egg
	dw StatsScreenWaitCry
	dw EggStatsJoypad
	dw StatsScreen_LoadPage
	dw StatsScreenWaitCry
	dw MonStatsJoypad
	dw StatsScreen_Exit

StatsScreen_WaitAnim:
	ld hl, wStatsScreenFlags
	bit 6, [hl]
	jr nz, .try_anim
	bit 5, [hl]
	jr nz, .finish
	call DelayFrame
	ret

.try_anim
	farcall SetUpPokeAnim
	jr nc, .finish
	ld hl, wStatsScreenFlags
	res 6, [hl]
; .finish
	ld hl, wStatsScreenFlags
	res 5, [hl]
	farcall HDMATransferTilemapToWRAMBank3
	ret

.finish
	ld hl, wcf64
	res 5, [hl]
	farcall _HDMATransferTilemapAndAttrmap_Menu
	ret

StatsScreen_SetJumptableIndex:
	ld a, [wJumptableIndex]
	and $80
	or h
	ld [wJumptableIndex], a
	ret

StatsScreen_Exit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

MonStatsInit:
	ld hl, wStatsScreenFlags
	res 6, [hl]
	call ClearBGPalettes
	call ClearTilemap
	farcall HDMATransferTilemapToWRAMBank3
	call StatsScreen_CopyToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call StatsScreen_InitLeftHalf
	ld hl, wStatsScreenFlags
	set 4, [hl]
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.egg
	ld h, 1
	call StatsScreen_SetJumptableIndex
	ret

EggStatsInit:
	call EggStatsScreen
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

EggStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .check
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.check
	bit A_BUTTON_F, a
	jr nz, .quit
if DEF(_DEBUG)
	cp START
	jr z, .hatch
endc
	and D_DOWN | D_UP | A_BUTTON | B_BUTTON
	jp StatsScreen_JoypadAction

.quit
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

if DEF(_DEBUG)
.hatch
	ld a, [wMonType]
	or a
	jr nz, .skip
	push bc
	push de
	push hl
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Happiness
	call AddNTimes
	ld [hl], 1
	ld a, 1
	ld [wTempMonHappiness], a
	ld a, 127
	ld [wStepCount], a
	ld de, .HatchSoonString
	hlcoord 8, 17
	call PlaceString
	ld hl, wStatsScreenFlags
	set 5, [hl]
	pop hl
	pop de
	pop bc
.skip
	xor a
	jp StatsScreen_JoypadAction

.HatchSoonString:
	db_w "▶即将孵化！　@"
endc

StatsScreen_LoadPage:
	call StatsScreen_LoadGFX
	ld hl, wStatsScreenFlags
	res 4, [hl]
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

MonStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .next
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.next
	and D_DOWN | D_UP | D_LEFT | D_RIGHT | A_BUTTON | B_BUTTON
	jp StatsScreen_JoypadAction

StatsScreenWaitCry:
	call IsSFXPlaying
	ret nc
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

StatsScreen_CopyToTempMon:
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .not_tempmon
	ld a, [wBufferMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wBufferMon
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	jr .done

.not_tempmon
	farcall CopyMonToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .done
	ld a, [wMonType]
	cp BOXMON
	jr c, .done
	farcall CalcTempmonStats
.done
	and a
	ret

StatsScreen_GetJoypad:
	call GetJoypad
	ld a, [wMonType]
	cp TEMPMON
	jr nz, .not_tempmon
	push hl
	push de
	push bc
	farcall StatsScreenDPad
	pop bc
	pop de
	pop hl
	ld a, [wMenuJoypad]
	and D_DOWN | D_UP
	jr nz, .set_carry
	ld a, [wMenuJoypad]
	jr .clear_carry

.not_tempmon
	ldh a, [hJoyPressed]
.clear_carry
	and a
	ret

.set_carry
	scf
	ret

StatsScreen_JoypadAction:
	push af
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	pop af
	bit B_BUTTON_F, a
	jp nz, .b_button
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	jr .done

.d_down
	ld a, [wMonType]
	cp BOXMON
	jr nc, .done
	and a
	ld a, [wPartyCount]
	jr z, .next_mon
	ld a, [wOTPartyCount]
.next_mon
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	cp b
	jr z, .done
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.d_up
	ld a, [wCurPartyMon]
	and a
	jr z, .done
	dec a
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .load_mon
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon

.a_button
	ld a, c
	cp BLUE_PAGE ; last page
	jr z, .b_button
.d_right
	inc c
	ld a, BLUE_PAGE ; last page
	cp c
	jr nc, .set_page
	ld c, PINK_PAGE ; first page
	jr .set_page

.d_left
	dec c
	jr nz, .set_page
	ld c, BLUE_PAGE ; last page
	jr .set_page

.done
	ret

.set_page
	ld a, [wStatsScreenFlags]
	and ~STAT_PAGE_MASK
	or c
	ld [wStatsScreenFlags], a
	ld h, 4
	call StatsScreen_SetJumptableIndex
	ret

.load_mon
	ld h, 0
	call StatsScreen_SetJumptableIndex
	ret

.b_button
	ld h, 7
	call StatsScreen_SetJumptableIndex
	ret

StatsScreen_InitLeftHalf:
	call .PlaceHPBar
	xor a
	ldh [hBGMapMode], a
	ld a, DFS_VRAM_LIMIT_VRAM1
	ld [wDFSVramLimit], a
	ld a, [wBaseDexNo]
	ld [wTextDecimalByte], a
	ld [wCurSpecies], a
	hlcoord 1, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	hlcoord 3, 0
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	ld de, wTextDecimalByte
	call PrintNum
	hlcoord 1, 8
	call PrintLevel
	ld hl, .NicknamePointers
	call GetNicknamePointer
	call CopyNickname
	lb bc, 15, 0
	farcall FixStrLength
	hlcoord 0, 10
	call PlaceString
	hlcoord 5, 8
	call .PlaceGenderChar
	; hlcoord 0, 12
	; ld a, "/"
	; ld [hli], a
	ld a, [wBaseDexNo]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	farcall GetStrLength
	ld a, b
	cp a, 8
	hlcoord 0, 12
	jr nc, .skipdash
	ld a, "/"
	ld [hli], a
.skipdash
	call PlaceString
	call StatsScreen_PlaceVerticalDividerAndKeepName
	call StatsScreen_PlacePageSwitchArrows
	call StatsScreen_PlaceShinyIcon
	xor a ; DFS_VRAM_LIMIT_NOLIMIT
	ld [wDFSVramLimit], a
	ret

.PlaceHPBar:
	ld hl, wTempMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wTempMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	farcall ComputeHPBarPixels
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	call DelayFrame
	ret

.PlaceGenderChar:
	push hl
	farcall GetGender
	pop hl
	ret c
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"
.got_gender
	ld [hl], a
	ret

.NicknamePointers:
	dw wPartyMonNicknames
	dw wOTPartyMonNicknames
	dw sBoxMonNicknames
	dw wBufferMonNickname

StatsScreen_PlaceVerticalDivider: ; unreferenced
; The Japanese stats screen has a vertical divider.
	hlcoord 7, 0
	ld bc, SCREEN_WIDTH
	ld d, SCREEN_HEIGHT
.loop
	ld a, $31 ; vertical divider
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .loop
	ret

; StatsScreen_PlaceHorizontalDivider:
	; hlcoord 0, 7
	; ld b, SCREEN_WIDTH
	; ld a, $62 ; horizontal divider (empty HP/exp bar)
; .loop
	; ld [hli], a
	; dec b
	; jr nz, .loop
	; ret

StatsScreen_PlaceVerticalDividerAndKeepName:
	hlcoord 7, 0
	ld de, SCREEN_WIDTH
	ld c, $31; "|"
	ld b, 9
.loop1
	ld [hl], c
	add hl, de
	dec b
	jr nz, .loop1

	ld b, 4
.loop2
	call StatsScreen_MoveNameToStaticArea
	add hl, de
	dec b
	jr nz, .loop2

	ld b, SCREEN_HEIGHT - 9 - 4
.loop3
	ld [hl], c
	add hl, de
	dec b
	jr nz, .loop3
	ret

StatsScreen_MoveNameToStaticArea:
	push de
	ld de, wAttrmap - wTilemap
	add hl, de
	bit OAM_TILE_BANK, [hl]
	ld de, wTilemap - wAttrmap
	add hl, de ; add hl, rr keep zy
	jr nz, .not_space
	pop de
	ld [hl], c
	ret
.not_space
	push bc
	ld a, [hl]

	swap a
	ld d, a
	and $F0
	ld e, a
	ld a, d
	and $0F
	or HIGH(vTiles4)
	ld d, a

	ld a, $42 + 4
	sub b
	ld [hl], a
	push hl

	swap a
	ld h, a
	and $F0
	ld l, a
	ld a, h
	and $0F
	or HIGH(vTiles2)
	ld h, a

	ld c, LEN_1BPP_TILE
.loop
.wait1
	ldh a, [rLY]
	cp a, LY_VBLANK - 4 ; 快发生行消隐时直接跑空
	jr nc, .wait1
	di
	ld a, 1 ; vram only
	ldh [rVBK], a
.wait2
	ldh a, [rSTAT]
	and a, 2
	jr nz, .wait2
	ld a, [de]
	ld b, a
	xor a
	ldh [rVBK], a
	ei
	ld a, b
	and $F0
	or $0C ; border
	ld b, a
	di
.wait3
	ldh a, [rSTAT]
	and a, 2
	jr nz, .wait3
	ld a, b
	ld [hli], a
	or $0F ; border
	ld [hli], a
	ei
	inc de
	inc de
	dec c
	jr nz, .loop

	pop hl
	ld de, wAttrmap - wTilemap
	add hl, de
	res OAM_TILE_BANK, [hl]
	ld de, wTilemap - wAttrmap
	add hl, de
	pop bc
	pop de
	ret

StatsScreen_PlacePageSwitchArrows:
	; hlcoord 12, 6
	; ld [hl], "◀"
	; hlcoord 19, 6
	; ld [hl], "▶"
	; ret
	hlcoord 2, 16
	ld a, $32
	ld b, 4
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
	ret

StatsScreen_PlaceShinyIcon:
	ld bc, wTempMonDVs
	farcall CheckShininess
	ret nc
	hlcoord 6, 8
	ld [hl], "⁂"
	ret

StatsScreen_LoadGFX:
	ld a, [wBaseDexNo]
	ld [wTempSpecies], a
	ld [wCurSpecies], a
	xor a
	ldh [hBGMapMode], a ; 原先代码注释，感觉无意义，暂时取消
	call .ClearBox
	call .PageTilemap
	call .LoadPals
	ld hl, wStatsScreenFlags
	bit 4, [hl]
	jr nz, .place_frontpic
	call SetDefaultBGPAndOBP
	ret

.place_frontpic
	call StatsScreen_PlaceFrontpic
	ret

.ClearBox:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	call StatsScreen_LoadPageIndicators
	hlcoord 8, 0
	lb bc, SCREEN_HEIGHT, SCREEN_WIDTH - 8
	call ClearBox
	ret

.LoadPals:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	ld c, a
	farcall LoadStatsScreenPals
	call DelayFrame
	ld hl, wStatsScreenFlags
	set 5, [hl]
	ret

.PageTilemap:
	ld a, [wStatsScreenFlags]
	maskbits NUM_STAT_PAGES
	dec a
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
; entries correspond to *_PAGE constants
	table_width 2, StatsScreen_LoadGFX.Jumptable
	dw LoadPinkPage
	dw LoadGreenPage
	dw LoadBluePage
	assert_table_length NUM_STAT_PAGES

LoadPinkPage:
	hlcoord 10, 1
	ld b, $0
	predef DrawPlayerHP
	hlcoord 18, 1
	ld [hl], $41 ; right HP/exp bar end cap
	ld de, .Status_Type
	hlcoord 9, 4
	call PlaceString
	ld a, [wTempMonPokerusStatus]
	ld b, a
	and $f
	jr nz, .HasPokerus
	ld a, b
	and $f0
	jr z, .NotImmuneToPkrs
	hlcoord 8, 8
	ld [hl], "." ; Pokérus immunity dot
.NotImmuneToPkrs:
	ld a, [wMonType]
	cp BOXMON
	jr z, .StatusOK
	hlcoord 13, 4
	push hl
	ld de, wTempMonStatus
	predef PlaceLargeStatusString
	pop hl
	jr nz, .done_status
	jr .StatusOK
.HasPokerus:
	ld de, .PkrsStr
	hlcoord 13, 4
	call PlaceString
	jr .done_status
.StatusOK:
	ld de, .OK_str
	call PlaceString
.done_status
	hlcoord 13, 6
	predef PrintMonTypes
	; hlcoord 9, 8
	; ld de, SCREEN_WIDTH
	; ld b, 10
	; ld a, $31 ; vertical divider
; .vertical_divider
	; ld [hl], a
	; add hl, de
	; dec b
	; jr nz, .vertical_divider
	lb bc, 6, 10
	hlcoord 8, 10
	call TextboxBorder
	ld de, .ExpPointStr
	hlcoord 11, 10
	call PlaceString
	hlcoord 16, 15
	call .PrintNextLevel
	hlcoord 12, 11
	lb bc, 3, 7
	ld de, wTempMonExp
	call PrintNum
	call .CalcExpToNextLevel
	hlcoord 12, 13
	lb bc, 3, 7
	ld de, wExpToNextLevel
	call PrintNum
	ld de, .LevelUpStr
	hlcoord 9, 13
	call PlaceString
	ld de, .ToStr
	hlcoord 9, 15
	call PlaceString
	hlcoord 10, 16
	ld a, [wTempMonLevel]
	ld b, a
	ld de, wTempMonExp + 2
	predef FillInExpBar
	hlcoord 9, 16
	ld [hl], $40 ; left exp bar end cap
	hlcoord 18, 16
	ld [hl], $41 ; right exp bar end cap
	ret

.PrintNextLevel:
	ld a, [wTempMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .AtMaxLevel
	inc a
	ld [wTempMonLevel], a
.AtMaxLevel:
	call PrintLevel
	pop af
	ld [wTempMonLevel], a
	ret

.CalcExpToNextLevel:
	ld a, [wTempMonLevel]
	cp MAX_LEVEL
	jr z, .AlreadyAtMaxLevel
	inc a
	ld d, a
	farcall CalcExpAtLevel
	ld hl, wTempMonExp + 2
	ld hl, wTempMonExp + 2
	ldh a, [hQuotient + 3]
	sub [hl]
	dec hl
	ld [wExpToNextLevel + 2], a
	ldh a, [hQuotient + 2]
	sbc [hl]
	dec hl
	ld [wExpToNextLevel + 1], a
	ldh a, [hQuotient + 1]
	sbc [hl]
	ld [wExpToNextLevel], a
	ret

.AlreadyAtMaxLevel:
	ld hl, wExpToNextLevel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.Status_Type:
	db_w "状态/"
	next "属性/@"

.OK_str:
	db_w "正常@"

.ExpPointStr:
	db_w " 经验值@" ; 后面又半个空格 应该不需要再给

.LevelUpStr:
	db_w "还需@"

.ToStr:
	db_w "到@"

.PkrsStr:
	db_w "宝可病毒@"

LoadGreenPage:
	ld de, .Item
	hlcoord 8, 1
	call PlaceString
	call .GetItemName
	; hlcoord 8, 8
	jr z, .GPnormal
	ld a, [wTempMonItem]
	cp TM01
	jr c, .GPisItem
	ld hl, 10 ; TM/HM
	add hl, de
	push de
	ld d, h
	ld e, l
	push hl
	hlcoord 18, 3
	call PlaceString
	pop hl
	ld [hl], "@"
	pop de
.GPisItem
	farcall GetStrLength
	ld a, b
	cp a, 9
	jr c, .GPnormal
	hlcoord 10, 2
	jr .GPPPex
.GPnormal
	hlcoord 12, 2
.GPPPex
	call PlaceString
	lb bc, 12, 10
	hlcoord 8, 4
	call TextboxBorder
	ld de, .Move
	hlcoord 10, 4
	call PlaceString
	ld hl, wTempMonMoves
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	call CopyBytes
	hlcoord 9, 6
	ld a, SCREEN_WIDTH * 3
	ld [wListMovesLineSpacing], a
	predef ListMoves
	hlcoord 11, 7
	ld a, SCREEN_WIDTH * 3
	ld [wListMovesLineSpacing], a
	predef ListMovePP
	ret

.GetItemName:
	ld de, .ThreeDashes
	ld a, [wTempMonItem]
	and a
	ret z
	ld b, a
	farcall TimeCapsule_ReplaceTeruSama
	ld a, b
	ld [wNamedObjectIndex], a
	call GetItemName
	ret

.Item:
	db_w "持有@"

.ThreeDashes:
	db_w "无@"

.Move:
	db_w " 可用招式 @"

LoadBluePage:
	call .PlaceOTInfo
; 	hlcoord 10, 8
; 	ld de, SCREEN_WIDTH
; 	ld b, 10
; 	ld a, $31 ; vertical divider
; .vertical_divider
; 	ld [hl], a
; 	add hl, de
; 	dec b
; 	jr nz, .vertical_divider
; 	hlcoord 11, 8
	lb bc, 10, 10
	hlcoord 8, 6
	call TextboxBorder
	
	hlcoord 9, 8
	ld bc, 6
	predef PrintTempMonStats
	ret

.PlaceOTInfo:
	ld de, IDNoString
	hlcoord 9, 1
	call PlaceString
	ld de, OTString
	hlcoord 8, 3
	call PlaceString
	hlcoord 12, 1
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	ld de, wTempMonID
	call PrintNum
	ld hl, .OTNamePointers
	call GetNicknamePointer
	call CopyNickname
	farcall CorrectNickErrors
	; hlcoord 2, 13
	farcall GetStrLength
	ld a, b
	hlcoord 14, 3
	cp a, 7
	jr c, .normal
	dec hl
.normal
	call PlaceString
	ld a, [wTempMonCaughtGender]
	and a
	jr z, .done
	cp $7f
	jr z, .done
	and CAUGHT_GENDER_MASK
	ld a, "♂"
	jr z, .got_gender
	ld a, "♀"
.got_gender
	hlcoord 18, 1
	ld [hl], a
.done
	ret

.OTNamePointers:
	dw wPartyMonOTs
	dw wOTPartyMonOTs
	dw sBoxMonOTs
	dw wBufferMonOT

IDNoString:
	db_w "<ID>№/@"

OTString:
	db_w "初训家/@"

StatsScreen_PlaceFrontpic:
	ld hl, wTempMonDVs
	predef GetUnownLetter
	call StatsScreen_GetAnimationParam
	jr c, .egg
	and a
	jr z, .no_cry
	jr .cry

.egg
	call .AnimateEgg
	call SetDefaultBGPAndOBP
	ret

.no_cry
	call .AnimateMon
	call SetDefaultBGPAndOBP
	ret

.cry
	call SetDefaultBGPAndOBP
	call .AnimateMon
	ld a, [wCurPartySpecies]
	call PlayMonCry2
	ret

.AnimateMon:
	ld hl, wStatsScreenFlags
	set 5, [hl]
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr z, .unown
	hlcoord 0, 1
	call PrepMonFrontpic
	ret

.unown
	xor a
	ld [wBoxAlignment], a
	hlcoord 0, 1
	call _PrepMonFrontpic
	ret

.AnimateEgg:
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr z, .unownegg
	ld a, TRUE
	ld [wBoxAlignment], a
	call .get_animation
	ret

.unownegg
	xor a
	ld [wBoxAlignment], a
	call .get_animation
	ret

.get_animation
	ld a, [wCurPartySpecies]
	call IsAPokemon
	ret c
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	hlcoord 0, 1
	ld d, $0
	ld e, ANIM_MON_MENU
	predef LoadMonAnimation
	ld hl, wStatsScreenFlags
	set 6, [hl]
	ret

StatsScreen_GetAnimationParam:
	ld a, [wMonType]
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
	dw .PartyMon
	dw .OTPartyMon
	dw .BoxMon
	dw .Tempmon
	dw .Wildmon

.PartyMon:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld b, h
	ld c, l
	jr .CheckEggFaintedFrzSlp

.OTPartyMon:
	xor a
	ret

.BoxMon:
	ld hl, sBoxMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	call AddNTimes
	ld b, h
	ld c, l
	ld a, BANK(sBoxMons)
	call OpenSRAM
	call .CheckEggFaintedFrzSlp
	push af
	call CloseSRAM
	pop af
	ret

.Tempmon:
	ld bc, wTempMonSpecies
	jr .CheckEggFaintedFrzSlp ; utterly pointless

.CheckEggFaintedFrzSlp:
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call CheckFaintedFrzSlp
	jr c, .FaintedFrzSlp
.egg
	xor a
	scf
	ret

.Wildmon:
	ld a, $1
	and a
	ret

.FaintedFrzSlp:
	xor a
	ret

StatsScreen_LoadTextboxSpaceGFX:
	nop
	push hl
	push de
	push bc
	push af
	call DelayFrame
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a
	ld de, TextboxSpaceGFX
	lb bc, BANK(TextboxSpaceGFX), 1
	ld hl, vTiles2 tile " "
	call Get2bpp
	pop af
	ldh [rVBK], a
	pop af
	pop bc
	pop de
	pop hl
	ret

StatsScreenSpaceGFX: ; unreferenced
INCBIN "gfx/font/space.2bpp"

EggStatsScreen:
	xor a
	ldh [hBGMapMode], a
	ld a, DFS_VRAM_LIMIT_VRAM0
	ld [wDFSVramLimit], a
	ld hl, wCurHPPal
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	call GetSGBLayout
	; call StatsScreen_PlaceHorizontalDivider
	call StatsScreen_PlaceVerticalDividerAndKeepName
	ld de, EggString
	hlcoord 3, 9
	call PlaceString
	ld de, IDNoString
	hlcoord 9, 1
	call PlaceString
	ld de, OTString
	hlcoord 8, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 12, 1
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 14, 3
	call PlaceString
if DEF(_DEBUG)
	ld de, .PushStartString
	hlcoord 8, 17
	call PlaceString
	jr .placed_push_start

.PushStartString:
	db_w "▶按START键。@"

.placed_push_start
endc
	ld a, [wTempMonHappiness] ; egg status
	ld de, EggSoonString
	cp $6
	jr c, .picked
	ld de, EggCloseString
	cp $b
	jr c, .picked
	ld de, EggMoreTimeString
	cp $29
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 8, 7
	call PlaceString
	ld hl, wStatsScreenFlags
	set 5, [hl]
	call SetDefaultBGPAndOBP
	call DelayFrame
	hlcoord 0, 1
	call PrepMonFrontpic
	farcall HDMATransferTilemapToWRAMBank3
	call StatsScreen_AnimateEgg

	xor a ; DFS_VRAM_LIMIT_NOLIMIT
	ld [wDFSVramLimit], a
	ld a, [wTempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	call PlaySFX
	ret

EggString:
	db_w "蛋@"

FiveQMarkString:
	db_w "?????@"

EggSoonString:
	db_w "能听到从里面传来"
	next "的声音！好像快要"
	next "孵出来了！@"

EggCloseString:
	db_w "好像偶尔在动。"
	next "再过一点时间才会"
	next "孵出来吧？@"

EggMoreTimeString:
	db_w "会孵出来什么呢？"
	next "好像还要过段时间"
	next "才会孵出来。@"

EggALotMoreTimeString:
	db_w "这只蛋孵出来"
	next "好像需要很长一段"
	next "时间。@"

StatsScreen_AnimateEgg:
	call StatsScreen_GetAnimationParam
	ret nc
	ld a, [wTempMonHappiness]
	ld e, $7
	cp 6
	jr c, .animate
	ld e, $8
	cp 11
	jr c, .animate
	ret

.animate
	push de
	ld a, $1
	ld [wBoxAlignment], a
	call StatsScreen_LoadTextboxSpaceGFX
	ld de, vTiles2 tile $00
	predef GetAnimatedFrontpic
	pop de
	hlcoord 0, 1
	ld d, $0
	predef LoadMonAnimation
	ld hl, wStatsScreenFlags
	set 6, [hl]
	ret

StatsScreen_LoadPageIndicators:
	hlcoord 1, 14
	ld a, $36 ; first of 4 small square tiles
	call .load_square
	hlcoord 3, 14
	ld a, $36 ; " " " "
	call .load_square
	hlcoord 5, 14
	ld a, $36 ; " " " "
	call .load_square
	ld a, c
	cp GREEN_PAGE
	ld a, $3a ; first of 4 large square tiles
	hlcoord 1, 14 ; PINK_PAGE (< GREEN_PAGE)
	jr c, .load_square
	hlcoord 3, 14 ; GREEN_PAGE (= GREEN_PAGE)
	jr z, .load_square
	hlcoord 5, 14 ; BLUE_PAGE (> GREEN_PAGE)
.load_square
	push bc
	ld [hli], a
	inc a
	ld [hld], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

CopyNickname:
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	jr .okay ; utterly pointless
.okay
	ld a, [wMonType]
	cp BOXMON
	jr nz, .partymon
	ld a, BANK(sBoxMonNicknames)
	call OpenSRAM
	push de
	call CopyBytes
	pop de
	call CloseSRAM
	ret

.partymon
	push de
	call CopyBytes
	pop de
	ret

GetNicknamePointer:
	ld a, [wMonType]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonType]
	cp TEMPMON
	ret z
	ld a, [wCurPartyMon]
	jp SkipNames

CheckFaintedFrzSlp:
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .fainted_frz_slp
	ld hl, MON_STATUS
	add hl, bc
	ld a, [hl]
	and 1 << FRZ | SLP_MASK
	jr nz, .fainted_frz_slp
	and a
	ret

.fainted_frz_slp
	scf
	ret

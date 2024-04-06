PlaceMenuItemName:
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndex], a
	call GetItemName
	pop hl
	call PlaceString
	ret

PlaceMenuItemQuantity:
	push de
	ld a, [wMenuSelection]
	ld [wCurItem], a
	farcall _CheckTossableItem
	ld a, [wItemAttributeValue]
	pop hl
	and a
	jr nz, .done
	; ld de, $15
	; add hl, de
	inc hl
	inc hl
	ld [hl], "×"
	call ResetVramNo
	inc hl
	ld de, wMenuSelectionQuantity
	lb bc, 1, 2
	call PrintNum

.done
	ret

PlaceMoneyTopRight:
	ld hl, MoneyTopRightMenuHeader
	call CopyMenuHeader
	jr PlaceMoneyTextbox

PlaceMoneyBottomLeft:
	ld hl, MoneyBottomLeftMenuHeader
	call CopyMenuHeader
	jr PlaceMoneyTextbox

PlaceMoneyAtTopLeftOfTextbox:
	ld hl, MoneyTopRightMenuHeader
	lb de, 0, 0
	call OffsetMenuHeader

PlaceMoneyTextbox:
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	ret

MoneyTopRightMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 11, 0, SCREEN_WIDTH - 1, 2
	dw NULL
	db 1 ; default option

MoneyBottomLeftMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 8, 2
	dw NULL
	db 1 ; default option

DisplayCoinCaseBalance:
	; Place a text box of size 1x7 at 11, 0.
	hlcoord 8, 0
	ld b, 2
	ld c, 10
	call Textbox
	hlcoord 9, 2
	ld de, CoinString
	call PlaceString
	hlcoord 17, 2
	ld de, ShowMoney_TerminatorString
	call PlaceString
	ld de, wCoins
	lb bc, 2, 4
	hlcoord 13, 2
	call PrintNum
	ret

DisplayMoneyAndCoinBalance:
	hlcoord 5, 0
	ld b, 4
	ld c, 13
	call Textbox
	hlcoord 6, 2
	ld de, MoneyString
	call PlaceString
	hlcoord 11, 2
	ld de, wMoney
	lb bc, 3, 6 ; PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 6, 4
	ld de, CoinString
	call PlaceString
	hlcoord 13, 4
	ld de, wCoins
	lb bc, 2, 4
	call PrintNum
	hlcoord 17, 4
	ld de, ShowMoney_TerminatorString
	call PlaceString
	ret

MoneyString:
	db_w "零花钱      元@"
CoinString:
	db_w "代币@"
ShowMoney_TerminatorString:
	db_w "枚@"

StartMenu_PrintSafariGameStatus: ; unreferenced
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	hlcoord 0, 0
	ld b, 3
	ld c, 7
	call Textbox
	hlcoord 1, 1
	ld de, wSafariTimeRemaining
	lb bc, 2, 3
	call PrintNum
	hlcoord 4, 1
	ld de, .slash_500
	call PlaceString
	hlcoord 1, 3
	ld de, .booru_ko
	call PlaceString
	hlcoord 5, 3
	ld de, wSafariBallsRemaining
	lb bc, 1, 2
	call PrintNum
	pop af
	ld [wOptions], a
	ret

.slash_500
	db_w "<／><５><０><０>@"
.booru_ko
	db_w "ボール<　><　><　>こ@"

StartMenu_DrawBugContestStatusBox:
	hlcoord 0, 0
	ld b, 6
	ld c, 10
	jp Textbox
	; ld bc, 10 + 2
	; hlcoord 0, 1
	; decoord 0, 0
	; call CopyBytes
	; ret

StartMenu_PrintBugContestStatus:
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call StartMenu_DrawBugContestStatusBox
	hlcoord 1, 2
	ld de, .BallsString
	call PlaceString
	hlcoord 5, 2
	ld de, wParkBallsRemaining
	lb bc, 1, 2
	call PrintNum
	hlcoord 1, 4
	ld de, .CaughtString
	call PlaceString
	ld a, [wContestMon]
	and a
	ld de, .NoneString
	jr z, .no_contest_mon
	ld [wNamedObjectIndex], a
	call GetPokemonName

.no_contest_mon
	hlcoord 5, 4
	call PlaceString
	ld a, [wContestMon]
	and a
	jr z, .skip_level
	hlcoord 1, 6
	ld de, .LevelString
	call PlaceString
	ld a, [wContestMonLevel]
	ld h, b
	ld l, c
	inc hl
	ld c, 3
	call Print8BitNumLeftAlign

.skip_level
	pop af
	ld [wOptions], a
	ret

.BallsJPString: ; unreferenced
	db_w "ボール<　><　><　>こ@"
.CaughtString:
	db_w "捕获@"
.BallsString:
	db_w "剩余   球@"
.NoneString:
	db_w "无@"
.LevelString:
	db_w "等级@"; $6D,$6B,"@" ;":L"

FindApricornsInBag:
; Checks the bag for Apricorns.
	ld hl, wKurtApricornCount
	xor a
	ld [hli], a
	assert wKurtApricornCount + 1 == wKurtApricornItems
	dec a
	ld bc, 10
	call ByteFill

	ld hl, ApricornBalls
.loop
	ld a, [hl]
	cp -1
	jr z, .done
	push hl
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	pop hl
	jr nc, .nope
	ld a, [hl]
	call .addtobuffer
.nope
	inc hl
	inc hl
	jr .loop

.done
	ld a, [wKurtApricornCount]
	and a
	ret nz
	scf
	ret

.addtobuffer:
	push hl
	ld hl, wKurtApricornCount
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld [hl], a
	pop hl
	ret

INCLUDE "data/items/apricorn_balls.asm"

DisplayCaughtContestMonStats:
	call ClearBGPalettes
	call ClearTilemap
	call ClearSprites
	call LoadFontsBattleExtra
	ld b, SCGB_DIPLOMA
	call GetSGBLayout

	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]

	hlcoord 0, 4
	ld b, 5
	ld c, 8
	call Textbox

	hlcoord 10, 4
	ld b, 5
	ld c, 8
	call Textbox

	hlcoord 1, 3
	ld de, .Stock
	call PlaceString

	hlcoord 11, 3
	ld de, .This
	call PlaceString

	hlcoord 1, 9
	ld de, .Health
	call PlaceString

	hlcoord 11, 9
	ld de, .Health
	call PlaceString

	ld a, [wContestMon]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld de, wStringBuffer1
	hlcoord 1, 6
	call PlaceString

	; ld h, b
	; ld l, c
	hlcoord 6, 7
	ld a, [wContestMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	ld de, wEnemyMonNickname
	hlcoord 11, 6
	call PlaceString

	; ld h, b
	; ld l, c
	hlcoord 16, 7
	ld a, [wEnemyMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	hlcoord 6, 9
	ld de, wContestMonMaxHP
	lb bc, 2, 3
	call PrintNum

	hlcoord 16, 9
	ld de, wEnemyMonMaxHP
	call PrintNum

	ld hl, ContestAskSwitchText
	call PrintText

	pop af
	ld [wOptions], a

	call WaitBGMap
	; ld b, SCGB_DIPLOMA
	; call GetSGBLayout
	call SetDefaultBGPAndOBP
	ret

.Health:
	db_w "体力@"
.Stock:
	db_w "持有宝可梦@"
.This:
	db_w "新捉宝可梦@"

ContestAskSwitchText:
	text_far _ContestAskSwitchText
	text_end

DisplayAlreadyCaughtText:
	call GetPokemonName
	ld hl, .ContestAlreadyCaughtText
	jp PrintText

.ContestAlreadyCaughtText:
	text_far _ContestAlreadyCaughtText
	text_end

DummyPredef2F:
DummyPredef38:
DummyPredef39:
	ret

LoadBattleMenu:
	ld hl, BattleMenuHeader
	call LoadMenuHeader
	ld a, [wBattleMenuCursorPosition]
	ld [wMenuCursorPosition], a
	call InterpretBattleMenu
	ld a, [wMenuCursorPosition]
	ld [wBattleMenuCursorPosition], a
	call ExitMenu
	ret

SafariBattleMenu: ; unreferenced
	ld hl, SafariBattleMenuHeader
	call LoadMenuHeader
	jr CommonBattleMenu

ContestBattleMenu:
	ld hl, ContestBattleMenuHeader
	call LoadMenuHeader
	; fallthrough

CommonBattleMenu:
	ld a, [wBattleMenuCursorPosition]
	ld [wMenuCursorPosition], a
	call _2DMenu
	ld a, [wMenuCursorPosition]
	ld [wBattleMenuCursorPosition], a
	call ExitMenu
	ret

BattleMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 8, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_DISABLE_B ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dba .Text
	dbw BANK(@), NULL

.Text:
	db_w "战斗@"
	db_w "背包@"
	db_w "宝可梦@"
	db_w "逃走@"

SafariBattleMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_DISABLE_B ; flags
	dn 2, 2 ; rows, columns
	db 11 ; spacing
	dba .Text
	dba .PrintSafariBallsRemaining

.Text:
	db_w "サファりボール×<　><　>@" ; "SAFARI BALL×  @"
	db_w "エサをなげる@" ; "THROW BAIT"
	db_w "いしをなげる@" ; "THROW ROCK"
	db_w "にげる@" ; "RUN"

.PrintSafariBallsRemaining:
	hlcoord 17, 13
	ld de, wSafariBallsRemaining
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ret

ContestBattleMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 3, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_DISABLE_B ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dba .Text
	dba .PrintParkBallsRemaining

.Text:
	db_w "战斗@"
	db_w "公园球×  @"
	db_w "宝可梦@"
	db_w "逃走@"

.PrintParkBallsRemaining:
	hlcoord 17, 14
	ld de, wParkBallsRemaining
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ret

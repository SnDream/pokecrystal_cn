MACRO unownwall
	for n, CHARLEN(\1)
		DEF x = CHARSUB(\1, n + 1)
		if x == "-"
			db $64
		elif x >= "Y"
			db 2 * (x - "Y") + $60
		elif x >= "Q"
			db 2 * (x - "Q") + $40
		elif x >= "I"
			db 2 * (x - "I") + $20
		else
			db 2 * (x - "A")
		endc
	endr
	db -1 ; end
ENDM

UnownWalls:
; UNOWNWORDS_ESCAPE
	; db $08, $44, $04, $00, $2e, $08, -1
	; unownwall "ESCAPE"
	unownwall "LIDONG"
; UNOWNWORDS_LIGHT
	; db $26, $20, $0c, $0e, $46, -1
	; unownwall "LIGHT"
	unownwall "GUANG"
; UNOWNWORDS_WATER
	; db $4c, $00, $46, $08, $42, -1
	; unownwall "WATER"
	unownwall "SHUI"
; UNOWNWORDS_HO_OH
	; db $0e, $2c, $64, $2c, $0e, -1
	; unownwall "HO-OH"
	unownwall "FENGWANG"

MenuHeaders_UnownWalls:
; UNOWNWORDS_ESCAPE
	db MENU_BACKUP_TILES ; flags
	menu_coords 3, 4, 16, 9
; UNOWNWORDS_LIGHT
	db MENU_BACKUP_TILES ; flags
	menu_coords 4, 4, 15, 9
; UNOWNWORDS_WATER
	db MENU_BACKUP_TILES ; flags
	menu_coords 5, 4, 14, 9
; UNOWNWORDS_HO_OH
	db MENU_BACKUP_TILES ; flags
	menu_coords 1, 4, 18, 9

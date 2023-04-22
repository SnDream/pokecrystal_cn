ChrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 9, TEXTBOX_Y - 1
	dw .MaleNames
	db 1 ; default option
	db 0 ; ????

.MaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db "自己决定@"
MalePlayerNameArray:
	db "克里斯@"
	db "小阳@"
	db "阿武@"
	db "高尾@"
	db 2 ; title indent
	db " ", $62, $63, $64, $65, $66, $50 ; " NAME @" ; title

KrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 9, TEXTBOX_Y - 1
	dw .FemaleNames
	db 1 ; default option
	db 0 ; ????

.FemaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db "自己决定@"
FemalePlayerNameArray:
	db "克丽丝@"
	db "千瑶@"
	db "清美@"
	db "智子@"
	db 2 ; title indent
	db " ", $62, $63, $64, $65, $66, $50 ; " NAME @" ; title

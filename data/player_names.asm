ChrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 9, TEXTBOX_Y - 1
	dw .MaleNames
	db 1 ; default option
	db 0 ; ????

.MaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db_w "自己决定@"
MalePlayerNameArray:
	db_w "克里斯@"
	db_w "小阳@"
	db_w "阿武@"
	db_w "高尾@"
	db 2 ; title indent
	db_w " ", $62, $63, $64, $65, $66, $50 ; " NAME @" ; title

KrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 9, TEXTBOX_Y - 1
	dw .FemaleNames
	db 1 ; default option
	db 0 ; ????

.FemaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 5 ; items
	db_w "自己决定@"
FemalePlayerNameArray:
	db_w "克丽丝@"
	db_w "千瑶@"
	db_w "清美@"
	db_w "智子@"
	db 2 ; title indent
	db_w " ", $62, $63, $64, $65, $66, $50 ; " NAME @" ; title

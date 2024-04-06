BuenasPasswordTable:
	table_width 2, BuenasPasswordTable
	dw .JohtoStarters
	dw .Beverages
	dw .HealingItems
	dw .Balls
	dw .Pokemon1
	dw .Pokemon2
	dw .JohtoTowns
	dw .Types
	dw .Moves
	dw .XItems
	dw .RadioStations
	assert_table_length NUM_PASSWORD_CATEGORIES

                ; string type, points, option 1, option 2, option 3
.JohtoStarters: db_w BUENA_MON,    10, CYNDAQUIL, TOTODILE, CHIKORITA
.Beverages:     db_w BUENA_ITEM,   12, FRESH_WATER, SODA_POP, LEMONADE
.HealingItems:  db_w BUENA_ITEM,   12, POTION, ANTIDOTE, PARLYZ_HEAL
.Balls:         db_w BUENA_ITEM,   12, POKE_BALL, GREAT_BALL, ULTRA_BALL
.Pokemon1:      db_w BUENA_MON,    10, PIKACHU, RATTATA, GEODUDE
.Pokemon2:      db_w BUENA_MON,    10, HOOTHOOT, SPINARAK, DROWZEE
.JohtoTowns:    db_w BUENA_STRING, 16, "若叶镇@", "吉花市@", "桧皮镇@"
.Types:         db_w BUENA_STRING,  6, "飞行@", "虫@", "草@"
.Moves:         db_w BUENA_MOVE,   12, TACKLE, GROWL, MUD_SLAP
.XItems:        db_w BUENA_ITEM,   12, X_ATTACK, X_DEFEND, X_SPEED
.RadioStations: db_w BUENA_STRING, 13, "宝可梦讲座@", "宝可梦音乐台@", "幸运频道@"

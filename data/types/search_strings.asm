PokedexTypeSearchStrings:
; entries correspond with PokedexTypeSearchConversionTable (see data/types/search_types.asm)
	table_width POKEDEX_TYPE_STRING_LENGTH, PokedexTypeSearchStrings
	db_w "忽略@@@"
	db_w "一般@@@"
	db_w "火@@@@@"
	db_w "水@@@@@"
	db_w "草@@@@@"
	db_w "电@@@@@"
	db_w "冰@@@@@"
	db_w "格斗@@@"
	db_w "毒@@@@@"
	db_w "地面@@@"
	db_w "飞行@@@"
	db_w "超能力@"
	db_w "虫@@@@@"
	db_w "岩石@@@"
	db_w "幽灵@@@"
	db_w "龙@@@@@"
	db_w "恶@@@@@"
	db_w "钢@@@@@"
	assert_table_length NUM_TYPES + 1

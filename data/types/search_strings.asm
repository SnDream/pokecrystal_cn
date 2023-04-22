PokedexTypeSearchStrings:
; entries correspond with PokedexTypeSearchConversionTable (see data/types/search_types.asm)
	table_width POKEDEX_TYPE_STRING_LENGTH, PokedexTypeSearchStrings
	db "忽略@@@"
	db "一般@@@"
	db "火@@@@@"
	db "水@@@@@"
	db "草@@@@@"
	db "电@@@@@"
	db "冰@@@@@"
	db "格斗@@@"
	db "毒@@@@@"
	db "地面@@@"
	db "飞行@@@"
	db "超能力@"
	db "虫@@@@@"
	db "岩石@@@"
	db "幽灵@@@"
	db "龙@@@@@"
	db "恶@@@@@"
	db "钢@@@@@"
	assert_table_length NUM_TYPES + 1

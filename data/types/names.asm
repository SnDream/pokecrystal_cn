TypeNames:
; entries correspond to types (see constants/type_constants.asm)
	table_width 2, TypeNames

	dw Normal
	dw Fighting
	dw Flying
	dw Poison
	dw Ground
	dw Rock
	dw Bird
	dw Bug
	dw Ghost
	dw Steel
	assert_table_length UNUSED_TYPES

rept UNUSED_TYPES_END - UNUSED_TYPES - 1 ; discount CURSE_TYPE
	dw Normal
endr
	dw CurseType
	assert_table_length UNUSED_TYPES_END

	dw Fire
	dw Water
	dw Grass
	dw Electric
	dw Psychic
	dw Ice
	dw Dragon
	dw Dark
	assert_table_length TYPES_END

Normal:    db_w "一般@"
Fighting:  db_w "格斗@"
Flying:    db_w "飞行@"
Poison:    db_w "毒@"
CurseType: db_w "???@"
Fire:      db_w "火@"
Water:     db_w "水@"
Grass:     db_w "草@"
Electric:  db_w "电@"
Psychic:   db_w "超能力@"
Ice:       db_w "冰@"
Ground:    db_w "地面@"
Rock:      db_w "岩石@"
Bird:      db_w "鸟@"
Bug:       db_w "虫@"
Ghost:     db_w "幽灵@"
Steel:     db_w "钢@"
Dragon:    db_w "龙@"
Dark:      db_w "恶@"

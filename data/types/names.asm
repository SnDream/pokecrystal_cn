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
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
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

Normal:    db "一般@"
Fighting:  db "格斗@"
Flying:    db "飞行@"
Poison:    db "毒@"
CurseType: db "???@"
Fire:      db "火@"
Water:     db "水@"
Grass:     db "草@"
Electric:  db "电@"
Psychic:   db "超能力@"
Ice:       db "冰@"
Ground:    db "地面@"
Rock:      db "岩石@"
Bird:      db "鸟@"
Bug:       db "虫@"
Ghost:     db "幽灵@"
Steel:     db "钢@"
Dragon:    db "龙@"
Dark:      db "恶@"

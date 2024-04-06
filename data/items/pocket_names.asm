ItemPocketNames:
; entries correspond to item type constants
	table_width 2, ItemPocketNames
	dw .Item
	dw .Key
	dw .Ball
	dw .TM
	assert_table_length NUM_ITEM_TYPES

.Item: db_w "道具口袋@"
.Key:  db_w "重要口袋@"
.Ball: db_w "精灵球口袋@"
.TM:   db_w "招式口袋@"

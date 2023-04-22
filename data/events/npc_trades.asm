MACRO npctrade
; dialog set, requested mon, offered mon, nickname, dvs, item, OT ID, OT name, gender requested
	db \1, \2, \3, \4, \5, \6, \7
	dw \8
	db \9, \<10>, 0
ENDM

NPCTrades:
; entries correspond to NPCTRADE_* constants
	table_width NPCTRADE_STRUCT_LENGTH, NPCTrades
	npctrade TRADE_DIALOGSET_COLLECTOR, ABRA,       MACHOP,     "筋肉@@@@@@@", $37, $66, GOLD_BERRY,   37460, "直树@@@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_COLLECTOR, BELLSPROUT, ONIX,       "晃晃@@@@@@@", $96, $66, BITTER_BERRY, 48926, "昆太@@@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_HAPPY,     KRABBY,     VOLTORB,    "哔哩@@@@@@@", $98, $88, PRZCUREBERRY, 29189, "源@@@@@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_GIRL,      DRAGONAIR,  DODRIO,     "嘟利丝@@@@@", $77, $66, SMOKE_BALL,   00283, "美佐子@@@@@", TRADE_GENDER_FEMALE
	npctrade TRADE_DIALOGSET_NEWBIE,    HAUNTER,    XATU,       "佩罗@@@@@@@", $96, $86, MYSTERYBERRY, 15616, "清美@@@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_GIRL,      CHANSEY,    AERODACTYL, "飞翼@@@@@@@", $96, $66, GOLD_BERRY,   26491, "电磁@@@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_COLLECTOR, DUGTRIO,    MAGNETON,   "铁墩@@@@@@@", $96, $66, METAL_COAT,   50082, "森尾@@@@@@@", TRADE_GENDER_EITHER
	assert_table_length NUM_NPC_TRADES

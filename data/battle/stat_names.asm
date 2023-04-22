StatNames:
; entries correspond to stat ids
	list_start StatNames
	li "攻击"
	li "防御"
	li "速度"
	li "特攻"
	li "特防"
	li "命中率"
	li "闪避率"
	li "能力" ; used for BattleCommand_Curse
	assert_list_length NUM_LEVEL_STATS

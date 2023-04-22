BattleTowerTrainers:
; The trainer class is not used in Crystal 1.0 due to a bug.
; Instead, the sixth character in the trainer's name is used.
; See BattleTowerText in engine/events/battle_tower/trainer_text.asm.
	table_width (NAME_LENGTH - 1) + 1, BattleTowerTrainers
	; name, class
	db "汉森@@@@@@", FISHER
	db "索亚@@@@@@", POKEMANIAC
	db "增田@@@@@@", GUITARIST
	db "尼克尔@@@@", SCIENTIST
	db "奥尔逊@@@@", POKEFANM
	db "扎波罗斯基", LASS
	db "赖特@@@@@@", YOUNGSTER
	db "亚历山大@@", HIKER
	db "川上@@@@@@", TEACHER
	db "毕克特@@@@", POKEFANM
	db "斋藤@@@@@@", KIMONO_GIRL
	db "克劳福德@@", BOARDER
	db "迪亚兹@@@@", PICNICKER
	db "埃里克森@@", BIKER
	db "熊@@@@@@@@", JUGGLER
	db "亨特@@@@@@", POKEFANF
	db "希尔@@@@@@", FIREBREATHER
	db "贾维尔@@@@", SWIMMERF
	db "考夫曼@@@@", SWIMMERM
	db "兰开斯特@@", SKIER
	db "麦克马希尔", CAMPER
	assert_table_length BATTLETOWER_NUM_UNIQUE_MON
; The following can only be sampled in Crystal 1.1.
	db "奥布莱恩@@", GENTLEMAN
	db "弗罗斯特@@", BEAUTY
	db "摩尔斯@@@@", SUPER_NERD
	db "汤舟@@@@@@", BLACKBELT_T
	db "拉詹@@@@@@", COOLTRAINERF
	db "罗德里格兹", OFFICER
	db "圣地亚哥@@", PSYCHIC_T
	db "斯托克@@@@", POKEFANM
	db "四男@@@@@@", SCIENTIST
	db "瓦伦蒂诺@@", BEAUTY
	db "瓦格纳@@@@", CAMPER
	db "叶@@@@@@@@", BIRD_KEEPER
	db "安德罗斯@@", PICNICKER
	db "潘@@@@@@@@", POKEMANIAC
	db "森@@@@@@@@", SCIENTIST
	db "巴克曼@@@@", SAGE
	db "孔@@@@@@@@", SCHOOLBOY
	db "休斯@@@@@@", FISHER
	db "有田@@@@@@", KIMONO_GIRL
	db "扎西@@@@@@", PSYCHIC_T
	db "姚@@@@@@@@", CAMPER
	db "阿依@@@@@@", LASS
	db "西门@@@@@@", GENTLEMAN
	db "杰克逊@@@@", POKEFANF
	db "可汗@@@@@@", POKEMANIAC
	db "粱@@@@@@@@", YOUNGSTER
	db "马力诺@@@@", TEACHER
	db "纽曼@@@@@@", SAILOR
	db "阮@@@@@@@@", BLACKBELT_T
	db "奥格登@@@@", SUPER_NERD
	db "朴@@@@@@@@", COOLTRAINERF
	db "佐藤@@@@@@", SWIMMERM
	db "佟@@@@@@@@", BIRD_KEEPER
	db "崔@@@@@@@@", BOARDER
	db "欧阳@@@@@@", LASS
	db "透纳@@@@@@", OFFICER
	db "范戴克@@@@", SKIER
	db "吴@@@@@@@@", SCHOOLBOY
	db "梅耶@@@@@@", SWIMMERF
	db "约翰逊@@@@", YOUNGSTER
	db "亚当@@@@@@", GUITARIST
	db "史密斯@@@@", BUG_CATCHER
	db "田尻@@@@@@", BUG_CATCHER
	db "冯@@@@@@@@", POKEMANIAC
	db "皇甫@@@@@@", SCIENTIST
	db "陈@@@@@@@@", SUPER_NERD
	db "迪克斯特拉", SWIMMERF
	db "伊万@@@@@@", BIKER
	db "王@@@@@@@@", FIREBREATHER
	assert_table_length BATTLETOWER_NUM_UNIQUE_TRAINERS

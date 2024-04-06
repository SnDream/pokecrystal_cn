BattleTowerTrainers:
; The trainer class is not used in Crystal 1.0 due to a bug.
; Instead, the sixth character in the trainer's name is used.
; See BattleTowerText in engine/events/battle_tower/trainer_text.asm.
	table_width (NAME_LENGTH - 1) + 1, BattleTowerTrainers
	; name, class
	db_w "汉森@@@@@@", FISHER
	db_w "索亚@@@@@@", POKEMANIAC
	db_w "增田@@@@@@", GUITARIST
	db_w "尼克尔@@@@", SCIENTIST
	db_w "奥尔逊@@@@", POKEFANM
	db_w "扎波罗斯基", LASS
	db_w "赖特@@@@@@", YOUNGSTER
	db_w "亚历山大@@", HIKER
	db_w "川上@@@@@@", TEACHER
	db_w "毕克特@@@@", POKEFANM
	db_w "斋藤@@@@@@", KIMONO_GIRL
	db_w "克劳福德@@", BOARDER
	db_w "迪亚兹@@@@", PICNICKER
	db_w "埃里克森@@", BIKER
	db_w "熊@@@@@@@@", JUGGLER
	db_w "亨特@@@@@@", POKEFANF
	db_w "希尔@@@@@@", FIREBREATHER
	db_w "贾维尔@@@@", SWIMMERF
	db_w "考夫曼@@@@", SWIMMERM
	db_w "兰开斯特@@", SKIER
	db_w "麦克马希尔", CAMPER
	assert_table_length BATTLETOWER_NUM_UNIQUE_MON
; The following can only be sampled in Crystal 1.1.
	db_w "奥布莱恩@@", GENTLEMAN
	db_w "弗罗斯特@@", BEAUTY
	db_w "摩尔斯@@@@", SUPER_NERD
	db_w "汤舟@@@@@@", BLACKBELT_T
	db_w "拉詹@@@@@@", COOLTRAINERF
	db_w "罗德里格兹", OFFICER
	db_w "圣地亚哥@@", PSYCHIC_T
	db_w "斯托克@@@@", POKEFANM
	db_w "四男@@@@@@", SCIENTIST
	db_w "瓦伦蒂诺@@", BEAUTY
	db_w "瓦格纳@@@@", CAMPER
	db_w "叶@@@@@@@@", BIRD_KEEPER
	db_w "安德罗斯@@", PICNICKER
	db_w "潘@@@@@@@@", POKEMANIAC
	db_w "森@@@@@@@@", SCIENTIST
	db_w "巴克曼@@@@", SAGE
	db_w "孔@@@@@@@@", SCHOOLBOY
	db_w "休斯@@@@@@", FISHER
	db_w "有田@@@@@@", KIMONO_GIRL
	db_w "扎西@@@@@@", PSYCHIC_T
	db_w "姚@@@@@@@@", CAMPER
	db_w "阿依@@@@@@", LASS
	db_w "西门@@@@@@", GENTLEMAN
	db_w "杰克逊@@@@", POKEFANF
	db_w "可汗@@@@@@", POKEMANIAC
	db_w "粱@@@@@@@@", YOUNGSTER
	db_w "马力诺@@@@", TEACHER
	db_w "纽曼@@@@@@", SAILOR
	db_w "阮@@@@@@@@", BLACKBELT_T
	db_w "奥格登@@@@", SUPER_NERD
	db_w "朴@@@@@@@@", COOLTRAINERF
	db_w "佐藤@@@@@@", SWIMMERM
	db_w "佟@@@@@@@@", BIRD_KEEPER
	db_w "崔@@@@@@@@", BOARDER
	db_w "欧阳@@@@@@", LASS
	db_w "透纳@@@@@@", OFFICER
	db_w "范戴克@@@@", SKIER
	db_w "吴@@@@@@@@", SCHOOLBOY
	db_w "梅耶@@@@@@", SWIMMERF
	db_w "约翰逊@@@@", YOUNGSTER
	db_w "亚当@@@@@@", GUITARIST
	db_w "史密斯@@@@", BUG_CATCHER
	db_w "田尻@@@@@@", BUG_CATCHER
	db_w "冯@@@@@@@@", POKEMANIAC
	db_w "皇甫@@@@@@", SCIENTIST
	db_w "陈@@@@@@@@", SUPER_NERD
	db_w "迪克斯特拉", SWIMMERF
	db_w "伊万@@@@@@", BIKER
	db_w "王@@@@@@@@", FIREBREATHER
	assert_table_length BATTLETOWER_NUM_UNIQUE_TRAINERS

NonTrainerCallerNames:
; entries correspond to PHONECONTACT_* constants (see constants/trainer_constants.asm)
	table_width 2, NonTrainerCallerNames
	dw .none
	dw .mom
	dw .bikeshop
	dw .bill
	dw .elm
	dw .buena
	assert_table_length NUM_NONTRAINER_PHONECONTACTS + 1

.none:     db_w "----------@"
.mom:      db_w "妈妈@"
.bill:     db_w "正辉@"
.elm:      db_w "空木博士@"
.bikeshop: db_w "自行车店@"
.buena:    db_w "葵妍  电台主播@"

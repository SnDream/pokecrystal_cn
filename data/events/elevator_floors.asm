ElevatorFloorNames:
; entries correspond to FLOOR_* constants
	table_width 2, ElevatorFloorNames
	dw .B4F
	dw .B3F
	dw .B2F
	dw .B1F
	dw ._1F
	dw ._2F
	dw ._3F
	dw ._4F
	dw ._5F
	dw ._6F
	dw ._7F
	dw ._8F
	dw ._9F
	dw ._10F
	dw ._11F
	dw .ROOF
	assert_table_length NUM_FLOORS

.B4F:  db_w "地下4楼@"
.B3F:  db_w "地下3楼@"
.B2F:  db_w "地下2楼@"
.B1F:  db_w "地下1楼@"
._1F:  db_w "1楼@"
._2F:  db_w "2楼@"
._3F:  db_w "3楼@"
._4F:  db_w "4楼@"
._5F:  db_w "5楼@"
._6F:  db_w "6楼@"
._7F:  db_w "7楼@"
._8F:  db_w "8楼@"
._9F:  db_w "9楼@"
._10F: db_w "10楼@"
._11F: db_w "11楼@"
.ROOF: db_w "楼顶@"

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

.B4F:  db "地下4楼@"
.B3F:  db "地下3楼@"
.B2F:  db "地下2楼@"
.B1F:  db "地下1楼@"
._1F:  db "1楼@"
._2F:  db "2楼@"
._3F:  db "3楼@"
._4F:  db "4楼@"
._5F:  db "5楼@"
._6F:  db "6楼@"
._7F:  db "7楼@"
._8F:  db "8楼@"
._9F:  db "9楼@"
._10F: db "10楼@"
._11F: db "11楼@"
.ROOF: db "楼顶@"

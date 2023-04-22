; see engine/menus/naming_screen.asm

ChineseInput:
	db   "ABCDE FGHIJ KLMNOP"
	next "QRSTU VWXYZ ", $F2, $F2, $F2, $F2, $F2, $F2
	next $61
	next $EE
	next " ", $ED, $65, $66, $67, "  ", $ED, $68, $69, $6A, "  ", $ED, $6B, $6C, $6D," @"
	;               S    Y    M               D    E    L               E    N    D

EnglishInput:
	db   "ABCDE FGHIJ KLMNOP"
	next "QRSTU VWXYZ       "
	next $61
	next $EE
	next " ", $ED, $62, $63, $64, "  ", $ED, $68, $69, $6A, "  ", $ED, $6B, $6C, $6D, " @"
	;               C    H    N               D    E    L               E    N    D

; NameInputLower:
; 	db "a b c d e f g h i"
; 	db "j k l m n o p q r"
; 	db "s t u v w x y z  "
; 	db "× ( ) : ; [ ] <PK> <MN>"
; 	db "UPPER  DEL   END "

; BoxNameInputLower:
; 	db "a b c d e f g h i"
; 	db "j k l m n o p q r"
; 	db "s t u v w x y z  "
; 	db "é 'd 'l 'm 'r 's 't 'v 0"
; 	db "1 2 3 4 5 6 7 8 9"
; 	db "UPPER  DEL   END "

; NameInputUpper:
; 	db "A B C D E F G H I"
; 	db "J K L M N O P Q R"
; 	db "S T U V W X Y Z  "
; 	db "- ? ! / . ,      "
; 	db "lower  DEL   END "

; BoxNameInputUpper:
; 	db "A B C D E F G H I"
; 	db "J K L M N O P Q R"
; 	db "S T U V W X Y Z  "
; 	db "× ( ) : ; [ ] <PK> <MN>"
; 	db "- ? ! ♂ ♀ / . , &"
; 	db "lower  DEL   END "

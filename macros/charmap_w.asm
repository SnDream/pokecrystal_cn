IF !DEF(CHARMAP_W_INC)
DEF CHARMAP_W_INC EQU 1

; CONFIG: CHARMAP_W_DB_COMPMODE
; charmap_w db-compatible mode
; 0 : off
; 1 : 1 byte charmap_w only
; 2 : all charmap_w (first byte)
DEF CHARMAP_W_DB_COMPMODE = 1

; [Macro aliases]
DEF NEWCHARMAP_w EQUS "newcharmap_w"
DEF SETCHARMAP_w EQUS "setcharmap_w"
DEF PUSHC_w      EQUS "pushc_w"
DEF POPC_w       EQUS "popc_w"
DEF CHARMAP_w    EQUS "charmap_w"
DEF DB_w         EQUS "db_w"
DEF GETCHAR_w    EQUS "getchar_w"
DEF CHARLEN_w    EQUS "charlen_w"
DEF NEWCHARMAP_W EQUS "newcharmap_w"
DEF SETCHARMAP_W EQUS "setcharmap_w"
DEF PUSHC_W      EQUS "pushc_w"
DEF POPC_W       EQUS "popc_w"
DEF CHARMAP_W    EQUS "charmap_w"
DEF DB_W         EQUS "db_w"
DEF GETCHAR_W    EQUS "getchar_w"
DEF CHARLEN_W    EQUS "charlen_w"

; To implement charmap_w, the following variables will be taken.

; [Public / functions Definitions]
; REDEF    CHARMAP_W_NAME        EQUS "name"
; DEF      CHARMAP_W_DB_COMPMODE = $xx
; DEF      CHARMAP_W_CHAR        = $xxxxxxxx
; DEF      CHARMAP_W_CHARLEN     = $xx
; DEF      CHARMAP_W_MAX_LENGTH  = $xx

; [Private Definitions]
; DEF     _CHARMAP_W_I           = $xx
; DEF     _CHARMAP_W_J           = $xx
; DEF     _CHARMAP_W_STACK_P     = $xx
; REDEF   _CHARMAP_W_STACK_ENTRY_{0..n} EQUS "xxxx"
; charmap _CHARMAP_W_QUOTE

; [charmap_w Definitions]
; DEF     CHARMAP_W_{name}_MAX_LENGTH = $xx
; charmap {name}
; charmap CHARMAP_W_{name}_PLANE_{0..n+1}
; charmap CHARMAP_W_{name}_LENGTH

; Macro Private Definitions

DEF _CHARMAP_W_STACK_P = 0
pushc
newcharmap _CHARMAP_W_QUOTECMP
popc

; newcharmap_w max_length, [name], [basename]
;
; Creates a new, empty character map called name and switches to it. - Wide Chramap Version
; 
; max_length: Defines the maximum length of the charmap.
;             The characters actually defined may be less than this length.
;
; name      : Append wide charmap support to the default charmap if UNDEFINED.
;
; basename  : Copied from character map basename if defined.
MACRO newcharmap_w
	if _NARG < 1 || _NARG > 3
		fail "newcharmap_w: Invalid argument"
	elif _NARG > 2
		if CHARMAP_W_\3_MAX_LENGTH > \1
			fail "newcharmap_w: The max length of the base charmap_w is greater than the new charmap_w"
		endc
	endc

	DEF CHARMAP_W_MAX_LENGTH = \1

	if _NARG < 2
		REDEF CHARMAP_W_NAME EQUS "main"
	elif _NARG < 3
		REDEF CHARMAP_W_NAME EQUS "\2"
		newcharmap {CHARMAP_W_NAME}     ; db-compatible
	else
		REDEF CHARMAP_W_NAME EQUS "\2"
		newcharmap {CHARMAP_W_NAME}, \3  ; db-compatible
	endc

	DEF CHARMAP_W_{CHARMAP_W_NAME}_MAX_LENGTH EQU CHARMAP_W_MAX_LENGTH

	pushc
	if _NARG < 3
		newcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
		for _CHARMAP_W_I, \1 + 1
			newcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}
		endr
	else
		DEF _CHARMAP_W_J = CHARMAP_W_\3_MAX_LENGTH
		newcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH, CHARMAP_W_\3_LENGTH
		for _CHARMAP_W_I, _CHARMAP_W_J
			newcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}, CHARMAP_W_\3_PLANE_{d:_CHARMAP_W_I}
		endr
		for _CHARMAP_W_I, _CHARMAP_W_J, \1 + 1
			newcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}, CHARMAP_W_\3_PLANE_{d:CHARMAP_W_\3_MAX_LENGTH}
		endr
	endc
	popc
ENDM

; setcharmap_w name
;
; Switch to character map name. - Wide Charmap Version
MACRO setcharmap_w
	REDEF CHARMAP_W_NAME EQUS "\1"
	DEF CHARMAP_W_MAX_LENGTH = CHARMAP_W_{CHARMAP_W_NAME}_MAX_LENGTH
	setcharmap {CHARMAP_W_NAME}
ENDM

; pushc_w
;
; Push the current character map onto the stack. - Wide Charmap Version
MACRO pushc_w
	REDEF _CHARMAP_W_STACK_ENTRY_{d:_CHARMAP_W_STACK_P} EQUS "{CHARMAP_W_NAME}"
	DEF _CHARMAP_W_STACK_P += 1
	pushc
ENDM

; popc_w
;
; Pop a character map off the stack and switch to it. - Wide Charmap Version
MACRO popc_w
	if _CHARMAP_W_STACK_P <= 0
		fail "popc_w: No entries in the charmap_w stack"
	endc
	DEF _CHARMAP_W_STACK_P -= 1
	REDEF CHARMAP_W_NAME EQUS "{_CHARMAP_W_STACK_ENTRY_{d:_CHARMAP_W_STACK_P}}"
	DEF CHARMAP_W_MAX_LENGTH = CHARMAP_W_{CHARMAP_W_NAME}_MAX_LENGTH
	popc
ENDM

; charmap_w "Strings", value1, ..., valueN
;
; Mapping strings to arbitrary values (not only 8-bit)
; The length cannot be greater than the max_length of charmap_w.
; ```
; charmap_w "Example", $10, $20
; ```
MACRO charmap_w
	if _NARG < 2
		fail "charmap_w: Invalid argument"
	elif _NARG > CHARMAP_W_MAX_LENGTH + 1
		fail "charmap_w: The length of the charmap_w is greater than the charmap_w max legnth"
	endc

	; db-compatible
	if CHARMAP_W_DB_COMPMODE == 2 || (CHARMAP_W_DB_COMPMODE == 1 && _NARG == 2 )
		charmap \1, \2
	endc

	pushc
	setcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
	charmap \1, _NARG - 1

	for _CHARMAP_W_I, _NARG - 1
		setcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}
		DEF _CHARMAP_W_J = _CHARMAP_W_I + 2
		charmap \1, \<{d:_CHARMAP_W_J}>
	endr
	for _CHARMAP_W_I, _NARG - 1, CHARMAP_W_MAX_LENGTH + 1
		setcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}
		charmap \1, 0
	endr
	popc
ENDM

; db_w value1/"string1", ..., valueN/"stringN"
;
; Defines a list of bytes that will be stored in the final image.
;
; Works like native db, but adds Wide Charmap support for string.
;
; Requires quote(") signs before or after parameters to treat it as text.
; ```
; charmap_w "T", $23, $45
; charmap_w "ext", $67
; db_w $FF, "Text", 0 ; parse as db $FF, $23, $45, $67, $00
; ```
; Syntax like `db_w "Text" + 1` or `db_w STRCAT("Text1", "Text2")` will warn,
; and "Text" will be forced to treat as an 8-bit value only.
;
; For cases where only the 8-bit values in charmap are used,
; you can just use the native db. (See CHARMAP_W_DB_COMPMODE)
MACRO db_w
	rept _NARG
		pushc
		setcharmap _CHARMAP_W_QUOTECMP
		pusho
		opt Wunmapped-char=0
		if STRSUB("\1", 1, 1) == "\"" && STRSUB("\1", -1) == "\""
			setcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
			for _CHARMAP_W_I, 1, CHARLEN(\1) + 1
				if CHARSUB(\1, _CHARMAP_W_I) > CHARMAP_W_{CHARMAP_W_NAME}_MAX_LENGTH
					fail STRCAT("db_w: Unmapped character '",  CHARSUB(\1, _CHARMAP_W_I), "'")
				endc
			endr
			popo
			for _CHARMAP_W_I, 1, CHARLEN(\1) + 1
				setcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
				for _CHARMAP_W_J, CHARSUB(\1, _CHARMAP_W_I)
					setcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_J}
					db CHARSUB(\1, _CHARMAP_W_I)
				endr
			endr
			popc
		else
			if STRIN("\1", "\"") != 0
				warn "db_w: Parameter '\1' contains quotes that may not be parsed properly"
			endc
			popo
			popc
			db \1
		endc
		shift
	endr
ENDM

; getchar_w "Char", [value], [length]
;
; Get the value and byte length of a character.
; The value will be set to CHARMAP_W_CHAR,
; and the length will be set to CHARMAP_W_CHARLEN.
;
; value: CHARMAP_W_CHAR copied to value if defined.
;
; length: CHARMAP_W_CHARLEN copied to length if defined.
;
; Since HIGH()/LOW() cannot be rewritten as Macros, this macro is used instead.
; 
; For rgbds that natively support 16-bit charmap:
; ```
; charmap "Text", $1234
; ld a, HIGH("Text") ; parse as $12
; ```
; For the native rgbds that work with charmap_w, they need to be replaced with:
; ```
; charmap_w "Text", $12, $34
; getchar_w "Text", value
; ld a, HIGH(value) ; parse as $12
; ```
MACRO getchar_w
	pushc
	DEF CHARMAP_W_CHAR = 0
	setcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
	DEF CHARMAP_W_CHARLEN = \1
	for _CHARMAP_W_I, CHARMAP_W_CHARLEN
		setcharmap CHARMAP_W_{CHARMAP_W_NAME}_PLANE_{d:_CHARMAP_W_I}
		DEF CHARMAP_W_CHAR = (CHARMAP_W_CHAR << 8) | \1
	endr
	if _NARG > 1
		DEF \2 = CHARMAP_W_CHAR
	endc
	if _NARG > 2
		DEF \3 = CHARMAP_W_CHARLEN
	endc
	popc
ENDM

; getchar_w "String", [value]
;
; Get length of a string. The length will be set to CHARMAP_W_CHARLEN.
;
; length: CHARMAP_W_CHARLEN copied to length if defined.
MACRO charlen_w
	pushc
	DEF CHARMAP_W_CHARLEN = 0
	setcharmap CHARMAP_W_{CHARMAP_W_NAME}_LENGTH
	for _CHARMAP_W_I, 1, CHARLEN(\1) + 1
		DEF CHARMAP_W_CHARLEN += CHARSUB(\1, _CHARMAP_W_I)
	endr
	if _NARG > 1
		DEF \2 = CHARMAP_W_CHARLEN
	endc
	popc
ENDM

ENDC ; CHARMAP_W_INC

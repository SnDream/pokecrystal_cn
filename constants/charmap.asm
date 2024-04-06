; $00-$16 are TX_* constants (see macros/scripts/text.asm)

; Control characters (see home/text.asm)

	charmap_w "<NULL>",    $00
	charmap_w "<PLAY_G>",  $14 ; "<PLAYER>くん" or "<PLAYER>ちゃん"; same as "<PLAYER>" in English
	charmap_w "<MOBILE>",  $15
	charmap_w "<CR>",      $16
	charmap_w "<BSP>",     $1f ; breakable space (usually " ", or "<LF>" on the Town Map)
	charmap_w "<LF>",      $22
	charmap_w "<POKE>",    $24 ; "<PO><KE>"
	charmap_w "<WBR>",     $25 ; word-break opportunity (usually skipped, or "<LF>" on the Town Map)
	charmap_w "<RED>",     $38 ; wRedsName
	charmap_w "<GREEN>",   $39 ; wGreensName
	charmap_w "<ENEMY>",   $3f
	charmap_w "<MOM>",     $49 ; wMomsName
	charmap_w "<PKMN>",    $4a ; "<PK><MN>"
	charmap_w "<_CONT>",   $4b ; implements "<CONT>"
	charmap_w "<SCROLL>",  $4c
	charmap_w "<NEXT>",    $4e
	charmap_w "<LINE>",    $4f
	charmap_w "@",         $50 ; string terminator
	charmap_w "<PARA>",    $51
	charmap_w "<PLAYER>",  $52 ; wPlayerName
	charmap_w "<RIVAL>",   $53 ; wRivalName
	charmap_w "#",         $54 ; "POKé"
	charmap_w "<CONT>",    $55
	charmap_w "<……>",      $56 ; "……"
	charmap_w "<DONE>",    $57
	charmap_w "<PROMPT>",  $58
	charmap_w "<TARGET>",  $59
	charmap_w "<USER>",    $5a
	charmap_w "<PC>",      $5b ; "PC"
	charmap_w "<TM>",      $5c ; "TM"
	charmap_w "<TRAINER>", $5d ; "TRAINER"
	charmap_w "<ROCKET>",  $5e ; "ROCKET"
	charmap_w "<DEXEND>",  $5f

; Actual characters (from gfx/font/font_extra.png)

	charmap_w "<BOLD_A>",  $60 ; unused
	charmap_w "<BOLD_B>",  $61 ; unused
	charmap_w "<BOLD_C>",  $62 ; unused
	charmap_w "<BOLD_D>",  $63 ; unused
	charmap_w "<BOLD_E>",  $64 ; unused
	charmap_w "<BOLD_F>",  $65 ; unused
	charmap_w "<BOLD_G>",  $66 ; unused
	charmap_w "<BOLD_H>",  $67 ; unused
	charmap_w "<BOLD_I>",  $68 ; unused
	charmap_w "<BOLD_V>",  $69
	charmap_w "<BOLD_S>",  $6a
	charmap_w "<BOLD_L>",  $6b ; unused
	charmap_w "<BOLD_M>",  $6c ; unused
	charmap_w "<COLON>",   $6d ; colon with tinier dots than ":"
	charmap_w "ぃ",         $6e ; hiragana small i, unused
	charmap_w "ぅ",         $6f ; hiragana small u, unused
	charmap_w "<PO>",      $70
	charmap_w "<KE>",      $71
	charmap_w "<“>",         $72 ; opening quote
	charmap_w "<”>",         $73 ; closing quote
	charmap_w "<·>",         $74 ; middle dot, unused
	charmap_w "…",         $75 ; ellipsis
	charmap_w "ぁ",         $76 ; hiragana small a, unused
	charmap_w "ぇ",         $77 ; hiragana small e, unused
	charmap_w "ぉ",         $78 ; hiragana small o, unused

	charmap_w "┌",         $79
	charmap_w "─",         $7a
	charmap_w "┐",         $7b
	charmap_w "│",         $7c
	charmap_w "└",         $7d
	charmap_w "┘",         $7e
	charmap_w " ",         $7f

; Actual characters (from gfx/font/font_battle_extra.png)

	charmap_w "<LV>",      $6e

	charmap_w "<DO>",      $70 ; hiragana small do, unused
	charmap_w "◀",         $71
	charmap_w "<『>",         $72 ; Japanese opening quote, unused
	charmap_w "<ID>",      $73
	charmap_w "№",         $74

; Actual characters (from other graphics files)

	; needed for _LoadFontsExtra1 (see engine/gfx/load_font.asm)
	charmap_w "■",         $60 ; gfx/font/black.2bpp
	charmap_w "▲",         $61 ; gfx/font/up_arrow.png
	charmap_w "☎",         $62 ; gfx/font/phone_icon.2bpp

	; needed for MagikarpHouseSign (see engine/events/magikarp.asm)
	charmap_w "′",         $6e ; gfx/font/feet_inches.png
	charmap_w "″",         $6f ; gfx/font/feet_inches.png

	; needed for StatsScreen_PlaceShinyIcon and PrintPartyMonPage1
	charmap_w "⁂",         $3f ; gfx/stats/stats_tiles.png, tile 14

; Actual characters (from gfx/font/font.png)

	charmap_w "A",         $80
	charmap_w "B",         $81
	charmap_w "C",         $82
	charmap_w "D",         $83
	charmap_w "E",         $84
	charmap_w "F",         $85
	charmap_w "G",         $86
	charmap_w "H",         $87
	charmap_w "I",         $88
	charmap_w "J",         $89
	charmap_w "K",         $8a
	charmap_w "L",         $8b
	charmap_w "M",         $8c
	charmap_w "N",         $8d
	charmap_w "O",         $8e
	charmap_w "P",         $8f
	charmap_w "Q",         $90
	charmap_w "R",         $91
	charmap_w "S",         $92
	charmap_w "T",         $93
	charmap_w "U",         $94
	charmap_w "V",         $95
	charmap_w "W",         $96
	charmap_w "X",         $97
	charmap_w "Y",         $98
	charmap_w "Z",         $99

	charmap_w "(",         $9a
	charmap_w ")",         $9b
	charmap_w ":",         $9c
	charmap_w ";",         $9d
	charmap_w "[",         $9e
	charmap_w "]",         $9f

	charmap_w "a",         $a0
	charmap_w "b",         $a1
	charmap_w "c",         $a2
	charmap_w "d",         $a3
	charmap_w "e",         $a4
	charmap_w "f",         $a5
	charmap_w "g",         $a6
	charmap_w "h",         $a7
	charmap_w "i",         $a8
	charmap_w "j",         $a9
	charmap_w "k",         $aa
	charmap_w "l",         $ab
	charmap_w "m",         $ac
	charmap_w "n",         $ad
	charmap_w "o",         $ae
	charmap_w "p",         $af
	charmap_w "q",         $b0
	charmap_w "r",         $b1
	charmap_w "s",         $b2
	charmap_w "t",         $b3
	charmap_w "u",         $b4
	charmap_w "v",         $b5
	charmap_w "w",         $b6
	charmap_w "x",         $b7
	charmap_w "y",         $b8
	charmap_w "z",         $b9

	charmap_w "Ä",         $c0
	charmap_w "Ö",         $c1
	charmap_w "Ü",         $c2
	charmap_w "ä",         $c3
	charmap_w "ö",         $c4
	charmap_w "ü",         $c5

	charmap_w "'d",        $d0
	charmap_w "'l",        $d1
	charmap_w "'m",        $d2
	charmap_w "'r",        $d3
	charmap_w "'s",        $d4
	charmap_w "'t",        $d5
	charmap_w "'v",        $d6

	charmap_w "←",         $df
	charmap_w "'",         $e0
	charmap_w "<PK>",      $e1
	charmap_w "<MN>",      $e2
	charmap_w "-",         $e3

	charmap_w "?",         $e6
	charmap_w "!",         $e7
	charmap_w ".",         $e8
	charmap_w "&",         $e9

	charmap_w "é",         $ea
	charmap_w "→",         $eb
	charmap_w "▷",         $ec
	charmap_w "▶",         $ed
	charmap_w "▼",         $ee
	charmap_w "♂",         $ef
	charmap_w "¥",         $f0 ; Poké Dollar sign
	charmap_w "×",         $f1
	charmap_w "<DOT>",     $f2 ; decimal point; same as "." in English
	charmap_w "/",         $f3
	charmap_w ",",         $f4
	charmap_w "♀",         $f5

	charmap_w "0",         $f6
	charmap_w "1",         $f7
	charmap_w "2",         $f8
	charmap_w "3",         $f9
	charmap_w "4",         $fa
	charmap_w "5",         $fb
	charmap_w "6",         $fc
	charmap_w "7",         $fd
	charmap_w "8",         $fe
	charmap_w "9",         $ff

; Japanese control characters (see home/text.asm)

	charmap_w "<JP_18>",   $18 ; "ノ゛" (ungrammatical)
	charmap_w "<NI>",      $1d ; "に　"
	charmap_w "<TTE>",     $1e ; "って"
	charmap_w "<WO>",      $1f ; "を　"
	charmap_w "<TA!>",     $22 ; "た！"
	charmap_w "<KOUGEKI>", $23 ; "こうげき"
	charmap_w "<WA>",      $24 ; "は　"
	charmap_w "<NO>",      $25 ; "の　"
	charmap_w "<ROUTE>",   $35 ; "ばん　どうろ"
	charmap_w "<WATASHI>", $36 ; "わたし"
	charmap_w "<KOKO_WA>", $37 ; "ここは"
	charmap_w "<GA>",      $4a ; "が　"

; Japanese kana, for those bits of text that were not translated to English

	charmap_w "ガ", $05
	charmap_w "ギ", $06
	charmap_w "グ", $07
	charmap_w "ゲ", $08
	charmap_w "ゴ", $09
	charmap_w "ザ", $0a
	charmap_w "ジ", $0b
	charmap_w "ズ", $0c
	charmap_w "ゼ", $0d
	charmap_w "ゾ", $0e
	charmap_w "ダ", $0f
	charmap_w "ヂ", $10
	charmap_w "ヅ", $11
	charmap_w "デ", $12
	charmap_w "ド", $13

	charmap_w "バ", $19
	charmap_w "ビ", $1a
	charmap_w "ブ", $1b
	charmap_w "ボ", $1c

	charmap_w "が", $26
	charmap_w "ぎ", $27
	charmap_w "ぐ", $28
	charmap_w "げ", $29
	charmap_w "ご", $2a
	charmap_w "ざ", $2b
	charmap_w "じ", $2c
	charmap_w "ず", $2d
	charmap_w "ぜ", $2e
	charmap_w "ぞ", $2f
	charmap_w "だ", $30
	charmap_w "ぢ", $31
	charmap_w "づ", $32
	charmap_w "で", $33
	charmap_w "ど", $34

	charmap_w "ば", $3a
	charmap_w "び", $3b
	charmap_w "ぶ", $3c
	charmap_w "べ", $3d
	charmap_w "ぼ", $3e

	charmap_w "パ", $40
	charmap_w "ピ", $41
	charmap_w "プ", $42
	charmap_w "ポ", $43
	charmap_w "ぱ", $44
	charmap_w "ぴ", $45
	charmap_w "ぷ", $46
	charmap_w "ぺ", $47
	charmap_w "ぽ", $48

	charmap_w "<「>", $70
	charmap_w "<」>", $71
	charmap_w "<』>", $73
	charmap_w "・", $74
	charmap_w "⋯", $75

	charmap_w "<　>", $7f

	charmap_w "ア", $80
	charmap_w "イ", $81
	charmap_w "ウ", $82
	charmap_w "エ", $83
	charmap_w "オ", $84
	charmap_w "カ", $85
	charmap_w "キ", $86
	charmap_w "ク", $87
	charmap_w "ケ", $88
	charmap_w "コ", $89
	charmap_w "サ", $8a
	charmap_w "シ", $8b
	charmap_w "ス", $8c
	charmap_w "セ", $8d
	charmap_w "ソ", $8e
	charmap_w "タ", $8f
	charmap_w "チ", $90
	charmap_w "ツ", $91
	charmap_w "テ", $92
	charmap_w "ト", $93
	charmap_w "ナ", $94
	charmap_w "ニ", $95
	charmap_w "ヌ", $96
	charmap_w "ネ", $97
	charmap_w "ノ", $98
	charmap_w "ハ", $99
	charmap_w "ヒ", $9a
	charmap_w "フ", $9b
	charmap_w "ホ", $9c
	charmap_w "マ", $9d
	charmap_w "ミ", $9e
	charmap_w "ム", $9f
	charmap_w "メ", $a0
	charmap_w "モ", $a1
	charmap_w "ヤ", $a2
	charmap_w "ユ", $a3
	charmap_w "ヨ", $a4
	charmap_w "ラ", $a5
	charmap_w "ル", $a6
	charmap_w "レ", $a7
	charmap_w "ロ", $a8
	charmap_w "ワ", $a9
	charmap_w "ヲ", $aa
	charmap_w "ン", $ab
	charmap_w "ッ", $ac
	charmap_w "ャ", $ad
	charmap_w "ュ", $ae
	charmap_w "ョ", $af
	charmap_w "ィ", $b0

	charmap_w "あ", $b1
	charmap_w "い", $b2
	charmap_w "う", $b3
	charmap_w "え", $b4
	charmap_w "お", $b5
	charmap_w "か", $b6
	charmap_w "き", $b7
	charmap_w "く", $b8
	charmap_w "け", $b9
	charmap_w "こ", $ba
	charmap_w "さ", $bb
	charmap_w "し", $bc
	charmap_w "す", $bd
	charmap_w "せ", $be
	charmap_w "そ", $bf
	charmap_w "た", $c0
	charmap_w "ち", $c1
	charmap_w "つ", $c2
	charmap_w "て", $c3
	charmap_w "と", $c4
	charmap_w "な", $c5
	charmap_w "に", $c6
	charmap_w "ぬ", $c7
	charmap_w "ね", $c8
	charmap_w "の", $c9
	charmap_w "は", $ca
	charmap_w "ひ", $cb
	charmap_w "ふ", $cc
	charmap_w "へ", $cd
	charmap_w "ほ", $ce
	charmap_w "ま", $cf
	charmap_w "み", $d0
	charmap_w "む", $d1
	charmap_w "め", $d2
	charmap_w "も", $d3
	charmap_w "や", $d4
	charmap_w "ゆ", $d5
	charmap_w "よ", $d6
	charmap_w "ら", $d7
	charmap_w "り", $d8
	charmap_w "る", $d9
	charmap_w "れ", $da
	charmap_w "ろ", $db
	charmap_w "わ", $dc
	charmap_w "を", $dd
	charmap_w "ん", $de
	charmap_w "っ", $df
	charmap_w "ゃ", $e0
	charmap_w "ゅ", $e1
	charmap_w "ょ", $e2

	charmap_w "ー", $e3
	charmap_w "ﾟ", $e4
	charmap_w "ﾞ", $e5

	charmap_w "<？>", $e6
	charmap_w "<！>", $e7
	charmap_w "<。>", $e8

	charmap_w "ァ", $e9
	charmap_w "ゥ", $ea
	charmap_w "ェ", $eb

	charmap_w "円", $f0

	charmap_w "<．>", $f2
	charmap_w "<／>", $f3

	charmap_w "ォ", $f4

	charmap_w "<０>", $f6
	charmap_w "<１>", $f7
	charmap_w "<２>", $f8
	charmap_w "<３>", $f9
	charmap_w "<４>", $fa
	charmap_w "<５>", $fb
	charmap_w "<６>", $fc
	charmap_w "<７>", $fd
	charmap_w "<８>", $fe
	charmap_w "<９>", $ff

pushc
	newcharmap ascii
	DEF PRINTABLE_ASCII EQUS " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz\{|}~"
	for i, STRLEN("{PRINTABLE_ASCII}")
		charmap STRSUB("{PRINTABLE_ASCII}", i + 1, 1), i + $20
	endr
	charmap "\t", $09
	charmap "\n", $0a
	charmap "\r", $0d
popc

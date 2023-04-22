DEF TILE_WIDTH EQU 8 ; pixels
DEF LEN_1BPP_TILE EQU 1 * TILE_WIDTH ; bytes
DEF LEN_2BPP_TILE EQU 2 * TILE_WIDTH ; bytes

DEF NUM_PAL_COLORS EQU 4
DEF PAL_COLOR_SIZE EQU 2
DEF PALETTE_SIZE EQU NUM_PAL_COLORS * PAL_COLOR_SIZE

DEF PALRGB_WHITE EQU palred 31 + palgreen 31 + palblue 31 ; $7fff

DEF SCREEN_WIDTH  EQU 20 ; tiles
DEF SCREEN_HEIGHT EQU 18 ; tiles
DEF SCREEN_WIDTH_PX  EQU SCREEN_WIDTH  * TILE_WIDTH ; pixels
DEF SCREEN_HEIGHT_PX EQU SCREEN_HEIGHT * TILE_WIDTH ; pixels

DEF BG_MAP_WIDTH  EQU 32 ; tiles
DEF BG_MAP_HEIGHT EQU 32 ; tiles

DEF METATILE_WIDTH EQU 4 ; tiles
DEF SCREEN_META_WIDTH EQU 6 ; metatiles
DEF SCREEN_META_HEIGHT EQU 5 ; metatiles
DEF SURROUNDING_WIDTH  EQU SCREEN_META_WIDTH * METATILE_WIDTH ; tiles
DEF SURROUNDING_HEIGHT EQU SCREEN_META_HEIGHT * METATILE_WIDTH ; tiles
DEF MAP_CONNECTION_PADDING_WIDTH EQU 3 ; metatiles

DEF HP_BAR_LENGTH  EQU 6 ; tiles
DEF HP_BAR_SHORT_LENGTH  EQU 4 ; tiles
DEF EXP_BAR_LENGTH EQU 8 ; tiles
DEF HP_BAR_LENGTH_PX  EQU HP_BAR_LENGTH  * TILE_WIDTH ; pixels
DEF HP_BAR_SHORT_LENGTH_PX  EQU HP_BAR_SHORT_LENGTH  * TILE_WIDTH ; pixels
DEF EXP_BAR_LENGTH_PX EQU EXP_BAR_LENGTH * TILE_WIDTH ; pixels

; GetHPPal return values (see home/tilemap.asm)
DEF HP_GREEN  EQU 0
DEF HP_YELLOW EQU 1
DEF HP_RED    EQU 2

; sprite_oam_struct members (see macros/ram.asm)
rsreset
DEF SPRITEOAMSTRUCT_YCOORD     rb ; 0
DEF SPRITEOAMSTRUCT_XCOORD     rb ; 1
DEF SPRITEOAMSTRUCT_TILE_ID    rb ; 2
DEF SPRITEOAMSTRUCT_ATTRIBUTES rb ; 3
DEF SPRITEOAMSTRUCT_LENGTH EQU _RS
DEF NUM_SPRITE_OAM_STRUCTS EQU 40 ; see wShadowOAM

DEF SPRITE_GFX_LIST_CAPACITY EQU 32 ; see wUsedSprites

; PokeAnims indexes (see engine/gfx/pic_animation.asm)
	const_def
	const ANIM_MON_SLOW
	const ANIM_MON_NORMAL
	const ANIM_MON_MENU
	const ANIM_MON_TRADE
	const ANIM_MON_EVOLVE
	const ANIM_MON_HATCH
	const ANIM_MON_HOF
	const ANIM_MON_EGG1
	const ANIM_MON_EGG2

game_matrix DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
			DB 3, 2, 0, 0, 0, 4, 0, 4, 0, 0, 0, 4, 4, 0, 0, 0, 3
			DB 3, 0, 3, 0, 3, 0, 3, 4, 3, 4, 3, 4, 3, 0, 3, 0, 3
			DB 3, 0, 4, 4, 4, 4, 0, 4, 0, 4, 0, 0, 4, 0, 0, 0, 3
			DB 3, 4, 3, 0, 3, 4, 3, 0, 3, 0, 3, 0, 3, 4, 3, 0, 3
			DB 3, 4, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 4, 0, 0, 3
			DB 3, 4, 3, 0, 3, 4, 3, 0, 3, 0, 3, 4, 3, 4, 3, 0, 3
			DB 3, 0, 0, 0, 4, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 3
			DB 3, 0, 3, 0, 3, 4, 3, 0, 3, 4, 3, 4, 3, 4, 3, 0, 3
			DB 3, 4, 4, 4, 0, 4, 0, 4, 0, 4, 0, 0, 4, 4, 0, 0, 3
			DB 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 4, 3, 0, 3, 0, 3
			DB 3, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 3
			DB 3, 4, 3, 0, 3, 0, 3, 0, 3, 4, 3, 4, 3, 0, 3, 0, 3
			DB 3, 4, 4, 4, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3
			DB 3, 4, 3, 0, 3, 0, 3, 0, 3, 0, 3, 4, 3, 0, 3, 0, 3
			DB 3, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3
			DB 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3

nr_elem_linie DD 17
nr_elem_linie_1 DD 16
BOMBERMAN struct
	cordX DD 0
	cordY DD 0
	bombs DD 0
	lives DD 0
BOMBERMAN ends
BMAN BOMBERMAN {1,1,nr_of_bombs, 3}
actual_poz DD 0
future_poz DD 0

BOMB_ENTITY struct
	cordX DD 0
	cordY DD 0
	timer DD 0
	range DD 0
BOMB_ENTITY ends
nr_of_bombs EQU 3
sizeof_BOMB_ENTITY DD 16
bomb_timer DD 10
BOMBS BOMB_ENTITY nr_of_bombs dup ({-1,-1,10,4})

CLEAN_BOMBS struct
	position DD 0
	timer DD 0
	range DD 0
CLEAN_BOMBS ends
sizeof_CLEAN_BOMBS_ENTITY DD 0
clean_timer EQU 1
BOMBS_TO_CLEAN CLEAN_BOMBS nr_of_bombs dup ({-1,clean_timer,4})

start_explosion DD 0
bomb_power DD 2
range DD 0
left_limit DD 0
right_limit DD 0

window_title DB "BOMBERMAN TRIAL!",0
format_poz_bomba DB "POZITIA BOMBEI CARE A EXPLODAT :X=%d Y=%d TIMER=%d RAZA=%d", NL, 0
format_poz_bomba1 DB "POZITIA BOMBEI :X=%d Y=%d RAZA=%d", NL, 0
format_poz_clean DB "AVEM DE CURATAT BOMBA : POZ = %d", NL, 0
format_poz DB "POZITIA BOMBER-MANULUI : X = %d & Y = %d ", NL, 0
format_int DB "Avem valoarea: %d la pozitia %d", NL, 0
format_vieti DB "Mai ai %d vieti ramase!", NL, 0
booooom DB "BOOOOM!", NL, 0
area_width EQU 680
area_height EQU 680
area DD 0
counter DD 0 ; numara evenimentele de tip timer
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
arg5 EQU 24
arg6 EQU 28
COLOR_RED EQU 0FF0000h
COLOR_GREEN EQU 000FF00h
COLOR_BLUE EQU 00000FFh
COLOR_WHITE EQU 0FFFFFFh
symbol_width EQU 10
symbol_height EQU 20
symbol_width_bman EQU 40
symbol_height_bman EQU 40
maximum EQU 288
NL EQU 10
format_err DB "Eroare! X sau Y inafara matricii", NL,0
PATRAT struct
	x DD 0
	y DD 0
	color DD 0
	size_patrat DD 0
PATRAT ends
patratel PATRAT {0,0,0FF2342h,40}
line DD 0
column DD 0
value DD 0
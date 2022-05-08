; int draw_rectangle (int x, int y, int width, int height, int color)
draw_rectangle proc
	push ebp
	mov ebp, esp
	push esi
	cmp dword ptr [ebp+arg1], 0
	jl eroare
	mov eax, area_width
	sub eax, [ebp+arg3]
	cmp dword ptr [ebp+arg1], eax
	jg eroare
	
	cmp dword ptr [ebp+arg2], 0
	jl eroare
	mov eax, area_height
	sub eax, [ebp+arg4]
	cmp dword ptr [ebp+arg2], eax
	jg eroare
	; 0<=x<640-width
	; 0<=y<480-height
	; pos = (y * area_width + x) * 4
	; for i=0; i<height; i++
	xor ecx,ecx
	mov esi, [ebp+arg1]
bucla_orizontal:
	cmp ecx, [ebp+arg4]
	jge over_bucla_orizontal
	push ecx
	line_horizontal esi, [ebp+arg2], [ebp+arg3], [ebp+arg5]
	pop ecx
	add esi, area_width
	inc ecx
	jmp bucla_orizontal
over_bucla_orizontal:
	xor eax, eax
	jmp final
eroare:
	apel1 printf, offset format_err
	mov eax, -1
final:
	pop esi
	pop ebp
	ret
draw_rectangle endp
; Primeste un pointer la patrat,  
move_rectangle proc
	push ebp
	mov ebp, esp
	
	cmp dword ptr [ebp+arg2], 1
	je CLICK_W
	cmp dword ptr [ebp+arg2], 2
	je CLICK_A
	cmp dword ptr [ebp+arg2], 3
	je CLICK_S
	cmp dword ptr [ebp+arg2], 4
	je CLICK_D
CLICK_W:
	mov esi, [ebp+arg1]
	cmp dword ptr [esi+PATRAT.y], 0
	je end_move_rectangle
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], COLOR_WHITE
	mov ebx, [esi+PATRAT.size_patrat]
	sub [esi+PATRAT.y], ebx
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], [esi+PATRAT.color]
	jmp end_move_rectangle	
CLICK_A:
	mov esi, [ebp+arg1]
	cmp dword ptr [esi+PATRAT.x], 0
	je end_move_rectangle
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], COLOR_WHITE
	mov ebx, [esi+PATRAT.size_patrat]
	sub [esi+PATRAT.x], ebx
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], [esi+PATRAT.color]
	jmp end_move_rectangle
CLICK_S:
	mov esi, [ebp+arg1]
	mov eax, area_height
	sub eax, [esi+PATRAT.size_patrat]
	cmp dword ptr [esi+PATRAT.y], eax
	je end_move_rectangle
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], COLOR_WHITE
	mov ebx, [esi+PATRAT.size_patrat]
	add [esi+PATRAT.y], ebx
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], [esi+PATRAT.color]
	jmp end_move_rectangle
CLICK_D:
	mov esi, [ebp+arg1]
	mov eax, area_width
	sub eax, [esi+PATRAT.size_patrat]
	cmp dword ptr [esi+PATRAT.x], eax
	je end_move_rectangle
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], COLOR_WHITE
	mov ebx, [esi+PATRAT.size_patrat]
	add [esi+PATRAT.x], ebx
	apel5 draw_rectangle, [esi+PATRAT.x], [esi+PATRAT.y], [esi+PATRAT.size_patrat], [esi+PATRAT.size_patrat], [esi+PATRAT.color]
	jmp end_move_rectangle
	
end_move_rectangle:
	pop ebp
	ret
move_rectangle endp
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text: ; C = 2 , eax = 2*200
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
; make_symbol
; arg1 - simbolul de afisat (codat cu CIFRE)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_symbol proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, symbols
	cmp eax, 0
	jl make_space_symbol
	cmp eax, 9
	jg make_space_symbol
	jmp draw_text_symbol
make_space_symbol:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
draw_text_symbol:
	mov ebx, symbol_width_bman
	mul ebx
	mov ebx, symbol_height_bman
	mul ebx
	shl eax, 2
	add esi, eax
	mov ecx, symbol_height_bman
bucla_simbol_linii_symbol:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_bman
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_bman
bucla_simbol_coloane_symbol:
	mov eax, [esi]
	mov dword ptr [edi], eax
	add esi, 4
	add edi, 4
	loop bucla_simbol_coloane_symbol
	pop ecx
	loop bucla_simbol_linii_symbol
	popa
	mov esp, ebp
	pop ebp
	ret
make_symbol endp
; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
make_symbol_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_symbol
	add esp, 16
endm
; Functia de interpretare a matricei jocului
; care apeleaza make_symbol pentru a desena simbolurile reprezentate in matrice la coordonatele date 
draw_game_matrix proc
	lea esi, game_matrix
	mov ecx, 0
parcurgere_matrix:
	xor edx, edx
	mov eax, ecx
	div nr_elem_linie
	mov column, edx
	mov edx, 40
	mul edx
	mov line, eax
	mov eax, column
	mov edx, 40
	mul edx
	mov column, eax
	push ecx
	push esi
	mov eax, 0
	add al, byte ptr [esi]
	mov value, eax
	;apel3 printf, offset format_int, value, ecx
	pop esi
	pop ecx
	push ecx
	push esi
	;add line, 40
	make_symbol_macro value, area, column, line
	pop esi
	pop ecx
	cmp ecx, maximum
	je end_matrix
	inc ecx
	inc esi
	jmp parcurgere_matrix
end_matrix:
	ret
draw_game_matrix endp
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
move_bomberman proc
	push ebp
	mov ebp, esp
	pusha
	
	mov esi, [ebp+arg1]
	lea edi, game_matrix
	cmp dword ptr [ebp+arg2], 'W'
	je BCLICK_W
	cmp dword ptr [ebp+arg2], 'A'
	je BCLICK_A
	cmp dword ptr [ebp+arg2], 'S'
	je BCLICK_S
	cmp dword ptr [ebp+arg2], 'D'
	je BCLICK_D
BCLICK_W:
	mov eax, DWORD PTR [esi+BOMBERMAN.cordY]
	cmp eax, 0
	jle end_move_bomberman
	
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	mov actual_poz, eax
	sub eax, nr_elem_linie
	mov future_poz, eax

	cmp byte ptr [edi+eax], 0
	jne end_move_bomberman
	
	sub [esi+BOMBERMAN.cordY], 1
	jmp make_replacements
BCLICK_A:
	mov eax, DWORD PTR [esi+BOMBERMAN.cordX]
	cmp eax, 0
	jle end_move_bomberman
	
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	mov actual_poz, eax
	sub eax, 1
	mov future_poz, eax

	cmp byte ptr [edi+eax], 0
	jne end_move_bomberman
	
	sub [esi+BOMBERMAN.cordX], 1
	jmp make_replacements
BCLICK_S:
	mov eax, DWORD PTR [esi+BOMBERMAN.cordY]
	cmp eax, nr_elem_linie_1
	jge end_move_bomberman
	
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	mov actual_poz, eax
	add eax, nr_elem_linie
	mov future_poz, eax

	cmp byte ptr [edi+eax], 0
	jne end_move_bomberman
	
	add [esi+BOMBERMAN.cordY], 1	
	jmp make_replacements
BCLICK_D:
	mov eax, DWORD PTR [esi+BOMBERMAN.cordX]
	cmp eax, nr_elem_linie
	jge end_move_bomberman
	
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	mov actual_poz, eax
	add eax, 1
	mov future_poz, eax

	cmp byte ptr [edi+eax], 0
	jne end_move_bomberman
	
	add [esi+BOMBERMAN.cordX], 1
	jmp make_replacements

make_replacements:
	mov eax, actual_poz
	; if (actual == 6) actual = 2
	;else	actual = 0
	cmp byte ptr [edi+eax], 6
	je put_bomb
	jne put_space
put_bomb:
	mov byte PTR [edi+eax], 1
	mov eax, future_poz
	mov byte PTR [edi+eax], 2
	jmp end_move_bomberman
put_space:
	mov byte PTR [edi+eax], 0
	mov eax, future_poz
	mov byte PTR [edi+eax], 2
	jmp end_move_bomberman
end_move_bomberman:
	apel3 printf, offset format_poz, [esi+BOMBERMAN.cordX], [esi+BOMBERMAN.cordY]
	popa
	pop ebp
	ret
move_bomberman endp
; set_bomb(*BOMBS, *BOMBERMAN)
set_bomb proc
	push ebp
	mov ebp, esp
	pusha

	mov sizeof_BOMB_ENTITY, SIZEOF BOMB_ENTITY
	
	mov esi, [ebp+arg2]
	;Verificam sa nu punem bombe in acelasi loc
	lea edi, game_matrix
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	cmp byte ptr [edi+eax], 6
	je end_set_bomb
	
	;Daca se poate pune bomba, verificam daca mai avem bombe disponibile si cautam un loc in vectorul de bombe
	mov edi, [ebp+arg1]
	mov eax, [esi+BOMBERMAN.bombs]
	cmp eax, 0
	jle end_set_bomb
	mov ecx, 0
find_empty_bomb_slot:
	xor edx, edx
	mov eax, ecx
	mul sizeof_BOMB_ENTITY

	cmp dword ptr [edi+eax+BOMB_ENTITY.cordX], -1
	jne keep_looking

	sub dword ptr [esi+BOMBERMAN.bombs], 1
	mov ebx, dword ptr [esi+BOMBERMAN.cordX]
	mov dword ptr [edi+eax+BOMB_ENTITY.cordX], ebx
	mov ebx, dword ptr [esi+BOMBERMAN.cordY] 
	mov dword ptr [edi+eax+BOMB_ENTITY.cordY], ebx
	mov ebx, bomb_timer
	mov dword ptr [edi+eax+BOMB_ENTITY.timer], ebx
	mov ebx, bomb_power
	mov dword ptr [edi+eax+BOMB_ENTITY.range], ebx
	lea edi, game_matrix
	xor edx, edx
	mov eax, [esi+BOMBERMAN.cordY]
	mul nr_elem_linie
	add eax, [esi+BOMBERMAN.cordX]
	mov byte ptr [edi+eax], 6
	jmp end_set_bomb
keep_looking:
	inc ecx
	cmp ecx, nr_of_bombs
	jl find_empty_bomb_slot

end_set_bomb:
	popa
	pop ebp
	ret
set_bomb endp
; calculate_explosions ( *BOMBS, *BOMBERMAN)
calculate_explosions proc
	push ebp
	mov ebp, esp
	pusha
	
	mov ecx, 0
	mov esi, [ebp+arg1] ; ESI - BOMBS
	
;	pusha
;	;Afisam toate bombele pentru debugging
;	lea edi, BOMBS
;	mov ecx, 0
;	mov eax, 0
;show_bombs:
;	pusha
;	apel4 printf, offset format_poz_bomba1, dword ptr [edi+eax+BOMB_ENTITY.cordX], dword ptr [edi+eax+BOMB_ENTITY.cordY], dword ptr [edi+eax+BOMB_ENTITY.range]
;	popa
;	add eax, sizeof_BOMB_ENTITY
;	inc ecx
;	cmp ecx, nr_of_bombs
;	jl show_bombs
;	popa

loop_bombs:
	xor edx, edx
	mov eax, ecx
	mul sizeof_BOMB_ENTITY
	cmp dword ptr [esi+eax+BOMB_ENTITY.cordX], -1
	je loop_forward

	cmp dword ptr [esi+eax+BOMB_ENTITY.timer], 0
	jle explode

	sub dword ptr [esi+eax+BOMB_ENTITY.timer], 1
	jmp loop_forward

explode:
	mov edi, [ebp+arg2]
	add dword ptr [edi+BOMBERMAN.bombs], 1
	
	add eax, esi
	apel1 calculate_blast, eax
	
loop_forward:
	inc ecx
	cmp ecx, nr_of_bombs
	jl loop_bombs

	popa
	pop ebp
	ret
calculate_explosions endp
; calculate_blast (*BOMBA)
calculate_blast proc
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp+arg1]; ESI - BOMBA CARE EXPLODEAZA
	pusha
	apel5 printf, offset format_poz_bomba, [esi+BOMB_ENTITY.cordX], [esi+BOMB_ENTITY.cordY], [esi+BOMB_ENTITY.timer], [esi+BOMB_ENTITY.range]
	popa
	lea edi, game_matrix
	xor edx, edx
	mov eax, [esi+BOMB_ENTITY.cordY]
	mul nr_elem_linie
	
	add eax, [esi+BOMB_ENTITY.cordX] 
	mov start_explosion, eax ; In start_explosion avem originea exploziei
	sub eax, [esi+BOMB_ENTITY.cordX]
	mov left_limit, eax
	add eax, nr_elem_linie
	dec eax
	mov right_limit, eax
	
	mov ecx, [esi+BOMB_ENTITY.range]
	mov range, ecx

	mov ecx, 1
	mov eax, start_explosion
	xor edx, edx
explosion_up:
	sub eax, nr_elem_linie
	cmp eax, 0 ; Sa nu avem valori in afara matrici
	jl over_up
	cmp byte ptr [edi+eax], 0 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_up_go
	cmp byte ptr [edi+eax], 2 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_up_go
	cmp byte ptr [edi+eax], 4 ; Daca avem o cutie, doar o explodam si iesim
	je replace_up_exit
	jmp over_up
	
    ;replace_up_player:
	;sub BMAN.lives, 1
	;apel2 printf, offset format_vieti, BMAN.lives
	;jmp replace_up_go
	replace_up_exit:
	mov byte ptr [edi+eax], 5
	jmp over_up
	replace_up_go:
	mov byte ptr [edi+eax], 5
	inc ecx
	cmp ecx, range
	jle explosion_up	
over_up:
	mov ecx, 1
	mov eax, start_explosion
explosion_down:
	add eax, nr_elem_linie
	cmp eax, maximum
	jg over_down
	cmp byte ptr [edi+eax], 0 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_down_go
	cmp byte ptr [edi+eax], 2 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_down_go
	cmp byte ptr [edi+eax], 4 ; Daca avem o cutie, doar o explodam si iesim
	je replace_down_exit
	jmp over_down
	replace_down_exit:
	mov byte ptr [edi+eax], 5
	jmp over_down
	replace_down_go:
	mov byte ptr [edi+eax], 5
	inc ecx
	cmp ecx, range
	jle explosion_down
over_down:
	mov ecx, 1
	mov eax, start_explosion
explosion_left:
	dec eax
	cmp eax, left_limit
	jl over_left
	cmp byte ptr [edi+eax], 0 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_left_go
	cmp byte ptr [edi+eax], 2 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_left_go
	cmp byte ptr [edi+eax], 4 ; Daca avem o cutie, doar o explodam si iesim
	je replace_left_exit
	jmp over_left
	replace_left_exit:
	mov byte ptr [edi+eax], 5
	jmp over_left
	replace_left_go:
	mov byte ptr [edi+eax], 5
	inc ecx
	cmp ecx, range
	jle explosion_left
over_left:
	mov ecx, 1
	mov eax, start_explosion
explosion_right:
	inc eax
	cmp eax, right_limit
	jg over_right
	cmp byte ptr [edi+eax], 0 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_right_go
	cmp byte ptr [edi+eax], 2 ; Daca este spatiu, putem sa punem BOOM si sa continuam
	je replace_right_go
	cmp byte ptr [edi+eax], 4 ; Daca avem o cutie, doar o explodam si iesim
	je replace_right_exit
	jmp over_right
	replace_right_exit:
	mov byte ptr [edi+eax], 5
	jmp over_right
	replace_right_go:
	mov byte ptr [edi+eax], 5
	inc ecx
	cmp ecx, range
	jle explosion_right
over_right:	
	mov eax, start_explosion
	mov byte ptr [edi+eax], 5; punem BOOM
	apel2 set_clean, start_explosion, range
	mov dword ptr [esi+BOMB_ENTITY.cordY], -1
	mov dword ptr [esi+BOMB_ENTITY.cordX], -1
	mov dword ptr [esi+BOMB_ENTITY.timer], 20
	popa
	pop ebp
	ret
calculate_blast endp
; set_clean (int position, int range)
set_clean proc
	push ebp
	mov ebp, esp
	pusha

	mov sizeof_CLEAN_BOMBS_ENTITY, SIZEOF CLEAN_BOMBS
	lea edi, BOMBS_TO_CLEAN
	mov ecx, 0
find_empty_clean_slot:
	xor edx, edx
	mov eax, ecx
	mul sizeof_CLEAN_BOMBS_ENTITY

	cmp dword ptr [edi+eax+CLEAN_BOMBS.position], -1
	jne keep_looking_clean
	mov ebx, [ebp+arg1]
	mov dword ptr [edi+eax+CLEAN_BOMBS.position], ebx
	mov ebx, [ebp+arg2]
	mov dword ptr [edi+eax+CLEAN_BOMBS.range], ebx
	mov dword ptr [edi+eax+CLEAN_BOMBS.timer], clean_timer
	jmp end_set_clean
keep_looking_clean:
	inc ecx
	cmp ecx, nr_of_bombs
	jl find_empty_clean_slot

end_set_clean:
	popa
	pop ebp
	ret
set_clean endp
; find_cleaning_spots (*BOMBS_TO_CLEAN)
find_cleaning_spots proc
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp+arg1]
	mov ecx, 0

loop_bombs_to_clean:
	xor edx, edx
	mov eax, ecx
	mul sizeof_CLEAN_BOMBS_ENTITY
	cmp dword ptr [esi+eax+CLEAN_BOMBS.position], -1
	je loop_forward_clean

	cmp dword ptr [esi+eax+CLEAN_BOMBS.timer], 0
	jle clean

	sub dword ptr [esi+eax+CLEAN_BOMBS.timer], 1
	jmp loop_forward_clean

clean:
	add eax, esi
	apel1 clean_blast, eax; trimit adresa din BOMBS_TO_CLEAN
	
loop_forward_clean:
	inc ecx
	cmp ecx, nr_of_bombs
	jl loop_bombs_to_clean

	popa
	pop ebp
	ret
find_cleaning_spots endp
; clean_blast (*BOMBS_TO_CLEAN)
clean_blast proc
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp+arg1]; ESI - BOMBA DE CURATAT
	lea edi, game_matrix
	
	xor edx, edx
	mov eax, [esi+CLEAN_BOMBS.position]
	mov start_explosion, eax ; In start_explosion avem originea exploziei
	div nr_elem_linie
	
	mov ebx, start_explosion
	mov left_limit, ebx
	sub left_limit, edx
	
	mov ebx, left_limit
	mov right_limit, ebx
	mov ebx, nr_elem_linie
	add right_limit, ebx
	sub right_limit, 1	
	
	mov ecx, [esi+CLEAN_BOMBS.range]
	mov range, ecx

	mov ecx, 1
	mov eax, start_explosion
	xor edx, edx
clean_up:
	sub eax, nr_elem_linie
	cmp eax, 0 ; Sa nu avem valori in afara matrici
	jl over_clean_up
	cmp byte ptr [edi+eax], 5 ; Daca este BOOM, punem spatiu si continuam
	je clean_up_go
	cmp byte ptr [edi+eax], 1
	jge over_clean_up
	clean_up_go:
	mov byte ptr [edi+eax], 0
	inc ecx
	cmp ecx, range
	jle clean_up	
over_clean_up:
	mov ecx, 1
	mov eax, start_explosion
clean_down:
	add eax, nr_elem_linie
	cmp eax, maximum
	jg over_clean_down
	cmp byte ptr [edi+eax], 5 ; Daca este BOOM, punem spatiu si continuam
	je clean_down_go
	cmp byte ptr [edi+eax], 1
	jge over_clean_down
	clean_down_go:
	mov byte ptr [edi+eax], 0
	inc ecx
	cmp ecx, range
	jle clean_down
over_clean_down:
	mov ecx, 1
	mov eax, start_explosion
clean_left:
	dec eax
	cmp eax, left_limit
	jl over_clean_left
	cmp byte ptr [edi+eax], 5 ; Daca este BOOM, punem spatiu si continuam
	je clean_left_go
	cmp byte ptr [edi+eax], 1
	jge over_clean_left
	clean_left_go:
	mov byte ptr [edi+eax], 0
	inc ecx
	cmp ecx, range
	jle clean_left
over_clean_left:
	mov ecx, 1
	mov eax, start_explosion
clean_right:
	inc eax
	cmp eax, right_limit
	jg over_clean_right
	cmp byte ptr [edi+eax], 5 ; Daca este BOOM, punem spatiu si continuam
	je clean_right_go
	cmp byte ptr [edi+eax], 1
	jge over_clean_right
	clean_right_go:
	mov byte ptr [edi+eax], 0
	inc ecx
	cmp ecx, range
	jle clean_right
over_clean_right:

	mov eax, start_explosion
	mov byte ptr [edi+eax], 0
	mov dword ptr [esi+CLEAN_BOMBS.position], -1

	xor edx, edx
	mov eax, BMAN.cordY
	mul nr_elem_linie
	add eax, BMAN.cordX
	cmp byte ptr [edi+eax], 6
	je end_clean_blast
	mov byte ptr [edi+eax], 2

end_clean_blast:
	popa
	pop ebp
	ret
clean_blast endp
;------------------------------------------------- FUNCTIA PRINCIPALA
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	cmp eax, 3
	jz evt_keyboard
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_keyboard:
	cmp byte ptr [ebp+arg2], 'W'
	jne CMP_A
CMP_W:
	apel2 move_bomberman,offset BMAN, 'W'
	jmp afisare_litere
CMP_A:
	cmp byte ptr [ebp+arg2], 'A'
	jne CMP_S
	apel2 move_bomberman,offset BMAN, 'A'
	jmp afisare_litere
CMP_S:
	cmp byte ptr [ebp+arg2], 'S'
	jne CMP_D
	apel2 move_bomberman,offset BMAN, 'S'
	jmp afisare_litere
CMP_D:
	cmp byte ptr [ebp+arg2], 'D'
	jne CMP_SPACE
	apel2 move_bomberman,offset BMAN, 'D'
	jmp afisare_litere
CMP_SPACE:
	cmp byte ptr [ebp+arg2], ' '
	jne afisare_litere
	apel2 set_bomb, offset BOMBS, offset BMAN
	jne afisare_litere

evt_click:
	jmp afisare_litere
evt_timer:
	inc counter
	apel1 find_cleaning_spots, offset BOMBS_TO_CLEAN
	apel2 calculate_explosions, offset BOMBS, offset BMAN
afisare_litere:
	
	call draw_game_matrix

eroare_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp
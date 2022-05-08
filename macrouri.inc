apel0 MACRO functie
	call functie
ENDM
apel1 MACRO functie, argument_1
	pusha
	push argument_1
	call functie
	add ESP, 4
	popa
ENDM
apel2 MACRO functie, argument_1, argument_2
	pusha
	push argument_2
	push argument_1
	call functie
	add ESP, 8
	popa
ENDM
apel3 MACRO functie, argument_1, argument_2, argument_3
	pusha
	push argument_3
	push argument_2
	push argument_1
	call functie
	add ESP, 12
	popa
ENDM
apel4 MACRO functie, argument_1, argument_2, argument_3, argument_4
	push argument_4
	push argument_3
	push argument_2
	push argument_1
	call functie
	add ESP, 16
ENDM
apel5 MACRO functie, argument_1, argument_2, argument_3, argument_4, argument_5
	push argument_5
	push argument_4
	push argument_3
	push argument_2
	push argument_1
	call functie
	add ESP, 20
ENDM
line_horizontal macro x, y, len, color
	local bucla_linie
	mov ebx, area_width
	mov eax, y
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
bucla_linie:
	mov ebx, color
	mov dword ptr [eax], ebx
	add eax, 4
	loop bucla_linie
endm
line_vertical macro x, y, len, color
	local bucla_coloana
	mov ebx, area_width
	mov eax, y
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
bucla_coloana:
	mov dword ptr [eax], color
	add eax, 4*area_width
	loop bucla_coloana
endm
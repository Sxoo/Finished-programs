; disasm Martynas Padarauskas, 2grupė, 2pogrupis
.model small

skBufDydis equ 10
tarpBufDydis equ 80
rasBufDydis equ 10

.stack 100h

.data
rez db 16 dup (00h)
duom db 16 dup (00h)
rFail dw ?
dFail dw ?

skBuf db skBufDydis dup (?)
tarpBuf db tarpBufDydis dup (20h)
rasBuf db rasBufDydis dup (?)

help db "Martynas Padarauskas 2 grupe, 2 pogrupis, disassembleris",0Dh, 0Ah,"Iveskite duomenu failo pavadinima (.com) ir rezultatu failo pavadinima (.asm)", 24h
FailuKlaida db "Klaida atidarant arba uzdarant rezultatu/duomenu failus", 24h
enteris db 0Dh, 0Ah, 24h

d_bitas db ?
w_bitas db ?
s_bitas db ?
mod_bitai db ?
reg_bitai db ?
rm_bitai db ?
segreg db ?
seg_reg_bitai db ?
Pirmas_baitas db ?
formato_nr db ?
betarp_op db ?
betarp_op2 db ?
posl_jaun db ?
posl_vyr db ?
ajb db ?
avb db ?
segjb db ?
segvb db ?
ip_reiksme dw 0100h   
kiek_masyve db 00h
variantas db ?


format_table db 11, 11, 11, 11, 4, 4, 8, 8, 0, 0		;0                      		;1 formatas - mov registras, betop
			 db 0, 0, 0, 0, 8, 8, 0, 0, 0, 0			;10								;2 formatas - salyginiai jmp, int, loop, vidinis artimas jmp 
		     db 0, 0, 8, 8, 0, 0, 0, 0, 0, 0			;20								;3 formatas - jmp vid. tsg., call vid. tsg., ret betop, retf betop
			 db 8, 8, 0, 0, 0, 0, 0, 0, 0, 6			;30								;4 formatas - mov, cmp, add, sub - akumuliatorius + atmintis
			 db 11, 11, 11, 11, 4, 4, 0, 6, 0, 0     	;40								;5 formatas - jmp, call, pop, push, dec, inc, mul, div + atmintis + posl
			 db 0, 0, 0, 0, 0, 0, 11, 11, 11, 11		;50								;6 formatas - ret, retf
			 db 4, 4, 0, 0, 7, 7, 7, 7, 7, 7			;60								;7 formatas - dec, pop, push, inc + registras
			 db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7			;70								;8 formatas - pop, push segmento registras
		     db 7, 7, 7, 7, 7, 7, 7, 7, 7, 7			;80								;9 formatas - jmp, call isorinis tiesioginis 
			 db 7, 7, 7, 7, 7, 7, 0, 0, 0, 0			;90						   	   ;10 formatas - cmp, sub, add atmintis + betop
			 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0        	;100						   ;11 formatas - cmp, sub, add, mov registras + atmintis
			 db 0, 0, 2, 2, 2, 2, 2, 2, 2, 2			;110						   ;12 formatas - mov segreg, atmintis/registras
			 db 2, 2, 2, 2, 2, 2, 2, 2, 10, 10			;120						   ;13 formatas - mov atmintis, bet op
			 db 10, 10, 0, 0, 0, 0, 11, 11, 11, 11		;130
			 db 12, 0, 12, 5, 0, 0, 0, 0, 0, 0			;140
			 db 0, 0, 0, 0, 9, 0, 0, 0, 0, 0        	;150
			 db 4, 4, 4, 4, 0, 0, 0, 0, 0, 0			;160
			 db 0, 0, 0, 0, 0, 1, 1, 1, 1, 1			;170
			 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1			;180
			 db 1, 1, 0, 0, 3, 6, 0, 0, 13, 13			;190
			 db 0, 0, 3, 6, 2, 2, 2, 0, 0, 0        	;200
  			 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0			;210
			 db 0, 0, 0, 0, 0, 0, 2, 2, 0, 0			;220
			 db 0, 0, 3, 3, 9, 2, 0, 0, 0, 0			;230
			 db 0, 0, 0, 0, 0, 0, 5, 5, 0, 0			;240
			 db 0, 0, 0, 0, 5, 5						;250

k_jcxz db "jcxz   $"
k_loop db "loop   $"
k_jmp db "jmp    $" 
k_mov db "mov    $"
k_int db "int    $"
k_call db "call   $"
k_ret db "ret    $"
k_retf db "retf   $"
k_pop db "pop    $"
k_inc db "inc    $"
k_dec db "dec    $"
k_push db "push   $"
k_div db "div    $"
k_mul db "mul    $"
k_daa db "DAA    $"
k_das db "DAS    $"
k_neatpazinta db "neatpazinta$"
ptr_byte db "byte ptr $"
ptr_word db "word ptr $"
k_pav_antras db "jo     $jno    $jnae   $jae    $je     $jne    $jbe    $ja     $js     $jns    $jp     $jnp    $jl     $jge    $jle    $jg     $" 
k_pav_trecias db "                ret    $                                        call   $jmp    $retf   $"
k_pav_penktas db "                call   $call   $jmp    $jmp    $push   $"
k_pav_ketvirtas db "        add    $                                                mov    $                sub    $                        cmp    $"
k_pav_septintas db "inc    $dec    $push   $pop    $"
k_pav_desimtas db "add    $                                sub    $        cmp    $"
k_pav_vienuoliktas db "add    $                                sub    $        cmp    $"

r_w1 db "ax$cx$dx$bx$sp$bp$si$di$"
r_w0 db "al$cl$dl$bl$ah$ch$dh$bh$"
r_AL db "al$"
r_AX db "ax$"
r_segreg db "es$cs$ss$ds$"
rm_reiksmes_mod_nulis   db "bx+si$ bx+di$ bp+si$ bp+di$ si$    di$   $       bx$"
rm_reiksmes_mod_nenulis db "bx+si+$ bx+di+$ bp+si+$ bp+di+$ si+$    di+$    bp+$    bx+$    "

.code									;Kodo pradzia  
mov ax, @data
mov ds, ax
mov bp, 00h


mov ch, 00h								;Parametru apdorojimas
mov cl, es:[0080h]
cmp cx, 00h
je Parametrai 
mov bx, 0082h

Cikliukas: 
mov al, es:[bx] 
mov [duom+si], al
inc bx
cmp al, '/'
je Help2
cmp al, '-'
je Help1
cmp al, ' '
je DuomenuPabaiga
inc si
cmp si, cx
ja Parametrai
jmp Cikliukas
    
DuomenuPabaiga:
dec si
cmp duom[si], 'm'
jne Parametrai
dec si
cmp duom[si], 'o'
jne Parametrai
dec si
cmp duom[si], 'c'
jne Parametrai
dec si
cmp duom[si], '.'
jne Parametrai  

add si, 4d
mov duom[si], 00h
sub cx, si
sub cx, 3d
xor si, si

KitasCikliukas:
mov al, es:[bx]
inc bx
cmp al, ' '
je Parametrai
mov [rez+si], al
inc si
cmp si, cx
ja RezFailas
jmp KitasCikliukas
    
Help2:
mov al, es:[bx] 
cmp al, '?'
je Parametrai
jmp Cikliukas

Help1:
mov al, es:[bx] 
cmp al, 'h'
je Parametrai
jmp Cikliukas

Parametrai:
mov ah, 09h
mov dx, offset help
int 21h
jmp pabaiga

RezFailas:
mov di, offset rez
add di, si
dec di
cmp rez[di], 'm'
jne Parametrai
dec di
cmp rez[di], 's'
jne Parametrai
dec di
cmp rez[di], 'a'
jne Parametrai
dec di
cmp rez[di], '.'
jne Parametrai
add di, 4d
mov rez[di], 00h


mov ah, 3Dh								;duom failo atidarymas
mov	al, 00			
mov	dx, offset duom
int	21h			
jc	KlaidaFailu2
mov dFail, ax	


mov ah, 3Ch								;rez failo sukurimas
mov	cx, 0			
mov	dx, offset rez	
int	21h			
jc	KlaidaFailu2
mov	rFail, ax   
xor ax, ax
jmp Nauja_Komanda

KlaidaFailu2:
mov dx, offset FailuKlaida
mov ah, 09h
int 21h
jmp	pabaiga


Nauja_Komanda:										;Pagrindinis komandu atpazinimo ciklas
	mov di, offset tarpBuf
	mov ax, ip_reiksme
	mov al, ah
	call print_baita_hexu
	mov ax, ip_reiksme
	call print_baita_hexu
	call add_dvitaskis
	mov cx, 5d
	call add_tarpas
Nauja_KomandaV2:
call gauk_baita
	call print_baita_hexu
		call ar_prefiksas
		mov byte ptr[Pirmas_baitas], al
			call komandos_informacija
				call print_komanda
atgal:
	call RasauFaila
	jmp Nauja_Komanda


gauk_baita:  										;funkcija, kuri paiima baita is skaitymo buferio ir patalpina i al
cmp byte ptr[kiek_masyve], 00h
je skaityk_stotele
nuskaiciau:
mov al, [si]
inc si
mov dx, ip_reiksme
inc dx
mov [ip_reiksme], dx								;seku poslinki
	mov dl, kiek_masyve
	dec dl
	mov [kiek_masyve], dl
ret

skaityk_stotele:
mov bx, dFail
call SkaitykBuf
jmp nuskaiciau

uzdaryk_stotele:
jmp uzdarytiRasymui


komandos_informacija:							;funkcija, kuri surenka informacija apie komanda pagal formato numeri
call gauk_formato_nr
cmp byte ptr[formato_nr], 01d
je pirmas_formatas
cmp byte ptr[formato_nr], 02d
je antras_formatas
cmp byte ptr[formato_nr], 03d
je trecias_formatas
cmp byte ptr[formato_nr], 04d
je ketvirtas_formatas
cmp byte ptr[formato_nr], 05d
je penktas_formatas
cmp byte ptr[formato_nr], 06d
je sestas_formatas
cmp byte ptr[formato_nr], 07d
je septintas_formatas
cmp byte ptr[formato_nr], 08d
je astuntas_formatas
cmp byte ptr[formato_nr], 09d
je devintas_formatas
cmp byte ptr[formato_nr], 10d
je desimtas_formatas
cmp byte ptr[formato_nr], 11d
je vienuoliktas_formatas
cmp byte ptr[formato_nr], 12d
je dvyliktas_formatas
cmp byte ptr[formato_nr], 13d
je tryliktas_formatas
cmp byte ptr[formato_nr], 00h
je nulinis_formatas

pirmas_formatas:
call surink_pirmas_formatas
ret

antras_formatas:
call surink_antras_formatas
ret

trecias_formatas:
call surink_trecias_formatas
ret

ketvirtas_formatas:
call surink_ketvirtas_formatas
ret

penktas_formatas:
call surink_penktas_formatas
ret

sestas_formatas:
ret

septintas_formatas:
call surink_septintas_formatas
ret

astuntas_formatas:
call surink_astuntas_formatas
ret

devintas_formatas:
call surink_devintas_formatas
ret

desimtas_formatas:
call surink_desimtas_formatas
ret

vienuoliktas_formatas:
call surink_vienuoliktas_formatas
ret

dvyliktas_formatas:
call surink_dvyliktas_formatas
ret

tryliktas_formatas:
call surink_tryliktas_formatas
ret

nulinis_formatas:
ret


gauk_formato_nr: 										;funkcija, kuri gauna formato numeri is pirmo baito
mov al, byte ptr[Pirmas_baitas]
mov ah, 00h
mov bx, offset format_table
add bx, ax
mov al, [bx]
mov byte ptr[formato_nr], al
ret
 

spausdink_varda:										;funkcija, kuri suranda ir isspausdina komandos pavadinima
push ax
push bx
push cx
push dx
	cmp byte ptr[formato_nr], 0d
	je vardo_spausdinimo_pabaiga
	cmp byte ptr[formato_nr], 1d
	je tai_mov
	cmp byte ptr[formato_nr], 2d
	je komanda_antras_formatas
	cmp byte ptr[formato_nr], 3d
	je komanda_trecias_formatas
	cmp byte ptr[formato_nr], 4d
	je komanda_ketvirtas_formatas
	cmp byte ptr[formato_nr], 5d
	je komanda_penktas_formatas
	cmp byte ptr[formato_nr], 6d
	je komanda_sestas_formatas
	cmp byte ptr[formato_nr], 7d
	je komanda_septintas_formatas
	cmp byte ptr[formato_nr], 8d
	je komanda_astuntas_formatas
	cmp byte ptr[formato_nr], 9d
	je komanda_devintas_formatas
	cmp byte ptr[formato_nr], 10d
	je komanda_desimtas_formatas
	cmp byte ptr[formato_nr], 11d
	je komanda_vienuoliktas_formatas
	cmp byte ptr[formato_nr], 12d
	je tai_mov
	cmp byte ptr[formato_nr], 13d
	je tai_mov
	
	komanda_antras_formatas:
	call rask_pavadinima_antras
	jmp varda_spausdink
		
vardo_spausdinimo_pabaiga:
pop dx
pop cx
pop bx
pop ax
ret
	
	tai_mov:
	mov bx, offset k_mov
	jmp varda_spausdink
		
	komanda_trecias_formatas:
	call rask_pavadinima_trecias
	jmp varda_spausdink
		
	komanda_ketvirtas_formatas:
	call rask_pavadinima_ketvirtas
	jmp varda_spausdink
	
	komanda_penktas_formatas:
	call rask_pavadinima_penktas
	jmp varda_spausdink
		
	komanda_sestas_formatas:
	call rask_pavadinima_sestas
	jmp varda_spausdink
	
	komanda_septintas_formatas:
	call rask_pavadinima_septintas
	jmp varda_spausdink
	
	komanda_astuntas_formatas:
	call rask_pavadinima_astuntas
	jmp varda_spausdink
	
	komanda_devintas_formatas:
	cmp byte ptr[Pirmas_baitas], 9Ah
	je tai_call
	jmp tai_jmp
	
	komanda_desimtas_formatas:
	call rask_pavadinima_desimtas
	jmp varda_spausdink
	
	komanda_vienuoliktas_formatas:
	call rask_pavadinima_vienuoliktas
	jmp varda_spausdink
	
	tai_retf:
	mov bx, offset k_retf
	jmp varda_spausdink
	
	tai_call:
	mov bx, offset k_call
	jmp varda_spausdink
	
	tai_jmp:
	mov bx, offset k_jmp
	jmp varda_spausdink
	
	tai_ret:
	mov bx, offset k_ret
	jmp varda_spausdink

varda_spausdink:
call Perkelk_i_buferi
jmp vardo_spausdinimo_pabaiga
	

print_komanda:													;funkcija, kuri isspausdina komanda pagal surinkta informacija ir formata
cmp byte ptr[formato_nr], 01d
je format1
	cmp byte ptr[formato_nr], 02d
	je format2
		cmp byte ptr [formato_nr], 03d
		je format3
			cmp byte ptr [formato_nr], 04d
			je format4
				cmp byte ptr[formato_nr], 05d
				je format5
					cmp byte ptr[formato_nr], 06d
					je format6
						cmp byte ptr[formato_nr], 07d
						je format7
							cmp byte ptr[formato_nr], 08d
							je format8
								cmp byte ptr[formato_nr], 09d
								je format9
									cmp byte ptr[formato_nr], 10d
									je format10
										cmp byte ptr[formato_nr], 11d
										je format11
											cmp byte ptr[formato_nr], 12d
											je format12
												cmp byte ptr[formato_nr], 13d
												je format13
													cmp byte ptr[formato_nr], 00h
													je format0
jmp format0

format1:
call print_pirmas_formatas
ret
format2:
call print_antras_formatas
ret
format3:
call print_trecias_formatas
ret
format4:
call print_ketvirtas_formatas
ret
format5:
call print_penktas_formatas
ret
format6:
call print_sestas_formatas
ret 
format7:
call print_septintas_formatas
ret
format8:
call print_astuntas_formatas
ret
format9:
call print_devintas_formatas
ret
format10:
call print_desimtas_formatas
ret
format11:
call print_vienuoliktas_formatas
ret
format12:
call print_dvyliktas_formatas
ret
format13:
call print_tryliktas_formatas
ret
format0:
call print_nulinis_formatas
ret


print_baita_hexu:    											;funkcija, kuri pavercia baita esanti al i hex ir perkelia i tarpini buferi
   push ax
   push bx
   push cx
   push dx       
        push ax
            and al, 11110000b
                mov cl, 4
                shr al, cl 
                            
                call print_hex_skaitmuo
        pop ax
        
        push ax
            and al, 00001111b
            call print_hex_skaitmuo
        pop ax
   pop dx
   pop cx
   pop bx
   pop ax
ret

print_hex_skaitmuo:
    push ax
    push dx
        and al, 00001111b 
        cmp al, 9
        ja print_hex_raidyte
        jmp print_hex_skaiciukas
        
        print_hex_raidyte:
        push ax
        sub al, 0Ah
        add al, 'A'
		mov [di], al
		inc di
		inc bp
        pop ax
        jmp grizti_is_pr_hex_sk
        
        print_hex_skaiciukas:
        push ax
        add al, 30h
		mov [di], al
		inc di
		inc bp
        pop ax
        jmp grizti_is_pr_hex_sk
        
    grizti_is_pr_hex_sk:    
    pop dx
    pop ax
ret


print_reg_w1:											;funkcija, kuri apdoroja ir perkelia i tarpini buferi reikiama registra
push ax
push bx
push cx
push dx
	mov al, byte ptr[reg_bitai]
	mov cx, 3d
	mul cx
	cmp byte ptr[w_bitas], 00h
	je w_bitas_yra_0
	mov bx, offset r_w1
	add bx, ax
	jmp reg_spausdinam
		w_bitas_yra_0:
		mov bx, offset r_w0
		add bx, ax
reg_spausdinam:
call Perkelk_i_buferi
inc bp
pop dx
pop cx
pop bx
pop ax
ret


    uzdarytiRasymui:										;failu uzdarymas
	MOV	ah, 3Eh			
	MOV	bx, rFail		
	INT	21h		
	JC	KlaidaFailu	

	uzdarytiSkaitymui:
	mov ah, 3Eh		
	mov	bx, dFail		
	int	21h			
	jc	KlaidaFailu

	pabaiga:												;programos pabaiga
	mov ah, 4Ch		
	mov	al, 0			
	int 21h		

	KlaidaFailu:
	mov dx, offset FailuKlaida
	mov ah, 09h
	int 21h
	jmp	pabaiga


PROC SkaitykBuf			
	push ax
	push cx
	push dx
	mov	ah, 3Fh			
	mov	cx, skBufDydis		
	mov	dx, offset skBuf
	int	21h		
	mov byte ptr[kiek_masyve], al
	mov si, offset skBuf
	cmp ax, 00h
	je uzdarytiRasymui
	pop dx
	pop cx
	pop ax
	ret
SkaitykBuf ENDP

PROC Perkelk_i_buferi									
push ax
push bx
push cx
push dx
push si
mov si, bx
keliam_i_buferi:
mov bl, [si]
cmp bl, '$'
je baigiame_kelti
mov [di], bl
inc si
inc di
inc bp
jmp keliam_i_buferi
baigiame_kelti:
dec bp
pop si
pop dx
pop cx
pop bx
pop ax
ret
endp Perkelk_i_buferi

PROC RasauFaila										;funkcija, kuri po 10baitu is tarpinio buferio perkelia i rasymo buferi ir printina rasymo buferi
push ax
push bx
push cx
push dx
push si
mov cx, bp
mov ax, 0000h
mov si, offset TarpBuf
KeiciuToliau:
mov di, offset RasBuf
Keiciu:
mov dl, [si]
mov [di], dl
inc ax
inc si
inc di
cmp ax, 0Ah
je Rasau
loop Keiciu
dec ax
Rasau:
push cx
mov cx, ax
mov bx, rFail
mov ah, 40h
mov dx, offset RasBuf
int 21h
mov ax, 0000h
pop cx
cmp cx, 00h
jne KeiciuToliau
call print_enteris
pop si
pop dx
pop cx
pop bx
pop ax
mov bp, 00h
ret
endp RasauFaila

PROC add_kablelis
mov dl, ','
mov [di], dl
inc di
inc bp
ret
endp add_kablelis

PROC add_h
mov dl, 'h'
mov [di], dl
inc di
inc bp
ret
endp add_h

PROC add_dvitaskis
mov dl, ':'
mov [di], dl
inc di
inc bp
ret
endp add_dvitaskis

PROC add_atidarom
mov dl, '['
mov [di], dl
inc di
inc bp
ret
endp add_atidarom

PROC add_uzdarom
mov dl, ']'
mov [di], dl
inc di
inc bp
ret
endp add_uzdarom

PROC add_tarpas
add_tarpa:
mov dl, ' '
mov [di], dl
inc di
inc bp
loop add_tarpa
dec bp
ret
endp add_tarpas

PROC print_enteris
push dx
mov  ah, 40h
mov  bx, rFail
mov  cx, 2 
mov  dx, offset enteris
int  21h
pop dx
ret
ret
print_enteris endp

PROC surink_pirmas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
push ax
and al, 00000111b
mov byte ptr[reg_bitai], al
pop ax
and al, 00001000b
mov byte ptr[w_bitas], al
call surink_betop
pop ax
ret
endp surink_pirmas_formatas

PROC surink_antras_formatas
push ax
call gauk_baita
call print_baita_hexu
mov byte ptr[betarp_op], al
pop ax
ret
endp surink_antras_formatas

PROC surink_trecias_formatas
push ax
mov byte ptr[w_bitas], 00000001b
call surink_betop
pop ax
ret
endp surink_trecias_formatas 

PROC surink_ketvirtas_formatas
push ax
call surink_w
cmp byte ptr[Pirmas_baitas], 0A0h
jae gauk_adjb_advb
call surink_betop
jmp surink_ketvirtas_pabaiga
gauk_adjb_advb:
call gauk_baita
call print_baita_hexu
mov byte ptr[ajb], al
call gauk_baita
call print_baita_hexu
mov byte ptr[avb], al
surink_ketvirtas_pabaiga:
pop ax
ret
endp surink_ketvirtas_formatas

PROC surink_penktas_formatas
push ax
call gauk_baita
call print_baita_hexu
push ax
and al, 00000111b
mov byte ptr[rm_bitai], al
pop ax
call surink_mod
and al, 00111000b
mov byte ptr[reg_bitai], al
pop ax
ret
endp surink_penktas_formatas

PROC surink_septintas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00000111b
mov byte ptr[reg_bitai], al
pop ax
ret
endp surink_septintas_formatas

PROC surink_astuntas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00011000b
mov byte ptr[seg_reg_bitai], al
pop ax
ret
endp surink_astuntas_formatas

PROC surink_devintas_formatas
push ax
call gauk_baita
call print_baita_hexu
mov byte ptr[ajb], al
call gauk_baita
call print_baita_hexu
mov byte ptr[avb], al
call gauk_baita
call print_baita_hexu
mov byte ptr[segjb], al
call gauk_baita
call print_baita_hexu
mov byte ptr[segvb], al
pop ax
ret
endp surink_devintas_formatas

PROC surink_desimtas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00000010b
mov byte ptr[s_bitas], al
call surink_w
call gauk_baita
call print_baita_hexu
call surink_mod
push ax
and al, 00000111b
mov byte ptr[rm_bitai], al
pop ax
and al, 00111000b
mov byte ptr[reg_bitai], al
cmp byte ptr[w_bitas], 00h
je desimtas_betop1
cmp byte ptr[s_bitas], 00000010b
je praplesk 
call surink_betop
jmp desimtas_pabaiga
praplesk:
call gauk_baita
call print_baita_hexu
mov byte ptr[betarp_op], al
call praplesk_pagal_s
jmp desimtas_pabaiga
desimtas_betop1:
call surink_betop
desimtas_pabaiga:
pop ax
ret
endp surink_desimtas_formatas

PROC surink_vienuoliktas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00000010b
mov byte ptr[d_bitas], al
call surink_w
call gauk_baita
call print_baita_hexu
push ax
and al, 00111000b
shr al, 3d
mov byte ptr[reg_bitai], al
pop ax
call surink_mod
and al, 00000111b
mov byte ptr[rm_bitai], al
pop ax
ret
endp surink_vienuoliktas_formatas

PROC surink_dvyliktas_formatas
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00000010b
mov byte ptr[d_bitas], al
call gauk_baita
call print_baita_hexu
call surink_mod
push ax
and al, 00011000b
mov byte ptr[seg_reg_bitai], al
pop ax
and al, 00000111b
mov byte ptr[rm_bitai], al
pop ax
ret
endp surink_dvyliktas_formatas

PROC surink_tryliktas_formatas
push ax
call surink_w
call gauk_baita
call print_baita_hexu
call surink_mod
and al, 00000111b
mov byte ptr[rm_bitai], al
call surink_betop
pop ax
ret
endp surink_tryliktas_formatas

PROC print_pirmas_formatas
push ax
call platinam
call spausdink_varda
call print_reg_w1
call add_kablelis
call print_betop
pop ax
ret
endp print_pirmas_formatas

PROC print_antras_formatas
push ax
call platinam
call spausdink_varda
mov al, byte ptr[betarp_op]
call print_baita_hexu
call add_h
pop ax
ret
endp print_antras_formatas

PROC print_trecias_formatas
push ax
call platinam
call spausdink_varda
call print_betop
pop ax
ret
endp print_trecias_formatas

PROC print_ketvirtas_formatas
push ax
call platinam
call spausdink_varda
cmp byte ptr[Pirmas_baitas], 0A2h
je vienas_variantas
cmp byte ptr[Pirmas_baitas], 0A3h
je vienas_variantas
cmp byte ptr[Pirmas_baitas], 0A0h
jae kitas_variantas
jmp antras_variantas
	kitas_variantas:
	call print_akumuliatorius
	call add_kablelis
	call add_atidarom
	mov al, byte ptr[avb]
	call print_baita_hexu
	mov al, byte ptr[ajb]
	call print_baita_hexu
	call add_h
	call add_uzdarom
	jmp ketvirtas_pabaiga
		vienas_variantas:
		call add_atidarom
		mov al, byte ptr[avb]
		call print_baita_hexu
		mov al, byte ptr[ajb]
		call print_baita_hexu
		call add_h
		call add_uzdarom
		call add_kablelis
		call print_akumuliatorius
		jmp ketvirtas_pabaiga
			antras_variantas:
			call print_akumuliatorius
			call add_kablelis
			call print_betop
ketvirtas_pabaiga:
pop ax
ret
endp print_ketvirtas_formatas

PROC print_penktas_formatas
push ax
call platinam
call spausdink_varda
	cmp byte ptr[variantas], 01h
	je penktas_pirmas_variantas
	cmp byte ptr[mod_bitai], 11000000b
	je penktas_nereik_ptr
	call print_ptr
	call print_seg_reg
	call add_atidarom
	call print_rm_bitai
	call lyginam
	jmp print_penktas_formatas_end
			penktas_nereik_ptr:
			call print_seg_reg
			call add_atidarom
			call print_rm_bitai
			call lyginam
			jmp print_penktas_formatas_end
		penktas_pirmas_variantas:
		mov byte ptr[w_bitas], 00000001b
		call print_seg_reg
		call add_atidarom
		call print_rm_bitai
		call lyginam
print_penktas_formatas_end:
mov byte ptr[variantas], 00h
pop ax
ret
endp print_penktas_formatas

PROC print_sestas_formatas
push ax
call platinam
call spausdink_varda
pop ax
ret
endp print_sestas_formatas

PROC print_septintas_formatas
push ax
call platinam
call spausdink_varda
mov byte ptr[w_bitas], 00000001b
call print_reg_w1
call lyginam
pop ax
ret
endp print_septintas_formatas

PROC print_astuntas_formatas
push ax
call platinam
call spausdink_varda
call print_sr_bitai
call lyginam
pop ax
ret
endp print_astuntas_formatas

PROC print_devintas_formatas
push ax
call platinam
call spausdink_varda
mov al, byte ptr[segvb]
call print_baita_hexu
mov al, byte ptr[segjb]
call print_baita_hexu
call add_dvitaskis
mov al, byte ptr[avb]
call print_baita_hexu
mov al, byte ptr[ajb]
call print_baita_hexu
call add_h
pop ax
ret
endp print_devintas_formatas

PROC print_desimtas_formatas
push ax
call platinam
call spausdink_varda
call print_ptr
call print_seg_reg
call add_atidarom
call print_rm_bitai
call add_kablelis
call print_betop
pop ax
ret
endp print_desimtas_formatas

PROC print_vienuoliktas_formatas
push ax
call platinam
call spausdink_varda
cmp byte ptr[d_bitas], 00000010b
je d_vienuoliktas_1
call print_seg_reg
call add_atidarom
call print_rm_bitai
call add_kablelis
call print_reg_w1
call lyginam
jmp vienuoliktas_pabaiga
	d_vienuoliktas_1:
	call print_reg_w1
	call add_kablelis
	call print_seg_reg
	call add_atidarom
	call print_rm_bitai
vienuoliktas_pabaiga:
pop ax
ret
endp print_vienuoliktas_formatas

PROC print_dvyliktas_formatas
push ax
call platinam
call spausdink_varda
cmp byte ptr[d_bitas], 00h
je dvylikta_d_0
call print_sr_bitai
call add_kablelis
call print_seg_reg
call add_atidarom
call print_rm_bitai
jmp dvylikta_pabaiga
	dvylikta_d_0:
	call print_seg_reg
	call add_atidarom
	call print_rm_bitai
	call add_kablelis
	call print_sr_bitai
dvylikta_pabaiga:
pop ax
ret
endp print_dvyliktas_formatas

PROC print_tryliktas_formatas
push ax
call platinam
call spausdink_varda
call print_ptr
call print_seg_reg
call add_atidarom
call print_rm_bitai
call add_kablelis
call print_betop
call lyginam
dec bp
pop ax
ret
endp print_tryliktas_formatas

PROC print_nulinis_formatas
push ax
call platinam
mov bx, offset k_neatpazinta
call Perkelk_i_buferi
pop ax
ret
endp print_nulinis_formatas

PROC rask_pavadinima_antras
cmp byte ptr[Pirmas_baitas], 0EBh
je tai_jump
cmp byte ptr[Pirmas_baitas], 0E3h
je tai_jcxz
cmp byte ptr[Pirmas_baitas], 0E2h
je tai_loop
cmp byte ptr[Pirmas_baitas], 7Fh
jbe tai_vienas_is_jump
	tai_int:
	mov bx, offset k_int
	jmp rask_pavadinima_antras_pabaiga
		tai_loop:
		mov bx, offset k_loop
		jmp rask_pavadinima_antras_pabaiga
			tai_jump:
			mov bx, offset k_jmp
			jmp rask_pavadinima_antras_pabaiga
				tai_jcxz:
				mov bx, offset k_jcxz
				jmp rask_pavadinima_antras_pabaiga
					tai_vienas_is_jump:
					mov al, byte ptr[Pirmas_baitas]
					and al, 00001111b
					mov bx, offset k_pav_antras
					mov cx, 8d
					mul cx
					add bx, ax
rask_pavadinima_antras_pabaiga:
ret
endp rask_pavadinima_antras

PROC rask_pavadinima_trecias
mov al, byte ptr[Pirmas_baitas]
and al, 00001111b
mov cx, 8d
mul cx
mov bx, offset k_pav_trecias
add bx, ax
ret
endp rask_pavadinima_trecias

PROC rask_pavadinima_ketvirtas
mov al, byte ptr[Pirmas_baitas]
and al, 00111100b
shr al, 2d
mov cx, 8d
mul cx
mov bx, offset k_pav_ketvirtas
add bx, ax
ret
endp rask_pavadinima_ketvirtas

PROC rask_pavadinima_penktas
cmp byte ptr[Pirmas_baitas], 8Fh
je penktas_pop
cmp byte ptr[Pirmas_baitas], 0F6h
je div_arba_mul
cmp byte ptr[Pirmas_baitas], 0F7h
je div_arba_mul
cmp byte ptr[Pirmas_baitas], 0FEh
je dec_arba_inc
cmp byte ptr[reg_bitai], 00000000b
je dec_arba_inc
cmp byte ptr[reg_bitai], 00001000b
je dec_arba_inc
mov byte ptr[variantas], 01h
mov al, byte ptr[reg_bitai]
shr al, 3d
mov cx, 8d
mul cx
mov bx, offset k_pav_penktas
add bx, ax
jmp penktas_spausdink
penktas_pop:
mov byte ptr[variantas], 01h
mov bx, offset k_pop
jmp penktas_spausdink
div_arba_mul:
cmp byte ptr[reg_bitai], 00100000b
je penktas_mul
mov bx, offset k_div
jmp gauk_w
dec_arba_inc:
cmp byte ptr[reg_bitai], 00000000b
je penktas_inc
mov bx, offset k_dec
jmp gauk_w
penktas_mul:
mov bx, offset k_mul
jmp gauk_w
penktas_inc:
mov bx, offset k_inc
gauk_w:
call surink_w
penktas_spausdink:
ret
endp rask_pavadinima_penktas

PROC rask_pavadinima_sestas
mov al, byte ptr[Pirmas_baitas]
cmp byte ptr[Pirmas_baitas], 0C3h
je tai_ret_sestas
cmp byte ptr[Pirmas_baitas], 27h
je tai_daa
cmp byte ptr[Pirmas_baitas], 2Fh
je tai_das
mov bx, offset k_retf
jmp rask_pavadinima_sestas_pabaiga
tai_ret_sestas:
mov bx,offset k_ret
jmp rask_pavadinima_sestas_pabaiga
tai_daa:
mov bx, offset k_daa
jmp rask_pavadinima_sestas_pabaiga
tai_das:
mov bx, offset k_das
rask_pavadinima_sestas_pabaiga:
ret
endp rask_pavadinima_sestas

PROC rask_pavadinima_septintas
mov al, byte ptr[Pirmas_baitas]
and al, 00011000b
shr al, 3d
mov cx, 8d
mul cx
mov bx, offset k_pav_septintas
add bx, ax
ret
endp rask_pavadinima_septintas

PROC rask_pavadinima_astuntas
mov al, byte ptr[Pirmas_baitas]
and al, 00000001b
cmp al, 00000001b
je tai_pop
mov bx, offset k_push
ret
tai_pop:
mov bx, offset k_pop
ret
endp rask_pavadinima_astuntas

PROC rask_pavadinima_desimtas
mov al, byte ptr[reg_bitai]
shr al, 3d
mov cx, 8d
mul cx
mov bx, offset k_pav_desimtas
add bx, ax
ret
endp rask_pavadinima_desimtas

PROC rask_pavadinima_vienuoliktas
mov al, byte ptr[Pirmas_baitas]
and al, 11111100b
cmp al, 10001000b
je vienuolikta_mov
shr al, 3d
mov cx, 8d
mul cx
mov bx, offset k_pav_vienuoliktas
add bx, ax
jmp pavadinimas_vienuoliktas_pab
vienuolikta_mov:
mov bx, offset k_mov
pavadinimas_vienuoliktas_pab:
ret
endp rask_pavadinima_vienuoliktas

PROC ar_prefiksas
cmp al, 26h
je yra_seg_reg
cmp al, 2Eh
je yra_seg_reg
cmp al, 36h
je yra_seg_reg
cmp al, 3Eh
je yra_seg_reg
ret
yra_seg_reg:
mov byte ptr[segreg], al
call gauk_baita
call print_baita_hexu
ret
endp ar_prefiksas

PROC print_akumuliatorius
cmp byte ptr[w_bitas], 00000001b
je printinam_ax
mov bx, offset r_AL
call Perkelk_i_buferi
inc bp
ret
printinam_ax:
mov bx, offset r_AX
call Perkelk_i_buferi
inc bp
ret
endp print_akumuliatorius

PROC print_seg_reg
push ax
mov al, byte ptr[segreg]
cmp al, 00h
je nera
and al, 00011000b
shr al, 3d
mov bx, offset r_segreg
mov cx, 3d
mul cx
add bx, ax
call Perkelk_i_buferi
inc bp
call add_dvitaskis
mov byte ptr[segreg], 00h
nera:
pop ax
ret
endp print_seg_reg

PROC print_sr_bitai
mov al, byte ptr[seg_reg_bitai]
shr al, 3d
mov bx, offset r_segreg
mov cx, 3d
mul cx
add bx, ax
call Perkelk_i_buferi
inc bp
mov byte ptr[seg_reg_bitai], 00h
ret
endp print_sr_bitai

PROC surink_mod
push ax
and al, 11000000b
mov byte ptr[mod_bitai], al
cmp al, 11000000b
je mod_pabaiga
cmp al, 10000000b
je dviejub_posl
cmp al, 01000000b
je vienob_posl
cmp al, 00000000b
je gal_tiesioginis_adresas
jmp mod_pabaiga
dviejub_posl:
call gauk_baita
call print_baita_hexu
mov byte ptr[posl_jaun], al
call gauk_baita
call print_baita_hexu
mov byte ptr[posl_vyr], al
jmp mod_pabaiga
vienob_posl:
call gauk_baita
call print_baita_hexu
mov byte ptr[posl_jaun], al
jmp mod_pabaiga
gal_tiesioginis_adresas:
cmp byte ptr[rm_bitai], 00000110b
je tiesiog_adresas
jmp mod_pabaiga
tiesiog_adresas:
call gauk_baita
call print_baita_hexu
mov byte ptr[ajb], al
call gauk_baita
call print_baita_hexu
mov byte ptr[avb], al
mod_pabaiga:
pop ax
ret
endp surink_mod

PROC print_rm_bitai
push ax
push cx
mov al, byte ptr[rm_bitai]
cmp byte ptr[mod_bitai], 11000000b
je rm_yra_reg
cmp byte ptr[mod_bitai], 00000000b
je mod_yra_nulis
mov cx, 08d
mul cx
mov bx, offset rm_reiksmes_mod_nenulis
add bx, ax
call Perkelk_i_buferi
cmp byte ptr[mod_bitai], 01000000b
je posl_yra_vienas
mov al, posl_vyr
call print_baita_hexu
mov al, posl_jaun
call print_baita_hexu
call add_h
jmp rm_bitai_pabaiga
	posl_yra_vienas:
	mov al, posl_jaun
	call print_baita_hexu
	call add_h
	jmp rm_bitai_pabaiga
		mod_yra_nulis:
		cmp al, 00000110b
		je tiesioginis_adresas
		mov cx, 07d
		mul cx
		mov bx, offset rm_reiksmes_mod_nulis
		add bx, ax
		call Perkelk_i_buferi
		inc bp
		jmp rm_bitai_pabaiga
			tiesioginis_adresas:
			mov al, byte ptr[avb]
			call print_baita_hexu
			mov al, byte ptr[ajb]
			call print_baita_hexu
			call add_h
			jmp rm_bitai_pabaiga
				rm_yra_reg:
				mov al, byte ptr[rm_bitai]
				mov cl, byte ptr[reg_bitai]
				mov byte ptr[reg_bitai], al
				call print_reg_w1
				mov byte ptr[reg_bitai], cl
				mov al, ' '
				mov [di-3], al
				jmp rm_bitai_tikrai_pabaiga
rm_bitai_pabaiga:
call add_uzdarom
rm_bitai_tikrai_pabaiga:
pop cx
pop ax
ret
endp print_rm_bitai

PROC print_ptr
push ax
cmp byte ptr[w_bitas], 00h
je print_byte_ptr
mov bx, offset ptr_word
call Perkelk_i_buferi
jmp print_ptr_pabaiga
print_byte_ptr:
mov bx, offset ptr_byte
call Perkelk_i_buferi
print_ptr_pabaiga:
pop ax
ret
endp print_ptr

PROC lyginam
mov cx, 1d
call add_tarpas
inc bp
ret
endp lyginam

PROC platinam
mov cx, 29d
sub cx, bp
call add_tarpas
ret
endp platinam

PROC praplesk_pagal_s
push ax
cmp byte ptr[w_bitas], 00000000b
je praplesk_pabaiga
cmp byte ptr[s_bitas], 00000000b
je praplesk_pabaiga
mov al, byte ptr[betarp_op]
and al, 10000000b
cmp al, 00000000b
je pleciam_teigiama
mov byte ptr[betarp_op2], 0FFh
jmp praplesk_pabaiga
pleciam_teigiama:
mov byte ptr[betarp_op2], 00h
praplesk_pabaiga:
pop ax
ret
endp praplesk_pagal_s

PROC surink_w
push ax
mov al, byte ptr[Pirmas_baitas]
and al, 00000001b
mov byte ptr[w_bitas], al
pop ax
ret
endp surink_w

PROC surink_betop
push ax
cmp byte ptr[w_bitas], 00000000b
je vienas_betarpiskas
call gauk_baita
call print_baita_hexu
mov byte ptr[betarp_op], al
call gauk_baita
call print_baita_hexu
mov byte ptr[betarp_op2], al
jmp surink_betop_pabaiga
vienas_betarpiskas:
call gauk_baita
call print_baita_hexu
mov byte ptr[betarp_op], al
surink_betop_pabaiga:
pop ax
ret
endp surink_betop

PROC print_betop
push ax
cmp byte ptr[w_bitas], 00000000b
je print_vienas_betarpiskas
mov al, byte ptr[betarp_op2]
call print_baita_hexu
mov al, byte ptr[betarp_op]
call print_baita_hexu
call add_h
jmp print_betop_pabaiga
print_vienas_betarpiskas:
mov al, byte ptr[betarp_op]
call print_baita_hexu
call add_h
print_betop_pabaiga:
pop ax
ret
endp print_betop

END
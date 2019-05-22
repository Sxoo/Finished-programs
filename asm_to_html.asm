.model small

SkaitBufDydis equ 10
RasBufDydis equ 10
TarpBufDydis equ 70

.stack 200h

.data
filename db 16 dup (00h)
readname db 16 dup (00h)
handleris dw ?
readleris dw ?
SkaitBuf db SkaitBufDydis dup (?)
RasBuf db RasBufDydis dup (?)
TarpBuf db TarpBufDydis dup (00h)
virsus db "<!DOCTYPE html>", 0Dh, 0Ah, "<html>", 0Dh, 0Ah, "<body>", 0Dh, 0Ah, "<style>", 0Dh, 0Ah, "p{color: #9E9E9E}", 0Dh, 0Ah, "a{color: #DD2C00}", 0Dh, 0Ah, "</style>", 00h
apacia db "</body>", 0Dh, 0Ah, "</html>", 00h
enteris db 0Dh, 0Ah, 24h
paragrafas db " <p> ", 00h
paragrafasuzdarom db " </p> ", 00h
spalva db "<a>", 00h
nespalva db "</a>", 00h
keywords db "mov lea ret int pop end add sub mul div shr xor and not shl ror rol jne jbe jae jge jle cmp inc dec neg ", 00h
keywords5 db "endp push loop jump test call ", 00h
keywords3 db "or je jb ja jg jl ", 00h
skaitliukas db 26d
skaitliukas1 db 6d
skaitliukas2 db 6d
parametras db 20 dup (00h)
sukames db ?
help db "Martynas Padarauskas 2 grupe, 2 pogrupis, programa, kuri nuskaito", 0Dh, 0Ah, "asm faila ir isveda ji i html faila.",0Dh, 0Ah,"Iveskite duomenu failo pavadinima (.asm) ir rezultatu failo pavadinima (.html)", 24h
FailuKlaida db "Klaida atidarant arba uzdarant rezultatu/duomenu failus", 24h

.code  
mov ax, @data
mov ds, ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;INICIJUOJU BP;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov bp, 00h
mov cx, 00h
mov ax, 00h
mov bx, 00h
mov dx, 00h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;PARAMETRAI;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Start:
mov ch, 00h
mov cl, es:[0080h]
cmp cx, 00h
je Parametrai 
mov bx, 0082h

Cikliukas: 
mov al, es:[bx] 
mov [readname+si], al
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
cmp readname[si], 'm'
jne Parametrai
dec si
cmp readname[si], 's'
jne Parametrai
dec si
cmp readname[si], 'a'
jne Parametrai
dec si
cmp readname[si], '.'
jne Parametrai  

add si, 4d
mov readname[si], 00h
sub cx, si
sub cx, 3d
xor si, si

KitasCikliukas:
mov al, es:[bx]
inc bx
cmp al, ' '
je Parametrai
mov [filename+si], al
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
jmp TheEnd

RezFailas:
mov di, offset filename
add di, si
dec di
cmp filename[di], 'l'
jne Parametrai
dec di
cmp filename[di], 'm'
jne Parametrai
dec di
cmp filename[di], 't'
jne Parametrai
dec di
cmp filename[di], 'h'
jne Parametrai
dec di
cmp filename[di], '.'
jne Parametrai
add di, 5d
mov filename[di], 00h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FORMATUOJAM REZULTATU FAILA HTML PAVIDALU;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Startas: 
mov  ah, 3ch
mov  cx, 0
mov  dx, offset filename
int  21h  

mov  handleris, ax
mov  ah, 40h
mov  bx, handleris
mov  cx, 88 
mov  dx, offset virsus
int  21h
call printEnteris

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;GALIME PRADETI SKAITYMA;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PradetiSkaityma:
mov	ah, 3Dh
mov	al, 00
mov	dx, offset readname
int	21h
mov	readleris, ax
call printParagrafas
Skaitymas:
mov bx, readleris
call SkaitauFaila
cmp bp, 00h
jne TesiamEilute

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;DARBAS SU NUSKAITYTAIS DUOMENIM;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov cx, ax
push ax
mov bp, 00h
mov ax, 00h
mov si, offset SkaitBuf
mov di, offset TarpBuf
jmp Tesiam

TesiamEilute:
mov cx, ax
push ax
mov ax, 0000h
mov si, offset SkaitBuf

Tesiam:
mov dl, [si]
cmp dl, 0Ah
je NewLine
Keiciam:
mov [di], dl
inc si
inc di
inc ax
loop Tesiam
add bp, ax
mov cx, ax
pop ax
cmp ax, SkaitBufDydis
je Skaitymas
mov cx, 00h
mov cx, bp
call IeskauKeywords
call IeskauKeywords2
call IeskauKeywords5
call Konstanta
call RasauFaila
jmp UzdarytiRasyma

NewLine:
mov [di], dl
push cx
push si
mov cx, ax
add cx, bp
call IeskauKeywords
mov dl, skaitliukas
mov dl, 26d
mov skaitliukas, dl
call IeskauKeywords5
mov dl, skaitliukas1
mov dl, 6d
mov skaitliukas1, dl
call IeskauKeywords2
mov dl, skaitliukas2
mov dl, 6d
mov skaitliukas2, dl
call Konstanta
call RasauFaila
mov di, offset TarpBuf
pop si
pop cx
mov bp, 0000h 
mov ax, 0000h
cmp cx, 00h
jne Keiciam
pop ax
cmp ax, SkaitBufDydis
jne UzdarytiRasyma
jmp Skaitymas

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;SUKURIAM HTML FAILO PABAIGA;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UzdarytiRasyma:
call printUzdaromParagrafa
mov  ah, 40h
mov  bx, handleris
mov  cx, 16 
mov  dx, offset apacia
int  21h

call printEnteris

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;UZDAROM FAILA;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov  ah, 3eh
mov  bx, handleris
int  21h

mov  ah, 3eh
mov  bx, readleris
int  21h
jmp TheEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;RETURN 0;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TheEnd:
mov  ax,4c00h
int  21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;NAUDOJAMOS PROCEDUROS;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC Stumiam
Stumdom:
push si
push cx
call StumiamViena
pop cx
pop si
loop Stumdom
ret
endp Stumiam

PROC StumiamViena
mov cl, sukames
mov al, [si]
Testi:
inc si
mov ah, [si]
mov [si], al
xchg al, ah
loop Testi
ret
endp StumiamViena

PROC IeskauKeywords
mov di, offset keywords
push cx
KitasRasBuf:
mov si, offset TarpBuf
Kilpa:
mov dl, [si]
mov bl, [di]
cmp dl, bl
je Lygus
inc si
loop Kilpa
pop cx
push cx
add di, 4d
mov dl, skaitliukas
dec dl
cmp dl, 00h
je Nera
mov skaitliukas, dl
jmp KitasRasBuf

Lygus:
inc si
inc di
mov dl, [si]
mov bl, [di]
dec di
cmp dl, bl
jne Kilpa
inc si
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec di
dec di
cmp dl, bl
jne Kilpa
inc si
inc si
inc di
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec si
dec di
dec di
dec di
cmp dl, bl
je Yra

Nera:
pop cx
ret

Yra:
dec si
pop cx
add cx, 3d
mov sukames, cl
push cx
mov cx, 3d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
add cx, 3d
mov sukames, cl
push cx
add si, 3d
mov cx, 4d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, '/'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
ret
endp IeskauKeywords

PROC IeskauKeywords5
mov di, offset keywords5
push cx
KitasRasBuf1:
mov si, offset TarpBuf
Kilpa1:
mov dl, [si]
mov bl, [di]
cmp dl, bl
je Lygus1
inc si
loop Kilpa1
pop cx
push cx
add di, 5d
mov dl, skaitliukas1
dec dl
cmp dl, 00h
je Nera1
mov skaitliukas1, dl
jmp KitasRasBuf1

Lygus1:
inc si
inc di
mov dl, [si]
mov bl, [di]
dec di
cmp dl, bl
jne Kilpa1
inc si
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec di
dec di
cmp dl, bl
jne Kilpa1
inc si
inc si
inc di
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec si
dec di
dec di
dec di
cmp dl, bl
jne Kilpa1
inc si
inc si
inc si
inc di
inc di
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec si
dec si
dec di
dec di
dec di
dec di
cmp dl, bl
je Yra1

Nera1:
pop cx
ret

Yra1:
dec si
pop cx
add cx, 3d
mov sukames, cl
push cx
mov cx, 3d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
add cx, 3d
mov sukames, cl
push cx
add si, 4d
mov cx, 4d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, '/'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
ret
endp IeskauKeywords5

PROC IeskauKeywords2
mov di, offset keywords3
push cx
KitasRasBuf2:
mov si, offset TarpBuf
Kilpa2:
mov dl, [si]
mov bl, [di]
cmp dl, bl
je Lygus2
inc si
loop Kilpa2
pop cx
push cx
add di, 3d
mov dl, skaitliukas2
dec dl
cmp dl, 00h
je Nera2
mov skaitliukas2, dl
jmp KitasRasBuf2

Lygus2:
inc si
inc di
mov dl, [si]
mov bl, [di]
dec di
cmp dl, bl
jne Kilpa2
inc si
inc di
inc di
mov dl, [si]
mov bl, [di]
dec si
dec di
dec di
cmp dl, bl
je Yra2

Nera2:
pop cx
ret

Yra2:
dec si
pop cx
add cx, 3d
mov sukames, cl
push cx
mov cx, 3d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
add cx, 3d
mov sukames, cl
push cx
add si, 2d
mov cx, 4d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, '/'
mov [si], dl
inc si
mov dl, 'b'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
ret
endp IeskauKeywords2


PROC SkaitauFaila
push dx
push cx
mov ah, 3Fh
mov cx, SkaitBufDydis
mov dx, offset SkaitBuf
int 21h
pop cx
pop dx
ret
endp SkaitauFaila

PROC RasauFaila
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
mov bx, handleris
mov ah, 40h
mov dx, offset RasBuf
int 21h
mov ax, 0000h
pop cx
cmp cx, 00h
jne KeiciuToliau
call printUzdaromParagrafa
call printEnteris
call printParagrafas
mov dl, ' '
ret
endp RasauFaila

PROC printEnteris
push dx
mov  ah, 40h
mov  bx, handleris
mov  cx, 2 
mov  dx, offset enteris
int  21h
pop dx
ret
endp printEnteris

PROC printParagrafas
push dx
mov  ah, 40h
mov  bx, handleris
mov  cx, 5
mov  dx, offset paragrafas
int  21h
pop dx
ret
endp printParagrafas

PROC printUzdaromParagrafa
push dx
mov  ah, 40h
mov  bx, handleris
mov  cx, 6
mov  dx, offset paragrafasuzdarom
int  21h
pop dx
ret
endp printUzdaromParagrafa

PROC Konstanta
mov si, offset TarpBuf
push cx
mov ax, 00h
Kitas:
inc ax
mov dl, [si]
cmp dl, '0'
jl KitasSk
cmp dl, '9'
jg Didesnis
jmp Sk
Didesnis:
cmp dl, 'A'
jl KitasSk
cmp dl, 'F'
jg KitasSk
jmp Sk
KitasSk:
mov ax, 00h
inc si
loop Kitas
jmp NeraPabaiga

Sk:
inc ax
inc si
mov dl, [si]
cmp dl, 'h'
je Stotele
cmp dl, 'd'
je Stotele
cmp dl, 'o'
je Stotele
cmp dl, ' '
je Stotele
cmp dl, '0'
jl KitasSk
cmp dl, '9'
jg Didesnis1
jmp Sk1
Didesnis1:
cmp dl, 'A'
jl KitasSk
cmp dl, 'F'
jg KitasSk
jmp Sk1
Stotele:
jmp YraPabaiga
Sk1:
inc ax
inc si
mov dl, [si]
cmp dl, 'h'
je YraPabaiga
cmp dl, 'd'
je YraPabaiga
cmp dl, 'o'
je YraPabaiga
cmp dl, ' '
je YraPabaiga
cmp dl, '0'
jl KitasSk
cmp dl, '9'
jg Didesnis2
jmp Sk2
Didesnis2:
cmp dl, 'A'
jl KitasSk
cmp dl, 'F'
jg KitasSk
Sk2:
inc ax
inc si
mov dl, [si]
cmp dl, 'h'
je YraPabaiga
cmp dl, 'd'
je YraPabaiga
cmp dl, 'o'
je YraPabaiga
cmp dl, ' '
je YraPabaiga
cmp dl, '0'
jl Stotele2
cmp dl, '9'
jg Didesnis3
jmp Paskutinis
Didesnis3:
cmp dl, 'A'
jl Stotele2
cmp dl, 'F'
jg Stotele2
Paskutinis:
inc ax
inc si
mov dl, [si]
cmp dl, 'h'
je YraPabaiga
cmp dl, 'd'
je YraPabaiga
cmp dl, 'o'
je YraPabaiga
cmp dl, ' '
je YraPabaiga
jmp YraPabaiga
Stotele2:
jmp KitasSk

YraPabaiga:
dec ax
sub si, ax
pop cx
push ax
add cx, 3d
mov sukames, cl
push cx
mov cx, 3d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, 'a'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
add cx, 3d
mov sukames, cl
pop ax
inc ax
add si, ax
push cx
mov cx, 4d
call Stumiam
mov dl, '<'
mov [si], dl
inc si
mov dl, '/'
mov [si], dl
inc si
mov dl, 'a'
mov [si], dl
inc si
mov dl, '>'
mov [si], dl
inc si
pop cx
ret
NeraPabaiga:
pop cx
ret
endp Konstanta
  
END
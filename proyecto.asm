;=================================================
; Sustituir todas las vocales por una vocal dada
; NASM 64 bits - Linux
;=================================================

section .data

    msgCadena db "Ingrese una cadena (max 50 caracteres): "
    lenMsgCadena equ $-msgCadena

    msgVocal db "Ingrese la vocal de reemplazo: "
    lenMsgVocal equ $-msgVocal

    msgResultado db 10,"Cadena resultante: "
    lenMsgResultado equ $-msgResultado

    msgErrorVocal db 10,"ERROR: Debe ingresar una vocal (a,e,i,o,u)",10
    lenMsgErrorVocal equ $-msgErrorVocal

    msgErrorLong db 10,"ERROR: Maximo 50 caracteres permitidos",10
    lenMsgErrorLong equ $-msgErrorLong

    msgErrorCadenaVacia db 10,"ERROR: La cadena no puede estar vacia",10
    lenMsgErrorCadenaVacia equ $-msgErrorCadenaVacia

    msgErrorVocalVacia db 10,"ERROR: No ingreso ninguna vocal",10
    lenMsgErrorVocalVacia equ $-msgErrorVocalVacia

    msgErrorUnaVocal db 10,"ERROR: Debe ingresar una sola vocal",10
    lenMsgErrorUnaVocal equ $-msgErrorUnaVocal

    salto db 10

section .bss

    cadena resb 52
    vocal  resb 8

section .text
global _start

;=========================================
; MACRO IMPRIMIR
;=========================================
%macro imprimir 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

_start:

;-----------------------------------------
; Solicitar cadena
;-----------------------------------------
    imprimir msgCadena, lenMsgCadena

    mov rax,0
    mov rdi,0
    mov rsi,cadena
    mov rdx,52
    syscall

    mov rbx,rax

;-----------------------------------------
; Validar cadena vacia
;-----------------------------------------
    cmp rbx,1
    je error_cadena_vacia

;-----------------------------------------
; Validar longitud
;-----------------------------------------
    cmp rbx,51
    ja error_longitud

;-----------------------------------------
; Eliminar salto de linea
;-----------------------------------------
    mov rsi,cadena

buscar_fin:
    mov al,[rsi]

    cmp al,10
    je poner_cero

    cmp al,0
    je pedir_vocal

    inc rsi
    jmp buscar_fin

poner_cero:
    mov byte [rsi],0

;-----------------------------------------
; Solicitar vocal
;-----------------------------------------
pedir_vocal:

    imprimir msgVocal, lenMsgVocal

    mov rax,0
    mov rdi,0
    mov rsi,vocal
    mov rdx,8
    syscall

;-----------------------------------------
; Validar vocal vacia
;-----------------------------------------
    cmp byte [vocal],10
    je error_vocal_vacia

    cmp byte [vocal+1],10
    jne error_una_vocal

    mov al,[vocal]

;-----------------------------------------
; Convertir mayuscula a minuscula
;-----------------------------------------
    cmp al,'A'
    jb validar_vocal

    cmp al,'Z'
    ja validar_vocal

    add al,32
    mov [vocal],al

;-----------------------------------------
; Validar que sea una vocal
;-----------------------------------------
validar_vocal:

    cmp al,'a'
    je continuar

    cmp al,'e'
    je continuar

    cmp al,'i'
    je continuar

    cmp al,'o'
    je continuar

    cmp al,'u'
    je continuar
;  ----------------------------
; Cambio para que siga iteranco
;----------------------------------
    imprimir msgErrorVocal, lenMsgErrorVocal
    jmp pedir_vocal

continuar:

;-----------------------------------------
; Llamar subrutina
;-----------------------------------------
    call reemplazar_vocales

    imprimir msgResultado, lenMsgResultado

;-----------------------------------------
; Calcular longitud de cadena resultante
;-----------------------------------------
    mov rsi,cadena
    xor rdx,rdx

contar:
    cmp byte [rsi],0
    je mostrar

    inc rdx
    inc rsi
    jmp contar

;-----------------------------------------
; Mostrar resultado
;-----------------------------------------
mostrar:
    mov rax,1
    mov rdi,1
    mov rsi,cadena
    syscall

    imprimir salto, 1
    jmp salir

;-----------------------------------------
; Errores
;-----------------------------------------
error_longitud:
    imprimir msgErrorLong, lenMsgErrorLong
    jmp salir

error_cadena_vacia:
    imprimir msgErrorCadenaVacia, lenMsgErrorCadenaVacia
    jmp salir

error_vocal_vacia:
    imprimir msgErrorVocalVacia, lenMsgErrorVocalVacia
    jmp pedir_vocal

error_una_vocal:
    imprimir msgErrorUnaVocal, lenMsgErrorUnaVocal
    jmp pedir_vocal

;-----------------------------------------
; Salir
;-----------------------------------------
salir:
    mov rax,60
    xor rdi,rdi
    syscall

;=========================================
; SUBRUTINA
; Reemplaza todas las vocales
;=========================================
reemplazar_vocales:

    mov rsi,cadena

recorrer:
    mov al,[rsi]

    cmp al,0
    je fin_reemplazo

; convertir temporalmente mayusculas
    cmp al,'A'
    jb verificar

    cmp al,'Z'
    ja verificar

    add al,32

verificar:
    cmp al,'a'
    je sustituir

    cmp al,'e'
    je sustituir

    cmp al,'i'
    je sustituir

    cmp al,'o'
    je sustituir

    cmp al,'u'
    je sustituir

    inc rsi
    jmp recorrer

sustituir:
    mov bl,[vocal]
    mov [rsi],bl

    inc rsi
    jmp recorrer

fin_reemplazo:
    ret
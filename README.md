# Proyecto 8 - Sustitución de vocales (Ensamblador NASM)

## Descripción
Programa en ensamblador que permite ingresar una cadena y sustituir todas las vocales por una vocal dada por el usuario.

## Integrantes
- Enrique García
- Nayelli
- (p)

## Funcionalidades
- Ingreso de cadena por teclado
- Validación de máximo 50 caracteres
- Validación de vocal
- Reintento si la vocal es inválida
- Reemplazo de vocales
- Uso de macros y subrutinas

## Cómo compilar y ejecutar

```bash
nasm -f elf64 proyecto.asm -o proyecto.o
ld proyecto.o -o proyecto
./proyecto

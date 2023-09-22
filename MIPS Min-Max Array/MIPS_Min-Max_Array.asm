############################################################################
# ___________ Tarea 1 - Estructuras de Computadoras Digitales ____________ #
############################################################################
# ::::::::: Jos� Alejandro Castillo Sequeira - B81787 :::::::::::::::::::: #
############################################################################


#:::::::::::::#
# Descripci�n #
#:::::::::::::#
# Este programa en lenguaje ensamblador MIPS realiza operaciones en un arreglo de n�meros. 
# Comienza definiendo un conjunto de datos que incluye un arreglo de 20 n�meros enteros y 
# cadenas de caracteres para mensajes de salida. Luego, presenta un men� al usuario, permiti�ndole 
# elegir entre opciones como encontrar e imprimir el n�mero mayor, el n�mero menor o todos los valores 
# del arreglo separados por comas. El c�digo incluye funciones para realizar estas operaciones y utiliza 
# bucles para repetir el proceso hasta que el usuario decida salir del programa. 




.data
array:        .word       8, 12, 5, 20, 3, 17, 9, 14, 2, 18, 7, 11, 6, 15, 10, 4, 1, 19, 13, 16
msg_max1:   .asciiz     "El numero mayor del arreglo es: "
msg_min:    .asciiz     "El numero menor del arreglo es: "
arr:	    .asciiz     "Arreglo: "
comma:      .asciiz     ", "   # Cadena que representa una coma y un espacio
newline:    .asciiz     "\n"    # Cadena que representa un salto de l�nea
menu:       .asciiz     "Men� de Usuario:\n1. Imprimir el n�mero mayor\n2. Imprimir el n�mero menor\n3. Imprimir los valores del arreglo\n0. Salir\nIngrese su opci�n: "

.text
.globl  main

main:
    la      $s0,array             # $s0 = Direcci�n base del arreglo array
    addi    $s1,$s0,80         # $s1 = Direcci�n de fin del arreglo array (80 bytes despu�s)

    lw      $s2,0($s0)          # $s2 = max1 = array[0]
    lw      $s4,0($s0)          # $s4 = min = array[0]

menu_loop:
    # Mostrar el men� de usuario
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,menu
    syscall

    # Leer la opci�n del usuario
    li      $v0,5
    syscall
    addi    $t1, $v0, 0

    # Realizar la acci�n correspondiente seg�n la opci�n del usuario
    beq     $t1,1,print_max1     # Si el usuario ingresa 1, imprimir el n�mero mayor
    beq     $t1,2,print_min      # Si el usuario ingresa 2, imprimir el n�mero menor
    beq     $t1,3,print_array    # Si el usuario ingresa 3, imprimir los valores del arreglo
    beq     $t1,0,exit_program  # Si el usuario ingresa 0, salir del programa
    j       menu_loop             # Otra opci�n, mostrar el men� nuevamente

print_max1:
    # Encontrar el n�mero mayor
    la      $s0,array             # $s0 = Direcci�n base del arreglo array
    lw      $s4,0($s0)          # Reiniciar max1
    j       find_max1

find_max1:
    lw      $t0,0($s0)          # $t0 = Valor actual del arreglo
    addi    $s0,$s0,4           # Avanzar al siguiente elemento del arreglo

    slt $t5, $s2, $t0           # Comparar max1 con el valor actual
    beq $t5, $zero, continue_max1
    
    addi    $s2, $t0, 0         # Actualizar max1
    j       continue_max1

continue_max1:
    bne     $s0,$s1,find_max1   # Si no hemos llegado al final del arreglo, continuar buscando

    # Imprimir el n�mero mayor
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,msg_max1       # Cargar la direcci�n de la cadena "El numero mayor del arreglo es: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$s2, 0         # Cargar el valor del n�mero mayor en $a0
    syscall                     # Llamar a la syscall para imprimir el n�mero

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,newline         # Cargar la direcci�n de la cadena "\n" (salto de l�nea)
    syscall                     # Llamar a la syscall para imprimir un salto de l�nea
    j       menu_loop            # Volver al men� principal

print_min:
    # Encontrar el n�mero menor
    la      $s0,array             # $s0 = Direcci�n base del arreglo array
    lw      $s2,0($s0)          # Reiniciar min
    j       find_min

find_min:
    lw      $t0,0($s0)          # $t0 = Valor actual del arreglo
    addi    $s0,$s0,4           # Avanzar al siguiente elemento del arreglo

    slt $t6, $t0, $s4           # Comparar min con el valor actual
    beq $t6, $zero, continue_min

    addi    $s4, $t0, 0         # Actualizar min
    j       continue_min

continue_min:
    bne     $s0,$s1,find_min    # Si no hemos llegado al final del arreglo, continuar buscando

    # Imprimir el n�mero menor
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,msg_min         # Cargar la direcci�n de la cadena "El numero menor del arreglo es: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$s4, 0         # Cargar el valor del n�mero menor en $a0
    syscall                     # Llamar a la syscall para imprimir el n�mero

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,newline         # Cargar la direcci�n de la cadena "\n" (salto de l�nea)
    syscall                     # Llamar a la syscall para imprimir un salto de l�nea
    j       menu_loop            # Volver al men� principal

print_array:
    # Imprimir los valores del arreglo separados por comas
    lui $v0, 0x0000
    ori $v0, $v0, 4

    la      $a0,arr             # Cargar la direcci�n de la cadena "Arreglo: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    la      $s0,array             # $s0 = Direcci�n base del arreglo array

print_array_loop:
    lw      $t0,0($s0)          # $t0 = Valor actual del arreglo
    addi    $s0,$s0,4           # Avanzar al siguiente elemento del arreglo

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$t0, 0         # Cargar el valor del elemento actual en $a0
    syscall                     # Llamar a la syscall para imprimir el elemento

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,comma           # Cargar la direcci�n de la cadena ", "
    syscall                     # Llamar a la syscall para imprimir una coma y un espacio

    bne     $s0,$s1,print_array_loop

    lui $v0, 0x0000
    ori $v0, $v0, 4

    la      $a0,newline         # Cargar la direcci�n de la cadena "\n" (salto de l�nea)
    syscall                     # Llamar a la syscall para imprimir un salto de l�nea
    j       menu_loop            # Volver al men� principal

exit_program:
    # Salir del programa
    lui $v0, 0x0000
    ori $v0, $v0, 10
    syscall                     # Llamar a la syscall para salir del programa

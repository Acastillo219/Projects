############################################################################
# ___________ Tarea 1 - Estructuras de Computadoras Digitales ____________ #
############################################################################
# ::::::::: José Alejandro Castillo Sequeira - B81787 :::::::::::::::::::: #
############################################################################


#:::::::::::::#
# Descripción #
#:::::::::::::#
# Este programa en lenguaje ensamblador MIPS realiza operaciones en un arreglo de números. 
# Comienza definiendo un conjunto de datos que incluye un arreglo de 20 números enteros y 
# cadenas de caracteres para mensajes de salida. Luego, presenta un menú al usuario, permitiéndole 
# elegir entre opciones como encontrar e imprimir el número mayor, el número menor o todos los valores 
# del arreglo separados por comas. El código incluye funciones para realizar estas operaciones y utiliza 
# bucles para repetir el proceso hasta que el usuario decida salir del programa. 




.data
array:        .word       8, 12, 5, 20, 3, 17, 9, 14, 2, 18, 7, 11, 6, 15, 10, 4, 1, 19, 13, 16
msg_max1:   .asciiz     "El numero mayor del arreglo es: "
msg_min:    .asciiz     "El numero menor del arreglo es: "
arr:	    .asciiz     "Arreglo: "
comma:      .asciiz     ", "   # Cadena que representa una coma y un espacio
newline:    .asciiz     "\n"    # Cadena que representa un salto de línea
menu:       .asciiz     "Menú de Usuario:\n1. Imprimir el número mayor\n2. Imprimir el número menor\n3. Imprimir los valores del arreglo\n0. Salir\nIngrese su opción: "

.text
.globl  main

main:
    la      $s0,array             # $s0 = Dirección base del arreglo array
    addi    $s1,$s0,80         # $s1 = Dirección de fin del arreglo array (80 bytes después)

    lw      $s2,0($s0)          # $s2 = max1 = array[0]
    lw      $s4,0($s0)          # $s4 = min = array[0]

menu_loop:
    # Mostrar el menú de usuario
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,menu
    syscall

    # Leer la opción del usuario
    li      $v0,5
    syscall
    addi    $t1, $v0, 0

    # Realizar la acción correspondiente según la opción del usuario
    beq     $t1,1,print_max1     # Si el usuario ingresa 1, imprimir el número mayor
    beq     $t1,2,print_min      # Si el usuario ingresa 2, imprimir el número menor
    beq     $t1,3,print_array    # Si el usuario ingresa 3, imprimir los valores del arreglo
    beq     $t1,0,exit_program  # Si el usuario ingresa 0, salir del programa
    j       menu_loop             # Otra opción, mostrar el menú nuevamente

print_max1:
    # Encontrar el número mayor
    la      $s0,array             # $s0 = Dirección base del arreglo array
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

    # Imprimir el número mayor
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,msg_max1       # Cargar la dirección de la cadena "El numero mayor del arreglo es: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$s2, 0         # Cargar el valor del número mayor en $a0
    syscall                     # Llamar a la syscall para imprimir el número

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,newline         # Cargar la dirección de la cadena "\n" (salto de línea)
    syscall                     # Llamar a la syscall para imprimir un salto de línea
    j       menu_loop            # Volver al menú principal

print_min:
    # Encontrar el número menor
    la      $s0,array             # $s0 = Dirección base del arreglo array
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

    # Imprimir el número menor
    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,msg_min         # Cargar la dirección de la cadena "El numero menor del arreglo es: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$s4, 0         # Cargar el valor del número menor en $a0
    syscall                     # Llamar a la syscall para imprimir el número

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,newline         # Cargar la dirección de la cadena "\n" (salto de línea)
    syscall                     # Llamar a la syscall para imprimir un salto de línea
    j       menu_loop            # Volver al menú principal

print_array:
    # Imprimir los valores del arreglo separados por comas
    lui $v0, 0x0000
    ori $v0, $v0, 4

    la      $a0,arr             # Cargar la dirección de la cadena "Arreglo: "
    syscall                     # Llamar a la syscall para imprimir la cadena

    la      $s0,array             # $s0 = Dirección base del arreglo array

print_array_loop:
    lw      $t0,0($s0)          # $t0 = Valor actual del arreglo
    addi    $s0,$s0,4           # Avanzar al siguiente elemento del arreglo

    lui $v0, 0x0000
    ori $v0, $v0, 1
    addi    $a0,$t0, 0         # Cargar el valor del elemento actual en $a0
    syscall                     # Llamar a la syscall para imprimir el elemento

    lui $v0, 0x0000
    ori $v0, $v0, 4
    la      $a0,comma           # Cargar la dirección de la cadena ", "
    syscall                     # Llamar a la syscall para imprimir una coma y un espacio

    bne     $s0,$s1,print_array_loop

    lui $v0, 0x0000
    ori $v0, $v0, 4

    la      $a0,newline         # Cargar la dirección de la cadena "\n" (salto de línea)
    syscall                     # Llamar a la syscall para imprimir un salto de línea
    j       menu_loop            # Volver al menú principal

exit_program:
    # Salir del programa
    lui $v0, 0x0000
    ori $v0, $v0, 10
    syscall                     # Llamar a la syscall para salir del programa

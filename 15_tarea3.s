.data

.balign 8
array_bubble:
    .quad 7, 3, 21, 10, 0, 8, 2, 15, 6, 1

array_selection:
    .quad 7, 3, 21, 10, 0, 8, 2, 15, 6, 1

    array_len = 10

msg_bubble_before:
    .ascii "Bubble Sort antes: "
    msg_bubble_before_len = . - msg_bubble_before

msg_bubble_after:
    .ascii "Bubble Sort despues: "
    msg_bubble_after_len = . - msg_bubble_after

msg_selection_before:
    .ascii "Selection Sort antes: "
    msg_selection_before_len = . - msg_selection_before

msg_selection_after:
    .ascii "Selection Sort despues: "
    msg_selection_after_len = . - msg_selection_after

space:
    .ascii " "

newline:
    .ascii "\n"

.bss

number:
    .skip 32

.text

.include "06_itoa.s"
// x0 = direccion del array, x1 = cantidad de numeros
// ordenar de menor a mayor en el mismo array

bubble_sort:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame

    cmp x1, #2               // verificar si hay al menos dos numeros
    blt bubble_end           // si hay menos de dos, terminar

    mov x2, #0               // i = 0
    sub x3, x1, #1           // limite = cantidad - 1

// while (i < cantidad - 1)
bubble_outer:
    cmp x2, x3               // comparar i con cantidad - 1
    bge bubble_end           // terminar el ciclo externo

    mov x4, #0               // j = 0
    sub x5, x3, x2           // limite interno = cantidad - 1 - i

// while (j < cantidad - 1 - i)
bubble_inner:
    cmp x4, x5               // comparar j con el limite interno
    bge bubble_next          // terminar esta pasada

    ldr x6, [x0, x4, lsl #3] // leer array[j], cada numero ocupa 8 bytes
    add x7, x4, #1           // posicion j + 1
    ldr x8, [x0, x7, lsl #3] // leer array[j + 1]

    cmp x6, x8               // comparar los dos numeros con signo
    ble bubble_continue      // si ya estan ordenados, continuar

    str x8, [x0, x4, lsl #3] // guardar el menor en array[j]
    str x6, [x0, x7, lsl #3] // guardar el mayor en array[j + 1]

bubble_continue:
    add x4, x4, #1           // j = j + 1
    b bubble_inner           // repetir ciclo interno

bubble_next:
    add x2, x2, #1           // i = i + 1
    b bubble_outer           // repetir ciclo externo

bubble_end:
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar

// x0 = direccion del array, x1 = cantidad de numeros
// ordenar de menor a mayor en el mismo array

selection_sort:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame

    cmp x1, #2               // verificar si hay al menos dos numeros
    blt selection_end        // si hay menos de dos, terminar

    mov x2, #0               // i = 0
    sub x3, x1, #1           // limite = cantidad - 1

// while (i < cantidad - 1)
selection_outer:
    cmp x2, x3               // comparar i con cantidad - 1
    bge selection_end        // terminar el ciclo externo

    mov x4, x2               // posicion del menor = i
    add x5, x2, #1           // j = i + 1

// while (j < cantidad)
selection_inner:
    cmp x5, x1               // comparar j con la cantidad
    bge selection_swap       // al terminar la busqueda, intercambiar

    ldr x6, [x0, x5, lsl #3] // leer array[j]
    ldr x7, [x0, x4, lsl #3] // leer array[posicion del menor]

    cmp x6, x7               // comparar los numeros con signo
    bge selection_continue   // si no es menor, continuar
    mov x4, x5               // guardar la nueva posicion del menor

selection_continue:
    add x5, x5, #1           // j = j + 1
    b selection_inner        // repetir ciclo interno

selection_swap:
    ldr x6, [x0, x2, lsl #3] // leer array[i]
    ldr x7, [x0, x4, lsl #3] // leer el menor encontrado
    str x7, [x0, x2, lsl #3] // guardar el menor en array[i]
    str x6, [x0, x4, lsl #3] // guardar el otro numero en su lugar

    add x2, x2, #1           // i = i + 1
    b selection_outer        // repetir ciclo externo

selection_end:
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar


.global _start

_start:
    // imprimir array antes de Bubble Sort
    ldr x1, =msg_bubble_before // direccion del mensaje
    mov x2, msg_bubble_before_len // longitud del mensaje
    bl print                  // imprimir mensaje

    ldr x0, =array_bubble      // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl print_array            // imprimir array

    // ordenar con Bubble Sort
    ldr x0, =array_bubble      // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl bubble_sort            // llamar a Bubble Sort

    // imprimir array despues de Bubble Sort
    ldr x1, =msg_bubble_after  // direccion del mensaje
    mov x2, msg_bubble_after_len // longitud del mensaje
    bl print                  // imprimir mensaje

    ldr x0, =array_bubble      // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl print_array            // imprimir array ordenado

    // imprimir array antes de Selection Sort
    ldr x1, =msg_selection_before // direccion del mensaje
    mov x2, msg_selection_before_len // longitud del mensaje
    bl print                  // imprimir mensaje

    ldr x0, =array_selection   // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl print_array            // imprimir array

    // ordenar con Selection Sort
    ldr x0, =array_selection   // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl selection_sort         // llamar a Selection Sort

    // imprimir array despues de Selection Sort
    ldr x1, =msg_selection_after // direccion del mensaje
    mov x2, msg_selection_after_len // longitud del mensaje
    bl print                  // imprimir mensaje

    ldr x0, =array_selection   // direccion del array
    mov x1, array_len         // cantidad de numeros
    bl print_array            // imprimir array ordenado

    // exit(0)
    mov x0, #0                // codigo de salida
    mov x8, #93               // syscall de salida
    svc #0                    // ejecutar syscall

// x0 = direccion del array, x1 = cantidad de numeros
print_array:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame
    stp x19, x20, [sp, #-16]! // guardar registros del llamador
    stp x21, x22, [sp, #-16]! // guardar registros del llamador

    mov x19, x0              // direccion del array
    mov x20, x1              // cantidad de numeros
    mov x21, #0              // indice = 0

print_array_loop:
    cmp x21, x20             // comparar indice con cantidad
    bge print_array_end      // terminar si ya se imprimieron todos

    ldr x0, [x19, x21, lsl #3] // cargar el numero actual
    bl print_number          // imprimir numero

    ldr x1, =space           // direccion del espacio
    mov x2, #1               // longitud del espacio
    bl print                 // separar los numeros

    add x21, x21, #1         // aumentar indice
    b print_array_loop       // repetir ciclo

print_array_end:
    bl print_newline         // imprimir salto de linea
    ldp x21, x22, [sp], #16  // recuperar registros del llamador
    ldp x19, x20, [sp], #16  // recuperar registros del llamador
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar

// x0 = numero a imprimir
print_number:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame
    ldr x1, =number          // direccion del buffer
    add x1, x1, #32          // final del buffer
    bl itoa                  // convertir numero a texto
    bl print                 // imprimir texto
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar

print_newline:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame
    ldr x1, =newline         // direccion del salto de linea
    mov x2, #1               // longitud del salto de linea
    bl print                 // imprimir salto de linea
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar

// x1 = direccion del mensaje, x2 = longitud del mensaje
print:
    stp x29, x30, [sp, #-16]! // guardar direccion de retorno
    mov x29, sp              // guardar inicio del frame
    // write(1, direccion, longitud)
    mov x0, #1               // stdout
    mov x8, #64              // syscall de escritura
    svc #0                   // ejecutar syscall
    ldp x29, x30, [sp], #16  // recuperar direccion de retorno y stack
    ret                      // regresar

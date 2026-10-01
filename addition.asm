global _start
extern ExitProcess

section .data
    num1    dd  15
    num2    dd  27

section .text
_start:
    mov     eax, [num1]
    add     eax, [num2]

    push    eax
    call    [ExitProcess]
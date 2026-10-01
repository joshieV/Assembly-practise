; addition_print_linux64.asm
; Computes num1 + num2 and prints the result as decimal.
; Platform: Linux 64-bit (myCompiler, XIDE, x86-64 playground, etc.)
; Assemble: nasm -f elf64 addition_print_linux64.asm -o addition_print.o
; Link:     ld addition_print.o -o addition_print
; Run:      ./addition_print

section .data
    num1    dd  15
    num2    dd  27
    msg     db  "Result: "
    msg_len equ $ - msg
    nl      db  10

section .bss
    buf     resb 16

section .text
    global _start

_start:
    mov     eax, [num1]
    add     eax, [num2]         ; eax = 42

    ; Convert to ASCII (backwards) 
    lea     rsi, [buf + 15]
    mov     ecx, 10
    xor     ebx, ebx            ; ebx = digit count

convert_loop:
    xor     edx, edx
    div     ecx
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    inc     ebx
    test    eax, eax
    jnz     convert_loop

    ; Save digit pointer and length BEFORE we clobber rsi
    mov     r12, rsi            ; r12 = pointer to first digit
    mov     r13, rbx            ; r13 = digit count

    ; Print "Result: " 
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [msg]          ; now safe to overwrite rsi
    mov     rdx, msg_len
    syscall

    ; Print digit
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, r12            ; restore digit pointer
    mov     rdx, r13            ; digit count
    syscall

    ; Newline
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [nl]
    mov     rdx, 1
    syscall

    ;  Exit
    mov     rax, 60
    xor     rdi, rdi
    syscall
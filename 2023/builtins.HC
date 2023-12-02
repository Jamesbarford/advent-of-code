asm {
_READ_FILE:
    push    %rbp
    movq    %rsp, %rbp
    subq    $512, %rsp
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
    
    movq    -16(%rbp), %rdi
    call    _malloc
    movq    %rax, -32(%rbp)
    movq    -32(%rbp), %rax

    movq    -8(%rbp), %rdi
    movq    $0, %rsi
    movq    $420, %rdx
    call    _open
    movq    %rax, -40(%rbp)

    movq    -40(%rbp), %rdi
    movq    -32(%rbp), %rsi
    movq    -16(%rbp), %rdx
    call    _read
    movq    %rax, -48(%rbp)

    movq    %rax, %rdx
    movq    -24(%rbp), %rax
    movq    %rdx, (%rax)
    movq    -32(%rbp), %rax
    movq    -48(%rbp), %rcx
    addq    %rcx, %rax
    movq    $0, (%rax)
    movq    -32(%rbp), %rax
    leave
    ret

_STRNCMP:
    push   %rbp
    movq   %rsp, %rbp
    subq   $48, %rsp
    movq   %rdi, -8(%rbp)
    movq   %rsi, -16(%rbp)
    movq   %rdx, -24(%rbp)
.J0:
    cmpq   $0, -24(%rbp)
    je     .J1
    movq   -8(%rbp), %rax
    movq   -16(%rbp), %rbx
    movzbq (%rax), %rcx
    movzbq (%rbx), %rdx
    cmp    %rcx, %rdx
    jne    .J2
    test   %rcx, %rcx
    je     .J3
    addq   $1, -8(%rbp)
    addq   $1, -16(%rbp)
    subq   $1, -24(%rbp)
    jmp    .J0
.J2:
    sub    %rdx, %rcx
    jmp    .J4
.J3:
    movq   $0, %rax
.J4:
    movq   %rcx, %rax
    leave
    ret
.J1:
    movq   $0, %rax
    leave
    ret

_STRLEN:
    push    %rbp
    movq    %rsp, %rbp
    subq    $8, %rsp
    movq    %rdi, -8(%rbp)
    movq    -8(%rbp), %rbx
    movq    $0, %rcx
.JJ0:
	movzbl (%rbx), %eax
	movsbl  %al, %eax
    cmp     $0, %eax
    jz      .JJ1
    addq    $1, %rcx
    addq    $1, %rbx
    jmp     .JJ0
.JJ1:
    movq    %rcx, %rax
    leave
    ret
}

_extern _STRNCMP I64 StrNCmp(U8 *s1, U8 *s2, I64 len);
_extern _STRLEN I64 StrLen(U8 *s1);
_extern _READ_FILE U8 *FileRead(U8 *name, I64 max_size, I64 *_len);

.global _READ_FILE
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

.global _STRNCMP
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

.global _STRLEN
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

.global _MALLOC
_MALLOC:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq    %rax, %rdi
	call    _malloc
	leave
	ret

.global _FREE
_FREE:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq    %rax, %rdi
	call    _free
	leave
	ret

.data
.L0:
	.string "Card %d: \0"
.L1:
	.string "%2d \0"
.L2:
	.string "| \0"
.L3:
	.string "%2d \0"
.L4:
	.string "\n\0"
.L5:
	.string "./input.txt\0"
.L6:
	.string "part1: %zu\n\0"
.L7:
	.string "part1: %zu\n\0"
	.text
	.global _STRNCMP
	.text
	.global _STRLEN
	.text
	.global _READ_FILE
	.text
	.global _MALLOC
	.text
	.global _FREE
	.text
	.global _CardNew
_CardNew:
	push   %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp #STACK LOCAL COUNT 1
	movq   $40, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _MALLOC
	movq   %rax, -8(%rbp)
	movq   $8, %rax
	push   %rax
	movq   $200, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _MALLOC
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 16(%rax)
	
# Problem code END 
	movq   $8, %rax
	push   %rax
	movq   $200, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _MALLOC
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, (%rax)
	
# Problem code END 
	movq   $0, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	movq   $0, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 32(%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _CardPrint
_CardPrint:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 2
	movq   %rdi, -32(%rbp)
	leaq   .L0(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L8:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L9
	leaq   .L1(%rip), %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	jmp    .L8
.L9:
	leaq   .L2(%rip), %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _printf
	movq   $0, %rax
	movq   %rax, -16(%rbp)
.L10:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L11
	leaq   .L3(%rip), %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -16(%rbp)
	jmp    .L10
.L11:
	leaq   .L4(%rip), %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _printf
	leave
	ret
.text
	.global _CardFree
_CardFree:
	push   %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp #STACK LOCAL COUNT 0
	movq   %rdi, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _FREE
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _FREE
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _FREE
	leave
	ret
.text
	.global _GetLine
_GetLine:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 1
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
	movq   %rdx, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L12:
	# AND AND Start
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	test   %rax, %rax
	movq   $0, %rax
	je    .L14
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $10, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setne   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je     .L14
	movq   $1, %rax
	.L14:
	# AND AND End
	test   %rax, %rax
	je     .L13
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   -48(%rbp), %rax
	addq     $1, %rax
	movq   %rax, -48(%rbp)
	pop    %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	pop    %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	jmp    .L12
.L13:
	movq   $0, %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L15
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	.L15:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L16
	movq   $0, %rax
	leave
	ret
.L16:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _ParseNumber
_ParseNumber:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 2
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   -48(%rbp), %rax
	addq     $1, %rax
	movq   %rax, -48(%rbp)
	pop    %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -8(%rbp)
	movq   $0, %rax
	movq   %rax, -16(%rbp)
.L17:
	# RANGE Start
	movq   $48, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L19
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $57, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L19
	movq   $1, %rax
	.L19:
	# Range END 
	
	test   %rax, %rax
	je     .L18
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $10, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   -48(%rbp), %rax
	addq     $1, %rax
	movq   %rax, -48(%rbp)
	pop    %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -16(%rbp)
	pop    %rax
	jmp    .L17
.L18:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _ParseNumbersUntil
_ParseNumbersUntil:
	push   %rbp
	movq   %rsp, %rbp
	subq   $80, %rsp #STACK LOCAL COUNT 4
	movq   %rdi, -80(%rbp)
	movq   %rsi, -72(%rbp)
	movq   %rdx, -64(%rbp)
	movq   %rcx, -56(%rbp)
	movq   $0, %rax
	movq   %rax, -16(%rbp)
	movq   $0, %rax
	movq   %rax, -24(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
.L20:
	# AND AND Start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	test   %rax, %rax
	movq   $0, %rax
	je    .L22
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setne   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je     .L22
	movq   $1, %rax
	.L22:
	# AND AND End
	test   %rax, %rax
	je     .L21
	# RANGE Start
	movq   $48, %rax
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L23
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $57, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L23
	movq   $1, %rax
	.L23:
	# Range END 
	
	test   %rax, %rax
	je     .L24
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -16(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ParseNumber
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -64(%rbp)
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -24(%rbp)
	.L24:
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -64(%rbp)
	pop    %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -24(%rbp)
	pop    %rax
	jmp    .L20
.L21:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _LineToCard
_LineToCard:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 2
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
.L25:
	# RANGE Start
	movq   $48, %rax
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L27
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $57, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L27
	movq   $1, %rax
	.L27:
	# Range END 
	
	cmp    $0, %rax
	sete   %al
	movzb  %al, %rax
	test   %rax, %rax
	je     .L26
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -40(%rbp)
	pop    %rax
	jmp    .L25
.L26:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -16(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ParseNumber
	movq   %rax, -8(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -40(%rbp)
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 24(%rax)
	
# Problem code END 
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -16(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $124, %rax
	push   %rax
	pop    %rcx
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ParseNumbersUntil
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -40(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 32(%rax)
	
# Problem code END 
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -16(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	push   %rax
	pop    %rcx
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ParseNumbersUntil
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -40(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	leave
	ret
.text
	.global _QSort
_QSort:
	push   %rbp
	movq   %rsp, %rbp
	subq   $64, %rsp #STACK LOCAL COUNT 4
	movq   %rdi, -64(%rbp)
	movq   %rsi, -56(%rbp)
	movq   %rdx, -48(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L28
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   %rax, -24(%rbp)
.L29:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L30
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L31
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -32(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -16(%rbp)
	pop    %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	.L31:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -24(%rbp)
	pop    %rax
	jmp    .L29
.L30:
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _QSort
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _QSort
	.L28:
	leave
	ret
.text
	.global _GetCardScore
_GetCardScore:
	push   %rbp
	movq   %rsp, %rbp
	subq   $80, %rsp #STACK LOCAL COUNT 6
	movq   %rdi, -80(%rbp)
	movq   %rsi, -72(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	movq   $0, %rax
	movq   %rax, -16(%rbp)
	movq   $0, %rax
	movq   %rax, -24(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -48(%rbp)
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	push   %rax
	movq   $0, %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _QSort
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	push   %rax
	movq   $0, %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _QSort
.L32:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L33
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -24(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -32(%rbp)
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L34
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -48(%rbp)
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L35
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -40(%rbp)
	jmp    .L36
	.L35:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, -40(%rbp)
	.L36:
	.L34:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L37
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -16(%rbp)
	jmp    .L38
	.L37:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setg   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L39
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	.L39:
	.L38:
	jmp    .L32
.L33:
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L40
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	.L40:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _SolvePart1
_SolvePart1:
	push   %rbp
	movq   %rsp, %rbp
	subq   $4144, %rsp #STACK LOCAL COUNT 5
	movq   %rdi, -4144(%rbp)
	movq   $0, %rax
	movq   %rax, -4120(%rbp)
	mov    $0, %eax
	call   _CardNew
	movq   %rax, -4128(%rbp)
.L41:
	# LOAD rax START
	movq   -4144(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD LEAQ START: 1297648 # LOAD LEAQ START: %d %s
	
	leaq   -4096(%rbp), %rax
	# LOAD LEAQ END: array ptr *U8[4096]
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -4104(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _GetLine
	test   %rax, %rax
	je     .L42
	# LOAD rax START
	movq   -4128(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD LEAQ START: 1297936 # LOAD LEAQ START: %d %s
	
	leaq   -4096(%rbp), %rax
	# LOAD LEAQ END: array ptr *U8[4096]
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _LineToCard
	# LOAD rax START
	movq   -4128(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _GetCardScore
	movq   %rax, -4112(%rbp)
	# LOAD rax START
	movq   -4120(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -4112(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -4120(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -4144(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -4104(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -4144(%rbp)
	jmp    .L41
.L42:
	# LOAD rax START
	movq   -4120(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _SolvePart2
_SolvePart2:
	push   %rbp
	movq   %rsp, %rbp
	subq   $12384, %rsp #STACK LOCAL COUNT 12
	movq   %rdi, -12384(%rbp)
	movq   $0, %rax
	movq   %rax, -12304(%rbp)
	movq   $0, %rax
	movq   %rax, -12312(%rbp)
	movq   $0, %rax
	movq   %rax, -12320(%rbp)
	movq   $1, %rax
	movq   %rax, -12328(%rbp)
.L43:
	# LOAD rax START
	movq   -12328(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1024, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L44
	movq   $1, %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1298320 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12328(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -12328(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -12328(%rbp)
	jmp    .L43
.L44:
	mov    $0, %eax
	call   _CardNew
	movq   %rax, -12336(%rbp)
.L45:
	# LOAD rax START
	movq   -12384(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD LEAQ START: 1298608 # LOAD LEAQ START: %d %s
	
	leaq   -4096(%rbp), %rax
	# LOAD LEAQ END: array ptr *U8[4096]
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -12296(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _GetLine
	test   %rax, %rax
	je     .L46
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD LEAQ START: 1298896 # LOAD LEAQ START: %d %s
	
	leaq   -4096(%rbp), %rax
	# LOAD LEAQ END: array ptr *U8[4096]
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _LineToCard
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -12304(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _GetCardScore
	movq   $1, %rax
	movq   %rax, -12344(%rbp)
.L47:
	# LOAD rax START
	movq   -12344(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -12304(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L48
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -12344(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -12352(%rbp)
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1299280 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -12360(%rbp)
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1299472 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -12344(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1299664 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1299856 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12336(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -12344(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD rax START
	movq   -12344(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -12344(%rbp)
	jmp    .L47
.L48:
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -12384(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -12296(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -12384(%rbp)
	# LOAD rax START
	movq   -12312(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -12312(%rbp)
	jmp    .L45
.L46:
	movq   $1, %rax
	movq   %rax, -12368(%rbp)
.L49:
	# LOAD rax START
	movq   -12368(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -12312(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L50
	# LOAD rax START
	movq   -12320(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD LEAQ START: 1300144 # LOAD LEAQ START: %d %s
	
	leaq   -12288(%rbp), %rax
	# LOAD LEAQ END: array I64[8192]
	push   %rax
	# LOAD rax START
	movq   -12368(%rbp), %rax
	# LOAD rax END
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	##__DEREF_START: AST_TYPE_INT
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -12320(%rbp)
	# LOAD rax START
	movq   -12368(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -12368(%rbp)
	jmp    .L49
.L50:
	# LOAD rax START
	movq   -12320(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _main
_main:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 4
	leaq   .L5(%rip), %rax
	push   %rax
	movq   $50000, %rax
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -8(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _READ_FILE
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _SolvePart1
	movq   %rax, -24(%rbp)
	leaq   .L6(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _SolvePart2
	movq   %rax, -32(%rbp)
	leaq   .L7(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	leave
	ret

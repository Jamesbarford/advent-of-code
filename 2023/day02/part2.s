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

.data
.L0:
	.string "./input.txt\0"
.L1:
	.string "GAME ID :%d\n\0"
.L2:
	.string "====R:%d G:%d B:%d, product:%d\n\0"
.L3:
	.string "total:%d\n\0"
	.global RGB
RGB:
.quad 0
.quad 0
.quad 0
.text
	.global _HashFunction
_HashFunction:
	push   %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp #STACK LOCAL COUNT 0
	movq   %rdi, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $114, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L4
	movq   $0, %rax
	jmp    .L5
	.L4:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $103, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L6
	movq   $1, %rax
	jmp    .L7
	.L6:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $98, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L8
	movq   $2, %rax
	.L8:
	.L7:
	.L5:
	leave
	ret
.text
	.global _ClearScores
_ClearScores:
	push   %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp #STACK LOCAL COUNT 1
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L9:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $3, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L10
	movq   $0, %rax
	push   %rax
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
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
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	pop    %rax
	jmp    .L9
.L10:
	leave
	ret
.text
	.global _AtoI
_AtoI:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 3
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
	movq   $0, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -16(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L11
	jmp    .parsed_number
	.L11:
	movq   $0, %rax
	movq   %rax, -16(%rbp)
.L12:
	movq   $1, %rax
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
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -24(%rbp)
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L14
	jmp    .parsed_number
	.L14:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $9, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setg   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L15
	jmp    .parsed_number
	.L15:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $10, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -48(%rbp)
	pop    %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	pop    %rax
	jmp    .L12
.L13:
.parsed_number:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L16
	# LOAD rax START
	movq   -8(%rbp), %rax
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
	.L16:
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _main
_main:
	push   %rbp
	movq   %rsp, %rbp
	subq   $96, %rsp #STACK LOCAL COUNT 10
	leaq   .L0(%rip), %rax
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
	movq   $0, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -24(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -48(%rbp)
	movq   $0, %rax
	movq   %rax, -56(%rbp)
	movq   $0, %rax
	movq   %rax, -64(%rbp)
	mov    $0, %eax
	call   _ClearScores
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	movq   %rax, -72(%rbp)
.L17:
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	test   %rax, %rax
	je     .L18
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -32(%rbp)
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $71, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L19
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $5, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -72(%rbp)
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -48(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _AtoI
	movq   %rax, -24(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -72(%rbp)
	leaq   .L1(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	.L19:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L20
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $9, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je     .L20
	movq   $1, %rax
	.L20:
	test   %rax, %rax
	je     .L21
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -48(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _AtoI
	movq   %rax, -32(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
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
	movq   %rax, -72(%rbp)
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _HashFunction
	movq   %rax, -80(%rbp)
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
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
	movq   -32(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L22
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
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
	.L22:
	.L21:
	# LOAD rax START
	movq   -72(%rbp), %rax
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
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L23
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	movq   $0, %rax
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
	lea    RGB(%rip), %rax
	push   %rax
	movq   $1, %rax
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
	imulq   %rcx, %rax
	push   %rax
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	movq   $2, %rax
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
	imulq   %rcx, %rax
	movq   %rax, -64(%rbp)
	leaq   .L2(%rip), %rax
	push   %rax
	# Pointer Arithmetic start
	lea    RGB(%rip), %rax
	push   %rax
	movq   $0, %rax
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
	lea    RGB(%rip), %rax
	push   %rax
	movq   $1, %rax
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
	lea    RGB(%rip), %rax
	push   %rax
	movq   $2, %rax
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
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %r8
	pop    %rcx
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -56(%rbp)
	mov    $0, %eax
	call   _ClearScores
	.L23:
	# LOAD rax START
	movq   -72(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -72(%rbp)
	pop    %rax
	jmp    .L17
.L18:
	leaq   .L3(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	leave
	ret

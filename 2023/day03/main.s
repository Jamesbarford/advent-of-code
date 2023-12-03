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
	.string "%d \0"
.L1:
	.string "\n\0"
.L2:
	.string "./input.txt\0"
.L3:
	.string "pt1: %d\n\0"
.L4:
	.string "pt2: %d\n\0"
	.global DIRS
DIRS:
.quad 8
.quad 10
.quad 2
.quad 3
.quad 1
.quad 5
.quad 4
.quad 12
.text
	.global _MatrixNew
_MatrixNew:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 1
	movq   %rdi, -32(%rbp)
	movq   %rsi, -24(%rbp)
	movq   $40, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _malloc
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 32(%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 24(%rax)
	
# Problem code END 
	movq   $8, %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _malloc
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 16(%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _MatrixFree
_MatrixFree:
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
	call   _free
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _free
	leave
	ret
.text
	.global _InBounds
_InBounds:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 0
	movq   %rdi, -32(%rbp)
	movq   %rsi, -24(%rbp)
	movq   %rdx, -16(%rbp)
	# AND AND Start
	# Diamond start
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L6
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L6
	movq   $1, %rax
	.L6:
	# Diamond end
	
	test   %rax, %rax
	movq   $0, %rax
	je    .L5
	# Diamond start
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L7
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L7
	movq   $1, %rax
	.L7:
	# Diamond end
	
	test   %rax, %rax
	movq   $0, %rax
	je     .L5
	movq   $1, %rax
	.L5:
	# AND AND End
	leave
	ret
.text
	.global _MatrixPrint
_MatrixPrint:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 2
	movq   %rdi, -32(%rbp)
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
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L11
	leaq   .L0(%rip), %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	leaq   .L1(%rip), %rax
	push   %rax
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
	leave
	ret
.text
	.global _LineLen
_LineLen:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 1
	movq   %rdi, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L12:
	# LOAD rax START
	movq   -32(%rbp), %rax
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
	je     .L13
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
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
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _RowCount
_RowCount:
	push   %rbp
	movq   %rsp, %rbp
	subq   $32, %rsp #STACK LOCAL COUNT 1
	movq   %rdi, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L14:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	test   %rax, %rax
	je     .L15
	# LOAD rax START
	movq   -32(%rbp), %rax
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
	je     .L16
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	pop    %rax
	.L16:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	jmp    .L14
.L15:
	# LOAD rax START
	movq   -8(%rbp), %rax
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
	# Diamond start
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
	setle  %al
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
	movq   $48, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L19
	movq   $1, %rax
	.L19:
	# Diamond end
	
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
	.global _FileToMatrix
_FileToMatrix:
	push   %rbp
	movq   %rsp, %rbp
	subq   $80, %rsp #STACK LOCAL COUNT 7
	movq   %rdi, -80(%rbp)
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _LineLen
	movq   %rax, -8(%rbp)
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _RowCount
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _MatrixNew
	movq   %rax, -24(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -48(%rbp)
.L20:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	test   %rax, %rax
	je     .L21
	# Diamond start
	# LOAD rax START
	movq   -80(%rbp), %rax
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
	setle  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L22
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $48, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge  %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L22
	movq   $1, %rax
	.L22:
	# Diamond end
	
	test   %rax, %rax
	je     .L23
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	# ADDR LVAR START AST_TYPE_INT 
	leaq   -56(%rbp), %rax
	# ADDR LVAR END AST_TYPE_INT 
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ParseNumber
	movq   %rax, -48(%rbp)
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
	movq   %rax, -80(%rbp)
.L24:
	# LOAD rax START
	movq   -56(%rbp), %rax
	# LOAD rax END
	push   %rax
	subq   $1, %rax
	movq   %rax, -56(%rbp)
	pop    %rax
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L25
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	jmp    .L24
.L25:
	jmp    .L26
	.L23:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $42, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L27
	movq   $0, %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	jmp    .L28
	.L27:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	##__DEREF_START: AST_TYPE_CHAR
	movq   %rax, %rcx
	movzbl (%rcx), %eax
	movsbl  %al, %eax
	##__DEREF_END
	push   %rax
	movq   $1000, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	push   %rax
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	.L28:
	.L26:
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# Pointer Arithmetic end
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
	je     .L29
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -40(%rbp)
	pop    %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -80(%rbp)
	pop    %rax
	.L29:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -80(%rbp)
	pop    %rax
	jmp    .L20
.L21:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _EmitCoord
_EmitCoord:
	push   %rbp
	movq   %rsp, %rbp
	subq   $64, %rsp #STACK LOCAL COUNT 5
	movq   %rdi, -64(%rbp)
	movq   %rsi, -56(%rbp)
	# Pointer Arithmetic start
	lea    DIRS(%rip), %rax
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
	movq   $1, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	sarq   %cl, %rax
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -16(%rbp)
	movq   $1, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -24(%rbp)
	movq   $1, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	sarq   %cl, %rax
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -32(%rbp)
	movq   $1, %rax
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	sarq   %cl, %rax
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -40(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L30
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	subq   $1, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, (%rax)
	
# Problem code END 
	pop    %rax
	.L30:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L31
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	addq   $1, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, (%rax)
	
# Problem code END 
	pop    %rax
	.L31:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L32
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	subq   $1, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	pop    %rax
	.L32:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	test   %rax, %rax
	je     .L33
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	addq   $1, %rax
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	pop    %rax
	.L33:
	leave
	ret
.text
	.global _IsAdjacent
_IsAdjacent:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 2
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
	movq   %rdx, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L34:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $8, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L35
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, (%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _EmitCoord
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _InBounds
	test   %rax, %rax
	je     .L36
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	movq   %rax, -16(%rbp)
	# AND AND Start
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L37
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $46, %rax
	push   %rax
	movq   $1000, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setne   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je     .L37
	movq   $1, %rax
	.L37:
	# AND AND End
	test   %rax, %rax
	je     .L38
	movq   $1, %rax
	leave
	ret
.L38:
	.L36:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	jmp    .L34
.L35:
	movq   $0, %rax
	leave
	ret
.text
	.global _SolvePart1
_SolvePart1:
	push   %rbp
	movq   %rsp, %rbp
	subq   $64, %rsp #STACK LOCAL COUNT 6
	movq   %rdi, -64(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -40(%rbp)
.L39:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L40
	movq   $0, %rax
	movq   %rax, -48(%rbp)
.L41:
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L42
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	movq   %rax, -8(%rbp)
	# AND AND Start
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setg   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L43
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _IsAdjacent
	test   %rax, %rax
	movq   $0, %rax
	je     .L43
	movq   $1, %rax
	.L43:
	# AND AND End
	test   %rax, %rax
	je     .L44
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -32(%rbp)
.L45:
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -64(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	movq   %rax, -8(%rbp)
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setg   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L46
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -48(%rbp)
	jmp    .L45
.L46:
	.L44:
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -48(%rbp)
	jmp    .L41
.L42:
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -40(%rbp)
	jmp    .L39
.L40:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _ArrayContains
_ArrayContains:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 1
	movq   %rdi, -48(%rbp)
	movq   %rsi, -40(%rbp)
	movq   %rdx, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
.L47:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L48
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
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
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L49
	movq   $1, %rax
	leave
	ret
.L49:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -8(%rbp)
	jmp    .L47
.L48:
	movq   $0, %rax
	leave
	ret
.text
	.global _IsAdjacentToGear
_IsAdjacentToGear:
	push   %rbp
	movq   %rsp, %rbp
	subq   $128, %rsp #STACK LOCAL COUNT 4
	movq   %rdi, -128(%rbp)
	movq   %rsi, -120(%rbp)
	movq   %rdx, -112(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	movq   $0, %rax
	movq   %rax, -80(%rbp)
.L50:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $8, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L51
	# LOAD rax START
	movq   -112(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, (%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -120(%rbp), %rax
	# LOAD rax END
	
# Problem code START 
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	pop    %rcx
	movq   %rcx, 8(%rax)
	
# Problem code END 
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _EmitCoord
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _InBounds
	test   %rax, %rax
	je     .L52
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   8(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   (%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -128(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	movq   %rax, -88(%rbp)
	# AND AND Start
	# LOAD rax START
	movq   -88(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setg   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L53
	# LOAD LEAQ START: 20005488 # LOAD LEAQ START: %d %s
	
	leaq   -72(%rbp), %rax
	# LOAD LEAQ END: array I64[64]
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -88(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ArrayContains
	cmp    $0, %rax
	sete   %al
	movzb  %al, %rax
	test   %rax, %rax
	movq   $0, %rax
	je     .L53
	movq   $1, %rax
	.L53:
	# AND AND End
	test   %rax, %rax
	je     .L54
	# LOAD rax START
	movq   -88(%rbp), %rax
	# LOAD rax END
	push   %rax
	# Pointer Arithmetic start
	# LOAD LEAQ START: 20005728 # LOAD LEAQ START: %d %s
	
	leaq   -72(%rbp), %rax
	# LOAD LEAQ END: array I64[64]
	push   %rax
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	addq   $1, %rax
	movq   %rax, -8(%rbp)
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
	.L54:
	.L52:
	# LOAD rax START
	movq   -80(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -80(%rbp)
	jmp    .L50
.L51:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $2, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L55
	# Pointer Arithmetic start
	# LOAD LEAQ START: 20005968 # LOAD LEAQ START: %d %s
	
	leaq   -72(%rbp), %rax
	# LOAD LEAQ END: array I64[64]
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
	# LOAD LEAQ START: 20006160 # LOAD LEAQ START: %d %s
	
	leaq   -72(%rbp), %rax
	# LOAD LEAQ END: array I64[64]
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
	leave
	ret
.L55:
	movq   $0, %rax
	leave
	ret
.text
	.global _SolvePart2
_SolvePart2:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 4
	movq   %rdi, -48(%rbp)
	movq   $0, %rax
	movq   %rax, -8(%rbp)
	movq   $0, %rax
	movq   %rax, -16(%rbp)
	movq   $0, %rax
	movq   %rax, -24(%rbp)
.L56:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   32(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L57
	movq   $0, %rax
	movq   %rax, -32(%rbp)
.L58:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L59
	# Pointer Arithmetic start
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   16(%rax), %rcx
	movq   %rcx, %rax
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	movq   24(%rax), %rcx
	movq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
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
	movq   %rax, -16(%rbp)
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L60
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -48(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	push   %rax
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _IsAdjacentToGear
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -8(%rbp)
	.L60:
	# LOAD rax START
	movq   -32(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	jmp    .L58
.L59:
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	addq   $1, %rax
	movq   %rax, -24(%rbp)
	jmp    .L56
.L57:
	# LOAD rax START
	movq   -8(%rbp), %rax
	# LOAD rax END
	leave
	ret
.text
	.global _main
_main:
	push   %rbp
	movq   %rsp, %rbp
	subq   $48, %rsp #STACK LOCAL COUNT 5
	leaq   .L2(%rip), %rax
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
	movq   %rax, -24(%rbp)
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	movq   %rax, -32(%rbp)
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _FileToMatrix
	movq   %rax, -40(%rbp)
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _SolvePart1
	movq   %rax, -16(%rbp)
	leaq   .L3(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _SolvePart2
	movq   %rax, -16(%rbp)
	leaq   .L4(%rip), %rax
	push   %rax
	# LOAD rax START
	movq   -16(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	# LOAD rax START
	movq   -40(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _MatrixFree
	# LOAD rax START
	movq   -24(%rbp), %rax
	# LOAD rax END
	push   %rax
	pop    %rdi
	mov    $0, %eax
	call   _free
	leave
	ret

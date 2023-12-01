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

.data
.L0:
	.string "./input.txt"
.L1:
	.string ">>%d\n"
.L2:
	.string "done: %d\n"
	.text
	.global _main
_main:
	push   %rbp
	movq   %rsp, %rbp
	subq   $96, %rsp #STACK LOCAL COUNT 11
	movq   $0, %rax
	movq   %rax, -24(%rbp)
	leaq   .L0(%rip), %rax
	push   %rax
	movq   $30000, %rax
	push   %rax
	leaq   -8(%rbp), %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _READ_FILE
	movq   %rax, -32(%rbp)
	movq   $1, %rax
	movq   %rax, -56(%rbp)
	movq   $0, %rax
	movq   %rax, -72(%rbp)
.L3:
	# LOAD RAX
	movq   -72(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -8(%rbp), %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L4
	# LOAD RAX
	movq   -32(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -72(%rbp), %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -80(%rbp)
	movq   $0, %rax
	movq   %rax, -88(%rbp)
.L5:
	# LOAD RAX
	movq   -88(%rbp), %rax
	push   %rax
	movq   $8, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L6
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -88(%rbp), %rax
	push   %rax
	movq   $8, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	sarq   %cl, %rax
	movq   %rax, -16(%rbp)
	movq   $255, %rax
	push   %rax
	# LOAD RAX
	movq   -16(%rbp), %rax
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -16(%rbp)
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	movq   $10, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L7
	movq   $1, %rax
	movq   %rax, -56(%rbp)
	movq   $0, %rax
	movq   %rax, -64(%rbp)
	# LOAD RAX
	movq   -48(%rbp), %rax
	push   %rax
	movq   $10, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, -64(%rbp)
	# LOAD RAX
	movq   -64(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -40(%rbp), %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -64(%rbp)
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -64(%rbp), %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -24(%rbp)
	.L7:
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -16(%rbp)
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	movq   $0, %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L8
	jmp    .out
	.L8:
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	movq   $0, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setge   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L9
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	movq   $9, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setle   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L9
	movq   $1, %rax
	.L9:
	test   %rax, %rax
	je     .L10
	# LOAD RAX
	movq   -56(%rbp), %rax
	test   %rax, %rax
	je     .L11
	# LOAD RAX
	movq   -16(%rbp), %rax
	movq   %rax, -48(%rbp)
	# LOAD RAX
	movq   -16(%rbp), %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -56(%rbp)
	jmp    .L12
	.L11:
	# LOAD RAX
	movq   -16(%rbp), %rax
	movq   %rax, -40(%rbp)
	.L12:
	leaq   .L1(%rip), %rax
	push   %rax
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	.L10:
	# LOAD RAX
	movq   -88(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -88(%rbp)
	pop    %rax
	jmp    .L5
.L6:
	# LOAD RAX
	movq   -72(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -72(%rbp)
	pop    %rax
	jmp    .L3
.L4:
.out:
	leaq   .L2(%rip), %rax
	push   %rax
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	leave
	ret

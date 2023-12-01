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
	.string "%ld\n"
	.text
	.global _ProcessLine
_ProcessLine:
	push   %rbp
	movq   %rsp, %rbp
	subq   $80, %rsp #STACK LOCAL COUNT 7
	movq   %rdi, -80(%rbp)
	movq   %rsi, -72(%rbp)
	movq   $1, %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -56(%rbp)
.L2:
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -72(%rbp), %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L3
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -8(%rbp)
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -16(%rbp)
	movq   $500, %rax
	movq   %rax, -48(%rbp)
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $116, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L4
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L5
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $110, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L5
	movq   $1, %rax
	.L5:
	test   %rax, %rax
	je     .L6
	movq   $10, %rax
	movq   %rax, -48(%rbp)
	jmp    .L7
	.L6:
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $104, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L10
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $114, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L10
	movq   $1, %rax
	.L10:
	test   %rax, %rax
	movq   $0, %rax
	je    .L9
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L9
	movq   $1, %rax
	.L9:
	test   %rax, %rax
	movq   $0, %rax
	je    .L8
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $4, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L8
	movq   $1, %rax
	.L8:
	test   %rax, %rax
	je     .L11
	movq   $3, %rax
	movq   %rax, -48(%rbp)
	jmp    .L12
	.L11:
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $119, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L13
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $111, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L13
	movq   $1, %rax
	.L13:
	test   %rax, %rax
	je     .L14
	movq   $2, %rax
	movq   %rax, -48(%rbp)
	.L14:
	.L12:
	.L7:
	jmp    .L15
	.L4:
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $111, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L16
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $110, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L17
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L17
	movq   $1, %rax
	.L17:
	test   %rax, %rax
	je     .L18
	movq   $1, %rax
	movq   %rax, -48(%rbp)
	.L18:
	jmp    .L19
	.L16:
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $102, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L20
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $105, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L22
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $118, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L22
	movq   $1, %rax
	.L22:
	test   %rax, %rax
	movq   $0, %rax
	je    .L21
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L21
	movq   $1, %rax
	.L21:
	test   %rax, %rax
	je     .L23
	movq   $5, %rax
	movq   %rax, -48(%rbp)
	jmp    .L24
	.L23:
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $111, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L26
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $117, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L26
	movq   $1, %rax
	.L26:
	test   %rax, %rax
	movq   $0, %rax
	je    .L25
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $114, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L25
	movq   $1, %rax
	.L25:
	test   %rax, %rax
	je     .L27
	movq   $4, %rax
	movq   %rax, -48(%rbp)
	.L27:
	.L24:
	jmp    .L28
	.L20:
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $115, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L29
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $105, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L30
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $120, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L30
	movq   $1, %rax
	.L30:
	test   %rax, %rax
	je     .L31
	movq   $6, %rax
	movq   %rax, -48(%rbp)
	jmp    .L32
	.L31:
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L35
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $118, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L35
	movq   $1, %rax
	.L35:
	test   %rax, %rax
	movq   $0, %rax
	je    .L34
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L34
	movq   $1, %rax
	.L34:
	test   %rax, %rax
	movq   $0, %rax
	je    .L33
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $4, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $110, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L33
	movq   $1, %rax
	.L33:
	test   %rax, %rax
	je     .L36
	movq   $7, %rax
	movq   %rax, -48(%rbp)
	.L36:
	.L32:
	jmp    .L37
	.L29:
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L38
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $105, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L41
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $103, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L41
	movq   $1, %rax
	.L41:
	test   %rax, %rax
	movq   $0, %rax
	je    .L40
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $104, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L40
	movq   $1, %rax
	.L40:
	test   %rax, %rax
	movq   $0, %rax
	je    .L39
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $4, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $116, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L39
	movq   $1, %rax
	.L39:
	test   %rax, %rax
	je     .L42
	movq   $8, %rax
	movq   %rax, -48(%rbp)
	.L42:
	jmp    .L43
	.L38:
	# LOAD RAX
	movq   -8(%rbp), %rax
	push   %rax
	movq   $110, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L44
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $1, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $105, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L46
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $2, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $110, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L46
	movq   $1, %rax
	.L46:
	test   %rax, %rax
	movq   $0, %rax
	je    .L45
	# LOAD RAX
	movq   -80(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	movq   $3, %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	push   %rax
	movq   $101, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	movq   $0, %rax
	je    .L45
	movq   $1, %rax
	.L45:
	test   %rax, %rax
	je     .L47
	movq   $9, %rax
	movq   %rax, -48(%rbp)
	.L47:
	jmp    .L48
	.L44:
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
	je    .L49
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
	je    .L49
	movq   $1, %rax
	.L49:
	test   %rax, %rax
	je     .L50
	# LOAD RAX
	movq   -16(%rbp), %rax
	movq   %rax, -48(%rbp)
	.L50:
	.L48:
	.L43:
	.L37:
	.L28:
	.L19:
	.L15:
	# LOAD RAX
	movq   -48(%rbp), %rax
	push   %rax
	movq   $500, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L51
	# LOAD RAX
	movq   -40(%rbp), %rax
	test   %rax, %rax
	je     .L52
	movq   $0, %rax
	movq   %rax, -40(%rbp)
	# LOAD RAX
	movq   -48(%rbp), %rax
	movq   %rax, -24(%rbp)
	# LOAD RAX
	movq   -48(%rbp), %rax
	movq   %rax, -32(%rbp)
	jmp    .L53
	.L52:
	# LOAD RAX
	movq   -48(%rbp), %rax
	movq   %rax, -32(%rbp)
	.L53:
	.L51:
	# LOAD RAX
	movq   -56(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -56(%rbp)
	pop    %rax
	jmp    .L2
.L3:
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	movq   $10, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, -48(%rbp)
	# LOAD RAX
	movq   -48(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -32(%rbp), %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -48(%rbp)
	# LOAD RAX
	movq   -48(%rbp), %rax
	leave
	ret
.text
	.global _main
_main:
	push   %rbp
	movq   %rsp, %rbp
	subq   $2128, %rsp #STACK LOCAL COUNT 10
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	movq   $0, %rax
	movq   %rax, -40(%rbp)
	leaq   .L0(%rip), %rax
	push   %rax
	movq   $50000, %rax
	push   %rax
	leaq   -8(%rbp), %rax
	push   %rax
	pop    %rdx
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _READ_FILE
	movq   %rax, -48(%rbp)
	movq   $0, %rax
	movq   %rax, -2104(%rbp)
.L54:
	# LOAD RAX
	movq   -2104(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -8(%rbp), %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L55
	# LOAD RAX
	movq   -48(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -2104(%rbp), %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	##__DEREF_START
	movq   (%rcx), %rax
	##__DEREF_END
	movq   %rax, -16(%rbp)
	movq   $0, %rax
	movq   %rax, -2112(%rbp)
.L56:
	# LOAD RAX
	movq   -2112(%rbp), %rax
	push   %rax
	movq   $8, %rax
	pop    %rcx
	cmp    %rax, %rcx
	setl   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L57
	# LOAD RAX
	movq   -16(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -2112(%rbp), %rax
	push   %rax
	movq   $8, %rax
	movq   %rax, %rcx
	pop    %rax
	imulq   %rcx, %rax
	movq   %rax, %rcx
	pop    %rax
	sarq   %cl, %rax
	movq   %rax, -24(%rbp)
	movq   $255, %rax
	push   %rax
	# LOAD RAX
	movq   -24(%rbp), %rax
	pop    %rcx
	and    %rcx, %rax
	movq   %rax, -24(%rbp)
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	leaq  -2096(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -32(%rbp), %rax
	imul   $8, %rax
	popq   %rcx
	addq   %rax, %rcx
	movq   %rcx, %rax
	# ASSIGN DREF INTERNAL START
	movq   (%rax), %rcx #OK mov
	pop    %rcx
	movq   %rcx, (%rax)
	# ASSIGN DREF INTERNAL end
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	movq   $10, %rax
	pop    %rcx
	cmp    %rax, %rcx
	sete   %al
	movzb  %al, %eax
	test   %rax, %rax
	je     .L58
	leaq  -2096(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -32(%rbp), %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _ProcessLine
	movq   %rax, -2120(%rbp)
	# LOAD RAX
	movq   -40(%rbp), %rax
	push   %rax
	# LOAD RAX
	movq   -2120(%rbp), %rax
	movq   %rax, %rcx
	pop    %rax
	addq   %rcx, %rax
	movq   %rax, -40(%rbp)
	movq   $0, %rax
	movq   %rax, -32(%rbp)
	jmp    .L59
	.L58:
	# LOAD RAX
	movq   -32(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -32(%rbp)
	pop    %rax
	.L59:
	# LOAD RAX
	movq   -24(%rbp), %rax
	push   %rax
	movq   $48, %rax
	movq   %rax, %rcx
	pop    %rax
	subq   %rcx, %rax
	movq   %rax, -24(%rbp)
	# LOAD RAX
	movq   -24(%rbp), %rax
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
	je     .L60
	jmp    .out
	.L60:
	# LOAD RAX
	movq   -2112(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -2112(%rbp)
	pop    %rax
	jmp    .L56
.L57:
	# LOAD RAX
	movq   -2104(%rbp), %rax
	push   %rax
	addq   $1, %rax
	movq   %rax, -2104(%rbp)
	pop    %rax
	jmp    .L54
.L55:
.out:
	leaq   .L1(%rip), %rax
	push   %rax
	# LOAD RAX
	movq   -40(%rbp), %rax
	push   %rax
	pop    %rsi
	pop    %rdi
	mov    $0, %eax
	call   _printf
	leave
	ret
	leave
	ret

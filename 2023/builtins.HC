asm {
/* Stores the allocated amount of bytes in the first 8 bytes */
_MALLOC:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movq    %rdi, -8(%rbp)
    movq    -8(%rbp), %rax
    addq    $8, %rax
    movq    %rax, %rdi
    call    _malloc
    movq    %rax, -16(%rbp)
    movq    -8(%rbp), %rcx
    movq    %rcx, (%rax)
    addq    $8, %rax
    leave
    ret

_READ_FILE:
    push    %rbp
    movq    %rsp, %rbp
    subq    $512, %rsp
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
    
    movq    -16(%rbp), %rdi
    call    _MALLOC
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

/* Gets to the start of the actual allocated buffer 
 * And then calls free */
_FREE:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    %rdi, %rax
    subq    $8, %rax
    movq    %rax, %rdi
    call    _free
    leave
    ret

/* Get how many bytes were allocated */
_MSIZE:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    %rdi, %rax
    subq    $8, %rax
    movq    (%rax), %rax
    leave
    ret

_MEMCPY:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    %rdi, %rax
    movq    %rsi, %rcx
    movq    %rdx, %rdx
    cmpq    $0, %rdx
    je      .memcpy_done
.memcpy_loop:
    movb    (%rcx), %bl
    movb    %bl, (%rax)
    addq    $1, %rax
    addq    $1, %rcx
    subq    $1, %rdx
    jnz     .memcpy_loop
.memcpy_done:
    leave
    ret

_THREAD_NEW:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rdx
	leaq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	_pthread_create
	movq	-8(%rbp), %rax
	leave
	ret

_THREAD_JOIN:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	movq	$0, %rsi
	call	_pthread_join
	leave
	ret

_THREAD_LOCK_INIT:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
    movq    $0, %rsi
	call	_pthread_mutex_init
	leave
	ret

_THREAD_LOCK:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	call	_pthread_mutex_lock
	leave
	ret

_THREAD_UNLOCK:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	call	_pthread_mutex_unlock
	leave
	ret

_THREAD_LOCK_DESTORY:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	call	_pthread_mutex_destroy
	leave
	ret
}

#define TRUE  1
#define FALSE 0
#define NULL  0
#define __MUTEX_LOCK_PADDING__ 56
#define __BUFSIZ__ 2048

/* This I _think_ is specific to MacOS implementation of pthreads 
 * It does work. */
class MutexLock 
{
  I64 __sig;
  I8 __opaque[__MUTEX_LOCK_PADDING__];
};

// public _extern _STRNCMP I64 StrNCmp(U8 *s1, U8 *s2, I64 len);
public _extern _READ_FILE U8 *FileRead(U8 *name, I64 max_size, I64 *_len);
public _extern _MALLOC U0 *MAlloc(I64 size);
public _extern _FREE U0 Free(U0 *ptr);
public _extern _MSIZE U0 MSize(U0 *ptr);
public _extern _MEMCPY U0 MemCpy(U0 *dst, U0 *src, I64 len);
public _extern _THREAD_NEW I64 ThreadNew(U0 (*function_ptr)(U0 *argv),
        U0 *argv=NULL);
public _extern _THREAD_JOIN I64 ThreadJoin(I64 thread_id,
        U0 *thread_attr=NULL);
public _extern _THREAD_LOCK_INIT I64 ThreadLockInit(MutexLock *lk,
        U0 *thread_attr=NULL);
public _extern _THREAD_LOCK_DESTORY I64 ThreadLockDestroy(MutexLock *lk);
public _extern _THREAD_LOCK I64 ThreadLock(MutexLock *lk);
public _extern _THREAD_UNLOCK I64 ThreadUnLock(MutexLock *lk);

public MutexLock *MutexLockNew()
{
  MutexLock *lk = MAlloc(sizeof(MutexLock));
  ThreadLockInit(lk);
  return lk;
}

public U0 MutexLockDestroy(MutexLock *lk)
{
   ThreadLockDestroy(lk);
   Free(lk);
}

public I64 StrLen(U8 *str)
{
  I64 len = 0;
  while (*str) {
    str++;
    len++;
  }
  return len;
}

public I64 StrNCmp(U8 *s1, U8 *s2, I64 len)
{
  while (len) {
    if (*s1 != *s2) {
      return len;
    }
    ++s1;
    ++s2;
    --len;
  }
  return len;
}

public U64 MemAddr(U0 *ptr)
{
  U8 buffer[__BUFSIZ__];
  I64 len;
  len = snprintf(buffer, __BUFSIZ__, "%p", ptr);
  buffer[len] = '\0';
  return strtoll(buffer,NULL,16);
}

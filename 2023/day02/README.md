# Day 2
Fixed string support with the compiler. This involved changing the registers
used to deal with a byte:

```asm
movq    %rax, %rcx   # move byte from RAX to RCX, RAX is a pointer to a string
movzbl  (%rcx), %eax # Dereference RCX to get the value and store in EAX, making the higher bits 0
movsbl  %al, %eax    # Nicked this from GCC, seems redundant as we already have 8bits in EAX as we have moved a byte with movzbl
# ... code 
```
This then allows looking at a single character at a time which is what you
want when iterating over a string. `movsbl` means 'move and zero byte extend'

Ironically as a consequence of "fixing" this bug I believe I have now made my 
day 1 solution un-compilable with my compiler.

I also added basic support for while loops. However still do not have a break 
clause. Thus a goto is needed to be able to break out:

```c
while (1) {
    /* code */
    if (/* */) {
        goto out;
    }
}
out:
    /* more code */
```
Overall, while obscure, the code is looking more readible.

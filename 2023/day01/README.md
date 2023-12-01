# Day 1

For this challenge I did not have string support. Therefore the following does not work as expected:

```c
U8 *buffer = FileRead("<file>", <max_bytes>, <*len>);
```
As the compiler currently only supports 64bit integers this segfaults, despite the implementation of `FileRead` being in `x86_64`. Therefore we have to read the file as:

```c
I64 *buffer = FileRead("<file>", <max_bytes>, <*len>);
```
This has the added fun that on each loop iteration you get back `8` bytes.


```c
for (I64 i = 0; i < len; i++) {
    I64 ch = buffer[i];
    /* In the context of the sample file for day1 ch will hold: 
     * 1abc2\npq
     *
     * which can then be extracted through bit shifting
     */
}
```

For part2 I realised I can load a temporary `I64` array with the extracted values and go line by line
which, while still really grim, made part2 possible!

The code looks extremely strange but this is mostly due to a partially complete compiler than my shoddy programming skills (I hope)!

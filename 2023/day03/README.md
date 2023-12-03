# Day 3

Flew through this one pretty easily. I don't seem to be able to support `*=` as 
syntax.

I seemed to be doing a lot of range checks so invented:

```c
if (10 <> num <> 0) {
    /* Code */
}
```
Where: `num <= 10` and  `num >= 0`. Not sure if it is a good idea however it 
was fun to implement. Compiler also does not support nested arrays preventing:

```c
I64 Dirs[8][2] = {
    {0,1},
    {0,-1},
    /* ETC.. */
};
```

## Update
TempleOS has range checks like:

```c
if ('0' <= ch <= '9') {
    /* Code */
}
```
So I removed `<>` in favour of what is in templos

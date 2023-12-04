# Day 4
Support for `','` separated declarations for variables. Also support function
pointers but this was not needed.

## Bugs
- `func(func2())` etc.. does not work
- mutli dimensional arrays still not supported
- mathematical precidence is completely off
- no multi assign like `i = j = 0`
- cannot do `&c->len` to get the address of the variable `len` of class `c`

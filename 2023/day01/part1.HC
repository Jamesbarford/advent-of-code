U0 Main() {
    I64 len;
    I64 x;
    I64 acc = 0;
    I64 *buffer = FileRead("./input.txt", 30000, &len);
    I64 last;
    I64 first;
    I64 isfirst = 1;
    I64 num;

    for (I64 i = 0; i < len; i++) {
        I64 ch = buffer[i];
        for (I64 j = 0; j < 8; j++) {
            x = ch >> j * 8;
            x &= 0xFF;
            if (x == 10) {
                isfirst = 1;
                num = 0;
                num = first * 10;
                num += last;
                acc += num;
            }
            x -= '0';

            if (x == 0 - 48) {
                goto out;
            }

            if (x >= 0 && x <= 9) {
                if (isfirst) {
                    first = x;
                    last = x;
                    isfirst = 0;
                } else {
                    last = x;
                }
                ">>%d\n", x;
            }
        }
    }
out:
    "done: %d\n",acc;
}

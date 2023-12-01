I64 ProcessLine(I64 *line, I64 len) {
    I64 ch;
    I64 x;
    I64 f;
    I64 l;
    I64 isfirst = 1;
    I64 num;

    for (I64 i = 0; i < len; i ++) {
        ch = line[i];
        x = ch - '0';
        num = 500;

        if (ch == 't') {
            if (line[i + 1] == 'e' &&
                line[i + 2] == 'n') {
                num = 10;
            } else if (line[i + 1] == 'h' && 
                       line[i + 2] == 'r' &&
                       line[i + 3] == 'e' &&
                       line[i + 4] == 'e') {
                num = 3;
            } else if (line[i + 1] == 'w' &&
                       line[i + 2] == 'o') {
                num = 2;
            }
        } else if (ch == 'o') {
            if (line[i + 1] == 'n' && line[i + 2] == 'e') {
                num = 1;
            }
        } else if (ch == 'f') {
            if (line[i + 1] == 'i' &&
                line[i + 2] == 'v' &&
                line[i + 3] == 'e') {
                num = 5;
            } else if (line[i + 1] == 'o' &&
                line[i + 2] == 'u' &&
                line[i + 3] == 'r') {
                num = 4;
            }
        } else if (ch == 's') {
            if (line[i + 1] == 'i' &&
                line[i + 2] == 'x') {
                num = 6;
            } else if (line[i + 1] == 'e' &&
                line[i + 2] == 'v' &&
                line[i + 3] == 'e' &&
                line[i + 4] == 'n') {
                num = 7;
            }
        } else if (ch == 'e') {
            if (line[i + 1] == 'i' && 
                line[i + 2] == 'g' &&
                line[i + 3] == 'h' &&
                line[i + 4] == 't') {
                num = 8;
            }
        } else if (ch == 'n') {
            if (line[i + 1] == 'i' && 
                line[i + 2] == 'n' &&
                line[i + 3] == 'e') {
                num = 9;
            }
        } else {
            if (x >= 0 && x <= 9) {
                num = x;
            }
        }
        if (num < 500) {
            if (isfirst) {
                isfirst = 0;
                f = num;
                l = num;
            } else {
                l = num;
            }
        }
    }
    num = f * 10;
    num += l;
    return num;
}

U0 Main() {
    I64 len;
    I64 ch;
    I64 x;
    I64 ii = 0;
    I64 acc = 0;
    I64 *buffer = FileRead("./input.txt", 50000, &len);
    I64 line[256];

    for (I64 i = 0; i < len; i++) {
        ch = buffer[i];
        for (I64 j = 0; j < sizeof(I64); j++) {
            x = ch >> j * sizeof(I64);
            x &= 0xFF;
            line[ii] = x; 

            if (x == 10) {
                I64 a = ProcessLine(line,ii);
                acc += a;
                ii = 0;
            } else {
                ii++;
            }
            x -= '0';
            if (x == 0 - 48) {
                goto out;
            }
        }
    }
out:
    "%ld\n",acc;
    return;
}

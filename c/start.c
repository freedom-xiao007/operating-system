#define COL8_000000 0
#define COL8_FF0000 1
#define COL8_00FF00 2
#define COL8_FFFF00 3
#define COL8_0000FF      4
#define COL8_FF00FF      5
#define COL8_00FFFF      6
#define COL8_FFFFFF      7
#define COL8_C6C6C6      8
#define COL8_840000      9
#define COL8_008400      10
#define COL8_848400      11
#define COL8_000084      12
#define COL8_840084      13
#define COL8_008484      14
#define COL8_848484      15

/*就算写在同一个源文件里，如果想在定义前使用，还是必须事先声明一下。*/
void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
void putfont8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);

void int_2_string(int num, char *s);

static char font_A[16] = {
    0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,
    0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00
};

void start(void)
{
    init_palette(); /* 设定调色板 */

    char *vram; /* 变量p是BYTE [...]用的地址 */
    vram = (char *) 0xa0000; /* 指定地址 */
    int xsize = 320;
    int ysize = 200;

    boxfill8(vram, xsize, COL8_008484,  0,         0,          xsize, ysize - 29);
    boxfill8(vram, xsize, COL8_C6C6C6,  0,         ysize - 28, xsize, ysize - 28);
    boxfill8(vram, xsize, COL8_FFFFFF,  0,         ysize - 27, xsize, ysize - 27);
    boxfill8(vram, xsize, COL8_C6C6C6,  0,         ysize - 26, xsize, ysize -  1);

    //     y距离有时候需要大于3
    boxfill8(vram, xsize, COL8_FFFFFF,  3,         ysize - 24, 59,         ysize - 21);
    boxfill8(vram, xsize, COL8_FFFFFF,  2,         ysize - 24,  2,         ysize -  4);
    boxfill8(vram, xsize, COL8_848484,  3,         ysize -  4, 59,         ysize -  1);
    boxfill8(vram, xsize, COL8_848484, 59,         ysize - 23, 59,         ysize -  5);
    boxfill8(vram, xsize, COL8_000000,  2,         ysize -  3, 59,         ysize -  0);
    boxfill8(vram, xsize, COL8_000000, 60,         ysize - 24, 60,         ysize -  3);

    boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 24, xsize -  4, ysize - 21);
    boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 23, xsize - 47, ysize -  4);
    boxfill8(vram, xsize, COL8_FFFFFF, xsize - 47, ysize -  3, xsize -  4, ysize -  0);
    boxfill8(vram, xsize, COL8_FFFFFF, xsize -  3, ysize - 24, xsize -  3, ysize -  3);

    putfont8_asc(vram, xsize, 8, 8, COL8_FFFFFF, "Hollo OS 123456!");

    char s[10];
    int_2_string(xsize, s);
    putfont8_asc(vram, xsize, 16, 64, COL8_FFFFFF, s); 

    for (; ; ) {
        io_hlt();
    }
}

void init_palette(void)
{
    static unsigned char table_rgb[16 * 3] = {
        0x00, 0x00, 0x00,   /*  0：黑 */
        0xff, 0x00, 0x00, /* 1：亮红 */
        0x00, 0xff, 0x00, /* 2：亮绿 */
        0xff, 0xff, 0x00, /* 3：亮黄 */
        0x00, 0x00, 0xff, /* 4：亮蓝 */
        0xff, 0x00, 0xff, /* 5：亮紫 */
        0x00, 0xff, 0xff, /* 6：浅亮蓝 */
        0xff, 0xff, 0xff, /* 7：白 */
        0xc6, 0xc6, 0xc6, /* 8：亮灰 */
        0x84, 0x00, 0x00, /* 9：暗红 */
        0x00, 0x84, 0x00, /* 10：暗绿 */
        0x84, 0x84, 0x00, /* 11：暗黄 */
        0x00, 0x00, 0x84, /* 12：暗青 */
        0x84, 0x00, 0x84, /* 13：暗紫 */
        0x00, 0x84, 0x84, /* 14：浅暗蓝 */
        0x84, 0x84, 0x84 /* 15：暗灰 */
    };
    set_palette(0, 15, table_rgb);
    return;

    /* C语言中的static char语句只能用于数据，相当于汇编中的DB指令 */
}

void set_palette(int start, int end, unsigned char *rgb)
{
    int i, eflags;
    eflags = io_load_eflags();  /* 记录中断许可标志的值*/
    io_cli();                      /* 将中断许可标志置为0，禁止中断 */
    io_out8(0x03c8, start);
    for (i = start; i <= end; i++) {
        io_out8(0x03c9, rgb[0] / 4);
        io_out8(0x03c9, rgb[1] / 4);
        io_out8(0x03c9, rgb[2] / 4);
        rgb += 3;
    }
    io_store_eflags(eflags);     /* 复原中断许可标志 */
    return;
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{
    int x, y;
    for (x = x0; x <= x1; x++) {
        for (y = y0; y <= y1; y++) {
            vram[y * xsize + x] = c;
        }
    }
    return;
}

void putfont8_asc(char *vram, int xsize, int x, int y, char c,  unsigned char *s)
{
   extern char hankaku[4096];
    /* C语言中，字符串都是以0x00结尾 */
    for (; *s != 0x00; s++) {
	putfont8(vram, xsize, x, y, c, hankaku + *s * 16);
	x += 8;
    }
    return; 
}

void putfont8(char *vram, int xsize, int x, int y, char c,  char *font)
{
    int i;
    char *p, d /* data */;
    for (i = 0; i < 16; i++) {
        p = vram + (y + i) * xsize + x;
        d = font[i];
        if ((d & 0x80) != 0) { p[0] = c; }
        if ((d & 0x40) != 0) { p[1] = c; }
        if ((d & 0x20) != 0) { p[2] = c; }
        if ((d & 0x10) != 0) { p[3] = c; }
        if ((d & 0x08) != 0) { p[4] = c; }
        if ((d & 0x04) != 0) { p[5] = c; }
        if ((d & 0x02) != 0) { p[6] = c; }
        if ((d & 0x01) != 0) { p[7] = c; }
    }
    return;
}

// 目前默认处理正整数，转换成十进制，先简单点
void int_2_string(int num, char *s) {
    char num_index[] = "0123456789";
    
    char temp[40];
    int i = 0;
    int remain = num % 10;
    temp[i] = num_index[remain];
    num = num / 10;
    while (num > 0) {
        i = i + 1;
        remain = num % 10;
        temp[i] = num_index[remain];
        num = num / 10;
    }

    int j = 0;
    while(i > -1) {
        s[j] = temp[i]; 
        j = j + 1;
        i = i - 1;
    }
    s[j] = 0x00;
    return;
}
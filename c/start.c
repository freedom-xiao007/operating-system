/* 告诉C编译器，有一个函数在别的文件里 */
typedef unsigned char uint8_t;

void put_str(uint8_t* message);

void start(void) {
    put_str("0123456789");
    int i;
    char *p;
    for (i = 0xa0000; i < 0xaffff; i++) {
	p = (char *) i;
	*p = i & 0x0f;
    }
    while(1);
}
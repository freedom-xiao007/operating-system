/* 告诉C编译器，有一个函数在别的文件里 */
typedef unsigned char uint8_t;

void put_str(uint8_t* message);
void write_mem8(int addr, int data);

void start(void) {
    put_str("0123456789");
    int i;
    for (i = 0xa0000; i < 0xaffff; i++) {
	write_mem8(i, i & 0x0f);
    }
    while(1);
}
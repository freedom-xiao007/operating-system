void print_s(char* s);
void io_hlt();
int add(char* a, char* b);
char* get_char();

void start(void)
{

    char *a = get_char();
    char *b = get_char();
    int c = add(a, b);

    if (c == 3) {
        char *s = "hello world2$";
        print_s(s);
    }
    for (; ; ) {
        io_hlt();
    }
}

int add(char* a, char* b) {
    if (a == "a") {
        print_s(a);
        return 1;
    };
    if (b == "b") {
        print_s(b);
        return 2;
    }
    char *s = "hello world1$";
    print_s(s);
    return 3;
}
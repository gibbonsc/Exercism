#include <stdio.h>

extern const char *hello(void);

int main(void) {
    printf("%s\n", hello());
    return 0;
}

/*  To compile and execute in WSL:

    $ aarch64-linux-gnu-gcc -o hello_world hello_world.S hello_world.c
    $ qemu-aarch64 -L /usr/aarch64-linux-gnu ./hello_world
 */

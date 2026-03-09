#include <stdio.h>
#include <stdint.h>

/* extern int step(int64_t); */
extern int steps(int64_t);

int main(void) {
    printf("1: %d\n", steps(3));
    return 0;
}

/*  To compile and execute in WSL (from parent directory):
    $ ex=collatz_conjecture
    $ aarch64-linux-gnu-gcc -o byhand/$ex $ex.s byhand/$ex.c
    $ qemu-aarch64 -L /usr/aarch64-linux-gnu ./${ex}
 */

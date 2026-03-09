.equ INVALID_NUMBER, -1

.text
.globl steps
.globl step
step:
        mov x1, x0
        and x1, x1, #1
        cmp x1, #0
        beq even
        b odd
even:
// even argument: x/2
        lsr x0, x0, #1
        b stepret
odd:
// odd argument: x*3+1
        mov x1, x0
        lsl x1, x1, #1
        add x0, x0, x1
        add x0, x0, #1
stepret:
        ret

steps:
// handle invalid argument
        cmp x0, 1
        bpl valid
        mov x0, #INVALID_NUMBER
        b stepsret
valid:
//Prologue
        stp fp, lr, [sp, #-0x10]!
// initialize counter
        mov x3, #0
iter:
// iterate while result isn't 1
        cmp x0, #1
        beq finish
// count iterations
        add x3, x3, #1
        bl step
        b iter
finish:
        mov x0, x3
//Epilogue
        ldp fp, lr, [sp], #0x10
stepsret:
        ret

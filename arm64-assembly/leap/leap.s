.text
.globl leap_year

leap_year:
        mov x1, x0
        and x1, x1, #3  // x1 = x0 mod 4
        mov x2, x0
        mov x3, #100
        udiv x4, x2, x3
        msub x2, x4, x3, x2  // x2 = x0 mod 100
        mov x3, x0
        mov x4, #400
        udiv x5, x3, x4
        msub x3, x5, x4, x3  // x3 = x0 mod 400

        cmp x2, #0  // divisible by 100?
        beq divx100
        b not_divx100
divx100:
        cmp x3, #0  // divisible by 400?
        beq leap_yes
        b leap_no
not_divx100:
        cmp x1, #0  // divisible by 4?
        beq leap_yes
leap_no:
        mov x0, #0  // return false
        b leap_return
leap_yes:
        mov x0, #1  // return true
leap_return:
        ret

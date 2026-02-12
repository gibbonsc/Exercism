# "Cross-assembling and emulating" arm64 on an x86_64 Windows host

## QEMU

### qemu-system-aarch64

I chose to install **MSYS2** from [https://www.msys2.org/](https://www.msys2.org/),
then in its ucrt64 environment, I used `pacman -S mingw-w64-ucrt-x86_64-qemu` to install QEMU,
It has a 64-bit ARM emulator, `qemu-system-aarch64`.
I also installed some toolchains
`mingw-w64-ucrt-x86_64-clang mingw-w64-ucrt-x86_64-aarch64-linux-gnu-gcc mingw-w64-ucrt-x86_64-aarch64-none-elf-gcc`
to cross-compile and build binaries.

I added convenient and appropriate `PATH` enviornment variables.

### aarch64-none-elf-gcc

In WSL (Ubuntu), I used `apt install -y build-essential make gcc-aarch64-linux-gnu qemu-user`
and those packages seemed to get everything I needed to successfully cross-compile Linux binaries.

At this point I was able to type `make` to operate Exercism's `Makefile` to assemble
the source code and compile and run the C unit tests wrapper.

After a successful `make` I could
also directly emulate the `tests` 64-bit ARM Linux executable:

```
$ file tests
tests: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, BuildID[sha1]=f6057e0c57308671f33f63c18689468669e7481c, for GNU/Linux 3.7.0, not stripped
$ qemu-aarch64 -L /usr/aarch64-linux-gnu ./tests
hello_world_test.c:12:test_say_hi:FAIL: Expected 'Hello, World!' Was 'Goodbye, Mars!'

-----------------------
1 Tests 1 Failures 0 Ignored
FAIL
25gibbonsc:hello-world$ make
hello_world_test.c:12:test_say_hi:FAIL: Expected 'Hello, World!' Was 'Goodbye, Mars!'

-----------------------
1 Tests 1 Failures 0 Ignored
FAIL
make: *** [Makefile:28: all] Error 1
```
Success! (The next step was to modify the assembly source code to satisfy the "Hello World" test case...)

### Arm GNU Toolchain for AArch64 bare-metal (aarch64-none-elf)

Although it wasn't necessary to do the Exercism challenges, my genAI chat clanker persuaded me
to spend extra time installing additional Windows-native tools, in anticipation of assembling
bare-metal executables. That way I could transfer cross-assembled code to an actual 64-bit ARM
microcontroller when I obtain one someday.
Unlike the Linux ELF cross-assembled binaries for Exercism, which I had to run in WSL,
I could run these bare-metal ARM GNU tools in PowerShell 7 natively in Windows.

A genAI chat clanker helped me with additional "hello world" variants
and procedures for assembling and linking a plain (not Linux) firmware executable - first a
"semihosting" procedure, and then a QEMU-emulated _PL011 UART_ procedure.
I didn't want to spend time crafting a `Makefile`, so instead
I wrote a `pwsh` script to build and execute a bare-metal binary:

```powershell
$source="startPL011UART.S"
$object="startPL011UART.o"
$linker="startPL011UART.ld"
$linked="firmware.elf"

Write-Host "...assembling..." -ForegroundColor DarkGreen
aarch64-none-elf-gcc -c -O2 -ffreestanding -nostdlib $source -o $object
if ($LASTEXITCODE) { throw "assemble failed" }

Write-Host "...linking..." -ForegroundColor DarkGreen
aarch64-none-elf-ld  -nostdlib -T $linker $object -o $linked
if ($LASTEXITCODE) { throw "link failed" }

Write-Host "...here you go..." -ForegroundColor Gray
qemu-system-aarch64 -M virt -cpu cortex-a72 -nographic -kernel $linked
#qemu-system-aarch64 -M virt,virtualization=on -cpu cortex-a72 -nographic -kernel $linked
```

A few times I got interesting CPU state dumps from the emulator:
```
 PC=0000000040080008 X00=0000000000000000 X01=0000000000000018
X02=0000000000000000 X03=0000000000000000 X04=0000000000000000
X05=0000000000000000 X06=0000000000000000 X07=0000000000000000
X08=0000000000000000 X09=0000000000000000 X10=0000000000000000
X11=0000000000000000 X12=0000000000000000 X13=0000000000000000
X14=0000000000000000 X15=0000000000000000 X16=0000000000000000
X17=0000000000000000 X18=0000000000000000 X19=0000000000000000
X20=0000000000000000 X21=0000000000000000 X22=0000000000000000
X23=0000000000000000 X24=0000000000000000 X25=0000000000000000
X26=0000000000000000 X27=0000000000000000 X28=0000000000000000
X29=0000000000000000 X30=0000000000000000  SP=0000000000000000
PSTATE=00000000400003c5 -Z-- EL1h
```

cc -o golc gameoflife.c
nasm -felf64 -o golasm.o gameoflife.asm
ld -o golasm golasm.o
# ./golc
# ./golasm

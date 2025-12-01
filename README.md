Como compilar:

Cria o objeto (Use -f elf32, programa feito em 32bits)
```bash
nasm -f elf32 calc.asm -o calc.o 
```

Cria o executavel (Usa mesma flag 32bits)
```bash
ld -m elf_i386 -o calc calc.o 
```

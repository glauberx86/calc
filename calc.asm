section .data
  msg db 'Input 1:', 0xA
  len equ $- msg
  msg2 db 'Input 2:', 0xA
  len2 equ $- msg2

section .bss
  ; Numeros e respostas
  nm1 resb 2
  nm2 resb 2
  resp resb 1

global _start

section .text
_start:
  
  ; Texto Input 1
  mov eax, 4
  mov ebx, 1
  mov ecx, msg
  mov edx, len
  int 0x80
  
  ; Numero 1
  mov eax, 3
  mov ebx, 0
  mov ecx, nm1
  mov edx, 2
  int 0x80

  ; Texto Input 2
  mov eax, 4
  mov ebx, 1
  mov ecx, msg2
  mov edx, len2
  int 0x80

  ; Numero 2
  mov eax, 3
  mov ebx, 0
  mov ecx, nm2
  mov edx, 2
  int 0x80

soma:
  mov al, [nm1]
  mov bl, [nm2]
  sub al, '0'
  sub bl, '0'
  add al, bl
  add al, '0'
  mov [resp], al
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov ecx, resp
  mov edx, 1
  int 0x80

saida:
  mov eax, 1
  xor ebx, ebx
  int 0x80

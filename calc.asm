section .data
  msg db 'Input 1:', 0xA
  len equ $- msg
  msg2 db 'Input 2:', 0xA
  len2 equ $- msg2
  msg_op db 'Escolha operacao (1 = soma, 2 = subtracao, 3 = multiplicacao, 4 = divisao, 0 = sair): ', 0xA
  len_op equ $- msg_op
  msg_res db 'Resultado: ', 0xA
  len_res equ $- msg_res
  msg_cont db 0xA, 'Outro calculo? (s/n): ', 0xA
  len_cont equ $- msg_cont
  msg_div0 db 'Divisao por zero. Coloque outro numero.', 0xA
  len_div0 equ $- msg_div0

section .bss
  ; Numeros e respostas
  nm1 resb 2
  nm2 resb 2
  resp resb 1
  op resb 2
  cont resb 2

global _start

section .text
_start:

novo_calculo:
  ; Escolha da operacao
  mov eax, 4
  mov ebx, 1
  mov ecx, msg_op
  mov edx, len_op
  int 0x80

  ; Leitura da operacao (1 ou 2)
  mov eax, 3
  mov ebx, 0
  mov ecx, op
  mov edx, 2
  int 0x80

  ; Valida operacao
  mov al, [op]
  cmp al, '0'
  je saida
  cmp al, '1'
  je ler_numeros
  cmp al, '2'
  je ler_numeros
  cmp al, '3'
  je ler_numeros
  cmp al, '4'
  je ler_numeros
  jmp novo_calculo

ler_numeros:
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

processa_op:
  mov al, [op]
  cmp al, '0'
  je saida
  cmp al, '1'
  je faz_soma
  cmp al, '2'
  je subtracao
  cmp al, '3'
  je multiplicacao
  cmp al, '4'
  je divisao
  jmp novo_calculo

faz_soma:
  mov al, [nm1]
  mov bl, [nm2]
  sub al, '0'
  sub bl, '0'
  add al, bl
  add al, '0'
  jmp mostra_resposta

subtracao:
  mov al, [nm1]
  mov bl, [nm2]
  sub al, '0'
  sub bl, '0'
  sub al, bl
  add al, '0'
  jmp mostra_resposta

multiplicacao:
  mov al, [nm1]
  mov bl, [nm2]
  sub al, '0'
  sub bl, '0'
  mul bl                ; AX = AL * BL (somente um digito exibido)
  add al, '0'
  jmp mostra_resposta

divisao:
  mov al, [nm1]
  mov bl, [nm2]
  sub al, '0'
  sub bl, '0'
  cmp bl, 0
  je divisao_zero
  xor ah, ah
  div bl                ; AL = quociente
  add al, '0'

mostra_resposta:
  mov [resp], al

  ; Texto resultado
  mov eax, 4
  mov ebx, 1
  mov ecx, msg_res
  mov edx, len_res
  int 0x80

  ; Valor resultante
  mov eax, 4
  mov ebx, 1
  mov ecx, resp
  mov edx, 1
  int 0x80

  ; Pergunta se continua
  mov eax, 4
  mov ebx, 1
  mov ecx, msg_cont
  mov edx, len_cont
  int 0x80

  mov eax, 3
  mov ebx, 0
  mov ecx, cont
  mov edx, 2
  int 0x80

  cmp byte [cont], 's'
  je novo_calculo
  cmp byte [cont], 'S'
  je novo_calculo

  jmp saida

divisao_zero:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg_div0
  mov edx, len_div0
  int 0x80
  jmp novo_calculo

saida:
  mov eax, 1
  xor ebx, ebx
  int 0x80

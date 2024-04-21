BITS 64

%define EXIT_SYS 60
%define WRITE_SYS 1
%define STDOUT 1

%define HEIGHT 40
%define WIDTH 40

global _start
section .text
putc:
    push rbp
    mov rbp, rsp
    mov rsi, rdi
    mov rax, WRITE_SYS
    mov rdi, STDOUT
    mov rdx, 1
    syscall
    pop rbp
    ret

puts:
    push rbp
    mov rbp, rsp
    mov rdx, rsi
    mov rsi, rdi
    mov rax, WRITE_SYS
    mov rdi, STDOUT
    syscall
    pop rbp
    ret

init_grid:
    push rbp
    mov rbp, rsp
    mov BYTE [grid + 40*1 + 25], 0x1

    mov BYTE [grid + 40*2 + 23], 0x1
    mov BYTE [grid + 40*2 + 25], 0x1

    mov BYTE [grid + 40*3 + 13], 0x1
    mov BYTE [grid + 40*3 + 14], 0x1
    mov BYTE [grid + 40*3 + 21], 0x1
    mov BYTE [grid + 40*3 + 22], 0x1
    mov BYTE [grid + 40*3 + 35], 0x1
    mov BYTE [grid + 40*3 + 36], 0x1

    mov BYTE [grid + 40*4 + 12], 0x1
    mov BYTE [grid + 40*4 + 16], 0x1
    mov BYTE [grid + 40*4 + 21], 0x1
    mov BYTE [grid + 40*4 + 22], 0x1
    mov BYTE [grid + 40*4 + 35], 0x1
    mov BYTE [grid + 40*4 + 36], 0x1

    mov BYTE [grid + 40*5 + 1],  0x1
    mov BYTE [grid + 40*5 + 2],  0x1
    mov BYTE [grid + 40*5 + 11], 0x1
    mov BYTE [grid + 40*5 + 17], 0x1
    mov BYTE [grid + 40*5 + 21], 0x1
    mov BYTE [grid + 40*5 + 22], 0x1

    mov BYTE [grid + 40*6 + 1],  0x1
    mov BYTE [grid + 40*6 + 2],  0x1
    mov BYTE [grid + 40*6 + 11], 0x1
    mov BYTE [grid + 40*6 + 15], 0x1
    mov BYTE [grid + 40*6 + 17], 0x1
    mov BYTE [grid + 40*6 + 18], 0x1
    mov BYTE [grid + 40*6 + 23], 0x1
    mov BYTE [grid + 40*6 + 25], 0x1

    mov BYTE [grid + 40*7 + 11], 0x1
    mov BYTE [grid + 40*7 + 17], 0x1
    mov BYTE [grid + 40*7 + 25], 0x1

    mov BYTE [grid + 40*8 + 12], 0x1
    mov BYTE [grid + 40*8 + 16], 0x1

    mov BYTE [grid + 40*9 + 13], 0x1
    mov BYTE [grid + 40*9 + 14], 0x1

    pop rbp
    ret

display_grid:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov DWORD [rbp - 8], 0          ; y = 0
.d_fory:
    cmp DWORD [rbp - 8], HEIGHT
    jge .d_endfory
    mov DWORD [rbp - 4], 0          ; x = 0
.d_forx:
    cmp DWORD [rbp - 4], WIDTH
    jge .d_endforx
    mov eax, DWORD [rbp - 8]
    imul eax, HEIGHT
    add eax, DWORD [rbp - 4]
    mov al, BYTE [grid + eax]
    test al, al
    jz .d_else
    mov rdi, char_o                 ; 'o '
    mov rsi, 2
    call puts
    jmp .d_endif
.d_else:
    mov rdi, char_dot               ; '. '
    mov rsi, 2
    call puts
.d_endif:
    add DWORD [rbp - 4], 1          ; x++
    jmp .d_forx
.d_endforx:
    mov rdi, char_nl                ; '\n'
    call putc
    add DWORD [rbp - 8], 1          ; y++
    jmp .d_fory
.d_endfory:
    leave
    ret

modulo:
    push rbp
    mov rbp, rsp
    mov eax, edi
    cdq
    mov ebx, esi
    idiv ebx
    mov eax, edx
    add eax, esi
    cdq
    idiv ebx
    mov eax, edx
    pop rbp
    ret

count_neighbors:
    push rbp
    mov rbp, rsp
    sub rsp, 16*2
    mov DWORD [rbp - 30], 0     ; int count = 0
    mov DWORD [rbp - 8], edi    ; int y
    mov DWORD [rbp - 4], esi    ; int x

    mov DWORD [rbp - 16], -1    ; int dy = -1
.cn_fory:
    mov DWORD [rbp - 12], -1    ; int dx = -1
    cmp DWORD [rbp - 16], 1
    jg .cn_endfory
.cn_forx:
    cmp DWORD [rbp - 12], 1
    jg .cn_endforx

    mov edi, DWORD [rbp - 8]    ; y
    add edi, DWORD [rbp - 16]   ; dy
    mov esi, HEIGHT
    call modulo
    mov DWORD [rbp - 24], eax   ; int iy = modulo(y + dy, HEIGHT)

    mov edi, DWORD [rbp - 4]
    add edi, DWORD [rbp - 12]
    mov esi, WIDTH
    call modulo
    mov DWORD [rbp - 20], eax   ; int ix = modulo(x + dx, WIDTH)

    mov eax, [rbp - 24]
    imul eax, HEIGHT
    add eax, [rbp - 20]
    mov al, BYTE [grid + eax]
    test al, al
    jz .cn_else
    add DWORD [rbp - 30], 1     ; count += 1
.cn_else:
    add DWORD [rbp - 12], 1     ; dx++
    jmp .cn_forx
.cn_endforx:
    add DWORD [rbp - 16], 1     ; dy++
    jmp .cn_fory
.cn_endfory:
    mov eax, [rbp - 8]
    imul eax, HEIGHT
    add eax, [rbp - 4]
    mov al, BYTE [grid + eax]
    test al, al
    jz .cn_else2
    sub DWORD [rbp - 30], 1     ; count -= 1
.cn_else2:
    mov eax, DWORD [rbp - 30]
    leave
    ret

next_gen:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov DWORD [rbp - 12], 0     ; int count = 0
    mov DWORD [rbp - 8], 0      ; int y = 0
.ng_fory:
    mov DWORD [rbp - 4], 0      ; int x = 0;
    cmp DWORD [rbp - 8], HEIGHT
    jge .ng_endfory
.ng_forx:
    cmp DWORD [rbp - 4], WIDTH
    jge .ng_endforx

    mov edi, DWORD [rbp - 8]    ; y
    mov esi, DWORD [rbp - 4]    ; x
    call count_neighbors
    mov DWORD [rbp - 12], eax   ; count = count_neighbors(y, x)

    ; find index [y][y]
    mov eax, [rbp - 8]
    imul eax, HEIGHT
    add eax, [rbp - 4]
    mov ebx, eax
.if_1:
    mov al, BYTE [grid + ebx]
    test al, al
    jnz .if_2
.if_11:
    cmp DWORD [rbp - 12], 3
    jne .if_2
    mov BYTE [grid_next + ebx], 1   ; grid_next[y][x] = 1

.if_2:
    mov al, BYTE [grid + ebx]
    test al, al
    jz .endif_2

    cmp DWORD [rbp - 12], 2
    je .short
    cmp DWORD [rbp - 12], 3
    jne .endif_2
.short:
    mov BYTE [grid_next + ebx], 1   ; grid_next[y][x] = 1
.endif_2:
    add DWORD [rbp - 4], 1          ; x++
    jmp .ng_forx

.ng_endforx:
    add DWORD [rbp - 8], 1          ; y++
    jmp .ng_fory

.ng_endfory:
; copy grid_next to grid
    mov DWORD [rbp - 8], 0          ; int y = 0
.cp_fory:
    cmp DWORD [rbp - 8], HEIGHT
    jge .cp_endfory
    mov DWORD [rbp - 4], 0          ; int x = 0
.cp_forx:
    cmp DWORD [rbp - 4], WIDTH
    jge .cp_endforx

    ; find index [y][x]
    mov eax, [rbp - 8]
    imul eax, HEIGHT
    add eax, [rbp - 4]

    mov cl, BYTE [grid_next + eax]
    mov BYTE [grid + eax], cl       ; grid[y][x] = grid_next[y][x]
    mov BYTE [grid_next + eax], 0   ; grid_next[y][x] = 0

    add DWORD [rbp - 4], 1          ; x++
    jmp .cp_forx
.cp_endforx:
    add DWORD [rbp - 8], 1          ; y++
    jmp .cp_fory
.cp_endfory:
    leave
    ret

sleep:
    mov ecx, 300000000
.sleep_loop:
    dec ecx
    jnz .sleep_loop
    ret

_start:
    call init_grid
.loop:
    call display_grid
    call sleep

    mov rdi, escape_msg
    mov rsi, QWORD [len_escape]
    call puts

    call next_gen
    jmp .loop

    ; exit(0)
    mov rax, EXIT_SYS
    mov rdi, 0
    syscall

section .data
char_o:
    db 'o '
char_dot:
    db '. '
char_nl:
    db 10
escape_msg:
    ; "\033[2J\033[0;0f"
    db 27, 91, 50, 74, 27, 91, 48, 59, 48, 102
len_escape:
    dq $ - escape_msg
grid:
    times 1600 db 0
grid_next:
    times 1600 db 0

dochar:
    call cprint
sprint:
    mov eax, [esi]
    lea esi, [esi+1]
    cmp al, 0
    jne dochar
    add byte [ypos], 1
    mov byte [xpos], 0
    ret
 
cprint:
    mov ah, 0x0F
    mov ecx, eax
    movzx eax, byte [ypos]
    mov edx, 160
    mul edx
    movzx ebx, byte [xpos]
    shl ebx, 1
 
    mov edi, 0xb8000
    add edi, eax
    add edi, ebx
 
    mov eax, ecx
    mov word [ds:edi], ax
    add byte [xpos], 1
 
    ret

printreg32:
    mov edi, outstr32
    mov eax, [reg32]
    mov esi, hexstr
    mov ecx, 8
 
hexloop:
    rol eax, 4
    mov ebx, eax
    and ebx, 0x0f ;
    mov bl, [esi + ebx]
    mov [edi], bl
    inc edi
    dec ecx
    jnz hexloop
 
    mov esi, outstr32
    call sprint
 
    ret
 
xpos db 0
ypos db 0
hexstr db '0123456789ABCDEF'
outstr32 db '00000000', 0
reg32 dd 0
 
[ORG 0x7c00]

; reset data registers to 0x0000
start:   xor ax, ax 
   mov ds, ax
   mov ss, ax
   ; move 2000h past read
   mov sp, 0x9c00

   ; set nointerrupt bit
   cli
   push ds

   ; load global descriptor table
   lgdt [gdtinfo]

   ; switch to 32 bit protected mode
   mov eax, cr0
   or al,1
   mov cr0, eax
   mov bx, 0x08
   mov ds, bx

   ; go back to 16 bit mode to set voodoo mode
   and al, 0xFE
   ; side note, only need to set this bit to switch between 16 and 32 bit mode
   ; I forcefully set it to make sure
   mov cr0, eax

   ; restore old stack segments
   pop ds
   sti

   mov bx, 0x0f01
   ; set 32 bit offset for video memory, needed later for non bios display
   mov eax, 0x0b8000
   mov word [ds:eax], bx

   ; continually reset to attain voodoo mode
   jmp $

gdtinfo:
   dw gdt_end - gdt - 1
   dd gdt
gdt        dd 0x0
flatdesc    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:

   times 510-($-$$) db 0
   db 0x55
   db 0xAA
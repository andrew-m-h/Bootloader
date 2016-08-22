BITS 16
        mov ax, 0x500
        mov ds, ax

        mov si, welcome

        call print_string
        call print_nl

        jmp $

        welcome db 'hello from section 2', 0

print_string:
        mov ah, 0x0E            ; int 10h 'print char' function

.loop:
        lodsb                   ; Get character from string and place in AL
        cmp al, 0
        je .done                ; If the character is null, exit
        int 0x10                ; call interrupt and print it
        jmp .loop

.done:
        ret

print_nl:
        mov ax, 0x0E0D  ; ah=0x0E (print char subfunc), al=0x0D carriage return (CR)
        int 0x10
        mov al, 0x0A    ; al = 0x0A line feed (LF)
        int 0x10
        ret

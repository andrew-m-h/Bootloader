BITS 16

_start:
        mov ax, 0x07C0          ; set data segment pointer
        mov ds, ax

        mov si, message         ; si generally holds pointers
                                ; lodsb reads the char at (ds:si) into al and increments si

        call print_string       ; Call our string-printing routine
        call print_nl

        mov ax, 0x500           ; 0x500 is where then next boot sector is placed
        mov es, ax              ; ES is a segment register, holding the address
        xor bx, bx              ; int 13h reads the sector pointer at (es:bx)

        mov ah, 0x02            ; int 13h subfunction 2h reads memory
        mov al, 0x1             ; read 1 sector
        mov dx, 0x0             ; head=0, drive=0 (dh:dl)
        mov ch, 0x0             ; cylinder=0
        mov cl, 0x2             ; sector=2

        int 0x13                ; read next sector into 0x500

        jc error                ; the carry flag is set on error (jump to handler)

        mov si, jumping
        call print_string
        call print_nl

        jmp 0x500               ; jump to second code segment

        ; these strings are included within the .text segment
        ; they must not be allowed to execute
        message db 'hello from section 1', 0
        jumping db 'jumping to next boot sector', 0
        errormsg db 'Error occurred', 0

error:
        ; print generic error message
        mov si, errormsg
        call print_string
        call print_nl

        ; print ascii code representation of error code (stored in ah)
        mov al, ah
        add al, 65d ; convert code to printable ascii (ascii A-Z)
        mov ah, 0x0E
        int 0x10
        call print_nl

        jmp $

        ;; print null terminated string to terminal
        ;; AH selects video services sub function
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

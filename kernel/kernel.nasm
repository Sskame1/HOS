bits 16
org 0x7E00

kernel_main:
    ; Настройка видеорежима
    mov ax, 0x0003      ; Текстовый режим 80x25
    int 0x10
    
    ; Вывод сообщения
    mov si, msg_hello   ; Указатель на строку
    call print_string
    
    ; Бесконечный цикл
    jmp $

; Функция вывода строки
print_string:
    mov ah, 0x0E        ; Функция вывода символа
.loop:
    lodsb               ; Загрузка символа из SI в AL
    cmp al, 0           ; Конец строки?
    je .done
    int 0x10            ; Вывод символа
    jmp .loop
.done:
    ret

; Данные
msg_hello db 'Hello, World from Hentai OS Kernel on NASM!', 0xD, 0xA, 0

times 512-($-$$) db 0   ; Выравнивание до 512 байт
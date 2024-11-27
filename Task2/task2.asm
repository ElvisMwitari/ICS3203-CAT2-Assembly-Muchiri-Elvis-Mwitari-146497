section .data
    prompt db "Enter 5 integers: ", 0        ; Prompt message
    prompt_len equ $ - prompt
    reversed_msg db "Reversed array: ", 0    ; Output message
    reversed_msg_len equ $ - reversed_msg
    arr times 5 dd 0                          ; Space for 5 integers

section .bss
    input resb 16                             ; Buffer for input

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4                                 ; Syscall: write
    mov ebx, 1                                 ; File descriptor: stdout
    mov ecx, prompt                            ; Message to print
    mov edx, prompt_len                        ; Message length
    int 0x80                                   ; Invoke syscall

    ; Read 5 integers
    mov ecx, 5                                 ; Loop counter
    lea esi, [arr]                             ; Load address of the array
read_loop:
    ; Clear the input buffer
    mov eax, 3                              ; Syscall: read
    mov ebx, 0                              ; File descriptor: stdin
    lea edx, [input]                        ; Input buffer
    mov edi, 16                             ; Max input length
    int 0x80                                ; Invoke syscall

    ; Check if the read was successful
    test eax, eax                            ; If eax is 0, no bytes were read
    jz reverse_loop

    ; Null-terminate the input string
    mov byte [input + eax - 1], 0           ; Null-terminate the string

    ; Convert input to integer
    call atoi                               ; Convert input to integer
    mov [esi], eax                          ; Store integer in the array
    add esi, 4                              ; Move to the next integer

    dec ecx                                 ; Decrement loop counter
    jnz read_loop                           ; Repeat if not zero

reverse_loop:
    cmp esi, edi                               ; Check if pointers crossed
    jge end_reverse                            ; If crossed or equal, end loop

    mov eax, [esi]                             ; Load arr[start] into eax
    mov ebx, [edi]                             ; Load arr[end] into ebx
    mov [esi], ebx                             ; Swap arr[start] with arr[end]
    mov [edi], eax                             ; Swap arr[end] with arr[start]

    add esi, 4                                 ; Move start pointer forward
    sub edi, 4                                 ; Move end pointer backward
    jmp reverse_loop

end_reverse:

    ; Print reversed array message
    mov eax, 4                                 ; Syscall: write
    mov ebx, 1                                 ; File descriptor: stdout
    mov ecx, reversed_msg                      ; Message to print
    mov edx, reversed_msg_len                  ; Message length
    int 0x80                                    ; Invoke syscall

    ; Print reversed array
    lea esi, [arr]
    mov ecx, 5                                 ; Loop counter
print_loop:
    mov eax, [esi]                             ; Load integer to print
    call itoa                                  ; Convert integer to string
    mov eax, 4                                 ; Syscall: write
    mov ebx, 1                                 ; File descriptor: stdout
    lea edx, [input]                           ; Buffer with converted string
    mov ecx, 16                                ; Max string length
    int 0x80                                    ; Invoke syscall

    add esi, 4                                 ; Move to the next integer
    dec ecx                                    ; Decrement loop counter
    jnz print_loop                             ; Repeat if not zero

    ; Exit program
    mov eax, 1                                 ; Syscall: exit
    xor ebx, ebx                               ; Exit code 0
    int 0x80

; Convert string to integer
atoi:
    xor eax, eax          ; Clear eax (result)
    xor ebx, ebx          ; Clear ebx (temporary digit)
    xor ecx, ecx          ; Clear ecx (sign)
    
    mov edx, input        ; Pointer to the input buffer

    ; Check for optional '+' or '-'
    mov cl, [edx]         ; Load first character
    cmp cl, '-'           
    jne check_plus
    mov ecx, -1           ; Set sign to negative
    inc edx               ; Move to the next character
    jmp start_conversion
check_plus:
    cmp cl, '+'
    jne start_conversion
    inc edx               ; Ignore '+' and move to the next character

start_conversion:
    xor ecx, ecx          ; Default sign is positive
convert_loop:
    mov cl, [edx]         ; Load the current character
    cmp cl, 0             ; Check for null terminator
    je end_atoi           ; End if null terminator

    sub cl, '0'           ; Convert ASCII to numeric value
    cmp cl, 9
    ja end_atoi           ; End if character is not a valid digit

    mov ebx, eax          ; Store the current result in ebx
    imul eax, eax, 10     ; Multiply eax by 10
    add eax, ebx          ; Add the digit value

    inc edx               ; Move to the next character
    jmp convert_loop

end_atoi:
    cmp ecx, -1           ; Check if the sign is negative
    jne done_atoi
    neg eax               ; Negate the result for negative numbers
done_atoi:
    ret

; Convert integer to string
itoa:
    xor ebx, ebx          ; Clear ebx
    xor ecx, ecx          ; Clear ecx
    mov edx, input        ; Pointer to the output buffer

    cmp eax, 0
    jge skip_negative
    mov byte [edx], '-'   ; Add '-' for negative numbers
    inc edx               ; Move buffer pointer
    neg eax               ; Convert to positive
skip_negative:
    xor ebx, ebx
store_digits:
    xor edx, edx          ; Clear edx for division
    mov ebx, 10
    div ebx               ; Divide eax by 10, quotient in eax, remainder in edx
    add dl, '0'           ; Convert digit to ASCII
    push dx               ; Store digit on stack (reversed order)
    inc ecx               ; Increment digit counter
    test eax, eax         ; Check if quotient is 0
    jnz store_digits

write_digits:
    pop dx
    mov [edx], dl         ; Write ASCII character to buffer
    inc edx
    loop write_digits

    mov byte [edx], 0     ; Null-terminate the string
    ret
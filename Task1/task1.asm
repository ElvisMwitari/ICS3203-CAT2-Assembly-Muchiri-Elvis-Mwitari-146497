section .data
    prompt db "Enter a number (e.g., -5, 0, 10): ", 0
    positive_msg db "POSITIVE", 0
    negative_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    number resb 4

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4             
    mov ebx, 1             
    lea ecx, [prompt]
    mov edx, 32
    int 0x80

    ; Read user input
    mov eax, 3             
    mov ebx, 0             
    lea ecx, [number]
    mov edx, 4
    int 0x80

    ; Convert input (assumes number is entered correctly)
    mov esi, number        
    xor eax, eax           
    xor ebx, ebx           

    ; Check for negative sign
    cmp byte [esi], '-'
    jne parse_digits       
    inc esi                
    mov bl, 1              

parse_digits:
    xor ecx, ecx           

parse_loop:
    mov cl, byte [esi]     
    cmp cl, 0              
    je finalize_conversion 
    sub cl, 48             
    imul eax, eax, 10      
    add eax, ecx           
    inc esi                
    jmp parse_loop         

finalize_conversion:
    cmp bl, 0              
    je classification
    neg eax                

classification:
    ; Classify the number
    cmp eax, 0
    je zero_case           
    jl negative_case       
    jmp positive_case      

zero_case:
    ; Display "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 4
    int 0x80
    jmp program_end

negative_case:
    ; Display "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, negative_msg
    mov edx, 8
    int 0x80
    jmp program_end

positive_case:
    ; Display "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, positive_msg
    mov edx, 8
    int 0x80

program_end:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

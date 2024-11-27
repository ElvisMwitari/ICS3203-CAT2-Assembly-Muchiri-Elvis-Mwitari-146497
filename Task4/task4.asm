section .data
    prompt db "Enter sensor value: ", 0
    motor_on_msg db "Motor is ON", 10, 0
    motor_off_msg db "Motor is OFF", 10, 0
    alarm_msg db "Alarm is triggered!", 10, 0
    no_alarm_msg db "No alarm", 10, 0

section .bss
    sensor_value resb 4   

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4             
    mov ebx, 1             
    lea ecx, [prompt]
    mov edx, 19            
    int 0x80

    ; Read user input (sensor value as a string)
    mov eax, 3             
    mov ebx, 0             
    lea ecx, [sensor_value]
    mov edx, 4             
    int 0x80

    ; Convert input (ASCII to integer)
    lea esi, [sensor_value] 
    xor eax, eax            
    xor ebx, ebx            

convert_loop:
    movzx ecx, byte [esi]   
    cmp ecx, 10              
    je done_conversion       
    sub ecx, 48              
    imul eax, eax, 10        
    add eax, ecx             
    inc esi                  
    jmp convert_loop

done_conversion:
    ; Perform logic based on sensor value
    cmp eax, 100
    jg trigger_alarm

    cmp eax, 50
    jg turn_on_motor

    jmp stop_motor

trigger_alarm:
    ; Display "Alarm is triggered!"
    mov eax, 4
    mov ebx, 1
    lea ecx, [alarm_msg]
    mov edx, 20
    int 0x80
    jmp exit

turn_on_motor:
    ; Display "Motor is ON"
    mov eax, 4
    mov ebx, 1
    lea ecx, [motor_on_msg]
    mov edx, 14
    int 0x80
    jmp exit

stop_motor:
    ; Display "Motor is OFF"
    mov eax, 4
    mov ebx, 1
    lea ecx, [motor_off_msg]
    mov edx, 15
    int 0x80
    jmp exit

exit:
    ; Exit program
    mov eax, 1             
    xor ebx, ebx           
    int 0x80

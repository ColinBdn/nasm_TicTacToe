global _main
extern _printf
extern _system
extern _scanf
extern _getch



section .data
    header_s db "----------------------------------------------------", 10
             db "---------------                      ---------------", 10
             db "-------------   nasm win32 TicTacToe   -------------", 10
             db "---------------                      ---------------", 10
             db "----------------------------------------------------", 10,10,10,10, 0


    clsCommand db "cls", 0
    inputFormat db "%c", 0

    table db ' ',' ',' '
        db ' ',' ',' '
        db ' ',' ',' '

    tableString db "-------------", 10
                db "| %c | %c | %c |", 10
                db "-------------", 10
                db "| %c | %c | %c |", 10
                db "-------------", 10
                db "| %c | %c | %c |", 10
                db "-------------", 10,0

    askInput_s db 10,"enter the case number (between 1 and 9) : ",0
    wrongInput_s db "wrong input please try again...",10,0
    winMessage db 10,"'%c' win !!",0

section .bss
    userInput resb 1




section .text

_main:
    call main
    call _getch
    ret


main:
    call clearConsole
    push header_s
    call _printf
    add esp, 4
    call printTable

    mov ecx, 0
    mainLoop:

        scan:
            push ecx                    ; save ecx (iterator)
            push askInput_s
            call _printf
            add esp, 4
            push userInput
            push inputFormat
            call _scanf
            add esp, 8
            pop ecx                     ; restore ecx
            
            mov eax, [userInput]        ; put the user input (case id) into eax
            cmp al, '1'                 ; check if the first number is between 1 and 9
                jl wrongInput
            cmp al, '9'
                jg wrongInput

            sub eax, 48                 ; converting eax to an int
            sub eax, 1                  ; the case 1 is at the index/offset 0 so we sub 1 to eax
            cmp byte [table+eax], ' '   ; check if the case (table+eax) is empty (if not scan again)
                jne wrongInput
            jmp afterWrongInput

        wrongInput:
            push ecx
            push wrongInput_s
            call _printf
            add esp, 4
            pop ecx
            jmp scan
        afterWrongInput:

        mov ebx, ecx
        and ebx, 1                      ; check if iterator is even
        jz pair

        mov byte [table+eax], 'o'       ; if iterator odd
        jmp clearBuffer

        pair:
        mov byte [table+eax], 'x'       ; if iterator even

        clearBuffer:                    ; clear the input buffer (removing all char after the case number)
            push ecx
            push userInput
            push inputFormat
            call _scanf
            add esp, 8
            pop ecx
            cmp byte [userInput], 10
            jne clearBuffer


        push ecx
        call clearConsole
        push header_s
        call _printf
        add esp, 4
        call printTable
        pop ecx

        push ecx
        call checkWin
        pop ecx
        cmp al, 'o'
        je ending
        cmp al, 'x'
        je ending

        inc ecx
        cmp ecx, 9                      ; compare the iterator and 9
        jl mainLoop                     ; loop again if iterator is less than 9


    ending:
    push eax
    push winMessage
    call _printf
    add esp, 8
    ret



checkWin:
    push ebp
    mov ebp, esp

    lh1:                        ;test line horizontal 1
    mov al, [3*0+table+0]
    mov bl, [3*0+table+1]
    mov cl, [3*0+table+2] 
    cmp al, ' '
    je lh2
    cmp al, bl
    jne lh2
    cmp bl, cl
    jne lh2
    jmp epilogue

    lh2:                        ;test line horizontal 2
    mov al, [3*1+table+0]
    mov bl, [3*1+table+1]
    mov cl, [3*1+table+2] 
    cmp al, ' '
    je lh3
    cmp al, bl
    jne lh3
    cmp bl, cl
    jne lh3
    jmp epilogue
    
    lh3:                        ;test line horizontal 3
    mov al, [3*2+table+0]
    mov bl, [3*2+table+1]
    mov cl, [3*2+table+2] 
    cmp al, ' '
    je lv1
    cmp al, bl
    jne lv1
    cmp bl, cl
    jne lv1
    jmp epilogue


    lv1:                        ;test line vertical 1
    mov al, [3*0+table+0]
    mov bl, [3*1+table+0]
    mov cl, [3*2+table+0] 
    cmp al, ' '
    je lv2
    cmp al, bl
    jne lv2
    cmp bl, cl
    jne lv2
    jmp epilogue

    lv2:                        ;test line vertical 2
    mov al, [3*0+table+1]
    mov bl, [3*1+table+1]
    mov cl, [3*2+table+1] 
    cmp al, ' '
    je lv3
    cmp al, bl
    jne lv3
    cmp bl, cl
    jne lv3
    jmp epilogue

    lv3:                        ;test line vertical 3
    mov al, [3*0+table+1]
    mov bl, [3*1+table+1]
    mov cl, [3*2+table+1] 
    cmp al, ' '
    je d1
    cmp al, bl
    jne d1
    cmp bl, cl
    jne d1
    jmp epilogue

    d1:                        ;test diagonal 1
    mov al, [3*0+table+0]
    mov bl, [3*1+table+1]
    mov cl, [3*2+table+2] 
    cmp al, ' '
    je d2                               
    cmp al, bl
    jne d2
    cmp bl, cl
    jne d2
    jmp epilogue

    d2:                        ;test diagonal 2
    mov al, [3*0+table+2]
    mov bl, [3*1+table+1]
    mov cl, [3*2+table+0] 
    cmp al, ' '
    je noWinner                               
    cmp al, bl
    jne noWinner
    cmp bl, cl
    jne noWinner
    jmp epilogue

    noWinner:
    mov eax, 0
    jmp epilogue

    epilogue:
    mov esp, ebp
    pop ebp
    ret



printTable:
    push dword [table+8]
    push dword [table+7]
    push dword [table+6]
    push dword [table+5]
    push dword [table+4]
    push dword [table+3]
    push dword [table+2]
    push dword [table+1]
    push dword [table]
    push tableString
    call _printf
    add	esp, 4
    add esp, 36
    ret


clearConsole:
    push clsCommand
    call _system
    add esp, 4
    ret

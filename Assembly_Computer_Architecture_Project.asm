; AUTHOR : KLISMANN DE OLIVEIRA BARROS
; PROGRAM: PRIME NUMBER IDENTIFIER IN MASM32
;            ASSEMBLY CODE


.686 ; -> INSTRUCTION PACKAGE SUPORTED BY MY PROGRAM
.model flat, stdcall ; -> MODEL THAT THE LINEAR MEMORY ADDRESS WILL FOLLOW
option casemap :none ; -> ACTIVATING CASE SENSITIVE RO CALL WINDOWS API FUNCTIONS
; -> LIBRARY INCLUDING
    include \masm32\include\windows.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\user32.inc
    include \masm32\include\msvcrt.inc
    include \masm32\include\masm32.inc
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\msvcrt.lib
    includelib \masm32\lib\masm32.lib
    include \masm32\macros\macros.asm

.data   ; -> DECLARING INITIAL DATA OR CONSTANTS TO BE PROCESSED
   divide dw 0 ; Used to confirm if the number is divisible by this one
   number dw ? ; User input
   again dw ? ; Confirm another run
   return dw ? ; Simulating the C return instruction
   
   inputString db 50 dup(0) ; User input processing to convert string -> integer
   inputHandle dd 0
   console_count dd 0
   size_of_string dd 0
   
   inputString1 db 50 dup(0) ; User confirmation of choice conversion string -> integer
   inputHandle1 dd 0
   console_count1 dd 0
   size_of_string1 dd 0


.code ; -> BEGIN OF THE CODE SECTION

main: ; -> Obrigatory main function
    ;EAX => number
    ;ECX => counter 
    ;EDX => rest of division, as recomended on the manual

    input_number:
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov inputHandle, eax

        invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

        string_correct:
            mov esi, offset inputString
            next:
                mov al, [esi]
                inc esi
                cmp al, 48
                jl end
                cmp al, 58
                jl next
            end:
                dec esi
                xor al, al
                mov [esi], al
        
        ; Substituting the scanf function
        invoke atodw, addr inputString
        mov number, EAX 

        mov divisor, 0

        cmp number, 1
        je not_prime
        
        mov ECX, 1

    ; Crucial part of the code
    main_loop:
        mov EAX, number
        xor EDX, EDX ; Making the rest of division (EDX:EAX) 0
        div ECX ; Divisor for each number unitil the user input

        inc ECX

    confirm_entry_loop:
        cmp ECX, number 
        ja end_loop

        cmp EDX, 0
        je add_one_counter
        jne main_loop
        
    add_one_counter: ; Incrementing divisor 
        inc divisor
        jmp main_loop

    end_loop:

        cmp divisor, 2 ; Maximum amount of divisors = 2
        jbe prime
        ja not_prime

        prime:
            mov return, 1 ; Return 'true' if prime
            printf("Prime number\n")
            add esp, 4
            jmp finish_program
        not_prime:
            mov return, 0 ; Return 'false' if not prime
            printf("Not prime\n")
            add esp, 4

    finish_program:
        printf("Another try? (1-Y/0-N): ")
        add esp, 4

        again_answer:
            invoke GetStdHandle, STD_INPUT_HANDLE
            mov inputHandle1, eax

            invoke ReadConsole, inputHandle1, addr inputString1, sizeof inputString1, addr console_count1, NULL

            want_or_not:
                mov esi, offset inputString1
                next1:
                    mov al, [esi]
                    inc esi
                    cmp al, 48
                    jl finish1
                    cmp al, 58
                    jl next1
                finish1:
                    dec esi
                    xor al, al
                    mov [esi], al
        
            invoke atodw, addr inputString1
            mov again, EAX

        cmp again, 0
        je stop
        jne input_number

    stop:
        invoke ExitProcess, 0 
      

end main ; - Obrigatory directive to end the main function
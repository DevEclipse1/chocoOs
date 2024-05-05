org 0x0
bits 16

jmp boot

%define NL 0Ah, 0Dh

welcome_text: db "Welcome to chocoOs! Type 'help' if you dont know what to do", NL, 0
prompt: db NL, "> ", 0
buffer: db 100
input_string: times 100 db 0 
empty: db "", 0

chelp: db "help", 0

cclear: db "clear", 0
chelpres: db NL, "Welcome to chocoOs help!", NL, "-> help, shows this", NL, "-> clear, clears the screen", NL, "-> shutdown, turns the computer off", NL, "-> reboot, reboots the computer", NL, "-> smiley, prints a smiley, couple of times... :)", NL, "-> chocolate, prints a chocolate", NL, "-> poopos, poopos reference?",NL,0

cshutdown: db "shutdown", 0

creboot: db "reboot", 0

csmiley: db "smiley", 0

cchocolate: db "chocolate", 0

cpoopos: db "poopos", 0

cpaintos: db "paintos", 0

smileyface: db NL, ":)", NL, ":)", NL, ":)", NL, ":)", NL, ":)", NL, ":)", NL, ":)", NL, ":)", NL, 0

chocolateart: db NL, "## ## ##", NL, NL, "## ## ##", NL, NL,  "## ## ##", NL, NL, "## ## ##", NL, NL, "## ## ##", 0

pooposresponse: db "Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop Poop ", NL, 0

boot:
    ; video mode 3 80x25
    mov ax, 0003h
    int 10h


    ; print welcome message
    mov si, welcome_text
    call print

    ; goto the kernel
    jmp main

main:
    mov si, prompt
    call print

    call getinput

    ; check for help command

    mov si, input_string
    mov di, chelp
    cld
    mov cx, 4
    repe cmpsb
    je help

    ; check for clear command

    mov si, input_string
    mov di, cclear
    cld
    mov cx, 3
    repe cmpsb
    je clear

    ; check for shutdown command

    mov si, input_string
    mov di, cshutdown
    cld
    mov cx, 8
    repe cmpsb
    je shutdown

    ; check for reboot command

    mov si, input_string
    mov di, creboot
    cld
    mov cx, 6
    repe cmpsb
    je reboot

    ; check for smiley command
    
    mov si, input_string
    mov di, csmiley
    cld
    mov cx, 6
    repe cmpsb
    je smiley

    ; check for chocolate command
        
    mov si, input_string
    mov di, cchocolate
    cld
    mov cx, 9
    repe cmpsb
	je chocolate

	; check for chocolate command
	        
	mov si, input_string
	mov di, cpoopos
	cld
	mov cx, 6
	repe cmpsb
	je poopos
	
    jmp main    

; commands

help:
    mov si, chelpres
    call print
    jmp main

clear:
    mov ax, 0003h
    int 10h

    mov di, input_string
    mov cx, 100
    xor al, al
    rep stosb

    jmp main

shutdown:
    mov ax, 5307h
    mov bx, 0001h

    hlt

    ret

reboot:
    mov ax, 00
    int 19h

smiley:
	mov si, smileyface
	call print
	
	jmp main
		
	ret

chocolate:
	mov si, chocolateart
	call print

	jmp main

	ret

poopos:
	mov si, pooposresponse
	call print

	jmp poopos

; input

waitkey:
    mov ah, 0h
    int 16h
    ret

getinput:
    mov di, input_string
    mov cx, 100
    xor al, al
    rep stosb

    mov di, input_string
    mov cx, 0

get_input_loop:
    mov ah, 0h
    int 16h

    cmp al, 0Dh
    je return

    mov [di], al
    mov ah, 0Eh
    int 10h

    inc di
    inc cx
    cmp cx, 100
    je return
    jmp get_input_loop

; output

print:
    lodsb
    or al, al
    jz return
    
    mov ah, 0Eh 
    int 10h
    
    jmp print
    
; other

return:
    ret

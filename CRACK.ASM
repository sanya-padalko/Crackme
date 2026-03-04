.model tiny
.code
org 100h

PASS_LEN	equ 9h		; len of password
RED_YELL	equ 4ah
GREEN_YELL	equ 2ah

locals @@

start:		mov ah, 0ah
		push cs
		pop ds
		mov dx, offset buffer
		int 21h

		call check
		cmp flag, 0h
		jne @@no_access
		mov dx, offset access
		mov ah, 09h
		int 21h
		mov ah, GREEN_YELL
		call fill
		jmp @@end

  @@no_access:	mov dx, offset wrong
		mov ah, 09h
		int 21h
		mov ah, RED_YELL
		call fill

  @@end:	mov ax, 4c00h
		int 21h

buffer		db 40h, 0h, 10 DUP(0h)
password	db 'coca cola', 10 DUP(0h)
flag		db 0h
wrong		db '>:(', 40 DUP(0h), '$'
access		db ':)', 40 DUP(0h), '$'

check		proc

		mov cx, PASS_LEN
		push cs cs
		pop ds es
		mov ax, offset buffer
		add ax, 2h
		mov di, ax
		mov ax, offset password
		mov si, ax

  @@reps:	mov al, es:[di]
		mov dl, ds:[si]
		cmp al, dl
		je @@cont
		mov flag, 1h
		jmp @@break

  @@cont:	inc si
		inc di
		dec cx
		jne @@reps

  @@break:	ret
		endp

fill		proc

		mov dh, ah
		mov ax, 0b814h
		mov es, ax
		mov bx, -1h
		mov ax, 2160d

  @@reps:	add bx, 2h
		mov byte ptr es:[bx], dh
		dec ax
		jne @@reps

		ret
		endp

end start
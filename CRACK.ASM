.model tiny
.code
org 100h

RED_YELL	equ 4ah
GREEN_YELL	equ 2ah
PRIME_DIGIT	equ 7h

locals @@

start:		mov ah, 0ah
		mov dx, offset buffer
		int 21h

		call CalcPass
		call CalcBuff

		mov ax, hash_pass
		cmp ax, hash_buff
		jne @@not_eq
		mov flag, 1h

		
  @@not_eq:	cmp flag, 0h
		je @@no_access
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

password	db 'coca cola$'
buffer		db 0ffh, 0h, 20 DUP(0h)
hash_pass	dw 0h
hash_buff	dw 0h
flag		db 0h
access		db 'Right password :)', 20 DUP(0h), '$'
wrong		db 'Wrong password >:(', 20 DUP(0h), '$'

CalcPass	proc

		mov bx, offset password
		call GetLen

		mov bx, offset password
		call CalcHash
		mov hash_pass, ax

		ret
		endp



CalcBuff	proc

		mov ch, 0h
		mov bx, offset buffer
		inc bx
		mov cl, byte ptr [bx]
		inc bx
		
		call CalcHash
		mov hash_buff, ax

		ret
		endp



CalcHash	proc

		mov si, bx
		mov ax, 0h
  @@nxt_symb:	
		mov dl, byte ptr [si]
		mov dh, 0h
		add ax, dx
		mov bx, PRIME_DIGIT
		mul bx
		inc si
		dec cx
		jne @@nxt_symb

		mov bx, si

		ret
		endp

GetLen		proc

		mov cx, 0h
  @@nxt_symb:	
		cmp byte ptr [bx], '$'
		je @@break
		inc bx
		inc cx
		jmp @@nxt_symb

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
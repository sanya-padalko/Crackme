.model tiny
.code
org 100h

RED_YELL	equ 4ah
GREEN_YELL	equ 2ah
PRIME_DIGIT	equ 7h

locals @@

start:
		jmp main

password	db 'ronaldo better than coca cola$'
screen_clear	db 0dh, 0ffh DUP(0h)
buffer		db 0ffh, 0h, 30 DUP(0h)
flag		db 0h
hash_pass	dw 0h
hash_buff	dw 0h
access		db 'Access granted :)', 20 DUP(0h), '$'
wrong		db 'Access denied >:(', 20 DUP(0h), '$'

;=====================================================
main:		mov ah, 0ah
		mov dx, offset buffer
		int 21h

		call CalcPass
		call CalcBuff

		mov ax, hash_pass
		cmp ax, hash_buff
		jne @@not_eq
		mov flag, 1h

  @@not_eq:
  		cmp flag, 0h
		je denied

		jmp granted

  end_main:
  		mov ax, 4c00h
		int 21h
;-----------------------------------------------------



;=====================================================
granted:
		call ClearScreen
		mov dx, offset access
		mov ah, 09h
		int 21h
		mov ah, GREEN_YELL
		call Fill
		jmp end_main
;-----------------------------------------------------



;=====================================================
denied:
		call ClearScreen
		mov dx, offset wrong
		mov ah, 09h
		int 21h
		mov ah, RED_YELL
		call Fill
		jmp end_main
;-----------------------------------------------------



;=====================================================
; Clearing screen from input string
;=====================================================
ClearScreen	proc

		lea si, buffer
		mov bh, 0h
		mov bl, byte ptr [si + 1]
		add bl, 0ah

		mov screen_clear[bx], 0dh
		mov screen_clear[bx + 1], '$'
		lea dx, screen_clear
		mov ah, 09h
		int 21h

		ret
		endp
;-----------------------------------------------------



;=====================================================
; Calcing hash of password
;=====================================================
CalcPass	proc

		mov bx, offset password
		call GetLen

		mov bx, offset password
		call CalcHash
		mov hash_pass, ax

		ret
		endp
;-----------------------------------------------------



;=====================================================
; Calcing hash of string from buffer
;=====================================================
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
;-----------------------------------------------------



;=====================================================
; Getting hash of string, which start in [BX], and
; has length = CX
;=====================================================
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
;-----------------------------------------------------



;=====================================================
; Getting length of string, which ended '$'
;=====================================================
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
;-----------------------------------------------------



;=====================================================
; Filling the entire screen in one color (in AH)
;=====================================================
Fill		proc

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
;-----------------------------------------------------

end start

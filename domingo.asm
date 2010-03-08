extern printf

SECTION .data
fmt:	db "%d",10,0
marzo:	db "El dia %d de Marzo de %d sera domingo de resurrecion",10,0
abril:	db "El dia %d de Abril de %d sera domingo de resurrecion",10,0
noyear:	db "Lo sentimos, no es posible calcular el dia de pascua en ese año",10,0

;this is the only value to be changed... set the year you want:_________
year:	dd 2016
;_______________________________________________________________________

SECTION .bss
a:		resd 1
b:		resd 1
c:		resd 1
d:		resd 1
e:		resd 1
M:		resd 1
N:		resd 1

SECTION .text
	global main
	
main:
	push	ebp
	mov		ebp,esp		;prologe
	
	mov		eax,[year]	;EAX contains the year
	call	get_M_N		;calculate M and N
	
	mov		ebx,19		;
	call	module		;
	mov		[a],ecx		;a = EAX module 19
	
	mov		ebx,4		;
	call	module		;
	mov		[b],ecx		;b = EAX module 4
	
	mov		ebx,7		;
	call	module		;
	mov		[c],ecx 	;c = EAX module 7
	
	push	eax			;save oirignal year
						;IMPORTAN!!: this will stay on the stack,
						;so there's no need to pop it back to print
						;the year!!! yeee-peeee!!!
	
	mov		eax,[a]		;EAX = a
	mov		ebx,19		;EBX = 19
	mul		ebx			;EAX = EAX * EBX
	add		eax,[M]		;Dont forget M is a pointer!!
	mov		ebx,30		;EBX = 30
	call	module		;ECX = EAX module EBX
	mov		[d], ecx	;d = ((19 * a) + M) module 30
	
	mov		eax,[b]		;EAX = b
	mov		ebx,2		;EBX = 2
	mul		ebx			;EAX = 2*b
	mov		ecx,eax		;ECX = EAX = (2*b)
	mov		eax,[c]		;EAX = c
	mov		ebx,4		;EBX = 4
	mul		ebx			;EAX = 4*c
	add		ecx,eax		;ECX = ECX + EAX = (2*b) + (4*c)
	mov		eax,[d]		;EAX = d
	mov		ebx,6		;EBX = 6
	mul		ebx			;EAX = 6*d
	add		ecx,eax		;ECX = ECX + EAX = (2*b) + (4*c) + (6*d)
	add		ecx,[N]		;ECX = ECX + N = (2*b) + (4*c) + (6*d) + N
	mov		eax,ecx		;EAX = (2*b) + (4*c) + (6*d) + N
	mov		ebx,7
	call 	module		;ECX = EAX module 7
	mov		[e],ecx		;e = ((2*b) + (4*c) + (6*d) + N) module 7
	
	mov		eax,[d]		;EAX = d
	add		eax,[e]		;EAX = d+e
	mov		ebx,10
	cmp		eax,ebx
	jge		on_april 	;if d+e >= 10 it will be  on_april
						;else, it will be on march
						
	mov		ecx,[d]		;
	add		ecx,[e]		;
	add		ecx,22		;ECX = d+e+22
	
	push	ecx			
	push	marzo
	call	printf		;print pascua (on March)
	jmp		exit
	
on_april:
	mov		ecx,[d]
	add		ecx,[e]
	sub		ecx,9		;ECX = d+e-9
	
	mov		edx,26
	cmp		ecx,edx		;ECX == 26?
	je		on26
	
	mov		edx,25
	cmp		ecx,edx		;ECX == 25?
	je		on25
	
	push	ecx
	push	abril
	call	printf
	jmp		exit

on26:					;if ECX is 26, then ECX = 19
	mov		ecx,19
	push	ecx
	push	abril
	call	printf
	jmp		exit
	
on25:					;if ECX is 25
	mov		eax,[d]
	mov		ebx,28
	cmp		eax,ebx		;d == 28?
	jne		original25	;if not pascua is still on d+e-9.
	
	mov		eax,[e]
	mov		ebx,6
	cmp		eax,ebx		;e == 6?
	jne		original25	;if not pascua is still on d+e-9.
	
	mov		eax,[a]
	mov		ebx,10
	cmp		eax,ebx		;a > 10?
	jle		original25	;if not pascua is still on d+e-9.
	
	mov		ecx,18		;if (ECX == 25 && d == 28 && e == 6 && a > 10),
	push	ecx			;pascua is on the 18th.
	push	abril
	call	printf
	jmp		exit
original25:
	push	ecx
	push	abril
	call	printf		;ECX still holds d+e-9
	jmp		exit
;_______________________________________________________________________




;calculates eax module ebx and returns the module in ecx _______________
module: 				
	push	ebp			;
	mov		ebp,esp		;Prologue
	
	push	eax
	push	ebx
	cmp		eax,ebx
	jl		end_module
again:
	sub		eax,ebx
	cmp		eax,ebx
	jge		again
end_module:
	mov		ecx,eax		;return value goes in ecx
	pop		ebx			;restore original values for ebx and eax
	pop		eax
	
	leave				;Epilogue
	ret
;_______________________________________________________________________
	
	
	
	
	
;calculates M and N depending on the year in EAX _______________________
get_M_N:
	push	ebp			;
	mov		ebp,esp		;prologue
	
	mov		ebx,2200
	cmp		eax,ebx		;EAX > 2200?
	jge		ge2200
	mov		ebx,2100
	cmp		eax,ebx		;EAX > 2100?
	jge		ge2100
	mov		ebx,1900
	cmp		eax,ebx		;EAX > 1900?
	jge		ge1900
	mov		ebx,1800
	cmp		eax,ebx		;EAX > 1800?
	jge		ge1800
	mov		ebx,1700
	cmp		eax,ebx		;EAX > 1700?
	jge		ge1700
	mov		ebx,1583
	cmp		eax,ebx		;EAX > 1583?
	jge		ge1583
	jmp		not_possible
ge2200:					;Y=2200-2299, M=25, N=0
	mov		ebx,2300
	cmp		eax,ebx		;if Y >= 2300, not possible
	jge		not_possible
	mov		dword [M],25	
	mov		dword [N],0
	jmp		end_get_M_N
ge2100:					;Y=2100-2199, M=24, N=6
	mov		dword [M],24
	mov		dword [N],6
	jmp		end_get_M_N
ge1900:					;Y=1900-2099, M=24, N=5
	mov		dword [M],24
	mov		dword [N],5
	jmp		end_get_M_N
ge1800:					;Y=1800-1899, M=23, N=4
	mov		dword [M],23
	mov		dword [N],4
	jmp		end_get_M_N
ge1700:					;Y=1700-1799, M=23, N=3
	mov		dword [M],23
	mov		dword [N],3
	jmp		end_get_M_N
ge1583:					;Y=1583-1699, M=22, N=2
	mov		dword [M],22
	mov		dword [N],2
	jmp		end_get_M_N
not_possible:
	push	noyear
	call	printf
	jmp		exit
end_get_M_N:
	leave				;epilogue
	ret					;
;_______________________________________________________________________





;exits the program _____________________________________________________
exit:					
	mov		eax,1
	mov		ebx,0
	int		80h

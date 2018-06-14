data segment
str1 db 0ffh,?,300 dup(?)
str2 db 300 dup(?)
CRLF 	DB  0DH,0AH,'$'	
data ends
code segment
assume cs:code,ds:data
start:
mov ax,data
mov ds,ax
lea dx,str1

mov ah,0ah
int 21h
lea dx,CRLF
mov ah,09h
int 21h
mov cl,str1+1
xor ch,ch
mov si,cx
inc si
std
mov di,0
l1:
lodsb
mov str2[di],al
inc di
loop l1

mov bl,str1+1
xor bh,bh
mov str2[bx],'$'

lea dx,str2
mov ah,09h

int 21h

mov ah,4ch
int 21h
code ends
end start

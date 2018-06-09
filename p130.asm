assume cs:code,ds:data
data segment
db 'BaSiC'
db 'iNfOrMaTiOn'
data ends
code segment
start:
  mov ax,data
  mov ds,ax
  mov bx,0;设置偏移地址
  mov cx,5;循环五次
s:
  mov al,[bx]
  and al,11011111b;转为大写字母 大写字母第五位为0
  mov [bx],al
  inc bx
  loop s

  mov bx,5
  mov cx,11
s0:
  mov al,[bx]
  or  al,00100000b;转为小写字母 小写字母第五位为1
  mov [bx],al
  inc bx
  loop s0

  mov ax,4c00h
  int 21h
code ends
end  start

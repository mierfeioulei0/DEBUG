data segment
	file  db 'pis.bmp',00;位于当前文件夹下bmp图片文件
	head  db 54 dup(0);位图信息头以及文件头部分
	color db 1024 dup(0);调色板
	datas db 64000 dup(0);图片数据信息部分
	errword db 'ERROR!',13,10,'$';文件操作错误提示信息
	handle1 dw ?;保存文件号
data ends
stacks segment stack
	dw 256 dup(?)
	top label word
stacks ends
code segment 
	assume cs:code,ss:stacks,ds:data
	main proc far
	
	mov ax,data
	mov ds,ax
	mov ax,stacks
	mov ss,ax
	lea sp,top
	
	;只读方式打开文件
	mov ah,3dh
	mov al,00h
	lea dx,file
	int 21h
	jc error
	
	;将文件读入数据缓冲区
	mov handle1,ax;bx=文件代号
	mov bx,handle1
	mov ah,3fh
	mov cx,0fe36h;cx=读取的字节数，即图片文件大小
	lea dx,head
	int 21h
	jc error
	
	;设置显示模式 256色，320*200像素
	mov ax,0013h
	int 10h
	
	;设置调色板
	mov cx,256
	mov bl,0
	mov di,0
l1:
	mov al,bl
	mov dx,03c8h;dx=端口号 03C8 r/w VGA PEL address write mode
	out dx,al

	mov dx,03c9h;dx=端口号 03C9 r/w VGA PEL data register

	push cx
	mov cl,2
	;位图中调色板存放格式:BGR
	mov al,color[di+2];red
	shr al,cl
	out dx,al		

	mov al,color[di+1];green
	shr al,cl
	out dx,al

	mov al,color[di];blue
	shr al,cl
	out dx,al

	pop cx
	add di,4
	inc bl
	loop L1
	
	;es段显存地址首地址
	mov ax,0a000h;显存地址(0A000:0000~0A000:0F9FF)
	mov es,ax

	;循环写入显存	
	lea si,datas;si定位图像数据首地址  	

	mov cx,200;设置外层循环
loop1:
	mov ax,cx
	dec ax;将循环次数赋予ax并减1，因为是从第0行开始，第200行为199

	push cx ;要设置内循环保护外循环cx，将其入栈

	mov cx,320
	mul cx ;将行数乘列数得到第199行首地址
	mov bx,ax ;将ax赋予bx作为基址
	mov di,0 ;di从0开始，定位列数
loop2:
	mov al,[si] ;读取8位图像数据存入al
	mov es:[bx+di],al ;将图像数据写入已定位的显存地址
	inc si			;指向下一个数据
	inc di;列数加一，定位下一像素
	loop loop2

	pop cx;内循环结束，恢复外循环cx出栈

	loop loop1

	jmp exit
	
error:
	lea dx,errword
	mov ah,9
	int 21h

exit:
	mov ah,4ch
	int 21h
	
	main endp
code ends
	end main



.model small
.stack 100h
.data
	menushape db '--Display Shape Menu--', 13, 10, '$'
	option1 db '1. Diamond', 13, 10, '$'
	option2 db '2. Rectangle', 13, 10, '$'
	option3 db '3. Circle', 13, 10, '$'
	option4 db '4. Square', 13, 10, '$'
	option5 db '5. Triangle', 13, 10, '$'
	option6 db '6. Exit', 13, 10, '$'
	inchoice db 'Enter your choice(1-6): $'
	invalidChoice db 'Invalid choice! Try again.', 13, 10, '$'
	invalidEnter db 'Invalid input, Must press Enter!', 13, 10, '$'
	newline db 13, 10, '$'
	numb db ?
	eod db ?
	star db ?
	blank db ?
.code

MAIN PROC
	mov ax,@data
	mov ds,ax

mmenu:				; main menu
	mov ah,09
	lea dx,menushape	; Display menu
	int 21h

	lea dx,option1		; Display selection 1
	int 21h

	lea dx,option2		; Display selection 2
	int 21h

	lea dx,option3		; Display selection 3
	int 21h

	lea dx,option4		; Display selection 4
	int 21h

	lea dx,option5		; Display selection 5
	int 21h

	lea dx,option6		; Display selection 6
	int 21h

dmch:				; display main choice
	mov ah,09
	lea dx,inchoice		; Display input part
	int 21h

rmch:				; read main choice
	mov ah,01		; read the input
	int 21h
	sub al,'0'
	mov numb,al

	mov ah,01
	int 21h
	mov eod,al
	cmp eod,8
	je backspace

	mov ah,09
	lea dx,newline
	int 21h
	cmp eod,13
	jne mnl1

	jmp mcond

mnl1:				; menu newline 1
	mov ah,09
	lea dx,newline
	int 21h
	jmp invch

backspace:
	dec numb
	mov ah,02
	mov dl,' '
	int 21h
	mov dl,8
	int 21h

	jmp rmch

mcond:				; main condition
	cmp numb,1
	je diamond

	cmp numb,2
	je jump

	cmp numb,3
	je jump

	cmp numb,4
	je jump

	cmp numb,5
	je jump

	cmp numb,6
	je jump

invch:
	mov ah,09
	lea dx,invalidChoice
	int 21h
	lea dx,newline
	int 21h
	jmp mmenu

mnl2:
	mov ah,09
	lea dx,newline
	int 21h
        jmp mmenu       

jump:			; function that jump to shape
	jmp jump1

diamond:
	mov bx,1	
	mov cx,5	

D1:
	push cx		
	mov ah,02	
	mov dl,32
	
D2:
	int 21h		
	loop D2		

	mov cx,bx	
	mov dl,'*'

D3:
	int 21h		
	loop D3		

	mov ah,02	
	mov dl,10	
	int 21h		
	mov dl,13	
	int 21h

	add bx,2				

	pop cx		
	loop D1
	
dbhf:
	mov cx,4	
	mov bh,7	
	mov bl,2	

	mov star,bh	
	mov blank,bl	

D4:
	cmp blank,0
	je D5
	mov ah,02	
	mov dl,32
	int 21h		
	dec blank
	jmp D4

D5:
	mov ah,02
	mov dl,'*'
	int 21h
	dec star
	cmp star,0
	jne D5

D6:
	mov ah,02
	mov dl,10
	int 21h
	mov dl,13
	int 21h

	sub bh,2
	mov star,bh

	inc bl
	mov blank,bl

	loop D4
	jmp mnl2

jump1:				; function jump to shape
	cmp numb,2
	je rectangle

	cmp numb,3
	je circle

	jmp jump2

rectangle:
	mov ah, 6
    	mov al, 0
    	mov bh, 0000
    	mov ch, 0
    	mov cl, 0
    	mov dh, 24
    	mov dl, 79
    	int 10h

    	mov ah, 6
    	mov al, 10
    	mov bh, 0111
    	mov ch, 0
    	mov cl, 0
    	mov dh, 20
    	mov dl, 15
    	int 10h
	
	jmp mnl2

jumpmn1:			; function jump to newline
	jmp mnl2

circle:
	mov bh,5
	mov bl,7
	mov cx,8

	mov star,bh
	mov blank,bl

C1:
	cmp blank,0
	je C2
	mov ah,02
	mov dl,32
	int 21h
	dec blank
	jmp C1

C2:
	mov ah,02
	mov dl,'*'
	int 21h
	dec star
	cmp star,0
	jne C2

C3:
	mov ah,02
	mov dl,10
	int 21h
	mov dl,13	
	int 21h
	jmp ccond

ccond:			;circle condition
	cmp cx,8
	je sa1		;1st run prepare for 2nd section
	cmp cx,7
	je sa2		;2nd run prepare for 3rd section
	cmp cx,6
	je sa3		;3rd run prepare for 4th section
	cmp cx,5
	je upd		;4th run prepare for 5th section
	cmp cx,4
	je sa4		;5th run prepare for 6th section
	cmp cx,3
	je sa5		;6th run prepare for 7th section
	cmp cx,2
	je sa6		;7th run prepare for 8th section
	cmp cx,1
	je C4
	cmp cx,0
	je C4

C4:
	loop C1
	jmp mnl2

sa1:				; -' 'x1,+*x2,edit to line 4, 3rd time loop
	sub bl,3
	mov blank,bl
	add bh,6
	mov star,bh
	jmp C4
				; -' 'x3,+*x6,edit to line 2, 1st time loop(normal run = 1st loop)
sa2:
	sub bl,2
	mov blank,bl
	add bh,4
	mov star,bh
	jmp C4
				; -' 'x2,+*x4,edit to line 3, 2nd time loop
sa3:
	dec bl
	mov blank,bl
	inc bh
	inc bh
	mov star,bh
	jmp C4

jump2:                          ; function jump to shape
	jmp jump3


upd:				; because the blank and star value now is 0 so need to update again
	mov blank,bl
	mov star,bh
	jmp C4

sa4:
	inc bl
	mov blank,bl
	dec bh
	dec bh
	mov star,bh
	jmp C4

sa5:
	add bl,2
	mov blank,bl
	sub bh,4
	mov star,bh
	jmp C4

sa6:
	add bl,3
	mov blank,bl
	sub bh,6
	mov star,bh
	jmp C4

jump3:				; function that jump to shape
	cmp numb,4
	je square

	cmp numb,5
	je triangle

	cmp numb,6
	je exit

jumpmn2:			; function that jump to newline
	jmp jumpmn1

square:
	mov ax, 13h
    	int 10h

    	mov al, 15 
    	mov ah, 0Ch 


    	mov cx, 100
    	mov dx, 100


    	draw_top:
        	int 10h
        	inc cx
        	cmp cx, 150
        	jne draw_top

    	mov cx, 150
   	draw_right:
        	int 10h
        	inc dx
        	cmp dx, 150 
        	jne draw_right

    	mov dx, 150
    	draw_bottom:
        	int 10h
        	dec cx
        	cmp cx, 100
        	jne draw_bottom


    	mov cx, 100
    	draw_left:
        	int 10h
        	dec dx
        	cmp dx, 100
        	jne draw_left

    	mov ah, 00h
    	int 16h

    	mov ax, 03h
    	int 10h
	jmp jumpmn2

triangle:
	mov bx,1
	mov cx,6

T1:
	push cx
	mov ah,02
	mov dl,32

T2:
	int 21h
	loop T2

	mov cx,bx
	mov dl,'*'

T3:
	int 21h
	loop T3

	mov ah,02
	mov dl,10
	int 21h
	mov dl,13
	int 21h

	add bx,2
	pop cx
	loop T1
	jmp jumpmn2

exit:
	mov ah,4ch
	int 21h

MAIN ENDP
END MAIN

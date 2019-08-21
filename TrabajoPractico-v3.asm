
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
jmp inicio

;Datos        
    hundle dw ?;No esta definido su valor.-Inicialmente-.   
    path_archivo2 db "C:\archivo3.txt", 0; El archivo almacenado en: C:\emu8086\vdrivers\C
    path_archivo3 db "C:\preguntas2.txt", 0  El archivo almacenado en: C:\emu8086\vdrivers\C                                                            
    path_archivo4 db "c:\archivo_ganado.txt", 0 El archivo almacenado en: C:\emu8086\vdrivers\C
    linea_enmemoria db 1440 dup(?)
    ganado_archivo db 1440 dup(?)  
    hundle3 dw ?
    cant db 8
    vec db 20 dup(?)
    tablero db 1440 dup(?)
    aleatoria db 4
    leer_preguntas db 720 dup (?)
    hundle2 dw ?
    cantEnter db 0
    inicioEnterFila db 0
    inicioEnterCol  db 0
    finEnterFila db 0
    finEnterCol db 0
    seRespondio db 0
    vidas db 3
    sonIguales db 0
    seGano db 0
    respuesta1 dw "B","A","J","O"
    respuesta2 dw "M","A","Q","U","I","N","A"
    respuesta3 dw "I",'N',"S","T","R","U","C","C","I","O","N","E","S"
    respuesta4 dw "R","E","G","I","S","T","R","O","S"
    respuesta5 dw "M","E","M","O","R","I","A"
    respuesta6 dw "A","D","D"
    respuesta7 dw "J","M","P"
    respuesta8 dw "C","O","M","A"
    respuesta9 dw "E","T","I","Q","U","E","T","A","S"
    respuesta10 dw "P","R","O","C","E","D","I","M","I","E","N","T","O","S" 
    numeroDePregunta db 0
    hasGanado db "H","A","S"," ","G","A","N","A","D","O","$"
    hasPerdido db "H","A","S"," ","P","E","R","D","I","D","O","$" 
    flagEspacio db 0
    filaPregunta db 16
    columnaPregunta db 0
    tamanioPregunta dw 80 
    respuesta dw 16 dup(0)
    noJugo db 0
    esCorrecta2 db "L","A"," ","R","E","S","P","U","E","S","T","A"," ","E","S"," ","C","O","R","R","E","C","T","A"," "," ","$"
    esIncorrecta db "L","A"," ","R","E","S","P","U","E","S","T","A"," ","E","S"," ","I","N","C","O","R","R","E","C","T","A","$"
    resOk db 0
    vidas3 db "V","I","D","A","S"," ","R","E","S","T","A","N","T","E","S",":"," ","3","$"
    vidas2 db "V","I","D","A","S"," ","R","E","S","T","A","N","T","E","S",":"," ","2","$"
    vidas1 db "V","I","D","A","S"," ","R","E","S","T","A","N","T","E","S",":"," ","1","$"
    
    
inicio: 

    call abrir_archivo
    call leer_archivo_tablero
    call generar_tablero2
    call abrir_preguntas
    call leer_archivo_preguntas
    call abrir_ganador
    call leer_archivo_ganador
    call mostrar_tablero

cicloRespuestas:
    cmp vidas,3
    je mostrarVidas3
    cmp vidas,2
    je mostrarVidas2
    cmp vidas,1
    je mostrarVidas1
   yaPusoVida:
    cmp noJugo,0
    je sigue1
    cmp resOk,1
    je  respondioBien
    mov dh, 6
    mov dl, 2
    call SetCursor
    mov ah,9
    mov dx, offset esIncorrecta
    int 21h
    jmp sigue1
   respondioBien:
    mov dh, 6
    mov dl, 2
    call SetCursor
    mov ah,9
    mov dx, offset esCorrecta2
    int 21h    
   sigue1:
    mov resOk,0     
    cmp vidas,0
    je GameOver
    cmp seRespondio,1
    je verificacion
    call mover_cursor
    jmp cicloRespuestas
  verificacion:
    inc noJugo
    call compara_respuesta    
    cmp sonIguales,1
    jne cicloRespuestas      
    call cambiar_pregunta
    cmp seGano,1
    je YouWin 
    jmp cicloRespuestas
  mostrarVidas3:
    mov dh, 0
    mov dl, 2
    call SetCursor
    mov ah,9
    mov dx, offset vidas3
    int 21h
    jmp yaPusoVida
  mostrarVidas2:
    mov dh, 0
    mov dl, 2
    call SetCursor
    mov ah,9
    mov dx, offset vidas2
    int 21h
    jmp yaPusoVida
  mostrarVidas1:
    mov dh, 0
    mov dl, 2
    call SetCursor
    mov ah,9
    mov dx, offset vidas1
    int 21h
    jmp yaPusoVida
GameOver:
mov dh, 0
mov dl, 0
call SetCursor
call mostrar_Final
mov dh, 8
mov dl, 32
call SetCursor
mov ah,9
mov dx, offset hasPerdido
int 21h

ret


YouWin:
mov dh, 0
mov dl, 0
call SetCursor
call mostrar_Final
mov dh, 8
mov dl, 32
call SetCursor
mov ah,9
mov dx, offset hasGanado
int 21h

ret



proc generar_tablero2
    
    mov SI, 0
    mov BP, 0
    mov DI, 0      
    
  leer_fila: 
    cmp linea_enmemoria[SI],'0'
    je poner_letra_aleatoria
    mov ah,linea_enmemoria[SI]
    mov tablero[BP],AH 
    mov AX, 0 
    inc SI
    inc BP
    cmp SI,1439
    je fin_tablero 
    jmp leer_fila
  poner_letra_aleatoria:
    call letra_aleatoria 
    mov tablero[BP], AH     
    mov AX, 0 
    inc SI
    inc BP 
    jmp leer_fila 
   fin_tablero:
    mov tablero[BP], '$'
    ret
    
endp 
      
proc letra_aleatoria
    siCero:
    mov AX,0
    mov AH,2Ch 
    int 21h
    cmp DL,0
    je siCero
    mov AH,0
    mov AL,DL
    div aleatoria
    add AL,65 
    mov AH,AL
    mov CX,0
    mov DX,0
    ret
endp

proc calcular_Pregunta
    
    mov AX,tamanioPregunta
    mul numeroDePregunta
    mov BX,AX    
    ret
endp

proc abrir_ganador
    
    mov AL, 00h; Modo de acceso - (0) lectura
                                 ;(1) escritura
                                 ;(2) escritura y lectura.
    mov DX, offset path_archivo4
    
    mov AH, 3dh; Codigo de libreria para abrir archivo.
    int 21h
    
    mov hundle3, AX; En AX se retorna la direccion que nos va a permitir acceder al archivo.
    
    ret
endp 

proc leer_archivo_ganador
    mov CX, 1440
    mov BX, hundle3
    mov DX, offset ganado_archivo
    mov AH, 3fh
    int 21h
    cmp AX, 0
    ret
endp
      
proc abrir_archivo
    
    mov AL, 00h; Modo de acceso - (0) lectura
                                 ;(1) escritura
                                 ;(2) escritura y lectura.
    mov DX, offset path_archivo2
    
    mov AH, 3dh; Codigo de libreria para abrir archivo.
    int 21h
    
    mov hundle, AX; En AX se retorna la direccion que nos va a permitir acceder al archivo.
    
    ret
endp

proc leer_archivo_tablero
    mov CX, 1440   
    mov BX, hundle
    mov DX, offset linea_enmemoria
    mov AH, 3fh
    int 21h
    cmp AX, 0
    ret
endp

proc mostrar_Final   
    mov ah,9
    mov dx, offset ganado_archivo
    int 21h
    ret
endp


proc mostrar_tablero    
    mov ah,9
    mov dx, offset tablero
    int 21h
    ret
endp

proc pedir_tecla
    mov ah,0
    int 16h
    ret
endp


    

proc cambiar_pregunta
    mov dh, filaPregunta
	mov dl, columnaPregunta
	call SetCursor	
	call calcular_pregunta
    inc numeroDePregunta
    cmp numeroDePregunta,10
    je Ganador
	mov DX,0		
	mov DX, offset leer_preguntas
	add DX,BX
	mov ah,9
	int 21h
	mov sonIguales,0
	jmp sigueJugando  
   Ganador:
    mov seGano,1
   sigueJugando: 
    ret

endp

proc abrir_preguntas
    
    mov AL, 00h; Modo de acceso - (0) lectura
                                 ;(1) escritura
                                 ;(2) escritura y lectura.
    mov DX, offset path_archivo3
    
    mov AH, 3dh; Codigo de libreria para abrir archivo.
    int 21h
    
    mov hundle2, AX; En AX se retorna la direccion que nos va a permitir acceder al archivo.
    
    ret
endp 

proc leer_archivo_preguntas
    mov CX, 720
    mov BX, hundle2
    mov DX, offset leer_preguntas
    mov AH, 3fh
    int 21h
    cmp AX, 0
    ret
endp

proc mover_cursor
    
    mov dl, 35           ; Posicion del cursor columna
    mov dh, 1           ; Posicion del cursor fila
 
   main:
   
     mov ah, 00h
     int 16h
                        
     cmp al, 115     ;Compara que tecla se presiono, si es 's' baja el cursor  
     je Down
                
     cmp al, 119     ;Compara que tecla se presiono, si es 'w'  sube el cursor  
     je Up 
              
     cmp al, 97     ;Compara que tecla se presiono, si es 'a' mueve a la izquierda   
     je Left
                
     cmp al, 100     ;Compara que tecla se presiono, si es 'd' mueve a la derecha   
     je Right
                
     cmp al, 13     ;Compara que tecla se presiono, si es 'Enter'selecciona el principio y-    
     je seleccionar                                            ;el fin de una respuesta
                
     jmp main        ;Sino, no hace nada y vuelve a pedir una tecla

            
;------------------- Funciones del teclado --------------------------

   seleccionar:
     
    empiezaRespuesta:
     cmp cantEnter,1
     je terminoRespuesta            
     mov inicioEnterFila, dh
     mov inicioEnterCol, dl
     inc cantEnter
     jmp main
    terminoRespuesta:          
     mov finEnterFila, dh 
     mov finEnterCol, dl
     mov cantEnter,0
     mov seRespondio,1         
     jmp fin_de_respuesta  

   Right:
     cmp dl,54
     jge sePasoDer
     add dl, 1           ;para reposicionar el cursor columna
     call SetCursor      ;llamo al procedimiento para setear cursor
    sePasoDer:      
     jmp main
     ret

   Left:
     cmp dl,35
     jle sePasoIzq
     sub dl, 1           ;para reposicionar el cursor columna
     call SetCursor      ;llamo al procedimiento para setear cursor
    sePasoIzq:
     jmp main
     ret

   Up:
     cmp dh,0
     jle sePasoUp
     sub dh, 1           ;para reposicionar el cursor fila
     call SetCursor      ;llamo al procedimiento para setear cursor
    sePasoUp:
     jmp main
     ret

   Down:
     cmp dh,14
     jge sePasoDown
     add dh, 1           ;para reposicionar el cursor fila
     call SetCursor      ;llamo al procedimiento para setear cursor
    sePasoDown:
     jmp main
     ret
 fin_de_respuesta:
     ret
endp

proc SetCursor               
     mov ah, 02h
     mov bh, 00
     int 10h             ;Analizar esta int, que es la que posiciona el cursor
     ret
       
endp

proc compara_respuesta         
    mov ax,0   
    mov al,finEnterCol
    sub al,inicioEnterCol
    add ax,1
    mov respuesta,ax
    mov ax,0
    mov bp,0 
  cicloArmado: 
    mov dh, inicioEnterFila
	mov dl, inicioEnterCol
	mov bh, 0
	mov ah, 2
	int 10h
	mov bh,0
    mov ah,08h
    int 10h
    mov ah,0
    mov respuesta[bp],ax
    inc bp
    inc inicioEnterCol
    mov ah,finEnterCol
    cmp ah,inicioEnterCol
    ;mov ah,inicioEnterCol
    ;cmp ah,finEnterCol
    jg terminoArmado
    jmp cicloArmado
  terminoArmado:
    cmp numeroDePregunta,1
    je compara2
    cmp numeroDePregunta,2
    je compara3 
    cmp numeroDePregunta,3
    je compara4
    cmp numeroDePregunta,4
    je compara5
    cmp numeroDePregunta,5
    je compara6
    cmp numeroDePregunta,6
    je compara7 
    cmp numeroDePregunta,7
    je compara8
    cmp numeroDePregunta,8
    je compara9
    cmp numeroDePregunta,9
    je compara10
    mov ax,0    
    mov ax,respuesta    
    cmp ax,respuesta1
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara2:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta2
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara3:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta3
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara4:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta4
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara5:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta5
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara6:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta6
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara7:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta7
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara8:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta8
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara9:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta9
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
   compara10:
    mov ax,0
    mov ax,respuesta    
    cmp ax,respuesta10
    je esCorrecta
    mov sonIguales,0
    dec vidas
    jmp fin_comparacion
  esCorrecta:
    mov sonIguales,1
    mov resOk,1       
  fin_comparacion:
    mov seRespondio,0   
    ret
endp







  

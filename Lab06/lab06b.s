.data
input_file:    
    .asciz "imagem.pgm"

input_adress: 
    .skip 0x40000 # Buffer entrada


.text
open: 
    la a0, input_file    # Endereço do caminho para o arquivo
    li a1, 0             # Flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # Modo
    li a7, 1024          # Syscall open 
    ecall
    ret

read:
    la a1, input_adress  # Buffer
    li a2, 262144        # Size 
    li a7, 63            # Syscall read (63)
    ecall
    ret

setCanvasSize:
    mv a0, a3          # Width
    mv a1, a4          # Height
    li a7, 2201        # Syscall read (2201)
    ecall

setPixel:
    # a1 = registrador com 0...255
    # t4 = registrador com o ponteiro temporario para os pixels
    # a2 = valor total do registrador
    # a6 = registrador com o valor maximo (255)
    # Verifica se esta na primeira ou ultima linha do arquivo e pinta de preto
    mv t4, a5
    li a2, 0
    li t3, 0
    li t6, 8
    li a6, 255
    beq t0, t3, pixelPreto
    addi t3, a3, -1
    beq t0, t3, pixelPreto
    li t3, 0
    beq t1, t3, pixelPreto
    addi t3, a4, -1
    beq t1, t3, pixelPreto

    # Pegar o pixel do canto superior esquerdo
    sub t4, t4, a3
    addi t4, t4, -1

    # Multiplicar pelo valor do pixel (primeira linha)
    lbu a1, 0(t4)
    sub a2, a2, a1
    lbu a1, 1(t4)
    sub a2, a2, a1
    lbu a1, 2(t4)
    sub a2, a2, a1
    # Pegar o pixel do canto meio esquerdo
    add t4, t4, a3
    # Multiplicar pelo valor do pixel (meio linha)
    lbu a1, 0(t4)
    sub a2, a2, a1
    lbu a1, 1(t4)
    mul a1, a1, t6
    add a2, a2, a1
    lbu a1, 2(t4)
    sub a2, a2, a1
    # Pegar o pixel do canto inferior esquerdo
    add t4, t4, a3
    # Multiplicar pelo valor do pixel (ultima linha)
    lbu a1, 0(t4)
    sub a2, a2, a1
    lbu a1, 1(t4)
    sub a2, a2, a1
    lbu a1, 2(t4)
    sub a2, a2, a1
    bgt a2, a6, pixelBranco    # Se a2 > a6 (255) pintar de branco
    blt a2, zero, pixelPreto   # Se a2 < 0 then pintar de preto
    mv a1, a2
    
    # a1 = registrador com 0...255
    # R | G | B | ALFA
    # a1 | a1 | a1 | 255
    # a2 = 255 + a1*256 + a1*256*256 + a1*256*256*256

    li a2, 255
    sll a1, a1, 8
    add a2, a2, a1
    sll a1, a1, 8
    add a2, a2, a1
    sll a1, a1, 8
    add a2, a2, a1

    j fimPixel

    pixelPreto:
    li a2, 0x000000FF
    j fimPixel

    pixelBranco:
    li a2, 0xFFFFFFFF
    
    fimPixel:
    mv a0, t0
    mv a1, t1

    li a7, 2200 # syscall setGSPixel (2200)
    ecall
    ret


readSize:
    # Dado um input, comecar do endereco 3 e contar ate o primeiro '\n' ou ' '
    # a0 = ponteiro da posicao do input adress
    # a1 = caractere atual
    # a2 = valor numerico do numero 

    li t1, '\n'            # Salva em t1 o caractere '\n'
    li t2, ' '             # Salva em t2 o caractere ' '
    li t3, 10              # Salva em t3 os valor 10
    li a2, 0               # Salva em a2 o valor 0

    while: 
        lbu a1, (a0)        # Caractere atual
        beq a1, t1, end     # Se for '\n', termina
        beq a1, t2, end     # Se for ' ', termina
        addi a1, a1, -'0'   # Converte o caractere para inteiro
        mul a2, a2, t3      # Multiplica o valor numerico por 10
        add a2, a2, a1      # Soma o caractere ao valor numerico
        addi a0, a0, 1      # Avanca para o proximo caractere
        j while             # E continua
    end: 
        addi a0, a0, 1      # Avanca para o proximo caractere
        ret


displayImage:
    # Percorre a imagem e chama a setPixel para cada pixel
    # a0 = ponteiro da posicao do input adress recebida
    # a1 = caractere atual
    # a3 = tamanho da largura
    # a4 = tamanho da altura
    # a5 = ponteira de posicao final
    # t0 = contador de largura
    # t1 = contador de altura
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a5, a5, 4          # Avanca para o primeiro caractere da imagem
    li t0, 0                # Salva em t0 o valor 0
    li t1, 0                # Salva em t1 o valor 0
    
    whileDisplay: 
        lbu a1, (a5)        # Caractere atual
        beq t0, a3, endLine # Se t0 >= a3 Eh necessario pular para a proxima linha
        call setPixel       # Chama a setPixel
        addi a5, a5, 1      # Avanca para o proximo caractere
        addi t0, t0, 1      # Incrementa o contador de largura
        j whileDisplay        # E continua
    endLine:
        addi t1, t1, 1      # Incrementa o contador de altura
        beq t1, a4, endImage# Se t1 >= a4 Acabou a imagem 
        li t0, 0            # Reinicia o valor da linha
        #addi a5, a5, 1     # Avanca para o proximo caractere
        j whileDisplay      # E continua
        endImage:
            lw ra, 0(sp)    # Restaura o ra 
            addi sp, sp, 4  # Restaura o sp 
            ret

.globl _start

_start: 
    call open
    call read
    
    la a0, input_adress    # Endereco do input
    addi a0, a0, 3         # Pula o PX e o espaco
    call readSize   
    mv a3, a2              # Salvar em a3 o tamanho da largura
    call readSize
    mv a4, a2              # Salvar em a4 o tamanho da altura
    mv a5, a0
    call setCanvasSize
    call displayImage
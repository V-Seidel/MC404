
.text
puts:
    # Funcao puts le a string ate achar o caractere '\0' (null) e imprime na tela adicionando o caractere '\n'
    # Temos em a0 o endereco da string

    mv t0, a0              # Salva em t0 o endereco da string
    li t1, 0               # Salva em t1 o caractere '\0'
    li t2, 0               # Salva em t2 a contagem de caracteres na string
    li t3, '\n'            # Salva em t3 o caractere '\n'

    # Contagem de caracteres na string
    while_puts: 
        lbu a1, (t0)        # Caractere atual
        beq a1, t1, end_puts # Se for '\0', termina
        addi t0, t0, 1       # Avanca para o proximo caractere
        addi t2, t2, 1       # Aumenta em 1 a contagem de caracteres
        j while_puts         # E continua
    
    end_puts: 
        mv a1, a0            # a1 -> Endereco do Buffer 
        li a0, 1             # a0 -> Salvar o file descriptor
        mv a2, t2            # a2 -> Tamanho do buffer
        li a7, 64            # a7 -> Chama o sistema
        ecall
    
        # Imprime o caractere '\n'
        addi sp, sp, -16     # Aloca espaco na pilha
        sb t3, (sp)          # Salva o caractere '\n' na pilha
        li a0, 1
        mv a1, sp            # a1 -> Endereco do Buffer
        li a2, 1             # a2 -> Tamanho do buffer
        ecall               
        addi sp, sp, 16      # Desaloca espaco na pilha

    ret

gets:
    # Funcao gets le um bloca de memoria ate achar o caractere '\0' (null) e salva adicionando a mesma numa string 
    # a0 eh o endereco de memoria recebido para inserir os caracteres

    mv t0, a0              # Salva em t0 o endereco da memoria
    li t1, 0               # Salva em t1 o caractere '\0'
    mv t2, a0              # Salva em t2 o inicio do buffer
    li t3, '\n'            # Salva em t1 o caractere '\n'

    while_gets:  
        # Leitura do caracter
        li a0, 0             # a0 -> Salvar o file descriptor
        mv a1, t0            # a1 -> Endereco do Buffer
        li a2, 1             # a2 -> Tamanho do buffer
        li a7, 63            # a7 -> Chama o sistema
        ecall
        lb t4, (t0)          # Salva o caractere na memoria
        beq t4, t3, end_gets # Se for igual a \n, termina
        addi t0, t0, 1       # Avanca para o proximo caractere
        j while_gets         # E continua
    end_gets: 
        sb t1, 0(t0)        # Salva o valor de t1 no endereco de memoria
        mv a0, t2           # a0 -> Endereco do Buffer
    ret

atoi: 
    # Dado uma string, comecar do endereco e contar ate o primeiro '\n' ou ' '
    # a0 -> Endereco da string
    # Ira retornar o valor numerico em a0 

    li t1, 0            # Salva em t1 o caractere '\n'
    li t2, ' '             # Salva em t2 o caractere ' '
    li t3, 10              # Salva em t3 os valor 10
    li t4, 1               # Salva em t4 o valor 1
    li t5, '-'             # Salva em t5 o valor '-'
    li a2, 0               # Salva em a2 o valor 0

    while_atoi: 
        lbu a1, (a0)        # Caractere atual
        beq a1, t1, end_atoi# Se for '\0', termina
        beq a1, t2, espaco  # Se for ' ', pula caractere e vai e volta para o while
        beq a1, t5, negativo_atoi# Se for '-', pula caractere e vai e volta para o while
        addi a1, a1, -'0'   # Converte o caractere para inteiro
        mul a2, a2, t3      # Multiplica o valor numerico por 10
        add a2, a2, a1      # Soma o caractere ao valor numerico
        espaco:
        addi a0, a0, 1      # Avanca para o proximo caractere
        j while_atoi        # E continua
        negativo_atoi:
        addi a0, a0, 1      # Avanca para o proximo caractere
        li t4, -1           # Salva em t4 o valor -1
        j while_atoi        # E continua
    end_atoi: 
        mv a0, a2           # a0 -> Valor numerico do numero
        mul a0, a0, t4      # Multiplica o valor numerico por -1 ou 1
    ret

itoa:
    # Parametros
    # a0 = valor do numero inteiro
    # a1 = endereco da posicao inicial do buffer
    # a2 = valor da base

    li t0, 0               # Salva em t0 o numero de digitos

    # Verificar se o numero e negativo
    blt a0, zero, negativo_itoa   # Se for negativo, vai para a rotina de negativo
    mv t1, a0              # Salva em t1 o valor do numero
  
    # Saber o tamanho do numero
    while_itoa: 
        div t1, t1, a2      # Divide o numero pela base
        addi t0, t0, 1      # Aumenta em 1 a contagem de digitos 
        bnez t1, while_itoa # Se for diferente de 0, continua
        add t2, t0, a1      # Salva em t2 o endereco do ultimo digito
        sb zero, (t2)       # Salva o numero de digitos no buffer
        addi t2, t2, -1     # Avanca para o proximo caractere
        li t1, 0            # Salva em t1 o numero 0
        mv t0, a0           # Salva em t0 o valor do numero

    sb zero, 1(t2)       # Salva o caractere '\0' no ultimo digito
    # Converter o numero para string
    while_itoa2: 
        rem t3, t0, a2        # Resto da divisao do numero por 10
        addi t3, t3, '0'      # Converte o numero para caractere
        li t4, '9'            # Salva em t4 o numero 9
        blt t3, t4, hex_fim         # Se for menor que 9, vai para a rotina de maior que 9
        addi t3, t3, 'a' - '9' - 1  # Converte o numero para caractere
        
        hex_fim:
        sb t3, 0(t2)     # Salva o caractere no endereco de memoria
        div t0, t0, a2   # Divide o numero por 10
        addi t2, t2, -1  # Diminui em 1 o endereco do ultimo digito
        bnez t0, while_itoa2 # Se for diferente de 0, continua
        j end_itoa
    
    negativo_itoa:    
        addi t0, t0, 1   # Aumenta em 1 a contagem de digitos
        li t4, -1        # Salva em t4 o valor -1
        mul a0, a0, t4   # Multiplica o numero por -1
        mv t1, a0        # Salva em t1 o valor do numero
        li t4, '-'       # Salva em t4 o caractere '-'
        sb t4, 0(a1)     # Salva o caractere no endereco de memoria
        j while_itoa     # E continua
    

    end_itoa:
        mv a0, a1        # a0 -> Endereco do Buffer
        ret

time:
    addi sp, sp, -16     # Alocar espaco para salvar os registradores
    addi a0, sp, 4       # a0 -> Endereco do buffer
    li a1, 0             # a1 -> Valor do numero inteiro
    li a7, 169           # a7 -> Chamada do sistema
    ecall                # Chama o sistema
    addi a0, sp, 4     
    lw t1, 0(a0) # tempo em segundos
    lw t2, 8(a0) # fração do tempo em microssegundos
    li t3, 1000
    mul t1, t1, t3
    div t2, t2, t3
    add a0, t2, t1
    addi sp, sp, 16
    ret

sleep:
    # Salvar o RA antes da chamada da funcao time
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a0, 8(sp) 

    jal time      # Guarda o tempo atual em a0
    sw a0, 4(sp)  # Aloca o tempo atual na pilha
    add a1, a0, zero

    loop_sleep:
        sub t3, a0, a1  # t3 -> tempo atual - tempo inicial
        lw t2, 8(sp)    # t2 -> tempo inicial
        bge t3, t2, fim # Se o tempo atual for maior que o tempo inicial, sai do loop  
        jal time        # Guarda o tempo atual em a0
        lw a1, 4(sp)    # a1 -> tempo inicial
        j loop_sleep    # E continua
    fim:

    lw ra, 12(sp)
    addi sp, sp, 16
    ret

approx_sqrt:
    # Parametros
    # a0 = valor do numero inteiro
    # a1 = numero de iteracoes

    li t1, 1               # t1 <= 1 (Iteracao inicial)
    li t4, 2               # t4 <= 2 (Divisor)
    div t0, a0, t4         # t0 <= a0 / 2 (Estimativa inicial da raiz)
    
    loop:
    bge t1, a1, end_loop   # Se t1 >= t2, pula para end
    div t3, a0, t0
    add t3, t3, t0
    div t0, t3, t4
    addi t1, t1, 1
    j loop

    end_loop:
    mv a0, t0
    ret

imageFilter:
    ret

exit:
    li a7, 93
    ecall

.globl puts
.globl gets
.globl atoi  
.globl itoa
.globl time
.globl sleep
.globl approx_sqrt
.globl imageFilter
.globl exit

    
.data 
input_adress: 
    .skip 0x19

output_adress: 
    .skip 0x19
    .byte'\n' # Pula linha


.text
read:
    # a0 -> Salvar o file descriptor
    # a1 -> Endereco do buffer
    # a2 -> Tamanho do buffer
    # a7 -> Chama o sistema
    li a0, 0 
    la a1, input_adress 
    li a2, 19
    li a7, 63 
    ecall
    ret

write:
    # a0 -> Salvar o file descriptor
    # a1 -> Endereco do Buffer
    # a2 -> Tamanho do buffer
    # a7 -> Chama o sistema
    li a0, 1            
    la a1, output_adress       
    li a2, 30   
    li a7, 64           
    ecall
    ret

    
charToInt:
    li a0, 0               # Inicia o valor de a0 com 0

    addi a5, a1, 0         # t2 = a1 + a3
    lb t0, (a5)            # t0 <= input_adress (a5) 
    addi t0, t0, -48       # Subtrai 48 para converter o caractere em inteiro
    li t1, 1000            # t1 <= 1000
    mul t0, t0, t1         # t0 <= t0 * t1 
    add a0, a0, t0         # a0 <= a0 + t0

    addi a5, a5, 1         # a5 = a5 + 1
    lb t0, (a5)            # t5 <= input_adress (a1)
    addi t0, t0, -48       # Subtrai 48 para converter o caractere em inteiro
    li t1, 100             # t1 <= 100
    mul t0, t0, t1         # t0 <= t0 * t1
    add a0, a0, t0         # a0 <= a0 + t0

    addi a5, a5, 1         # a5 = a5 + 1
    lb t0, (a5)            # t5 <= input_adress (a1)
    addi t0, t0, -48       # Subtrai 48 para converter o caractere em inteiro
    li t1, 10              # t1 <= 10
    mul t0, t0, t1         # t0 <= t0 * t1
    add a0, a0, t0         # a0 <= a0 + t0

    addi a5, a5, 1         # a5 = a5 + 1
    lb t0, (a5)            # t5 <= input_adress (a1)
    addi t0, t0, -48       # Subtrai 48 para converter o caractere em inteiro
    li t1, 1               # t1 <= 10
    mul t0, t0, t1         # t0 <= t0 * t1
    add a0, a0, t0         # a0 <= a0 + t0

    ret                    # Temos em a0 o valor multiplicado por 1000

intToChar:
    
    li t0, 1000            # t0 <= 1000  
    div t3, a0, t0         # t3 <= a0 / t0  
    addi t3, t3, 48        # t3 <= t3 + 48
    addi a5, a1, 0         # a5 <= a1
    sb t3, (a5)            # output_adress <= t3
    rem a0, a0, t0         # a0 <= a0 % t0

    li t0, 100             # t0 <= 100
    div t3, a0, t0         # t3 <= a0 / t0 
    addi t3, t3, 48        # t3 <= t3 + 48
    addi a5, a5, 1         # a5 =  a5 + 1
    sb t3, (a5)            # output_adress <= t3
    rem a0, a0, t0         # a0 <= a0 % t0

    li t0, 10              # t0 <= 100
    div t3, a0, t0         # a0 <= a0 / t0 
    addi t3, t3, 48        # a0 <= a0 + 48
    addi a5, a5, 1         # a5 =  a5 + 1
    sb t3, (a5)            # output_adress <= t3
    rem a0, a0, t0         # a0 <= a0 % t0

    li t0, 1               # t0 <= 100
    div t3, a0, t0         # a0 <= a0 / t0 
    addi t3, t3, 48        # a0 <= a0 + 48
    addi a5, a5, 1         # a5 =  a5 + 1
    sb t3, (a5)            # output_adress <= t3
    rem a0, a0, t0         # a0 <= a0 % t0

    addi a5, a5, 1         # a5 =  a5 + 1
    li t0, 32
    sb t0, (a5) 

    ret

squareRoot:
    li t1, 1               # t1 <= 1 (Iteracao inicial)
    li t2, 10              # t2 <= 10 (Numero de iteracoes)
    li t4, 2               # t4 <= 2 (Divisor)
    div t0, a0, t4          # t0 <= a0 / 2 (Estimativa inicial da raiz)
    

    loop:
    bge t1, t2, end_loop   # Se t1 >= t2, pula para end
    div t3, a0, t0
    add t3, t3, t0
    div t0, t3, t4
    addi t1, t1, 1
    j loop

    end_loop:
    mv a0, t0
    ret

.globl _start

_start:
    call read
    
    call charToInt       # Converte o valor de input_adress para inteiro
    call squareRoot      # Calcula a raiz quadrada do valor de a0
    la a1, output_adress # a1 <= output_adress
    call intToChar       # Converte o valor de a0 para caractere

    la a1, input_adress 
    addi a1, a1, 5
    call charToInt       # Converte o valor de input_adress para inteiro
    call squareRoot      # Calcula a raiz quadrada do valor de a0
    la a1, output_adress # a1 <= output_adress
    addi a1, a1, 5
    call intToChar       # Converte o valor de a0 para caractere

    la a1, input_adress 
    addi a1, a1, 10
    call charToInt       # Converte o valor de input_adress para inteiro
    call squareRoot      # Calcula a raiz quadrada do valor de a0
    la a1, output_adress # a1 <= output_adress
    addi a1, a1, 10
    call intToChar       # Converte o valor de a0 para caractere

    la a1, input_adress 
    addi a1, a1, 15
    call charToInt       # Converte o valor de input_adress para inteiro
    call squareRoot      # Calcula a raiz quadrada do valor de a0
    la a1, output_adress # a1 <= output_adress
    addi a1, a1, 15
    call intToChar       # Converte o valor de a0 para caractere
    
    call write           # Escreve o valor de output_adress
    
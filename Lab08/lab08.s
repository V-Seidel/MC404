# Calcular o vetor direcao
# Rotacionar o vetor direcao em 90 graus
# Calcular o vetor ate o destino
# Fazer produto interno desses dois vetores

.section .text 
# Enderecos de memoria dos perifericos

.set STATUS_GPS,    0xFFFF0100
.set STATUS_CAMERA, 0xFFFF0101
.set STATUS_SENSOR, 0xFFFF0102
.set ANGLE_X,       0xFFFF0104
.set ANGLE_Y,       0xFFFF0108
.set ANGLE_Z,       0xFFFF010C
.set COORD_X,       0xFFFF0110  #Coordenadas do GPS no eixo X
.set COORD_Y,       0xFFFF0114  #Coordenadas do GPS no eixo Y
.set COORD_Z,       0xFFFF0118  #Coordenadas do GPS no eixo Z
.set DISTANCE,      0xFFFF011C
.set WHEEL,         0xFFFF0120  #Valores negativos volante para esquerda, positivo volante para direita
.set DIRECTION,     0xFFFF0121  #Seta a direcao do carro (1 - Frente, 0 - Desligado, -1 - Atras)
.set HAND_BREAK,    0xFFFF0122  #Seta o freio de mao (1 - Freio, 0 - Desligado)


.globl _start

get_direction_vector:
    # Funcao que calcula o vetor direcao e salva a componente x em a0 e a componente y em a1

    li t0, COORD_X #Carrega o endereco de memoria da coordenada X do GPS
    lw a3, 0(t0)   #Carrega o valor da coordenada X do GPS em a0
    li t0, COORD_Z #Carrega o endereco de memoria da coordenada Z do GPS
    lw a2, 0(t0)   #Carrega o valor da coordenada Z do GPS em a1

    li t0, DIRECTION #Carrega o endereco de memoria da direcao do carro
    sb t1, 0(t0)     #Seta a direcao do carro para frente 
    li t4, 0
    li t5, 3000
    loop_sleep1:
        addi t4, t4, 1
        bne t4, t5, loop_sleep1
    sb zero, 0(t0)   #Seta a direcao do carro para desligado

    li t0, COORD_X #Carrega o endereco de memoria da coordenada X do GPS
    lw a1, 0(t0)   #Carrega o valor da coordenada X do GPS em a2
    li t0, COORD_Z #Carrega o endereco de memoria da coordenada Z do GPS
    lw a0, 0(t0)   #Carrega o valor da coordenada Z do GPS em a3

    sub a0, a0, a2 #Calcula o vetor direcao no eixo X
    sub a1, a1, a2 #Calcula o vetor direcao no eixo Z

    ret 

rotate_direction_vector:
    # Recebe o vetor direcao no a0 e a1 e rotaciona em 90 graus (x,y) -> (y,-x)
    li t5, -1
    mul a0, a0, t5
    mv a2, a0       #Salva o valor de a0 (-x) em a2
    mv a0, a1       #Salva o valor de a1 (y) em a0
    mv a1, a2       #Salva o valor de a2 (-x) em a1
    ret 

get_destiny_vector:
    # Funcao que calcula o vetor destino e salva a componente x em a2 e a componente y em a3

    li t0, COORD_X #Carrega o endereco de memoria da coordenada X do GPS
    lw a2, 0(t0)   #Carrega o valor da coordenada X do GPS em a2
    li t0, COORD_Z #Carrega o endereco de memoria da coordenada Z do GPS
    lw a3, 0(t0)   #Carrega o valor da coordenada Z do GPS em a3

    li t2, 73     #Valor do X destino
    li t3, -19    #Valor do Z destino

    sub a2, a2, t2 #Calcula o vetor destino no eixo X
    sub a3, a3, t3 #Calcula o vetor destino no eixo Y

    ret 

get_internal_product:
    # Recebe os vetores direcao e destino nos registradores a0 e a1 e a2 e a3 respectivamente
    # e calcula o produto interno entre eles
    mul a0, a0, a2 #Calcula o produto interno no eixo X
    mul a1, a1, a3 #Calcula o produto interno no eixo Y
    add a0, a0, a1 #Soma os dois produtos internos
    ret

  
_start: 
    li t1, 1
    li t0, STATUS_GPS   #Carrega o endereco de memoria do status do GPS
    sb t1, 0(t0)        #Liga o GPS  
    
    while:
    call get_direction_vector
    call rotate_direction_vector
    call get_destiny_vector
    call get_internal_product

    # Temos em a0 o valor do produto interno entre os vetores direcao e destino
    # Se ele for menor que 0 vira a roda pra esquerda e acelera, se for maior que 0 vira a roda pra direita e acelera
    # Se for igual a 0 acelera

    bgt a0, zero, turn_left #Se o produto interno for maior que zero vira a roda pra direita
    blt a0, zero, turn_right  #Se o produto interno for menor que zero vira a roda pra esquerda
    
    li t0, DIRECTION #Carrega o endereco de memoria da direcao do carro   
    sb t1, 0(t0)     #Seta a direcao do carro para frente
    li t4, 0
    li t5, 1000
    loop_sleep2:
    addi t4, t4, 1
    bne t4, t5, loop_sleep2
    jal while

    turn_right:
    li t0, WHEEL #Carrega o endereco de memoria do volante
    li t3, 15
    sb t3, 0(t0) #Seta o volante para direita    
    jal while

    turn_left:
    li t0, WHEEL #Carrega o endereco de memoria do volante
    li t3, -15
    sb t3, 0(t0) #Seta o volante para esquerda
    jal while
    
    


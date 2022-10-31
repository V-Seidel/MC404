.data
output_adress: 
    .skip 0x19
    .byte'\n' # Pula linha
    
.text
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


.globl _start

_start: 
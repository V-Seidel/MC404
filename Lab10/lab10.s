.bss
.align 4

user_stack: 
.skip 512
user_stack_end:

stack: 
.skip 512
stack_end:

.text
.align 4
.globl _start

int_handler:
  ###### Tratador de interrupções e syscalls ######
    
    li t3, 10
    bne a7, t3, fim

    #salva o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -64 # Aloca espaço na pilha
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp) # Salva a0


    syscall:
    .set WHEEL, 0xFFFF0120   
    .set DIRECTION, 0xFFFF0121  
    li s1, DIRECTION
    li s2, WHEEL

    li t0, 2
    bge a0, t0, error
    li t0, -2
    bge t0, a0, error

    li t0, 128
    bge a1, t0, error
    li t0, -128
    bge t0, a0, error

    j end

    error:
        li a0, -1
        j fim
    end:
        sb a0, (s1)
        sb a1, (s2)
        
    li a0, 0
    fim:

    lw a1, 4(sp)
    lw a2, 8(sp) # Salva a0
    addi sp, sp, 64

  # <= Implemente o tratamento da sua syscall aqui 
  
  csrr t0, mepc  # carrega endereço de retorno (endereço 
                 # da instrução que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
  csrw mepc, t0  # armazena endereço de retorno de volta no mepc
  mret           # Recuperar o restante do contexto (pc <- mepc)
  

_start:
  la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
  csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                      # o vetor de interrupções.

  la t0, stack_end # t0 <= base da pilha
  csrw mscratch, t0 # mscratch <= t0

  la sp, user_stack_end
  # Habilita Interrupções Global
  csrr t1, mstatus # Seta o bit 3 (MIE)
  ori t1, t1, 0x8 # do registrador mstatus
  csrw mstatus, t1


  csrr t1, mie # Seta o bit 11 (MEIE)
  li t2, 0x800 # do registrador mie
  or t1, t1, t2
  csrw mie, t1

  csrr t1, mstatus # Update the mstatus.MPP
  li t2, ~0x1800 # field (bits 11 and 12)
  and t1, t1, t2 # with value 00 (U-mode)
  csrw mstatus, t1
  la t0, user_main # Loads the user software
  csrw mepc, t0 # entry point into mepc
  mret

.globl logica_controle
logica_controle:
  # implemente aqui sua lógica de controle, utilizando apenas as 
  # syscalls definidas.
    li a0, 1
    li a1, -16
    li a7, 10
    ecall
    ret

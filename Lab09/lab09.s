# Reservar espaco para as duas pilhas 
isr_stack_end: # Base da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha

pc_stack_end: # Base da pilha do programa
.skip 1024 # Aloca 1024 bytes para a pilha

.globl _start
.globl main_isr
.globl play_note
.globl isr_stack_end
.globl pc_stack_end

.globl _system_time 
_system_time: .word 0

# Configuração do sistema durante a operação de reset
_start:
    la t0, main_isr # Grava o endereço da ISR principal
    csrw mtvec, t0 # no registrador mtvec

    # Configura mscratch com o topo da pilha das ISRs.
    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0 # mscratch <= t0

    # Configura pc com o topo da pilha do PC.
    la t0, pc_stack_end # t0 <= base da pilha
    mv sp, t0 # sp <= t0

    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1

    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 3 (MIE)
    ori t1, t1, 0x8 # do registrador mstatus
    csrw mstatus, t1

    # Habilita Interrupções GPT
    li t0, 0XFFFF0100 
    li t1, 100
    sw t1, 8(t0) # Configura o valor do GPT


    jal main # Chama a função main


main_isr:
    # Salvar o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -64 # Aloca espaço na pilha da ISR
    
    sw x0, 0(sp) # Salva a0
    sw x1, 4(sp) # Salva a1
    sw x2, 8(sp) # Salva a2
    sw x3, 12(sp) # Salva a3
    sw x4, 16(sp) # Salva a4
    sw x5, 20(sp) # Salva a5
    sw x6, 24(sp) # Salva a6
    sw x7, 28(sp) # Salva a7
    sw x8, 32(sp) # Salva s0
    sw x9, 36(sp) # Salva s1
    sw x10, 40(sp) # Salva s2
    sw x11, 44(sp) # Salva s3
    sw x12, 48(sp) # Salva s4
    sw x13, 52(sp) # Salva s5
    sw x14, 56(sp) # Salva s6
    sw x15, 60(sp) # Salva s7
    sw x16, 64(sp) # Salva s8
    sw x17, 68(sp) # Salva s9
    sw x18, 72(sp) # Salva s10
    sw x19, 76(sp) # Salva s11
    sw x20, 80(sp) # Salva t3
    sw x21, 84(sp) # Salva t4
    sw x22, 88(sp) # Salva t5
    sw x23, 92(sp) # Salva t6
    sw x24, 96(sp) # Salva t7
    sw x25, 100(sp) # Salva t8
    sw x26, 104(sp) # Salva t9
    sw x27, 108(sp) # Salva t10
    sw x28, 112(sp) # Salva t11
    sw x29, 116(sp) # Salva t12
    sw x30, 120(sp) # Salva t13
    sw x31, 124(sp) # Salva t14

    # Trata a interrupção
    li t0, 0XFFFF0100 # t0 <= GPT
    li t1, 100 # t1 <= GPT
    sw t1, 8(t0) # Configura o valor do GPT

    # Incremente o contador do tempo 
    la t0, _system_time
    lw t1, 0(t0)
    addi t1, t1, 100
    sw t1, 0(t0)

    # Recupera o contexto
    lw x31, 124(sp) # Recupera t14
    lw x30, 120(sp) # Recupera t13
    lw x29, 116(sp) # Recupera t12
    lw x28, 112(sp) # Recupera t11
    lw x27, 108(sp) # Recupera t10
    lw x26, 104(sp) # Recupera t9
    lw x25, 100(sp) # Recupera t8
    lw x24, 96(sp) # Recupera t7
    lw x23, 92(sp) # Recupera t6
    lw x22, 88(sp) # Recupera t5
    lw x21, 84(sp) # Recupera t4
    lw x20, 80(sp) # Recupera t3
    lw x19, 76(sp) # Recupera s11
    lw x18, 72(sp) # Recupera s10
    lw x17, 68(sp) # Recupera s9
    lw x16, 64(sp) # Recupera s8
    lw x15, 60(sp) # Recupera s7
    lw x14, 56(sp) # Recupera s6
    lw x13, 52(sp) # Recupera s5
    lw x12, 48(sp) # Recupera s4
    lw x11, 44(sp) # Recupera s3
    lw x10, 40(sp) # Recupera s2
    lw x9, 36(sp) # Recupera s1
    lw x8, 32(sp) # Recupera s0
    lw x7, 28(sp) # Recupera a7
    lw x6, 24(sp) # Recupera a6
    lw x5, 20(sp) # Recupera a5
    lw x4, 16(sp) # Recupera a4
    lw x3, 12(sp) # Recupera a3
    lw x2, 8(sp) # Recupera a2
    lw x1, 4(sp) # Recupera a1
    lw x0, 0(sp) # Recupera a0
    
    addi sp, sp, 64 # Desaloca espaço da pilha da ISR
    csrrw sp, mscratch, sp # Troca sp com mscratch novamente
    mret # Retorna da interrupção

play_note:
    # a0 (byte) - Enable 
    # a1 (short) - Instrumento
    # a2 (byte) - Frequancia
    # a3 (byte) - Velocidade
    # a4 (short) - Duracao

    li t0, 0XFFFF0300 # t0 <= MIDI

    sh a1, 2(t0) # Salva o instrumento
    sb a2, 4(t0) # Salva a frequencia
    sb a3, 5(t0) # Salva a velocidade
    sh a4, 6(t0) # Salva a duracao

    sb a0, 0(t0) # Salva o enable

    ret


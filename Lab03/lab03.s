	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab03.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 63	# syscall read (63) 
	ecall	

	mv	a3, a0
	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 64	# syscall write (64) 
	ecall	

	#NO_APP
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	isNegativeFunction
	.p2align	2
	.type	isNegativeFunction,@function
isNegativeFunction:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	addi	a1, zero, 45
	bne	a0, a1, .LBB2_2
	j	.LBB2_1
.LBB2_1:
	addi	a0, zero, 1
	sw	a0, -12(s0)
	j	.LBB2_3
.LBB2_2:
	mv	a0, zero
	sw	a0, -12(s0)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -12(s0)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	isNegativeFunction, .Lfunc_end2-isNegativeFunction

	.globl	findLength
	.p2align	2
	.type	findLength,@function
findLength:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	mv	a0, zero
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a1, zero
	beq	a0, a1, .LBB3_3
	j	.LBB3_2
.LBB3_2:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_3:
	lw	a0, -16(s0)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	findLength, .Lfunc_end3-findLength

	.globl	charArrayToInt
	.p2align	2
	.type	charArrayToInt,@function
charArrayToInt:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	mv	a1, zero
	sw	a1, -20(s0)
	sw	a1, -24(s0)
	lw	a0, -16(s0)
	beq	a0, a1, .LBB4_2
	j	.LBB4_1
.LBB4_1:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB4_2
.LBB4_2:
	j	.LBB4_3
.LBB4_3:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a1, zero
	beq	a0, a1, .LBB4_7
	j	.LBB4_4
.LBB4_4:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 10
	beq	a0, a1, .LBB4_6
	j	.LBB4_5
.LBB4_5:
	lw	a0, -24(s0)
	addi	a1, zero, 10
	mul	a1, a0, a1
	lw	a0, -12(s0)
	lw	a2, -20(s0)
	add	a0, a0, a2
	lbu	a0, 0(a0)
	add	a0, a0, a1
	addi	a0, a0, -48
	sw	a0, -24(s0)
	j	.LBB4_6
.LBB4_6:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB4_3
.LBB4_7:
	lw	a0, -24(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	charArrayToInt, .Lfunc_end4-charArrayToInt

	.globl	reverseArray
	.p2align	2
	.type	reverseArray,@function
reverseArray:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -16(s0)
	mv	a0, zero
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	bge	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	sb	a0, -21(s0)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	lw	a2, -20(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -1(a0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lb	a0, -21(s0)
	lw	a2, -12(s0)
	lw	a1, -16(s0)
	lw	a3, -20(s0)
	sub	a1, a1, a3
	add	a1, a1, a2
	sb	a0, -1(a1)
	j	.LBB5_3
.LBB5_3:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_4:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	reverseArray, .Lfunc_end5-reverseArray

	.globl	reverseEndianess
	.p2align	2
	.type	reverseEndianess,@function
reverseEndianess:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	mv	a1, zero
	beq	a0, a1, .LBB6_2
	j	.LBB6_1
.LBB6_1:
	lw	a1, -12(s0)
	lw	a0, -20(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, -1(a1)
	j	.LBB6_2
.LBB6_2:
	lw	a0, -12(s0)
	call	reverseArray
	lw	a0, -20(s0)
	mv	a1, sp
	sw	a1, -24(s0)
	addi	a1, a0, 15
	andi	a2, a1, -16
	mv	a1, sp
	sub	a1, a1, a2
	sw	a1, -36(s0)
	mv	sp, a1
	sw	a0, -28(s0)
	mv	a0, zero
	sw	a0, -32(s0)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -32(s0)
	lw	a1, -20(s0)
	addi	a1, a1, -2
	bge	a0, a1, .LBB6_6
	j	.LBB6_4
.LBB6_4:
	lw	a0, -36(s0)
	lw	a1, -12(s0)
	lw	a2, -32(s0)
	add	a1, a2, a1
	lb	a1, 1(a1)
	add	a2, a0, a2
	sb	a1, 0(a2)
	lw	a1, -12(s0)
	lw	a2, -32(s0)
	add	a2, a1, a2
	lb	a1, 0(a2)
	sb	a1, 1(a2)
	lw	a2, -32(s0)
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -12(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB6_5
.LBB6_5:
	lw	a0, -32(s0)
	addi	a0, a0, 2
	sw	a0, -32(s0)
	j	.LBB6_3
.LBB6_6:
	lw	a0, -24(s0)
	mv	sp, a0
	addi	sp, s0, -48
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end6:
	.size	reverseEndianess, .Lfunc_end6-reverseEndianess

	.globl	completeWithZeros
	.p2align	2
	.type	completeWithZeros,@function
completeWithZeros:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -16(s0)
	addi	a1, zero, 8
	bne	a0, a1, .LBB7_2
	j	.LBB7_1
.LBB7_1:
	lw	a0, -12(s0)
	call	reverseArray
	j	.LBB7_2
.LBB7_2:
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	addi	a0, a0, -2
	sw	a0, -28(s0)
	j	.LBB7_3
.LBB7_3:
	lw	a0, -28(s0)
	lw	a1, -16(s0)
	addi	a1, a1, 1
	bge	a0, a1, .LBB7_6
	j	.LBB7_4
.LBB7_4:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB7_5
.LBB7_5:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB7_3
.LBB7_6:
	lw	a0, -20(s0)
	mv	a1, zero
	beq	a0, a1, .LBB7_8
	j	.LBB7_7
.LBB7_7:
	lw	a0, -12(s0)
	sw	a0, -32(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	j	.LBB7_8
.LBB7_8:
	lw	a0, -16(s0)
	addi	a1, zero, 8
	bne	a0, a1, .LBB7_10
	j	.LBB7_9
.LBB7_9:
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 120
	sb	a0, 2(a1)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 3(a1)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, 4(a1)
	j	.LBB7_11
.LBB7_10:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 98
	sb	a0, 0(a1)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 1(a1)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, 2(a1)
	j	.LBB7_11
.LBB7_11:
	lw	a0, -12(s0)
	call	reverseArray
	lw	a0, -12(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end7:
	.size	completeWithZeros, .Lfunc_end7-completeWithZeros

	.globl	intToChar
	.p2align	2
	.type	intToChar,@function
intToChar:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -12(s0)
	mv	a1, zero
	beq	a0, a1, .LBB8_3
	j	.LBB8_2
.LBB8_2:
	lw	a0, -12(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a2, a0, a1
	srli	a2, a2, 3
	addi	a3, zero, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	ori	a0, a0, 48
	lw	a2, -16(s0)
	lw	a3, -24(s0)
	add	a2, a2, a3
	sb	a0, 0(a2)
	lw	a0, -12(s0)
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -12(s0)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB8_1
.LBB8_3:
	lw	a0, -20(s0)
	mv	a1, zero
	beq	a0, a1, .LBB8_5
	j	.LBB8_4
.LBB8_4:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a1, a0, a1
	addi	a0, zero, 45
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB8_5
.LBB8_5:
	lw	a0, -16(s0)
	call	reverseArray
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end8:
	.size	intToChar, .Lfunc_end8-intToChar

	.globl	returnCharVal
	.p2align	2
	.type	returnCharVal,@function
returnCharVal:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	mv	a1, zero
	blt	a0, a1, .LBB9_3
	j	.LBB9_1
.LBB9_1:
	lw	a1, -16(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB9_3
	j	.LBB9_2
.LBB9_2:
	lw	a0, -16(s0)
	addi	a0, a0, 48
	sb	a0, -9(s0)
	j	.LBB9_4
.LBB9_3:
	lw	a0, -16(s0)
	addi	a0, a0, 87
	sb	a0, -9(s0)
	j	.LBB9_4
.LBB9_4:
	lbu	a0, -9(s0)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end9:
	.size	returnCharVal, .Lfunc_end9-returnCharVal

	.globl	binaryOneComplement
	.p2align	2
	.type	binaryOneComplement,@function
binaryOneComplement:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -16(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	j	.LBB10_1
.LBB10_1:
	lw	a0, -20(s0)
	addi	a1, zero, 2
	blt	a0, a1, .LBB10_7
	j	.LBB10_2
.LBB10_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB10_4
	j	.LBB10_3
.LBB10_3:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB10_5
.LBB10_4:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 49
	sb	a0, 0(a1)
	j	.LBB10_5
.LBB10_5:
	j	.LBB10_6
.LBB10_6:
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	j	.LBB10_1
.LBB10_7:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end10:
	.size	binaryOneComplement, .Lfunc_end10-binaryOneComplement

	.globl	binaryTwoComplement
	.p2align	2
	.type	binaryTwoComplement,@function
binaryTwoComplement:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	sw	a0, -20(s0)
	j	.LBB11_1
.LBB11_1:
	lw	a0, -20(s0)
	addi	a1, zero, 2
	blt	a0, a1, .LBB11_6
	j	.LBB11_2
.LBB11_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB11_4
	j	.LBB11_3
.LBB11_3:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	call	binaryOneComplement
	j	.LBB11_6
.LBB11_4:
	j	.LBB11_5
.LBB11_5:
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -20(s0)
	j	.LBB11_1
.LBB11_6:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end11:
	.size	binaryTwoComplement, .Lfunc_end11-binaryTwoComplement

	.globl	DecimalToGenericBase
	.p2align	2
	.type	DecimalToGenericBase,@function
DecimalToGenericBase:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	mv	a0, zero
	sw	a0, -28(s0)
	j	.LBB12_1
.LBB12_1:
	lw	a0, -12(s0)
	mv	a1, zero
	beq	a0, a1, .LBB12_3
	j	.LBB12_2
.LBB12_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	remu	a0, a0, a1
	call	returnCharVal
	lw	a1, -20(s0)
	lw	a2, -28(s0)
	addi	a3, a2, 1
	sw	a3, -28(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	lw	a0, -12(s0)
	divu	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB12_1
.LBB12_3:
	lw	a0, -16(s0)
	addi	a1, zero, 2
	bne	a0, a1, .LBB12_5
	j	.LBB12_4
.LBB12_4:
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 98
	sb	a0, 0(a1)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB12_8
.LBB12_5:
	lw	a0, -16(s0)
	addi	a1, zero, 16
	bne	a0, a1, .LBB12_7
	j	.LBB12_6
.LBB12_6:
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 120
	sb	a0, 0(a1)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB12_7
.LBB12_7:
	j	.LBB12_8
.LBB12_8:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	mv	a1, zero
	sb	a1, 0(a0)
	lw	a0, -24(s0)
	beq	a0, a1, .LBB12_10
	j	.LBB12_9
.LBB12_9:
	lw	a0, -20(s0)
	addi	a1, zero, 32
	mv	a2, zero
	call	completeWithZeros
	lw	a0, -20(s0)
	call	binaryTwoComplement
	j	.LBB12_11
.LBB12_10:
	lw	a0, -20(s0)
	call	reverseArray
	j	.LBB12_11
.LBB12_11:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end12:
	.size	DecimalToGenericBase, .Lfunc_end12-DecimalToGenericBase

	.globl	power
	.p2align	2
	.type	power,@function
power:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -16(s0)
	sw	a1, -20(s0)
	lw	a1, -20(s0)
	addi	a0, zero, -1
	blt	a0, a1, .LBB13_2
	j	.LBB13_1
.LBB13_1:
	addi	a0, zero, -1
	sw	a0, -12(s0)
	j	.LBB13_8
.LBB13_2:
	addi	a0, zero, 1
	sw	a0, -24(s0)
	j	.LBB13_3
.LBB13_3:
	lw	a0, -20(s0)
	mv	a1, zero
	beq	a0, a1, .LBB13_7
	j	.LBB13_4
.LBB13_4:
	lbu	a0, -20(s0)
	andi	a0, a0, 1
	mv	a1, zero
	beq	a0, a1, .LBB13_6
	j	.LBB13_5
.LBB13_5:
	lw	a1, -16(s0)
	lw	a0, -24(s0)
	mul	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB13_6
.LBB13_6:
	lw	a0, -20(s0)
	srai	a0, a0, 1
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	mul	a0, a0, a0
	sw	a0, -16(s0)
	j	.LBB13_3
.LBB13_7:
	lw	a0, -24(s0)
	sw	a0, -12(s0)
	j	.LBB13_8
.LBB13_8:
	lw	a0, -12(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end13:
	.size	power, .Lfunc_end13-power

	.globl	binaryToHex
	.p2align	2
	.type	binaryToHex,@function
binaryToHex:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 2
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	lw	a1, -16(s0)
	addi	a0, zero, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	addi	a0, zero, 120
	sb	a0, 1(a1)
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -28(s0)
	lw	a1, -12(s0)
	lw	a0, -28(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, -1(a1)
	j	.LBB14_1
.LBB14_1:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a1, zero
	beq	a0, a1, .LBB14_10
	j	.LBB14_2
.LBB14_2:
	mv	a0, zero
	sw	a0, -32(s0)
	sw	a0, -36(s0)
	j	.LBB14_3
.LBB14_3:
	lw	a1, -36(s0)
	addi	a0, zero, 3
	blt	a0, a1, .LBB14_6
	j	.LBB14_4
.LBB14_4:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	lw	a2, -36(s0)
	addi	a1, zero, 3
	sub	a2, a1, a2
	addi	a1, zero, 1
	sll	a1, a1, a2
	mul	a1, a0, a1
	lw	a0, -32(s0)
	add	a0, a0, a1
	sw	a0, -32(s0)
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB14_5
.LBB14_5:
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB14_3
.LBB14_6:
	lw	a1, -32(s0)
	addi	a0, zero, 9
	blt	a0, a1, .LBB14_8
	j	.LBB14_7
.LBB14_7:
	lw	a0, -32(s0)
	addi	a0, a0, 48
	lw	a1, -16(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB14_9
.LBB14_8:
	lw	a0, -32(s0)
	addi	a0, a0, 87
	lw	a1, -16(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB14_9
.LBB14_9:
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB14_1
.LBB14_10:
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	lw	a0, -24(s0)
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, 1(a1)
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end14:
	.size	binaryToHex, .Lfunc_end14-binaryToHex

	.globl	hexToDecimal
	.p2align	2
	.type	hexToDecimal,@function
hexToDecimal:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	sw	a0, -28(s0)
	lw	a0, -12(s0)
	call	findLength
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	lw	a1, -20(s0)
	sub	a0, a0, a1
	sw	a0, -40(s0)
	j	.LBB15_1
.LBB15_1:
	lw	a1, -40(s0)
	lw	a0, -16(s0)
	bge	a0, a1, .LBB15_11
	j	.LBB15_2
.LBB15_2:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 48
	blt	a0, a1, .LBB15_5
	j	.LBB15_3
.LBB15_3:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a1, 0(a0)
	addi	a0, zero, 57
	blt	a0, a1, .LBB15_5
	j	.LBB15_4
.LBB15_4:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	sw	a0, -36(s0)
	j	.LBB15_9
.LBB15_5:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 97
	blt	a0, a1, .LBB15_8
	j	.LBB15_6
.LBB15_6:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a1, 0(a0)
	addi	a0, zero, 102
	blt	a0, a1, .LBB15_8
	j	.LBB15_7
.LBB15_7:
	lw	a0, -12(s0)
	lw	a1, -40(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -87
	sw	a0, -36(s0)
	j	.LBB15_8
.LBB15_8:
	j	.LBB15_9
.LBB15_9:
	lw	a0, -36(s0)
	sw	a0, -44(s0)
	lw	a1, -28(s0)
	addi	a0, zero, 16
	call	power
	mv	a1, a0
	lw	a0, -44(s0)
	mul	a1, a0, a1
	lw	a0, -24(s0)
	add	a0, a0, a1
	sw	a0, -24(s0)
	lw	a0, -32(s0)
	addi	a0, a0, -1
	sw	a0, -32(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB15_10
.LBB15_10:
	lw	a0, -40(s0)
	addi	a0, a0, -1
	sw	a0, -40(s0)
	j	.LBB15_1
.LBB15_11:
	lw	a0, -24(s0)
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end15:
	.size	hexToDecimal, .Lfunc_end15-hexToDecimal

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -304
	sw	ra, 300(sp)
	sw	s0, 296(sp)
	addi	s0, sp, 304
	mv	a0, zero
	sw	a0, -12(s0)
	sw	a0, -16(s0)
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	addi	a1, s0, -104
	sw	a1, -232(s0)
	addi	a2, zero, 40
	call	read
	mv	a1, a0
	lw	a0, -232(s0)
	sw	a1, -228(s0)
	lw	a1, -228(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	lbu	a0, -103(s0)
	addi	a1, zero, 120
	bne	a0, a1, .LBB16_4
	j	.LBB16_1
.LBB16_1:
	addi	a0, s0, -104
	addi	a1, zero, 1
	sw	a1, -236(s0)
	addi	a2, zero, 3
	call	hexToDecimal
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	addi	a1, s0, -224
	mv	a2, zero
	sw	a2, -244(s0)
	call	intToChar
	lw	a3, -244(s0)
	lw	a0, -24(s0)
	addi	a1, zero, 2
	addi	a2, s0, -64
	sw	a2, -240(s0)
	call	DecimalToGenericBase
	lw	a0, -240(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -240(s0)
	add	a2, a0, a1
	addi	a1, zero, 10
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -240(s0)
	mv	a2, a0
	lw	a0, -236(s0)
	call	write
	lw	a1, -24(s0)
	addi	a0, zero, -1
	blt	a0, a1, .LBB16_3
	j	.LBB16_2
.LBB16_2:
	addi	a0, zero, 1
	sw	a0, -20(s0)
	lw	a1, -24(s0)
	mv	a0, zero
	sub	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB16_3
.LBB16_3:
	lw	a0, -24(s0)
	lw	a2, -20(s0)
	addi	a1, s0, -224
	sw	a1, -268(s0)
	call	intToChar
	lw	a0, -268(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -268(s0)
	add	a2, a0, a1
	addi	a1, zero, 10
	sw	a1, -256(s0)
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -268(s0)
	mv	a2, a0
	addi	a0, zero, 1
	sw	a0, -248(s0)
	call	write
	addi	a0, s0, -104
	sw	a0, -264(s0)
	call	findLength
	lw	a1, -264(s0)
	mv	a2, a0
	lw	a0, -248(s0)
	call	write
	lw	a0, -264(s0)
	lw	a2, -248(s0)
	addi	a1, zero, 8
	call	completeWithZeros
	lw	a0, -264(s0)
	mv	a1, zero
	sw	a1, -260(s0)
	call	reverseEndianess
	lw	a0, -264(s0)
	addi	a1, zero, -1
	addi	a2, zero, 3
	call	hexToDecimal
	lw	a2, -260(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	addi	a1, s0, -184
	sw	a1, -252(s0)
	call	intToChar
	lw	a0, -252(s0)
	call	findLength
	lw	a1, -256(s0)
	mv	a2, a0
	lw	a0, -252(s0)
	add	a2, a0, a2
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -252(s0)
	mv	a2, a0
	lw	a0, -248(s0)
	call	write
	j	.LBB16_13
.LBB16_4:
	addi	a0, s0, -104
	sw	a0, -276(s0)
	call	isNegativeFunction
	mv	a1, a0
	lw	a0, -276(s0)
	sw	a1, -20(s0)
	lw	a1, -20(s0)
	call	charArrayToInt
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	a3, -20(s0)
	addi	a1, zero, 2
	addi	a2, s0, -64
	sw	a2, -284(s0)
	call	DecimalToGenericBase
	lw	a0, -284(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -284(s0)
	add	a2, a0, a1
	addi	a1, zero, 10
	sw	a1, -280(s0)
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -284(s0)
	mv	a2, a0
	addi	a0, zero, 1
	sw	a0, -272(s0)
	call	write
	lw	a1, -276(s0)
	lw	a0, -24(s0)
	lw	a2, -20(s0)
	call	intToChar
	lw	a0, -276(s0)
	call	findLength
	lw	a1, -280(s0)
	mv	a2, a0
	lw	a0, -276(s0)
	add	a2, a0, a2
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -276(s0)
	mv	a2, a0
	lw	a0, -272(s0)
	call	write
	lw	a0, -20(s0)
	mv	a1, zero
	beq	a0, a1, .LBB16_6
	j	.LBB16_5
.LBB16_5:
	addi	a0, s0, -64
	addi	a1, s0, -144
	call	binaryToHex
	j	.LBB16_7
.LBB16_6:
	lw	a0, -24(s0)
	lw	a3, -20(s0)
	addi	a1, zero, 16
	addi	a2, s0, -144
	sw	a2, -288(s0)
	call	DecimalToGenericBase
	lw	a0, -288(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -288(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	j	.LBB16_7
.LBB16_7:
	addi	a0, s0, -144
	sw	a0, -292(s0)
	call	findLength
	lw	a1, -292(s0)
	mv	a2, a0
	addi	a0, zero, 1
	call	write
	lw	a0, -20(s0)
	mv	a1, zero
	bne	a0, a1, .LBB16_9
	j	.LBB16_8
.LBB16_8:
	addi	a0, s0, -144
	addi	a1, zero, 8
	mv	a2, zero
	call	completeWithZeros
	j	.LBB16_9
.LBB16_9:
	addi	a0, s0, -144
	addi	a1, zero, 1
	call	reverseEndianess
	lw	a0, -20(s0)
	mv	a1, zero
	bne	a0, a1, .LBB16_11
	j	.LBB16_10
.LBB16_10:
	addi	a0, s0, -144
	addi	a1, zero, -1
	addi	a2, zero, 1
	call	hexToDecimal
	sw	a0, -24(s0)
	j	.LBB16_12
.LBB16_11:
	addi	a0, s0, -144
	addi	a1, zero, -1
	addi	a2, zero, 3
	call	hexToDecimal
	sw	a0, -24(s0)
	j	.LBB16_12
.LBB16_12:
	mv	a0, zero
	sw	a0, -20(s0)
	lw	a0, -24(s0)
	lw	a2, -20(s0)
	addi	a1, s0, -184
	sw	a1, -296(s0)
	call	intToChar
	lw	a0, -296(s0)
	call	findLength
	mv	a1, a0
	lw	a0, -296(s0)
	add	a2, a0, a1
	addi	a1, zero, 10
	sb	a1, 0(a2)
	call	findLength
	lw	a1, -296(s0)
	mv	a2, a0
	addi	a0, zero, 1
	call	write
	j	.LBB16_13
.LBB16_13:
	mv	a0, zero
	lw	s0, 296(sp)
	lw	ra, 300(sp)
	addi	sp, sp, 304
	ret
.Lfunc_end16:
	.size	main, .Lfunc_end16-main

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end17:
	.size	_start, .Lfunc_end17-_start

	.ident	"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym isNegativeFunction
	.addrsig_sym findLength
	.addrsig_sym charArrayToInt
	.addrsig_sym reverseArray
	.addrsig_sym reverseEndianess
	.addrsig_sym completeWithZeros
	.addrsig_sym intToChar
	.addrsig_sym returnCharVal
	.addrsig_sym binaryOneComplement
	.addrsig_sym binaryTwoComplement
	.addrsig_sym DecimalToGenericBase
	.addrsig_sym power
	.addrsig_sym binaryToHex
	.addrsig_sym hexToDecimal
	.addrsig_sym main

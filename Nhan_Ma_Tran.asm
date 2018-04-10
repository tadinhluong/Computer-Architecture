# 2D array with Row-major
# addr = baseAddr + (rowIndex * colSize + colIndex) * dataSize

.data
	arrx: .double 0 0 0 0 0 0 0 0 0				# arrx store result of the multipication
	arry: .double 4 2 3 4 5 6 4 2 3	# arry is multiplicand
	arrz: .double 6 2 5 7 1 3 3 1 2	# arrz is multiplier
	title: .asciiz "Start...\n"
	multiplicand: .asciiz "Multiplicand:\n"
	multiplier: .asciiz "Multiplier:\n"
	result: .asciiz "Result of the multiplication:\n"
	newline: .asciiz "\n"
	space: .asciiz " "
	.eqv DATA_SIZE 8					# define DATA_SIZE
	.eqv COL_SIZE 3						# define COL_SIZE
	.eqv ROW_SIZE 3						# define ROW_SIZE
	
.text
main:
	# Prompt title
	li $v0, 4
	la $a0, title
	syscall
	# Matrix Multiplication
	la $a1, arry		# load the address of arry to $a1
	la $a2, arrz		# load the address of arrz to $a2
	la $a3, arrx		# load the address of arrx to $a3
	li $t2, 0		# j = 0	is colIndex
	li $t3, 0		# i = 0	is rowIndex
	li $t5, 0		# k = 0
	
	
loopk: 
	mul $t4, $t3, COL_SIZE	# $t4 = rowIndex * COL_SIZE
	add $t4, $t4, $t5	# 		+ colIndex
	mul $t4, $t4, DATA_SIZE	#		* DATA_SIZE
	add $t0, $a1, $t4	#		+ baseAddr
	l.d $f2, ($t0)		# $f2 = arry[i][k]
	
	mul $t4, $t5, COL_SIZE	# t4 = rowIndex * COL_SIZE
	add $t4, $t4, $t2	# 		+ colIndex
	mul $t4, $t4, DATA_SIZE # 		* DATA_SIZE
	add $s0, $a2, $t4	#		+ baseAddr
	l.d $f4, ($s0)		# $f4 = arrz[k][j]
	
	mul.d $f2, $f2, $f4	# $f2 = arry[i][k] * arrz[k][j]
	add.d $f0, $f0, $f2	# $f0 = $f0 + $f2
	
	addi $t5, $t5, 1	# k = k + 1
	beq $t5, COL_SIZE, loopj# if k = COL_SIZE endloopk
	j loopk			# if k < COL_SIZE jump to loopk

loopj:	
	li $t5, 0		# k = 0
	#li $v0, 3
	#mov.d $f12, $f0
	#syscall
	
	# x[i][j] = f0 = sum;
	mul $t4, $t3, COL_SIZE	#
	add $t4, $t4, $t2	
	mul $t4, $t4, DATA_SIZE
	add $s2, $a3, $t4
	s.d $f0, ($s2)
	
	sub.d $f0, $f0, $f0
	addi $t2, $t2, 1	# j = j + 1
	beq $t2, COL_SIZE, loopi# if colIndex == COL_SIZE jump to loop i to increase rowIndex
	#li $v0, 4
	#la $a0, space
	#syscall
	j loopk			# jump to loopj if colIndex < COL_SIZE
loopi:
	li $t2, 0		# reset the colIndex
	addi $t3, $t3, 1	# i = i + 1
	#li $v0, 4
	#la $a0, newline
	#syscall
	beq $t3, ROW_SIZE, endmul	# if i == ROW_SIZE break
	j loopk
	
	
	
endmul:	
	# Prompt multiplicand
	li $v0, 4
	la $a0, multiplicand
	syscall
	# Print all elements of array results arry
	la  $a1, arry
	li $t2, 0		# t1 is the colIndex
	li $t3, 0		# t2 is the rowIndex
	
loopjy: 	
	mul $t4, $t3, COL_SIZE	# t2 = rowIndex * colSize
	add $t4, $t4, $t2	# 		+ colIndex
	mul $t4, $t4, DATA_SIZE	#		* DATA_SIZE
	add $t0, $a1, $t4	#		+ baseAddr
	
	li $v0, 3		# print arry[i][j]
	l.d $f12, 0($t0)
	syscall
	
	addi $t2, $t2, 1	# j = j + 1
	beq $t2, COL_SIZE, loopiy	# if $t2 = COL_SIZE jump to loopjy
	
	li $v0, 4
	la $a0, space
	syscall
	
	j loopjy		# if $t2 < COL_SIZE jump to loopjy
loopiy:
	li $t2, 0		# j = 0
	addi $t3, $t3, 1	# i = i + 1
	
	li $v0, 4		# newline
	la $a0, newline
	syscall
	
	beq $t3, ROW_SIZE, endy	# if $t3 = ROW_SIZE jump to endy
	j loopjy		# if $t3 < ROW_SIZE jump to loopjy
	
endy:
	# Prompt multiplier
	li $v0, 4
	la $a0, multiplier
	syscall
	# Print all elements of array results arrx
	la $a1, arrz
	li $t2, 0		# t1 is the colIndex
	li $t3, 0		# t2 is the rowIndex
	
loopjz: 	
	mul $t4, $t3, COL_SIZE	# t2 = rowIndex * colSize
	add $t4, $t4, $t2	# 		+ colIndex
	mul $t4, $t4, DATA_SIZE	#		* DATA_SIZE
	add $t0, $a1, $t4	#		+ baseAddr
	
	li $v0, 3		# print arrx[i][j]
	l.d $f12, 0($t0)
	syscall
	
	addi $t2, $t2, 1	# j = j + 1
	beq $t2, COL_SIZE, loopiz	# if $t2 = COL_SIZE jump to loopjz
	
	li $v0, 4
	la $a0, space
	syscall
	
	j loopjz		# if $t2 < COL_SIZE jump to loopjz
loopiz:
	li $t2, 0		# j = 0
	addi $t3, $t3, 1	# i = i + 1
	
	li $v0, 4		# newline
	la $a0, newline
	syscall
	
	beq $t3, ROW_SIZE, endz	# if $t3 = ROW_SIZE jump to endx
	j loopjz		# if $t3 < ROW_SIZE jump to loopjz
endz:
	# Prompt result
	li $v0, 4
	la $a0, result
	syscall
	# Print all elements of array results arrx
	la  $a1, arrx
	li $t2, 0		# t1 is the colIndex
	li $t3, 0		# t2 is the rowIndex
	
loopjx: 	
	mul $t4, $t3, COL_SIZE	# t2 = rowIndex * colSize
	add $t4, $t4, $t2	# 		+ colIndex
	mul $t4, $t4, DATA_SIZE	#		* DATA_SIZE
	add $t0, $a1, $t4	#		+ baseAddr
	
	li $v0, 3		# print arrx[i][j]
	l.d $f12, 0($t0)
	syscall
	
	addi $t2, $t2, 1	# j = j + 1
	beq $t2, COL_SIZE, loopix	# if $t2 = COL_SIZE jump to loopjx
	
	li $v0, 4
	la $a0, space
	syscall
	
	j loopjx		# if $t2 < COL_SIZE jump to loopjx
loopix:
	li $t2, 0		# j = 0
	addi $t3, $t3, 1	# i = i + 1
	
	li $v0, 4		# newline
	la $a0, newline
	syscall
	
	beq $t3, ROW_SIZE, endx	# if $t3 = ROW_SIZE jump to endx
	j loopjx		# if $t3 < ROW_SIZE jump to loopjx
endx:
	
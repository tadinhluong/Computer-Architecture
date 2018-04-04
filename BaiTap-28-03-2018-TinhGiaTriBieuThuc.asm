# Chuong trinh nhap vao x, y
# tinh gia tri (4*x + 5)/y
.data
	Sx: 	.asciiz "\nNhap vao so x: "
	Sy: 	.asciiz "\nNhap vao so y: "
	Sz: 	.asciiz "\nNhap vao so z: "
	result: .asciiz "\n=> (4*x + 5)/y =  "
	
	nam: 	.double 5.0
	bon: 	.double 4.0
	hai: 	.double 2.0
	# ba: 	. 3.0

.text
	# in thong bao de nhap x
	li $v0, 4
	la $a0, Sx	# tai dia chi cua nhan Sx vao thanh ghi $a0
	syscall
	
	# Nhap x
	li $v0, 7	# nhap vao so kieu double
	syscall
	
	# Luu gia tri cua x vao $f2
	mov.d $f2, $f0		# f2 = f0
	
	# Tinh gia tri 4x va luu vao $f2
	ldc1 $f4, bon	# load word into coprocessor1
	mul.d $f2, $f2, $f4		# f2 = f2*f4 = 4*x
	
	# load 5 va luu vao $f6
	ldc1 $f6, nam
	
	# Tinh 4x + 5 va luu vao $f2
	add.d $f2, $f2, $f6	# f2 = f2 + f6 = 4*x + 5
	
	# in thong bao de nhap y
	li $v0, 4
	la $a0, Sy
	syscall
	
	# Nhap y
	li $v0, 7		# nhap vao gia tri kieu double
	syscall	
		
	# Tinh ((4x + 5)/y) va luu vao f6
	mov.d $f6, $f0
	div.d $f2, $f2, $f6	# f2 = f2/f6 = (5*x + 3*y + z)/2 
	
	
	# hien thi ket qua
	li $v0, 4
	la $a0, result		# in thong bao ket qua
	syscall
	li $v0, 3		# in so kieu double
	add.d  $f12, $f2, $f10
	syscall
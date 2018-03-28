.data
	Dayso : 	.word 101 99 78 45 67 12 23 34 97 1 5 10
	Array_size:	.space	4
	mess1 : 	.asciiz "Day so ban dau: "
	mess2 : 	.asciiz "Day so da sap xep: "
	daucach :	.asciiz ", "
	xuongdong:	.asciiz "\n"
	
.text
	#.globl main
	
main:
# store the number of elements
	la		$t0, Array_size
	la		$t1, Dayso
	sub		$t2, $t0, $t1
	srl		$t2, $t2, 2
	sw		$t2, 0($t0)
	
# print mess1
	li		$v0, 4		# print string
	la		$a0, mess1
	syscall
# print Array
	jal		PRINT
	
# Call quick sort
	la		$a0, Dayso
	li		$a1, 0
	# a2 = Array_size - 1
	lw		$t0, Array_size
	addi	$t0, $t0, -1
	move	$a2, $t0
	# function call
	jal		QuickSort
	
# print mess2
	li		$v0, 4
	la		$a0, mess2
	syscall
# print Array
	jal		PRINT

	
# end program
	li		$v0, 10
	syscall

	
QuickSort: 
## Store $s and $ra
	addi $sp, $sp, -24
	sw	$s0, 0($sp)	# store s0 aka store word in register $s0 into RAM at address ($sp) 
	sw	$s1, 4($sp)	# store s1 aka store word in register $s1 into RAM at address ($sp + 4) and so on and so forth...
	sw	$s2, 8($sp)	# store s2
	sw	$a1, 12($sp)	# store a1
	sw	$a2, 16($sp)	# store a2
	sw	$ra, 20($sp)	# store ra
	
## set cac loai $s
	move $s0, $a1		# l = left
	move $s1, $a2		# r = right
	move $s2, $a1		# p = left	# $s2 = $a1
	
### while (l < r)
Loop_1:
	bge	$s0, $s1, Loop_1_Done
	
### MIPS implementation of while(arr[l] <= arr[p] && l < right)
while_1:
	li	$t7, 4		# t7 = 4
	## t0 = &arr[l]
	mult 	$s0, $t7
	mflo	$t0		# t0 = l * 4 bit
				#  move quantity in special register Lo to $t0:   $t0 = Lo
				#  used to get at result of product or quotient
	add 	$t0, $t0, $a0	# t0 = &arr[l]
	lw 	$t0, 0($t0)		
	## $t1 = &arr[p]
	mult 	$s2, $t7
	mflo	$t1		# t1 = p * 4 bit
	add 	$t1, $t1, $a0	# t1 = &arr[p]
	lw 	$t1, 0($t1)
	## Check  arr[l] <= arr[p]	aka 
	bgt 	$t0, $t1, while_1_end
	## Check l < right
	bge	$s0, $a2, while_1_end
	# l++
	addi	$s0, $s0, 1
	j	while_1	
while_1_end:

### MIPS implementation of while(arr[r] >= arr[p] && r > left)
while_2 :
	 li	$t7, 4		# t7 = 4
	 ## t0 = &arr[r]
	 mult	$s1, $t7
	 mflo	$t0		# t0 = r*4bit
	 add	$t0, $t0, $a0	# t0 = &arr[r]
	 lw	$t0, 0($t0)	# load word at RAM address contained in $t0 into $t0
	 ## t1 = &arr[p]
	 mult	$s2, $t7
	 mflo	$t1		# t1 = p*4bit
	 add	$t1, $t1, $a0	# t1 = &arr[p]
	 lw 	$t1, 0($t1)
	 ## Check arr[r] >= arr[p]
	 blt	$t0, $t1, while_2_end
	 ## Check r > left
	 ble	$s1, $a1, while_2_end
	 ## r--
	 addi	$s1, $s1, -1
	 j	while_2
while_2_end:

### if (l >= r)
	blt	$s0, $s1, if
	
## Swap (arr[p], arr[r])
	li	$t7, 4		# t7 = 4
	# t0 = &arr[p]
	mult	$s2, $t7
	mflo	$t6		# t6 = p *4bit
	add	$t0, $t6, $a0	# t0 = &arr[p]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6		# t6 = r*4bit
	add	$t1, $t6, $a0	# t1 = &arr[r]
	## Swap
	lw	$t2, 0($t0)	# load word at RAM address ($t0+0) aka arr[p] into register $t2
	lw	$t3, 0($t1)
	sw	$t3, 0($t0)	# store word in register $t3 aka arr[r] into RAM at address ($t0)
	sw	$t2, 0($t1)	# store word in register $t3 aka arr[p] into RAM at address ($t1)
	
## QuickSort(arr, left, r-1)
	## Set arguments
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = r - 1
	jal	QuickSort	# copy program counter (return address) to register $ra (return address register)
				# jump to program statement at sub_label
	## Pop Stack
	lw	$a1, 12($sp)	# load a1 aka load word at RAM address ($sp+12) into register $a1
	lw	$a2, 16($sp)	# load a2
	lw	$ra, 20($sp)	# load ra
## QuickSort(arr, r + 1, right)
	# set arguments
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1 = r + 1
	jal		QuickSort
	# pop stack
	lw		$a1, 12($sp)	# load a1 aka load word at RAM address ($sp+12) into register $a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
## return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24		# Adjust sp
	jr		$ra		# jump to return address in $ra (stored by jal instruction)	

If_quick1_jump:
	
if:
## Swap(arr[l], arr[r])
	li	$t7, 4		# t7 = 4
	## t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t6		# t6 = l *4bit
	add	$t0, $t6, $a0	# t0 = &arr[l]
	## t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6		# t6 = r*4bit
	add	$t1, $t6, $a0	# t1 = &arr[r]
	## Swap
	lw	$t2, 0($t0)	# load word at RAM address contained in $t0 into $t2
	lw	$t3, 0($t1)
	sw	$t3, 0($t0)	# store contents of register $t3 into RAM:  var1 = $t1
	sw	$t2, 0($t1) 
	
	j	Loop_1
Loop_1_Done: 
	 
## return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24		# Adjust sp
	jr		$ra		# jump to return address in $ra (stored by jal instruction)	 
		 
	
PRINT:
## print Array
	la		$s0, Dayso
	lw		$t0, Array_size
Print_Loop_1:
	beq		$t0, $zero, Print_Loop_end

	# printing Array elements
	li		$v0, 1
	lw		$a0, 0($s0)
	syscall

	# make space
	li		$v0, 4
	la		$a0, daucach
	syscall	
			
	addi	$t0, $t0, -1
	addi	$s0, $s0, 4
	
	j		Print_Loop_1
	
Print_Loop_end:
	# make new line
	li		$v0, 4
	la		$a0, xuongdong
	syscall
	jr		$ra
	
	

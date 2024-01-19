.data
	matrice: .space 4000  # 4(long)*100(linii)*100(coloane)
	cerinta: .space 4
	n: .space 4
	Legaturi: .space 400 # 4(long)*100(noduri)
	scanf_int: .asciz "%ld"
	printf_int: .asciz "%ld "
	printf_endl: .asciz "\n"
	ind: .space 4
	ind2: .space 4
	leg: .space 4
	node: .space 4
	nr: .space 4
.text
.globl main
 
main:
 
	# cin >> cerinta
	# cin >> n
 
	pushl $cerinta
	pushl $scanf_int
	call scanf
	popl %ebx
	popl %ebx
 
	pushl $n
	pushl $scanf_int
	call scanf
	popl %ebx
	popl %ebx
 
	# for(int i=0;i<n;i++) 
	# 	cin >> Legaturi[i];
 
	movl $0, ind
	lea Legaturi, %esi
 
	for_citire_legaturi:
 
		movl ind, %ecx
		cmp %ecx, n
		je exit_for_citire_legaturi
 
		pushl $leg
		pushl $scanf_int
		call scanf
		popl %ebx
		popl %ebx
 
		movl leg, %ebx
		movl ind, %ecx		
		movl %ebx, 0(%esi,%ecx,4)
 
		incl ind
		jmp for_citire_legaturi
 
	exit_for_citire_legaturi:
 
	# for(int i=0;i<n;i++)
	# 	for(int j=0;j<Legaturi[i];j++)
	#		cin >> node;
	#		matrice[i][node] = 1;
 
	movl $0, ind
 
	for_parcurgere:
 
		movl ind, %ecx
		cmp %ecx, n
		je exit_for_parcurgere
 
		movl $0, ind2
 
		for_legaturi:
 
			lea Legaturi, %esi
			movl ind, %ebx
			movl 0(%esi,%ebx,4), %ecx
 
			cmp ind2, %ecx
			je exit_for_legaturi
 
			pushl $node
			pushl $scanf_int
			call scanf
			popl %ebx
			popl %ebx
 
			# bag in ( i*n + node ) , $1
			# echivalent cu matrice[i][node] = 1
 
			movl ind, %eax
			movl n, %ebx
			movl $0, %edx
			mull %ebx
			addl node, %eax
 
			lea matrice, %edi
			movl $1, (%edi,%eax,4)
 
			incl ind2
			jmp for_legaturi
 
		exit_for_legaturi:
 
		incl ind
		jmp for_parcurgere
 
	exit_for_parcurgere:
 
	movl $1, %eax
	cmp %eax, cerinta
	je afisare_matrice
 
afisare_matrice:
 
	# for(int i=0;i<n;i++){
	# 	for(int j=0;j<n;j++){
	#		cout << matrice[i][j] << ' ';
	#	}
	# 	cout << '\n';
	# }
 
	movl $0, ind
 
	for_linie:
		movl ind, %ecx
		cmp %ecx, n
		je exit_for_linie
 
		movl $0, ind2
 
		for_coloana:
 
			movl ind2, %ecx
			cmp %ecx, n
			je exit_for_coloana
 
			# matrice[i][j] -> (i*n+j)
			movl n, %eax
			movl ind, %ebx
			movl $0, %edx
			mull %ebx
			addl ind2, %eax
 
			lea matrice, %edi
			movl (%edi,%eax,4), %ecx
			movl %ecx, nr
 
			pushl nr
			pushl $printf_int
			call printf
			popl %ebx
			popl %ebx
 
			incl ind2
			jmp for_coloana
 
		exit_for_coloana:
 
		pushl $printf_endl
		call printf
		popl %ebx
 
		incl ind
		jmp for_linie
 
	exit_for_linie:
 
	pushl $0
	call fflush
	popl %ebx
 
 
exit_code:
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
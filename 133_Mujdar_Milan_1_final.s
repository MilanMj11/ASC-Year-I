.data

	Maux : .space 40000    # 4(long)*100(linii)*100(coloane)
	cerinta: .space 4
	n: .space 4
	Legaturi: .space 400 # 4(long)*100(noduri)
	scanf_int: .asciz "%ld"
	printf_int: .asciz "%ld "
	printf_int_nospace: .asciz "%ld"
	printf_endl: .asciz "\n"
	ind: .space 4
	ind2: .space 4
	leg: .space 4
	node: .space 4
	nr: .space 4
	k: .space 4
	sursa: .space 4
	destinatie: .space 4
	pas: .space 4
	spatiu_de_alocat: .space 4
	adresa: .space 4
	
.text

matrix_mult:
	
	# for(int i = 0; i < n; i++) {
	#   for(int j = 0; j < n; j++) {
	#	Mrez_aux[i][j] = 0 
	#	for(int t = 0; t < n; t++) 
	#	    Mrez_aux[i][j] += matrice1[i][t] * matrice2[t][j];
	#   }
	# }
	# for(int i = 0; i < n; i++){
	#   for(int j = 0; j < n; j++){
	#	Mrez[i][j] = Mrez_aux[i][j]
	#   }
	# }
	
	pushl %ebp
	movl %esp, %ebp
	
	#movl 20(%ebp), %eax  # eax = n ( dimensiune matrice ) 
	#movl 16(%ebp), %edx  # edx = referinta / adresa matriceRez
	#movl 12(%ebp), %ebx  # ebx = referinta / adresa matrice2
	#movl 8(%ebp), %ecx  # ecx = referinta / adresa matrice1
	
	subl $24, %esp  
	subl $40000, %esp
	
	movl $0, -4(%ebp) # i = -4(%ebp)
	
	for_ii:
	
		movl -4(%ebp), %ecx
		cmp %ecx, 20(%ebp) 
		je exit_for_ii
		
		movl $0, -8(%ebp) # j = -8(%ebp)
		
		for_jj:
		
			movl -8(%ebp), %ecx
			cmp %ecx, 20(%ebp)
			je exit_for_jj
			
			# Mrez_aux[i][j] = 0
			
			# %eax = i*n+j   /// n = 20(%ebp)
			movl 20(%ebp), %eax
			movl -4(%ebp), %ebx
			movl $0, %edx
			mull %ebx
			addl -8(%ebp), %eax
			# %eax = i*n+j     /// n = 20(%ebp)
			
			movl %ebp, %esi
			subl $40024, %esi
			
			#movl -40024(%ebp), %esi    # -4024(%ebp) = referinta matriceRez_aux
			movl $0, 0(%esi,%eax,4)
			
			#  for(int t = 0; t < n; t++) 
			#    Mrez_aux[i][j] += matrice1[i][t] * matrice2[t][j];
			
			movl $0, -12(%ebp)
			
			for_tt:
				
				movl -12(%ebp), %ecx
				cmp %ecx, 20(%ebp)
				je exit_for_tt
				
				# Mrez_aux[i][j] += matrice1[i][t] * matrice2[t][j];
				
				# eax = i*n + j
				movl 20(%ebp), %eax
				movl -4(%ebp), %ebx
				movl $0, %edx
				mull %ebx
				addl -8(%ebp), %eax
				# eax = i*n + j	
				movl %eax, -16(%ebp)  # 16ebp = [i][j]
				
				
				# eax = i*n + t
				movl 20(%ebp), %eax
				movl -4(%ebp), %ebx
				movl $0, %edx
				mull %ebx
				addl -12(%ebp), %eax
				# eax = i*n + t
				movl %eax, -20(%ebp)  # 20ebp = [i][t]
				
				
				# eax = t*n + j
				movl 20(%ebp), %eax
				movl -12(%ebp), %ebx
				movl $0, %edx
				mull %ebx
				addl -8(%ebp), %eax
				# eax = t*n + j
				movl %eax, -24(%ebp)  # 24ebp = [t][j]
				
				# matrice1[i][t] * matrice2[t][j];
				# %eax = matrice1[i][t]
				movl 8(%ebp), %esi
				movl -20(%ebp), %ebx
				movl 0(%esi,%ebx,4), %eax
				# %ebx = matrice2[t][j]
				movl 12(%ebp), %esi
				movl -24(%ebp), %ecx
				movl 0(%esi,%ecx,4), %ebx
				
				movl $0, %edx
				mull %ebx
				# eax is now matrice1[i][t] * matrice2[t][j]
				
				# [i][j] = -16(%ebp)
				
				movl %ebp, %esi
				subl $40024, %esi
				
				#movl -40024(%ebp), %esi
				movl -16(%ebp), %ebx
				
				# Mrez_aux[i][j] += matrice1[i][t] * matrice2[t][j];
				addl %eax, 0(%esi,%ebx,4)
				
				incl -12(%ebp)
				jmp for_tt
			
			exit_for_tt:
			
			
			incl -8(%ebp)
			jmp for_jj	
			
		exit_for_jj:	
	
		incl -4(%ebp)  
		jmp for_ii
	
	exit_for_ii:
	
	
	movl $0, -4(%ebp)
	
	for_iii:
		
		movl -4(%ebp), %ecx
		cmp %ecx, 20(%ebp) 
		je exit_for_iii
		
		movl $0, -8(%ebp) # j = -8(%ebp)
		
		for_jjj:
		
			movl -8(%ebp), %ecx
			cmp %ecx, 20(%ebp)
			je exit_for_jjj
		
			# Mrez[i][j] = Mrez_aux[i][j]
			# aux = Mrez_aux[i][j]
			# Mrez[i][j] = aux
			
			
			# eax = i*n + j
			movl 20(%ebp), %eax
			movl -4(%ebp), %ebx
			movl $0, %edx
			mull %ebx
			addl -8(%ebp), %eax
			# eax = i*n + j
			
			movl 16(%ebp), %esi
			
			movl %ebp, %edi
			subl $40024, %edi
			
			#movl -40024(%ebp), %edi
			
			movl 0(%edi,%eax,4), %ebx
			movl %ebx, 0(%esi,%eax,4)
			
		
			incl -8(%ebp)
			jmp for_jjj
		
		exit_for_jjj:
		
		
		incl -4(%ebp)
		jmp for_iii
		
		
	exit_for_iii:
	
	addl $24, %esp
	addl $40000, %esp
	
	
	popl %ebp
	ret
	
	
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
	
	#alocam dinamic matricea (de adiacenta)
	
	movl n, %eax
	movl n, %ebx
	movl $0, %edx
	mull %ebx
	# now %eax = n*n
	movl $4, %ebx
	movl $0, %edx
	mull %ebx
	# now %eax = 4*n*n  ( spatiul care trebuie alocat ) 
	movl %eax, spatiu_de_alocat # retin cantitatea ce trb s-o aloc
	
	
	#malloc_:

	movl $192, %eax	       # eax = 192 - pentru mmap2
	movl $0, %ebx	       # ebx = 0
	movl spatiu_de_alocat, %ecx   # ecx = spatiul alocat
	movl $0x3, %edx        # edx (prot) = PROT_WRITE
	movl $0x22, %esi       # MAP_ANON / MAP_SHARED
	movl $-1, %edi	       # MAP_ANONYMOUS , trebuie fd = -1
	movl $0, %ebp	       # "Offset argument should be 0" - documentatia mmap
			       # de la MAP_ANONYMOUS
	int $0x80 	       # system_call
	
	# acum in %eax am adresa spatiului alocat
	# eax cu rol de *(addr)
	
	movl %eax, adresa
	
	
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
			
			movl adresa, %edi 
			movl $1, (%edi,%eax,4)
			
			incl ind2
			jmp for_legaturi
		
		exit_for_legaturi:
		
		incl ind
		jmp for_parcurgere
		
	exit_for_parcurgere:

verificare_cerinta: 

	movl $3, %eax
	cmp %eax, cerinta
	jne exit_code
	
rez_cerinta3:

	# cin >> k >> sursa >> destinatie
	
	pushl $k
	pushl $scanf_int
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $sursa
	pushl $scanf_int
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $destinatie
	pushl $scanf_int
	call scanf
	popl %ebx
	popl %ebx
	
	
	#	for (int i = 0; i < n; i++)
	# 	     for(int j = 0; j < n; j++ )
	# 		 Maux[i][j] = matrice[i][j];
	#
	# 	for (int pas = 1; pas < k; pas++ )
	# 		matrix_mult(maux,matrice,matrice,n);
	# 	
		
	
	movl $0, ind
		
	for_i:
	
		movl ind, %ecx
		cmp %ecx, n
		je exit_for_i
		
		movl $0, ind2
		
		for_j:
		
			movl ind2, %ecx
			cmp %ecx, n
			je exit_for_j
			
			#  Maux[i][j] = matrice[i][j]
			#  aux = matrice[i][j]
			#  Maux[i][j] = aux
			
			movl adresa, %esi
			
			# eax = i*n + j
			movl ind, %eax
			movl n, %ebx
			movl $0, %edx
			mull %ebx
			movl ind2, %ecx
			addl %ecx, %eax
			# eax = i*n + j
			
			lea Maux, %edi
			
			movl 0(%esi,%eax,4), %ebx   # ebx cu rol de aux
			movl %ebx, 0(%edi,%eax,4)
			
			incl ind2
			jmp for_j
			
		exit_for_j:
		
		incl ind
		jmp for_i
		
	exit_for_i:		
	
	
	# 	for (int pas = 1; pas < k; pas++ )
	# 		matrix_mult(maux,matrice,matrice,n);
	# 
	
	movl $1, pas
	
	for_pas:
		
		movl pas, %ecx
		cmp %ecx, k
		je exit_for_pas
	
		# matrix_mult(maux,matrice,matrice,n);
		
		pushl n
		pushl adresa  
		pushl adresa 
		pushl $Maux      
		call matrix_mult
		popl %edx
		popl %edx
		popl %edx
		popl %edx
	
		incl pas
		jmp for_pas
		
	exit_for_pas:	
	
	
	# cout << matrice[sursa][destinatie]	
	
	# %eax = sursa*n + destinatie
	movl sursa, %eax
	movl n, %ebx
	movl $0, %edx
	mull %ebx
	movl destinatie, %ecx
	addl %ecx, %eax
	# %eax = sursa*n + destinatie
	
	movl adresa, %esi
	movl 0(%esi,%eax,4), %ebx
	movl %ebx, nr
	
	pushl nr
	pushl $printf_int_nospace
	call printf
	popl %edx
	popl %edx
	
	jmp exit_code

exit_code:
	
	movl $91, %eax 		# eax = 91 pentru munmap ( dealocarea spatiului ) 
	movl adresa, %ebx    	# adresa de la care sa dea free
	movl spatiu_de_alocat, %ecx    # lungimea spatiului ce il dealoc
	int $0x80   	        # system_call
	
	pushl $0
	call fflush
	popl %ebx

	mov $1, %eax
	xor %ebx, %ebx
	int $0x80

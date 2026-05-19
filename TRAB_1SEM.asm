.data
    	entrada:  .asciiz "\nInsira um numero (0 para sair): "
    	fimPrograma:  .asciiz "\nPrograma encerrado.\n"
    	ehPalindromo: .asciiz "O numero eh palindromo.\n"
    	naoEh: .asciiz "O numero nao eh palindromo.\n"
    	maisProximo: .asciiz "O palindromo mais proximo eh: \n "
    	erro: .asciiz "Insira valores maiores que 1 e menores que 10000.\n"
.text
Main:
Enquanto:
    	# Insira o número (0 para sair)
    	li $v0, 4
    	la $a0, entrada
    	syscall
    	li $v0, 5
    	syscall
    	add $t0, $v0, $zero	# t0 = entrada
    	beq $t0, $zero, Saida 	# if (t0 == 0) vai para Saida
    	ble $t0, 1, Erro		# if (t0 <= 1) vai para o erro
    	bge $t0, 10000, Erro	# or (t0 >= 10000) vai para o erro 
    	j VerificaPalindromo	# Segue o algoritmo 

Erro:	# Se a entrada não esteve de acordo, mostra mensagem e volta ao loop principal.
    	li $v0, 4
    	la $a0, erro
    	syscall
    	j Enquanto

VerificaPalindromo:		
    	add $s0, $t0, $zero		# s0 = número original 
    	li $s1, 0				# s1 = número invertido

LoopInverte:				
    	beq $s0, 0, Comparacao	# if (s0 == 0) vai para Comparacao
    	rem $s2, $s0, 10			# s2 = ultimo digito do s0
    	mul $s1, $s1, 10			# s1 é multiplicado por 10
    	add $s1, $s1, $s2			# s1 += s2 
    	div $s0, $s0, 10			# s0 /= 10 (remove o último digito)
    	j LoopInverte			

Comparacao:
    	beq $t0, $s1, EhPalindromo	# if (t0 == s1) vai para EhPalindromo
    	j NaoEhPalindromo		# Caso contrário, vai para NaoEhPalindromo

EhPalindromo:
	# O número é palíndromo
	li $v0, 4
    	la $a0, ehPalindromo
    	syscall
    	j Enquanto 			# Volta ao loop

NaoEhPalindromo:	# Inicia processo de procurar o palíndromo mais próximo
    	li $v0, 4
    	la $a0, naoEh		# Imprime mensagem de que o número inserido não é palíndromo.
    	syscall
	add $s4, $t0, $zero	# s4 = entrada

BuscaPalindromo: 	# Loop que ocorre inversamente para busca
	subi $s4, $s4, 1		# s4 -= 1
   	add $s0, $s4, $zero	# s0 = número original
    	li $s1, 0				# s1 = número invertido

LoopBusca:			# A lógica é a mesma do LoopInverte...
    	beq $s0, 0, ComparaBusca
    	rem $s2, $s0, 10
    	mul $s1, $s1, 10
    	add $s1, $s1, $s2
    	div $s0, $s0, 10
   	j LoopBusca

ComparaBusca:
    	beq $s4, $s1, ImprimeProximo 	# if (s4 == s1) vai para ImprimePróximo
    	j BuscaPalindromo				# Caso contrário, retorna ao loop de busca

ImprimeProximo: 
	# O número palíndromo mais próximo é:
    	li $v0, 4
    	la $a0, maisProximo
    	syscall
    	li $v0, 1
    	move $a0, $s4 #	Número palíndromo mais próximo.
    	syscall
    	j Enquanto

Saida: 
	# Programa encerrado
    	li $v0, 4
    	la $a0, fimPrograma
    	syscall
    	li $v0, 5
    	syscall

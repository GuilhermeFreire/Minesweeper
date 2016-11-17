/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).
/*Carrega o arquivo mina.pl*/
:- ensure_loaded(ambiente).

/*Seta qualquer tupla em impresso(X,Y) como falso*/
/*dynamic, pois e uma funcao temporaria, criada somente para a execucao*/
:- dynamic impresso/2.
retractall(impresso(_, _)).


/*Caso a posicao ja foi impressa(jogada), retorna verdadeiro e CUT*/
posicao(X,Y):- 	impresso(X,Y), !.

/*Caso não seja jogada, marcamos essa posicao como jogada*/
/*Se existir uma mina, you lose, marca todas as jogadas...*/
posicao(X,Y):- 	mina(X,Y), !,
				assert(impresso(_,_)),
				write("perdeu o jogo!").

/*Não sendo uma mina, verifica se o valor na posicao é zero*/
/*Marca a posicao hehe*/
/*Se for zero, chama a funcao para os vizinhos*/
posicao(X,Y):- 	assert(impresso(X,Y)),
				valor(X,Y,N),
				N = 0, !,
				findNeighbors((X,Y),L),
				writeStream(X,Y,N),
				callNeighbors(L).

/*Não sendo zero, marca a posicao e escreva o valor*/
posicao(X,Y):-	assert(impresso(X,Y)),
				valor(X,Y,N),
				writeStream(X,Y,N).

/*Força o posicao retornar true e não encerrar o callNeighbors*/
posicao(X,Y):- assert(impresso(X,Y)).


/*Faz a chamada de posicao para os vizinhos*/
callNeighbors([]).
callNeighbors([(X,Y)|T]):-	impresso(X,Y),
							callNeighbors(T), !.
callNeighbors([(X,Y)|T]):-	posicao(X,Y),
							callNeighbors(T).

/*Escreve o valor na tela*/
/*Não está escrevendo em um arquivo ainda, pois buguei...*/
/*Como precisa do input do usuário... fiquei em duvida de como fazer isso*/
writeStream(Rows,Cols,N):- 	open("jogo.pl", write, Stream),
							write("valor("),
							write(Rows),
							write(", "),
							write(Cols),
							write(", "),
							write(N),
							write(").\n"),
							close(Stream).

findNeighbors((X,Y),[(A,C),(X,C),(B,C),(A,Y),(B,Y),(A,D),(X,D),(B,D)]):- A is X-1, B is X+1, C is Y-1, D is Y+1.
/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).
/*Carrega o arquivo ambiente.pl*/
:- ensure_loaded(ambiente).
/*Facilitadores*/
mina((X,Y)):- mina(X,Y).

/*Seta qualquer tupla em impresso(X,Y) como falso*/
/*dynamic, pois e uma funcao temporaria, criada somente para a execucao*/
:- dynamic impresso/2.
:- dynamic jogada/1.
retractall(impresso(_, _)).

/*Funcao que faz as jogadas e escreve no arquivo*/
/*Caso não seja a primeira jogada, não precisamos limpar o arquivo*/
posicao(X,Y):-	not(insideBoard(X,Y)),
				write("Jogue uma posicao valida\n").

posicao(X,Y):-	getJogada(0,Jogada),
				Jogada > 1, !,
				open("jogo.pl", append, Stream),
				writeJogada(Stream,Jogada),
				writePosicao(X,Y,Stream),
				writeAmbiente(Stream),
				setValor(X,Y,Stream),
				write(Stream,"\n"),
				close(Stream).

/*Caso seja a primeira jogada, limpamos o arquivo*/
posicao(X,Y):-	Jogada is 1,
				open("jogo.pl", write, Stream),
				writeJogada(Stream,Jogada),
				writePosicao(X,Y,Stream),
				writeAmbiente(Stream),
				setValor(X,Y,Stream),
				write(Stream,"\n"),
				close(Stream).


/*setValor obtem o valor das casas vizinhas explorando as casas
zeradas recurssivamente*/

/*Caso a posicao ja foi impressa(jogada), retorna verdadeiro e CUT*/
setValor(X,Y,Stream):-	impresso(X,Y),
						write(Stream,"/*posicao ja explorada.*/\n"), !.

/*Caso não tenha sido jogada, marcamos essa posicao como jogada*/
/*Se existir uma mina, you lose, marca todas as jogadas...*/
setValor(X,Y,Stream):- 	mina(X,Y), !,
						assert(impresso(_,_)),
						write(Stream,"jogo encerrado.").

/*Não sendo uma mina, verifica se o valor na posicao é zero*/
/*Marca a posicao hehe*/
/*Se for zero, chama a funcao para os vizinhos*/
setValor(X,Y,Stream):- 	assert(impresso(X,Y)),
						valor(X,Y,N),
						N = 0, !,
						findNeighbors((X,Y),L),
						writeValor(X,Y,N,Stream),
						callNeighbors(L,Stream).

/*Não sendo zero, marca a posicao e escreva o valor*/
setValor(X,Y,Stream):-	assert(impresso(X,Y)),
						valor(X,Y,N),
						writeValor(X,Y,N,Stream).

/*Força o posicao retornar true e não encerrar o callNeighbors.
Pois, podemos jogar posicao fora do tabuleiro...   				*/
setValor(X,Y,Stream):- assert(impresso(X,Y)).


/*Faz a chamada de posicao para os vizinhos*/
callNeighbors([],Stream).
callNeighbors([(X,Y)|T],Stream):-	impresso(X,Y),
									callNeighbors(T,Stream), !.
callNeighbors([(X,Y)|T],Stream):-	setValor(X,Y,Stream),
									callNeighbors(T,Stream).

/*Função que verifica quantos vizinhos não explorados certa posicao possui*/
unmarkedNeighbors(X,Y,Value):-	findNeighbors((X,Y),L),
								countUnmarked(L,Value).

/*Dado uma lista L de vizinhos, contamos quantos vizinhos válidos não foram jogados*/
countUnmarked([],0).
countUnmarked([(X,Y)|T],Value):-	impresso(X,Y), !,
									countUnmarked(T,Value).

countUnmarked([(X,Y)|T],Value):-	insideBoard(X,Y), !,
									countUnmarked(T,OldValue),
									Value is OldValue + 1.

countUnmarked([(X,Y)|T],Value):-	countUnmarked(T,Value).


/*-----------------------Funções auxiliares-----------------------*/
/* Seta toda jogada(X) como falso */
retractall(jogada(_)).
/*jogada(0) é verdade*/
jogada(0).

/*----------------- Funcao que obtem qual rodada estamos-----------------*/
/*enquanto jogada for verdadeira, incrimenta um e chama a função novamente*/
/*Quando der falso, significa que está no valor da jogada atual, marcamos esse valor
com o assert e retornamos o valor da jogada---------------------------------------*/
getJogada(N,M):-	jogada(N),
					Nn is N+1,
					getJogada(Nn,M), !.
getJogada(N,M):-	M is N,
					assert(jogada(M)).
/*--------------------------------------*/


writeValor(Rows,Cols,N,Stream):- 	write(Stream,"valor("),
									write(Stream,Rows),
									write(Stream,", "),
									write(Stream,Cols),
									write(Stream,", "),
									write(Stream,N),
									write(Stream,").\n").

writeAmbiente(Stream):-	write(Stream,"/*AMBIENTE*/\n").

writeJogada(Stream, Jogada):-	write(Stream,"/*JOGADA "),
								write(Stream,Jogada),
								write(Stream,"*/\n").

writePosicao(Rows,Cols,Stream):-	write(Stream,"posicao("),
									write(Stream,Rows),
									write(Stream,", "),
									write(Stream,Cols),
									write(Stream,").\n").

findNeighbors((X,Y),[(A,C),(X,C),(B,C),(A,Y),(B,Y),(A,D),(X,D),(B,D)]):- A is X-1, B is X+1, C is Y-1, D is Y+1.

/*Obter as dimensoes do tabuleiro, para evitar casos de borda*/
findDimensions(M, Num_Rows, Num_Cols):- findDimensionsX(M, Num_Rows), findDimensionsY(M, Num_Cols).

findDimensionsX([(X,_)], X).
findDimensionsX([(X,_)|T], X):- findDimensionsX(T, R),
				X > R,
				!.

findDimensionsX([_|T], R):- findDimensionsX(T, R), !.

findDimensionsY([(_,Y)], Y).
findDimensionsY([(_,Y)|T], Y):- findDimensionsY(T, C),
				Y > C,
				!.

findDimensionsY([_|T], C):- findDimensionsY(T, C), !.

getDimensions(Rows, Cols):- findall((X,Y), mina((X,Y)), Mines),
			   				ignore(false),
			   				findDimensions(Mines, Rows, Cols).

/*Função que verifica se dada coordenada está dentro do tabuleiro*/
insideBoard(X,Y):-	getDimensions(Rows,Cols),
					X > 0, X =< Rows,
					Y > 0, Y =< Cols.
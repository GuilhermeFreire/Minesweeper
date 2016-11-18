/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).
/*Carrega o arquivo mina.pl*/
:- ensure_loaded(ambiente).

/*Seta qualquer tupla em impresso(X,Y) como falso*/
/*dynamic, pois e uma funcao temporaria, criada somente para a execucao*/
:- dynamic impresso/2.
:- dynamic jogada/1.
retractall(impresso(_, _)).

/*Funcao que faz as jogadas e escreve no arquivo*/
/*Caso não seja a primeira jogada, não precisamos limpar o arquivo*/
posicao(X,Y):-	getJogada(0,Jogada),
				Jogada > 1, !,
				open("jogo.pl", append, Stream),
				writeJogada(Stream,Jogada),
				writePosicao(X,Y,Stream),
				writeAmbiente(Stream),
				getValor(X,Y,Stream),
				write(Stream,"\n"),
				close(Stream).

/*Caso seja a primeira jogada, limpamos o arquivo*/
posicao(X,Y):-	Jogada is 1,
				open("jogo.pl", write, Stream),
				writeJogada(Stream,Jogada),
				writePosicao(X,Y,Stream),
				writeAmbiente(Stream),
				getValor(X,Y,Stream),
				write(Stream,"\n"),
				close(Stream).


/*getValor obtem o valor das casas vizinhas explorando as casas
zeradas recurssivamente*/

/*Caso a posicao ja foi impressa(jogada), retorna verdadeiro e CUT*/
getValor(X,Y,Stream):-	impresso(X,Y),
						write(Stream,"posicao ja explorada\n"), !.

/*Caso não tenha sido jogada, marcamos essa posicao como jogada*/
/*Se existir uma mina, you lose, marca todas as jogadas...*/
getValor(X,Y,Stream):- 	mina(X,Y), !,
						assert(impresso(_,_)),
						write(Stream,"jogo encerrado\n").

/*Não sendo uma mina, verifica se o valor na posicao é zero*/
/*Marca a posicao hehe*/
/*Se for zero, chama a funcao para os vizinhos*/
getValor(X,Y,Stream):- 	assert(impresso(X,Y)),
						valor(X,Y,N),
						N = 0, !,
						findNeighbors((X,Y),L),
						writeValor(X,Y,N,Stream),
						callNeighbors(L,Stream).

/*Não sendo zero, marca a posicao e escreva o valor*/
getValor(X,Y,Stream):-	assert(impresso(X,Y)),
						valor(X,Y,N),
						writeValor(X,Y,N,Stream).

/*Força o posicao retornar true e não encerrar o callNeighbors.
Pois, podemos jogar posicao fora do tabuleiro...   				*/
getValor(X,Y,Stream):- assert(impresso(X,Y)).


/*Faz a chamada de posicao para os vizinhos*/
callNeighbors([],Stream).
callNeighbors([(X,Y)|T],Stream):-	impresso(X,Y),
									callNeighbors(T,Stream), !.
callNeighbors([(X,Y)|T],Stream):-	getValor(X,Y,Stream),
									callNeighbors(T,Stream).

/*Escreve o valor na tela*/
/*Não está escrevendo em um arquivo ainda, pois buguei...*/
/*Como precisa do input do usuário... fiquei em duvida de como fazer isso*/

/* Funcao que obtem qual rodada estamos */
retractall(jogada(_)).
jogada(0).

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
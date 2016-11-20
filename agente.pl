:- ensure_loaded(engine2).

%% Facilitadores
known((X,Y,V)):- known(X,Y,V).

randomMove:-.

start:- randomMove,
		findall(X, known(X), L),
		.

/*oioi*/

/*inicio do jogo*/
/*escolhe uma posição aleatoria do mapa para fazer a 1 jogada*/

:- ensure_loaded(engine2).

setJogadaInicial(X,Y):-random_between(1,LarguraDoTabuleiro,X),
			 random_between(1,AlturaDoTabuleiro,Y).

startGame():- setJogadaInicial(X,Y),
		posicao(X,Y),
		proximaJogada().

proximaJogada:- not()

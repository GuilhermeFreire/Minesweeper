:- ensure_loaded(engine2).

%% Facilitadores
known((X,Y,V)):- known(X,Y,V).

/*inicio do jogo*/
/*escolhe uma posição aleatoria do mapa para fazer a 1 jogada*/

setJogadaInicial(X,Y):-random_between(1,LarguraDoTabuleiro,X),
			 random_between(1,AlturaDoTabuleiro,Y).

startGame():- setJogadaInicial(X,Y),
		posicao(X,Y),
		not(mina(X,Y)),!,
		proximaJogada().

startGame():- fimDeJogo().

fimDeJogo():- print"u lose bro".

proximaJogada():- escolheJogada(nao sei oq botar),
		not(mina(X,Y)),!,
		proximaJogada().

proximaJogada():-fimDeJogo().


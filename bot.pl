/*Carrega o arquivo engine.pl*/
:- [engine].
:- ensure_loaded(jogo).

random_mark():-	random_between(1,4,X),
				random_between(1,5,Y),
				posicao(X,Y).


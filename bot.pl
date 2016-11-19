/*Carrega o arquivo engine.pl*/
:- [engine].

random_mark():-	random_between(1,4,X),
				random_between(1,5,Y),
				mark(X,Y).

mark(X,Y):- posicao(X,Y).


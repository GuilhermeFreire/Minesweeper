/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).
/*Carrega o arquivo mina.pl*/
:- ensure_loaded(ambiente).

:- abolish(prevCalled/2).

:- dynamic prevCalled/2.

:- abolish(known/3).

:- dynamic known/3.

posicao(Row, Col):- prevCalled(Row, Col), !.

posicao(Row, Col):- valor(Row, Col, Val),
					Val = 0,
					!,
					assert(prevCalled(Row, Col)),
					assert(known(Row, Col, Val)),
					A is Row - 1,
					B is Row + 1,
					C is Col -1,
					D is Col + 1,
					posicao(A, C), posicao(Row, C), posicao(B, C),
					posicao(A, Col), posicao(B, Col),
					posicao(A, D), posicao(Row, D), posicao(B, D).

posicao(Row, Col):- valor(Row, Col, Val),
					!,
					assert(prevCalled(Row, Col)),
					assert(known(Row, Col, Val)),
					format("Casa(~w, ~w): ~w ~n", [Row, Col, Val]).
					%% print(Val).

posicao(Row , Col):- mina(Row, Col), !, assert(prevCalled(Row, Col)), assert(known(Row, Col, mina)), format("Casa(~w, ~w): Mina~n", [Row, Col]).
posicao(_, _).
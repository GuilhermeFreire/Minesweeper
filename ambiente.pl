/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).

/*Facilitadores*/
mina((X,Y)):- mina(X,Y).
not_member(_, []):- !.
not_member(E, [H|T]):- E \= H, not_member(E, T).

/*Preenche o mapa M com zeros*/
fillRow([], _ , 0).
fillRow([Value|T], Value, N):- N >= 0, I is N -1, fillRow(T, Value, I).

fillZeros([], _ , 0).
fillZeros([H|T], Width, Height):- Height >= 0, Height2 is Height -1, fillRow(H, 0, Width), fillZeros(T, Width, Height2).

/*Itera sobre as minas marcando seus vizinhos com valores apropriados*/
alterRow([_|T], Pos, Val, [Val|T]):- Pos=1.
alterRow([H|T], Pos, Val, L):- Pos2 is Pos -1, Pos > 1, alterRow(T, Pos2, Val, L2), append([H], L2, L).

alterValue([H|T], (Row, Column), Value, [L|T]):- Row=1, alterRow(H, Column, Value, L).
alterValue([H|T], (Row, Column), Value, M):- Row2 is Row -1, Row > 1, alterValue(T, (Row2, Column), Value, M2), append([H], M2, M).

buildMineList([], L):- mina(X,Y), buildMineList([(X,Y)], L).
buildMineList(L, L2):- mina(X,Y), not_member((X,Y), L), append((X,Y), L, L2).
buildMineList(L):- buildMineList([], L).

%% allMines([H|T]):- .
/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).

/*Facilitadores*/
mina((X,Y)):- mina(X,Y).

findDimensions(M, Num_Rows, Num_Cols):- findDimensionsX(M, Num_Rows), findDimensionsY(M, Num_Cols).

findDimensionsX([(X,_)], X).
findDimensionsX([(X,_)|T], X):- findDimensionsX(T, R), X > R, !.
findDimensionsX([_|T], R):- findDimensionsX(T, R).

findDimensionsY([(_,Y)], Y).
findDimensionsY([(_,Y)|T], Y):- findDimensionsY(T, C), Y > C, !.
findDimensionsY([_|T], C):- findDimensionsY(T, C).

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

setupEnvironment(Map):- findall((X,Y), mina((X,Y)), Mines),
						findDimensions(Mines, Rows, Cols),
						fillZeros(ZeroMap, Rows, Cols),
						setupMines(ZeroMap, Mines, Map).

setupMines(Map, [], Map).
setupMines(ZMap, [H|T], Final_Field):- setupMines(ZMap, T, Field), alterValue(Field, H, m, Final_Field).
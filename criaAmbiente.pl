/*Carrega o arquivo mina.pl*/
:- ensure_loaded(mina).

/*Facilitadores*/
mina((X,Y)):- mina(X,Y).

findDimensions(M, Num_Rows, Num_Cols):- findDimensionsX(M, Num_Rows), findDimensionsY(M, Num_Cols).

findDimensionsX([(X,_)], X).
findDimensionsX([(X,_)|T], X):- findDimensionsX(T, R),
				X > R,
				!.

findDimensionsX([_|T], R):- findDimensionsX(T, R).

findDimensionsY([(_,Y)], Y).
findDimensionsY([(_,Y)|T], Y):- findDimensionsY(T, C),
				Y > C,
				!.

findDimensionsY([_|T], C):- findDimensionsY(T, C).

/*Preenche o mapa M com zeros*/
/*cria uma matriz X por Y preenchida de 0*/
fillRow([], _ , 0).
fillRow([Value|T], Value, N):- N >= 0,
				I is N -1,
				fillRow(T, Value, I).

fillZeros([], _ , 0).
fillZeros([H|T], Width, Height):- Height >= 0, 
				Height2 is Height -1, 
				fillRow(H, 0, Width), 
				fillZeros(T, Width, Height2).

/*Itera sobre as minas marcando seus vizinhos com valores apropriados*/
setupMines(0, Cols, Stream).
setupMines(Rows, Cols, Stream):- setupRows(Rows, Cols, Stream), R2 is Rows-1, setupMines(R2, Cols, Stream).

setupRows(Rows, 0, Stream).
setupRows(Rows, Cols, Stream):- mina(Rows, Cols),
				C2 is Cols-1,
				setupRows(Rows, C2, Stream),!.

setupRows(Rows, Cols, Stream):- C2 is Cols-1,
				setupRows(Rows, C2, Stream), 
				findNeighbors((Rows,Cols), N),
				neighborsMines(N, Count),
				write(Stream,"valor("),
				write(Stream,Rows),
				write(Stream,", "),
				write(Stream,Cols),
				write(Stream,", "),
				write(Stream,Count),
				write(Stream,").\n").

neighborsMines([],0).
neighborsMines([H|T],Count):- neighborsMines(T,CountOld), mina(H), Count is CountOld + 1, !.
neighborsMines([H|T],Count):- neighborsMines(T,Count).
  

createFile():- open("ambiente.pl", write, Stream), setupEnvironment(Stream), close(Stream).


setupEnvironment(Stream):- findall((X,Y), mina((X,Y)), Mines),
			   findDimensions(Mines, Rows, Cols),
			   setupMines(Rows, Cols, Stream).

findNeighbors((X,Y),[(A,C),(X,C),(B,C),(A,Y),(B,Y),(A,D),(X,D),(B,D)]):- A is X-1, B is X+1, C is Y-1, D is Y+1.





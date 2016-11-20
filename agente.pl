:- ensure_loaded(engine2).

:- abolish(flag/2).

:- dynamic flag/2.


%% Facilitadores
known((X,Y), V):- known(X,Y,V).


diff([],L,[]).
diff([X|T1],L2, [X|R]):-not(member(X,L2)),!, diff(T1,L2,R).
diff([X|T1],L2,R):-diff(T1,L2,R).


/*inicio do jogo*/
/*escolhe uma posição aleatoria do mapa para fazer a 1 jogada*/
/*ele nao vai chutar uma casa que ja foi marcada com uma flag de bomba*/

chutaPosicao(X,Y):-dim(DimX,DimY), 
			random_between(1,DimX,X),
			random_between(1,DimY,Y),
			not(flag(X,Y)),!.

chutaPosicao(X,Y):-chutaPosicao(X,Y).


startGame():- chutaPosicao(X,Y),
		posicao(X,Y),
		not(mina(X,Y)),!,
		proximaJogada().

startGame():- fimDeJogo().

fimDeJogo():- print("cabo").

proximaJogada():- fazJogada(KeepPlaying),
		KeepPlaying \= 0,
		dim(DimX, DimY),
		Ncasas is DimX*DimY,
		findall((X2,Y2), known(X2,Y2), L),
		length(L, CasasAbertas),
		CasasFechadas is Ncasas-CasasAbertas,
		contMina(NMinas),
		CasasFechadas>NMinas,
		proximaJogada().

proximaJogada():-fimDeJogo().





%%retorna lista das casas que podem ser jogadas (fechadas)
vizinhosFechados(X,Y, Fechados):- findNeighbors((X,Y), L), vizinhosAbertos(X,Y, Abertos), diff(L, Abertos, Fechados).  

%%retorna lista das casas ja descobertas
vizinhosAbertos(X,Y, Abertos):- findNeighbors((X,Y), L),
				countValid(L, Abertos).
			
countValid([], []). 
countValid([H|T], V2):- known(H, _),!, countValid(T, V), append([H],V, V2).
countValid([H|T], V):- countValid(T, V).


%%retorna lista dos vizinhos que ja estao marcados como flag

vizinhosFlag(X,Y, Flagados):- vizinhosFechados(X,Y, Fechados), countFlag(Fechados, Flagados).

countFlag([], []). 
countFlag([(X,Y)|T], V2):- flag(X,Y),!, countFlag(T, V), append([(X,Y)],V, V2).
countFlag([(X,Y)|T], V):- countFlag(T, V).
   

		
%%acha todos os vizinhos possiveis	
findNeighbors((X,Y), N):- dim(DimX, DimY), X=<DimX, X>0, Y=<DimY, Y>0, allNeighbors((X,Y), AllN), filterNeighbors(AllN, N).

allNeighbors((X,Y),[(A,C),(X,C),(B,C),(A,Y),(B,Y),(A,D),(X,D),(B,D)]):- A is X-1, 
									B is X+1, 
									C is Y-1, 
									D is Y+1.

filterNeighbors([], []).
filterNeighbors([(X,Y)|T], Out):- dim(DimX, DimY), X > 0, X =< DimX, Y > 0, Y =< DimY, !, 
					filterNeighbors(T, Out1), 
					append([(X,Y)],Out1, Out).

filterNeighbors([H|T], Out):- filterNeighbors(T, Out).


%%caso base 1, numero de casas fechadas = valor da casa (logo todas sao bombas)
casoBase1(X,Y,1):-known(X,Y, Val), 
		vizinhosFechados(X, Y, Fechados), 
		length(Fechados, Nfechados), 
		Val > 0,		
		Val=Nfechados,!,		
		marcaFlag(Fechados),
		format("casobase1(~w) ~n", [(X,Y)]).

casoBase1(_,_,0).

marcaFlag([]).
marcaFlag([(X,Y)|T]):- flag(X,Y),!, marcaFlag(T).
marcaFlag([(X,Y)|T]):- assert(flag(X,Y)), marcaFlag(T).



%%caso base 2, se ja temos n flags marcadas e val =n, entao abrir todas as outras casas

casoBase2(X,Y,1):-known(X,Y, Val), 
		vizinhosFlag(X,Y,Flagados), 
		length(Flagados, Nflagados),
		Val>0, 
		Val=Nflagados,
		vizinhosFechados(X,Y, Fechados),
		length(Fechados, NFechados),
		NFechados > Nflagados,!,
		diff(Fechados, Flagados, Seguros),
		abreCasas(Seguros),
		format("casobase2(~w) ~n", [(X,Y)]).

casoBase2(_,_,0).

abreCasas([]).
abreCasas([(X,Y)|T]):- posicao(X,Y), abreCasas(T).

%%caso base 3 (pra nao esquecer)




%%caso chute



%%loop de jogadas
fazJogada(1):- findall((X2,Y2), known(X2,Y2, _), L),
			format("findall(~w) ~n", [L]),
			parseCasa(L,M),
			M > 0, !.

fazJogada(0):- chutaPosicao(X,Y),
		format("chutei(~w) ~n", [(X,Y)]), 
		posicao(X,Y), mina(X,Y),!.

fazJogada(1).

			


parseCasa([],0).
parseCasa([(X,Y)|T],M4):- parseCasa(T, M3), format("parse(~w) ~n", [[(X,Y)|T]]),
			casoBase1(X,Y,M1), 
			casoBase2(X,Y,M2), 
			M is M1+M2, 
			M4 is M3 + M.














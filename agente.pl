:- ensure_loaded(engine2).

%% Facilitadores
known((X,Y,V)):- known(X,Y,V).

randomMove:-.

start:- randomMove,
		findall(X, ).
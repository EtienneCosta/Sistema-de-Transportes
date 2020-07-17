

%--------------------------------------- Extras --------------------------------------------------------------------------------
% Lista todas as operadoras do sistema de transporte.

operadoras(L):-findall(Operadora,paragem(_,_,_,_,_,_,_,Operadora,_,_,_),R),
               sort(R,L).
    
%-------------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- Distância Euclidiana --------------------------------------------------------------

distance(P1/P2,Q1/Q2,D):- X is exp((Q1-P1),2),
                          Y is exp((Q2-P2),2),
                          K is sqrt(X+Y)*0.001,
                          truncate(K,4,D).


%----------------------------------------------------------------------------------------------------------------------------


%--------------------------------------- Truncate ---------------------------------------------------------------------------

truncate(X,N,Result):- X >= 0, 
                       Result is floor(10^N*X)/10^N, 
                       !.
%----------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- Estimativa -------------------------------------------------------------------------
% paragem: #Gid,#Carreira,Latitude,Longitude,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.

estima(Origem,Estima):- goal(Destino),
                       paragem(Origem,_,Px,Py,_,_,_,_,_,_,_),
                       paragem(Destino,_,Qx,Qy,_,_,_,_,_,_,_),
                       distance(Px/Py,Qx/Qy,Estima).

%--------------------------------------------------------------------------------------------------------------------------



%----- MapLength -----
mapLength([],[]).
mapLength([H|Tail],[L1|R]):-length(H,L1),
                            mapLength(Tail,R).

%----- Equals -----



%----- Diferentes -----




%----- Clean -----

clean:- findall(G,goal(G),R1),
          forEachG(R1).

%----- Foreach Goal -----

forEachG([]).
forEachG([H|T]):- retract(goal(H)),
                  forEachG(T).





%viii. Calcula o maior de um conjunto de valores.
maximum([],R):- write('Empty List'),
                !,
                fail.
maximum([X],X).
maximum([Head|Tail],R):- maximum(Tail,Rest),
                         maior(Head,Rest,R).
                        


maior(X,Y,X):- X>Y,
               !.
maior(X,Y,Y).


maiorNC([(_,R)],R).
maiorNC([Head|Tail],R):- maiorNC(Tail,Rest),
                         p2(Head,K),
                         maior(K,Rest,R).
p2((A,B),B).

%

foreEachNC([],_,[]).
foreEachNC([(A,B)|Tail],B,[(A,B)|R]):- foreEachNC(Tail,B,R).
foreEachNC([(A,B)|Tail],K,R):- foreEachNC(Tail,K,R).




%--------------------------- Apaga todas as ocorrências de um dado elemento numa lista ----------------------------------------

apagaT(X,[],[]).
apagaT(X,[X|Tail],R):- apagaT(X,Tail,R).
apagaT(X,[Head|Tail],[Head|R]):- apagaT(X,Tail,R).

%------------------------------------------------------------------------------------------------------------------------------



%---------------- Verifica se todos os elementos de uma lista pertencem a outra ------------------------------------------------

mapMemberChk([],_).
mapMemberChk([H|T],L):-memberchk(H,L),
                       mapMemberChk(T,L).

%------------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- Adjacente ----------------------------------------------------------------------------
% adjacente: #Carreira,GidO,GidD,DistOD,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.


adjacente(Nodo,ProxNodo,Custo):- 
adjacente(_,Nodo,ProxNodo,Custo,_,_,_,_,_,_,_).

adjacente(Nodo,ProxNodo,Custo):- 
	adjacente(_,ProxNodo,Nodo,Custo,_,_,_,_,_,_,_).

%------------------------------------------------------------------------------------------------------------------------------


%--------------------------------------- Verifica se duas listas são iguais ----------------------------------------------------

equals([],[]).
equals([H|T],[H|T]).

%------------------------------------------------------------------------------------------------------------------------------


inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

%--------------------------------------- Seleciona -------------------------------------------------------------------------------------

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

%----------------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- Custo -------------------------------------------------------------------------------------

custoTotal([X],0).
custoTotal([X,Y|Tail],Result):- adjacente(X,Y,K),
                                custoTotal([Y|Tail],Temp),
                                Result is K + Temp.

%---------------------------------------------------------------------------------------------------------------------------------------


%--------------------------------------- Printf ---------------------------------------------------------------------------


printf([]).
printf([Head|Tail]):- write('---------------------------------------------------------------------'),
                      write('\n'),
                      write('PARAGEM: '),
                      write(Head),
                      write('\n'),
                      write('---------------------------------------------------------------------'),
                      write('\n'),
                      printf(Tail).



%----------------------------------------------------------------------------------------------------------------------------------


% --- Função auxiliar
auxiliar([], Acc, Acc).
auxiliar([Elem], Acc, Result) :- auxiliar([], [Elem|Acc], Result).
auxiliar([Node1,Node2|Rest], Acc, Result) :- 
    \+ adjacente(Node1,Node2,_),
    auxiliar([Node1|Rest], Acc, Result).
auxiliar([Node1,Node2|Rest], Acc, Result) :-
    adjacente(Node1,Node2,_),
    auxiliar([Node2|Rest], [Node1|Acc], Result).

removeNotConnected(List, Result) :- auxiliar(List, [], Result).
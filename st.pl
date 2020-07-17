% SICStus PROLOG: Sistema de Transportes 
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag(unknown,fail).
:- use_module(library(lists)).
:- set_prolog_flag(toplevel_print_options,
    [quoted(true), portrayed(true), max_depth(0)]).

:- include('auxiliar').
:- include('paragens').
:-include('adjacente').
:- dynamic(goal/1).


% paragem: #Gid,#Carreira,Latitude,Longitude,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.
% adjacente: #Carreira,GidO,GidD,DistOD,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.


%--------------------------------------- a) ----------------------------------------------------------------------------------
/*

a) Calcular um trajeto entre dois pontos.

O - Origem.
D - Destino.
T - Trajecto: Lista de gids percorridos .
    Distância Total percorrida. --- Acrescentar

Testes: 

trajecto(183,79,Trajecto).

trajecto(791,499,Trajecto).

trajecto(183,613,Trajecto).


*/

%---------------------------"Possível Solução Correta FICHA 9  Funcional"-----------------------------------------------------

trajecto(O,D,T):- trajectoAux(O,[D],T),
                  printf(T).

trajectoAux(O,[O|T1],[O|T1]).
trajectoAux(O,[D|T1],T):- adjacente(Carreira,X,D,_,_,_,_,Operadora,_,_,_),
                          \+ memberchk(X,[D|T1]),
                           trajectoAux(O,[X,(Carreira,Operadora,D)|T1],T).

%        trajectoAux(O,[X,D|T1],T).                   trajectoAux(O,[X,(Carreira,Operadora,D)|T1],T).

%---------------------------------------------------------------------------------------------------------------------------

%--------------------------- "Depth First Search"---------------------------------------------------------------------------
resolveDF(Origem,Destino,[Origem|Solucao],Km):-
    assert(goal(Destino)),
	resolvedf(Origem, [Origem],Solucao),
    printf([Origem|Solucao]),
    custoTotal([Origem|Solucao],Km).

resolvedf(Node,_,[]):-
	goal(Node),
    !,
    clean.


resolvedf(Node, Historico, [ProxNodo|Solucao]):-
    adjacente(Node,ProxNodo,_),
	\+(member(ProxNodo,Historico)),
	resolvedf(ProxNodo, [ProxNodo|Historico], Solucao).
    
%---------------------------------------------------------------------------------------------------------------------------

%--------------------------- "Bredth First Search"---------------------------------------------------------------------------

resolveBF(Origin, Destiny, Visited,Km) :-
    resolvebf([Origin],[],RevVisited,Destiny),
    removeNotConnected(RevVisited, Visited).
    %printf(Visited).
    %custoTotal(Visited,Km).

resolvebf([Destiny|_], History, [Destiny|History], Destiny).
resolvebf([Node|RestQ], History, RevVisited, Destiny) :-
    findall(NextNode, (adjacente(Node,NextNode,_), \+ member(NextNode, History), \+ member(NextNode, RestQ)), Successors), 
    append(RestQ, Successors, Queue), 
    resolvebf(Queue, [Node|History], RevVisited, Destiny).    

%---------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- b) ----------------------------------------------------------------------------------
/*

b) Selecionar apenas algumas operadoras de transporte para um determinado percurso.
O - Origem.
D - Destino.
Ops - Operadoras desejadas para o percurso.
T - Trajecto: Lista de gids percorridos .

percusoCAO : percurso Com As Operadoras.



percursoCAO(128,161,['SCoTTURB'],R).
no. ->  " Visto que não é possível fazer o percurso só com a operadora SCoTTURB."


percursoCAO(128,161,['Vimeca','SCoTTURB'],R). 




*/

%---------------------------"Possível Solução Correta FICHA 9"-------------------------------------------------------------

percursoCAO(O,D,Operadoras,T):- percursoCAOAux(O,[D],Operadoras,T),
                                printf(T).
percursoCAOAux(O,[O|T1],_,[O|T1]).
percursoCAOAux(O,[D|T1],Operadoras,T):- adjacente(Carreira,X,D,_,_,_,_,Operadora,_,_,_),
                                        memberchk(Operadora,Operadoras),
                                        \+ memberchk(X,[D|T1]),
                                        percursoCAOAux(O,[X,(Carreira,Operadora,D)|T1],Operadoras,T).
%--------------------------------------------------------------------------------------------------------------------------
                                       
%---------------------------"Depth First Search"---------------------------------------------------------------------------

resolveDFCAO(Origem,Destino,Operadoras,[Origem|Solucao]):-
    assert(goal(Destino)),
	resolvedfcao(Origem,[Origem],Operadoras,Solucao),
    printf([Origem|Solucao]).

resolvedfcao(Node,_,_,[]):-
	goal(Node),
    !,
    clean.


resolvedfcao(Node,Historico,Operadoras,[ProxNodo|Solucao]):-
    adjacente(_,Node,ProxNodo,_,_,_,_,Operadora,_,_,_),
    member(Operadora,Operadoras),
	\+(member(ProxNodo,Historico)),
	resolvedfcao(ProxNodo, [ProxNodo|Historico],Operadoras,Solucao).		


%----------------------------------------------------------------------------------------------------------------------------


%--------------------------- "Bredth First Search"---------------------------------------------------------------------------

resolveBFCAO(Origin, Destiny,Operadoras,Visited,Km) :-
    resolvebfcao([Origin],[],RevVisited,Destiny,Operadoras),
    removeNotConnected(RevVisited, Visited),
    printf(Visited),
    custoTotal(Visited,Km).

resolvebfcao([Destiny|_], History, [Destiny|History], Destiny,Operadoras).
resolvebfcao([Node|RestQ], History, RevVisited, Destiny,Operadoras) :-
    findall(NextNode, (adjacente(_,Node,NextNode,_,_,_,_,Operadora,_,_,_),member(Operadora,Operadoras), \+ member(NextNode, History), \+ member(NextNode, RestQ)), Successors), 
    append(RestQ, Successors, Queue), 
    resolvebfcao(Queue, [Node|History], RevVisited, Destiny,Operadoras).    

%---------------------------------------------------------------------------------------------------------------------------







%--------------------------------------- c) ----------------------------------------------------------------------------------


/*
 
c) Excluir um ou mais operadores de transporte para o percurso.
O - Origem.
D - Destino.
Operadoras - Operadoras não desejadas para o percurso.
T - Trajecto: Lista de gids percorridos .

percusoSAO : percurso Sem As Operadoras.


percursoSAO(128,161,['SCoTTURB'],R).

*/


%---------------------------"Possível Solução Correta FICHA 9"-------------------------------------------------------------


percursoSAO(O,D,Operadoras,T):- percursoSAOAux(O,[D],Operadoras,T),
                                printf(T).

percursoSAOAux(O,[O|T1],_,[O|T1]).
percursoSAOAux(O,[D|T1],Operadoras,T):- adjacente(Carreira,X,D,_,_,_,_,Operadora,_,_,_),
                                     \+ memberchk(Operadora,Operadoras),
                                     \+ memberchk(X,[D|T1]),
                                     percursoSAOAux(O,[X,(Carreira,Operadora,D)|T1],Operadoras,T).

%--------------------------------------------------------------------------------------------------------------------------

%---------------------------"Depth First Search"---------------------------------------------------------------------------
resolveDFSAO(Origem,Destino,Operadoras,[Origem|Solucao]):-
    assert(goal(Destino)),
	resolvedfsao(Origem,[Origem],Operadoras,Solucao).

resolvedfsao(Node,_,_,[]):-
	goal(Node),
    !,
    clean.


resolvedfsao(Node, Historico,Operadoras,[ProxNodo|Solucao]):-
    adjacente(_,Node,ProxNodo,_,_,_,_,Operadora,_,_,_),
    \+(member(Operadora,Operadoras)),
	\+(member(ProxNodo,Historico)),
	resolvedfsao(ProxNodo, [ProxNodo|Historico],Operadoras,Solucao).		


%--------------------------------------------------------------------------------------------------------------------------


%--------------------------- "Bredth First Search"---------------------------------------------------------------------------

resolveBFSAO(Origin, Destiny,Operadoras,Visited,Km) :-
    resolvebfsao([Origin],[],RevVisited,Destiny,Operadoras),
    removeNotConnected(RevVisited, Visited),
    printf(Visited),
    custoTotal(Visited,Km).

resolvebfsao([Destiny|_], History, [Destiny|History], Destiny,Operadoras).
resolvebfsao([Node|RestQ], History, RevVisited, Destiny,Operadoras) :-
    findall(NextNode, (adjacente(_,Node,NextNode,_,_,_,_,Operadora,_,_,_),\+ member(Operadora,Operadoras), \+ member(NextNode, History), \+ member(NextNode, RestQ)), Successors), 
    append(RestQ, Successors, Queue), 
    resolvebfsao(Queue, [Node|History], RevVisited, Destiny,Operadoras).    

%---------------------------------------------------------------------------------------------------------------------------









%--------------------------------------- d) -------------------------------------------------------------------------------
/*
 
d) Identificar quais as paragens com o maior número de carreiras num determinado percurso.
O - Origem.
D - Destino.
T - Trajecto: Par de gids percorridos bem como o número de carreiras associadas a paragem.
F - Paragens com o maior número de carreiras no percurso realizado.

percursoMNC :   percurso com paragens com Maior Número de Carreiras.

percursoMNC(183,613,T,MNC).
*/

percursoMNC(O,D,T,Final):-percursomnc(O,[D],T,Final),
                          printf(Final).
                  

percursomnc(O,[O|T1],[(O,Size)|T1],Final):- 
    findall(Cs,adjacente(Cs,_,O,_,_,_,_,_,_,_,_),Car),
    length(Car,Size).

percursomnc(O,[D|T1],T,Final):-
    findall(C,adjacente(C,_,D,_,_,_,_,_,_,_,_),Carreiras),
    length(Carreiras,Size),
    adjacente(_,X,D,_,_,_,_,_,_,_,_),
    \+(memberchk(X,[D|T1])),
    percursomnc(O,[X,(D,Size)|T1],T,Final),
    maiorNC(T,Maior),
    foreEachNC(T,Maior,Final).

%--------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- e) -------------------------------------------------------------------------------
/*
 
e)Escolher o menor percurso usando critério menor número de paragens.


percursoMNP(O,D,T):- findall((S,NrParagens),(trajecto(O,D,S),length(S,NrParagens)),L),
                      minimo(L,T). 

melhordf(S,Custo):- findall((S,C),(resolvedf(S), length(S,C)),L),
				  minimo(L,(S,Custo)).



minimo([(P,X)],(P,X)).
minimo([(Px,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y.
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), X=<Y.

resolveBF

*/

percursoMNP(O,D,T):- findall((S,NrParagens),(resolveBF(O,D,S,_),length(S,NrParagens)),L),
                      minimo(L,T). 


minimo([(P,X)],(P,X)).
minimo([(Px,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y.
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), X=<Y.

%--------------------------------------------------------------------------------------------------------------------------


%--------------------------------------- f) --------------------------------------------------------------------------------
/*
 
f)Escolher o percurso mais rápido usando critério da distância.

*/

resolve_aestrela(Origem,Destino,Caminho/Custo) :-
    assert(goal(Destino)),
	estima(Origem,Estima),
	aestrela([[Origem]/0/Estima], InvCaminho/Custo/_),
	inverso(InvCaminho, Caminho).
    

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,goal(Nodo).

aestrela(Caminhos, SolucaoCaminho):-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, SolucaoCaminho).		


obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

	
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor(Caminhos, MelhorCaminho).

expande_aestrela(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacenteEstrela(Caminho,NovoCaminho), ExpCaminhos).

adjacenteEstrela([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    adjacente(Nodo,ProxNodo,PassoCusto),
    \+ member(ProxNodo,Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo,Est).
    
%--------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- g) -------------------------------------------------------------------------------
/*
g) Escolher o percurso que passe apenas por abrigos com publicidade.

O - Origem.

D - Destino.

T - Trajecto: Lista de gids percorridos .

percusoACP : Percurso que passe por Abrigos Com Publicidade.   

percursoACP(268,827,T).



*/
%---------------------------"Possível Solução Correta FICHA 9"-------------------------------------------------------------

% adjacente: #Carreira,GidO,GidD,DistOD,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.

percursoACP(O,D,T):- percursoacp(O,[D],T).
percursoacp(O,[O|T1],[O|T1]).
percursoacp(O,[D|T1],T):- adjacente(Carreira,X,D,_,_,_,Publicidade,Operadora,_,_,_),
                          memberchk(Publicidade,['Yes']),
                          \+ memberchk(X,[D|T1]),
                          percursoacp(O,[X,(Carreira,Operadora,D,Publicidade)|T1],T).



%--------------------------------------------------------------------------------------------------------------------------

%---------------------------"Depth First Search"---------------------------------------------------------------------------
resolveDFACP(Origem,Destino,[Origem|Solucao]):-
    assert(goal(Destino)),
	resolvedfacp(Origem,[Origem],Solucao).

resolvedfacp(Node,_,[]):-
	goal(Node),
    !,
    clean.


resolvedfacp(Node, Historico,[ProxNodo|Solucao]):-
    adjacente(_,Node,ProxNodo,_,_,_,'Yes',_,_,_,_),
	\+(member(ProxNodo,Historico)),
	resolvedfacp(ProxNodo, [ProxNodo|Historico],Solucao).		


%--------------------------------------------------------------------------------------------------------------------------

%--------------------------------------------------------------------------------------------------------------------------


%--------------------------------------- h) -------------------------------------------------------------------------------
/*
h) Escolher o percurso que passe apenas por paragens abrigadas.


O - Origem.

D - Destino.

T - Trajecto: Lista de gids percorridos .

percusoPA : Percurso que passe apenas por Paragens Abrigadas. 


*/

%---------------------------"Possível Solução Correta FICHA 9"-------------------------------------------------------------


% adjacente: #Carreira,GidO,GidD,DistOD,Estado,Abrigo,Publicidade,Operadora,Codigo,Rua,Freguesia.

percursoPA(O,D,T):- percursopa(O,[D],T).
percursopa(O,[O|T1],[O|T1]).
percursopa(O,[D|T1],T):- adjacente(Carreira,X,D,_,_,Abrigo,_,Operadora,_,_,_),
                          memberchk(Abrigo,['Aberto dos Lados','Fechado dos Lados']),
                          \+ memberchk(X,[D|T1]),
                          percursopa(O,[X,(Carreira,Operadora,D,Abrigo)|T1],T).

%--------------------------------------------------------------------------------------------------------------------------

%---------------------------"Depth First Search"---------------------------------------------------------------------------


%--------------------------------------------------------------------------------------------------------------------------

%--------------------------------------- i) -------------------------------------------------------------------------------
/*
i) Escolher um ou mais pontos intermédios por onde o percurso deverá passar.


O - Origem.

D - Destino.

Intermedios - Lista de paragens que devem pertencer obrigatoriamente ao percurso.

T - Trajecto: Lista de gids percorridos .

percusoCPI : Percurso Com Pontos Intermédios.


*/

percursoCPI(O,D,Intermedios,T):- findall(Or,adjacente(_,Or,_,_,_,_,_,_,_,_,_),Partidas),
                                 findall(Des,adjacente(_,_,Des,_,_,_,_,_,_,_,_),Destinos),
                                 sort(Partidas,R1),
                                 sort(Destinos,R2),
                                 mapMemberChk(Intermedios,R1),
                                 mapMemberChk(Intermedios,R2),
                                 percursocpi(O,[D],Intermedios,T),
                                 printf(T).

percursocpi(O,[O|T1],[],[O|T1]).
percursocpi(O,[D|T1],Intermedios,T):-   adjacente(Carreira,X,D,_,_,_,_,Operadora,_,_,_),
                                        memberchk(X,Intermedios),
                                        apagaT(X,Intermedios,I),
                                        \+ memberchk(X,[D|T1]),
                                        percursocpi(O,[X,(Carreira,Operadora,D)|T1],I,T).

percursocpi(O,[D|T1],Intermedios,T):-  adjacente(Carreira,X,D,_,_,_,_,Operadora,_,_,_),
                                    \+ memberchk(X,Intermedios),
                                    \+ memberchk(X,[D|T1]),
                                       percursocpi(O,[X,(Carreira,Operadora,D)|T1],Intermedios,T).




%--------------------------------------------------------------------------------------------------------------------------

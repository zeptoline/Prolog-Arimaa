:- module(bot,[get_moves/3]).

% default call
%get_moves([
%         [[1,0],[2,0]],
%         [[0,0],[1,0]],
%         [[0,1],[0,0]],
%         [[0,0],[0,1]]
%       ], Gamestate, Board).

get_moves(M, Gamestate, Board) :- test(M,Board).
% ------------------------------------------------------------------------------
% declare the dynamic fact
:- dynamic moves/1.

% predicat to add a new move to the list of moves
add_move(NewMove) :- moves(M), retract(moves(M)), asserta(moves([NewMove|M])).

% init moves with an empty list, add a new move to this list, return the new moves with the added move
% botMouvAlea s'effectue 4 fois d'affilés, à chaque fois avec un nouveau board issu du déplacement précédent.
% Les fonctions add_move sont effectué à l'envers car le logiciel demande à ce que le premier coup à effectué soit le premier de la liste
test(M,Board) :- asserta(moves([])), 
                 botMouvAlea(Board, Board, Mouv, [[-1, -1], [-1, -1]]), change_board(Board, Mouv, NewBoard1), 
                 botMouvAlea(NewBoard1, NewBoard1, Mouv2, Mouv), change_board(NewBoard1, Mouv2, NewBoard2), 
                 botMouvAlea(NewBoard2, NewBoard2, Mouv3, Mouv2), change_board(NewBoard2, Mouv3, NewBoard3), 
                 botMouvAlea(NewBoard3, NewBoard3, Mouv4, Mouv3),
                 add_move(Mouv4), add_move(Mouv3), add_move(Mouv2), add_move(Mouv), 
                 moves(M).
% ------------------------------------------------------------------------------
% -------------------------------- NOTES ---------------------------------------
% PUSH / PULL marchent coter joueur (GOLD)
% Les traps fonctionnent.

% probleme : YOUR BOT >> {"Moves":[[[1,2],[2,2]],[[0,2],[1,2]],[[2,2],[3,2]],[[0,1],[0,2]]]}
% probleme : YOUR BOT >> {"Moves":[[[3,6],[4,6]],[[4,5],[5,5]],[[5,5],[6,5]],[[2,2],[3,2]]]}
% -> probleme quand on veut bouger 2 fois la meme pice

% pour la fin de partie (ensemble de mouvements trouver pour gagner, ne pas rajouter de mouvement inutiles, voir ecran gagnant coter silver)

% ------------------------------------------------------------------------------
% [1,0] avec X=1 et Y=0, X axe des ordonées, Y des abscisses en partant du haut gauche du plateau
% A few comments but all is explained in README of github

% get_moves signature
% get_moves(Moves, gamestate, board).

% Exemple of variable
% gamestate: [side, [captured pieces] ] (e.g. [silver, [ [0,1,rabbit,silver],[0,2,horse,silver] ]) 
% board: [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]

% Call exemple:
% get_moves(Moves, [silver, []], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).
% ------------------------------------------------------------------------------

% PossiblesMoves : [[[1,0],[2,0]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]], ...]
% Renvoi la liste des coups possibles qui sont en accord avec les règles
% get_possible_moves(PossiblesMoves, Gamestate, Board).

% Regarde les voisins d'une pièce, et determine si le pion voisin est plus fort
% [Xp, Yp, Anp, Sidep] piece dont on cherche les voisins
% [[X, Y, An, Side] | Q] le board. piece sur le board, check par recursiviter

% Tests :
% voisin_enemie_plus_fort([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,dog,gold],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver]], V).
% voisin_enemie_plus_fort([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,dog,gold],[0,1,loup,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver]], V).

% cases_libres([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]], V).
% cases_libres([1,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]], V).

% ------------------------------------------------------------------------------
% -----------------------------  FAITS   ---------------------------------------
% ------------------------------------------------------------------------------
est_plus_faible(rabbit, cat).
est_plus_faible(rabbit, dog).
est_plus_faible(rabbit, horse).
est_plus_faible(rabbit, camel).
est_plus_faible(rabbit, elephant).

est_plus_faible(cat, dog).
est_plus_faible(cat, horse).
est_plus_faible(cat, camel).
est_plus_faible(cat, elephant).

est_plus_faible(dog, horse).
est_plus_faible(dog, camel).
est_plus_faible(dog, elephant).

est_plus_faible(horse, camel).
est_plus_faible(horse, elephant).

est_plus_faible(camel, elephant).

trap([2,2]).
trap([2,5]).
trap([5,2]).
trap([5,5]).

% ------------------------------------------------------------------------------
% -----------------------------  Regles   --------------------------------------
% ------------------------------------------------------------------------------
est_plus_fort(A, B) :-  est_plus_faible(B, A), A\=B.

est_egal(A, B) :- A = B.
% ------------------------------------------------------------------------------
voisins(Pion, [], []).
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp - 1 =:= X, Yp =:= Y    , voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp + 1 =:= X, Yp =:= Y    , voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp =:= X    , Yp - 1 =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp =:= X    , Yp + 1 =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], Vois) :- voisins([Xp, Yp, Anp, Sidep], Q, Vois). % cas piece non voisine
% ------------------------------------------------------------------------------
voisin_enemie_plus_fort(Pion, Board, VoisinsEneForts) :- voisins(Pion, Board, Voisins), checkVEPF(Pion, Voisins, VoisinsEneForts).
checkVEPF(Pion, [], []).
checkVEPF([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side]|VoisinsEneForts]) :- est_plus_fort(An,Anp), Sidep\=Side, checkVEPF([Xp, Yp, Anp, Sidep], Q, VoisinsEneForts), !.
checkVEPF([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], VoisinsEneForts) :- checkVEPF([Xp, Yp, Anp, Sidep], Q, VoisinsEneForts).
% ------------------------------------------------------------------------------
voisin_allie(Pion, Board, VoisinsAllie) :- voisins(Pion, Board, Voisins), checkVA(Pion, Voisins, VoisinsAllie).
checkVA(Pion, [], []).
checkVA([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side]|VoisinsAllie]) :- Sidep = Side, checkVA([Xp, Yp, Anp, Sidep], Q, VoisinsAllie), !.
checkVA([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], VoisinsAllie) :- checkVA([Xp, Yp, Anp, Sidep], Q, VoisinsAllie).
% ------------------------------------------------------------------------------
retire_case_en_dehors(X, Y, CasesL) :- Xn is X-1, Xp is X+1, Yn is Y-1, Yp is Y+1, delete([[Xn, Y], [Xp, Y], [X, Yn], [X, Yp]], [-1, _], C1), delete(C1, [8, _], C2), delete(C2, [_, -1], C3), delete(C3, [_, 8], CasesL).
retire_case_avec_voisin(CasesL, [], CasesL):- !.
retire_case_avec_voisin(CasesL, [[X, Y, _, _] | Q], CasesP) :- retire_case_avec_voisin(CasesL, Q, CasesV), delete(CasesV, [X, Y], CasesP).

cases_libres([X, Y, rabbit, silver], Board, Cases) :- voisins([X, Y, An, Side], Board, Vois), retire_case_en_dehors(X,Y,CasesL), retire_case_avec_voisin(CasesL, Vois, CasesT), XImposible is X-1, delete(CasesT, [XImposible, _], Cases), !.
cases_libres([X, Y, rabbit, golden], Board, Cases) :- voisins([X, Y, An, Side], Board, Vois), retire_case_en_dehors(X,Y,CasesL), retire_case_avec_voisin(CasesL, Vois, CasesT), XImposible is X+1, delete(CasesT, [XImposible, _], Cases), !.
cases_libres([X, Y, An, Side], Board, Cases)       :- voisins([X, Y, An, Side], Board, Vois), retire_case_en_dehors(X,Y,CasesL), retire_case_avec_voisin(CasesL, Vois, Cases).
% ------------------------------------------------------------------------------
  % Présence ennemie + fort mais alié à coté, DONC si enemie pas de soutien allie, on renvoie faux
soutien_alie(Pion, Board) :- voisin_enemie_plus_fort(Pion, Board, V), V=[], !.
soutien_alie(Pion, Board) :- voisin_enemie_plus_fort(Pion, Board, _), voisin_allie(Pion, Board, V), V\=[].
% ------------------------------------------------------------------------------
trap_safe([XTrap,YTrap], [XPion, YPion, AnPion, SidePion], Board) :- \+trap([XTrap,YTrap]), ! . % Si l'emplacement n'est pas une trap, alors il est safe automatiquement
trap_safe([XTrap,YTrap], [XPion, YPion, AnPion, SidePion], Board) :-  voisin_allie([XTrap, YTrap, AnPion, SidePion], Board, [VoisinsAllieT|VoisinsAllieQ]), VoisinsAllieQ\=[].
  % trap_safe([2,2], [1,2,rabbit,silver], [[1,2,rabbit,silver],[3,2,rabbit,silver]]).
% ------------------------------------------------------------------------------
  % utile pour de pultiples choses mais surtout savoir si une trape est dans les mouvement possible
element(X, [X|Q]).
element(X, [T|Q]) :- element(X, Q).
% ------------------------------------------------------------------------------
deplacement_format_bot([Xp, Yp, Anp, Sidep], [], []):- !.
deplacement_format_bot([Xp, Yp, Anp, Sidep], [[MT1,MT2]|MouvementsQ], [[[Xp,Yp],[MT1,MT2]]|DeplacementsQ]) :- deplacement_format_bot([Xp, Yp, Anp, Sidep], MouvementsQ, DeplacementsQ), !.
  % deplacement_format_bot([1,4,rabbit,silver], [[1,2],[10,10]], Deplacements).
% ------------------------------------------------------------------------------
% mouvement possible (distinction lapin/le reste,
%           case libre autour,
%           présence ennemie + fort mais alié à coté,
%           deplacement dans le piège avec alié à coté (du piège),
%           dans le dernier cas, aller dans un piège sans alié)

% distinction des mouvements lapin directement gerer dans la régle cases_libres
% deplacement dans le piège avec alié à coté (du piège) / dans le dernier cas, aller dans un piège sans alié) : fait partie de la strategie donc non gerer ici

% cas enemie plus fort mais pas de soutien allier
mouvementsPossible([Xp, Yp, Anp, Sidep], Board, []) :- %voisin_enemie_plus_fort([Xp, Yp, Anp, Sidep],Board,Enemis), 
                                                       %Enemis\=[], 
                                                       \+soutien_alie([Xp, Yp, Anp, Sidep], Board), !.
% cas enemie plus fort mais soutien allier       
%mouvementsPossible([Xp, Yp, Anp, Sidep], Board, Mouvements) :- voisin_enemie_plus_fort([Xp, Yp, Anp, Sidep],Board,Enemis), Enemis\=[], soutien_alie([Xp, Yp, Anp, Sidep], Board), cases_libres([Xp, Yp, Anp, Sidep], Board, MouvementsT), deplacement_format_bot([Xp, Yp, Anp, Sidep], MouvementsT, Mouvements), !.

%%%%%%%%%%A VOIRE mais soutien alié ne verifie pas déjà les voisins plus forts ?
mouvementsPossible([Xp, Yp, Anp, Sidep], Board, Mouvements) :- voisin_enemie_plus_fort([Xp, Yp, Anp, Sidep],Board,Enemis), 
                                                               Enemis\=[], 
                                                               soutien_alie([Xp, Yp, Anp, Sidep], Board), 
                                                               cases_libres([Xp, Yp, Anp, Sidep], Board, MouvementsT),
                                                               deplacement_format_bot([Xp, Yp, Anp, Sidep], MouvementsT, Mouvements), !.
% cas pas d'enemis, on cherche les cases libres a coter
mouvementsPossible([Xp, Yp, Anp, Sidep], Board, Mouvements) :- voisin_enemie_plus_fort([Xp, Yp, Anp, Sidep],Board,Enemis), 
                                                               Enemis=[], 
                                                               cases_libres([Xp, Yp, Anp, Sidep], Board, MouvementsT), 
                                                               deplacement_format_bot([Xp, Yp, Anp, Sidep], MouvementsT, Mouvements), !.
% ------------------------------------------------------------------------------
% Donne un nouveau board qui contient les changement lié au dernier mouvement
change_board([], _, []):- !.
change_board([[X, Y, Anp, Sidep]| Q], [[X, Y], [X2, Y2]], [[X2, Y2, Anp, Sidep] | Q]):- !.
change_board([T|Q], Move, [T|Q2]) :- change_board(Q, Move, Q2).
% ------------------------------------------------------------------------------
mouv_opose([[X1, Y1], [X2, Y2]], [[X2, Y2], [X1, Y1]]).
% ------------------------------------------------------------------------------
% donne un element aleatoire d'une liste  
choose([], []).
choose(List, Elt) :- length(List, Length), random(0, Length, Index), nth0(Index, List, Elt).
% ------------------------------------------------------------------------------
% botMouvAlea(Board, [[XPion, YPion, AnPion, SideP]|Q], Mouvement) :- SideP = silver, AnPion = rabbit, mouvementsPossible([XPion, YPion, AnPion, SideP], Board, [TMouv|QMouv]), TMouv\=[], Mouvement = TMouv, !.
%botMouvAlea(Board, [[XPion, YPion, AnPion, SideP]|Q], Mouvement, LastMouv) :- SideP = silver, mouvementsPossible([XPion, YPion, AnPion, SideP], Board, [TMouv|QMouv]), TMouv\=[], \+mouv_opose(TMouv, LastMouv), Mouvement = TMouv, !.
%botMouvAlea(Board, [[XPion, YPion, AnPion, SideP]|Q], Mouvement, LastMouv) :- botMouvAlea(Board,Q,Mouvement, LastMouv), !.
  %botMouvAlea([[0,0,rabbit,golden],[0,1,dog,silver]], [[0,0,rabbit,golden],[0,1,dog,silver]], M).

%%%%%%%%%% Si aucun mouvement n'est possible, la fonction risque de tourner à l'infini. Peut-être faire un test "aucun_mouvement" qui teste chaque pions ?
botMouvAlea(Board, [], [], _).
botMouvAlea(Board, Board, Mouvement, LastMouv) :- choose(Board, [XPion, YPion, AnPion, SideP]), 
                                                  SideP = silver, 
                                                  mouvementsPossible([XPion, YPion, AnPion, SideP], Board, [TMouv|QMouv]), 
                                                  TMouv\=[], 
                                                  \+mouv_opose(TMouv, LastMouv), 
                                                  Mouvement = TMouv, !.
botMouvAlea(Board, Board, Mouvement, LastMouv) :- botMouvAlea(Board,Board,Mouvement, LastMouv), !.
% ------------------------------------------------------------------------------
% regles, si pour un lapin il est possible d'arriver sur la 1er ligne adversaire en 4 coups ou moins, il le fait et l'IA gagne
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
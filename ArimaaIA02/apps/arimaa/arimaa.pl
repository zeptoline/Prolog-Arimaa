%:- module(bot,
 %     [  get_moves/3
  %    ]).
	
% A few comments but all is explained in README of github

% get_moves signature
% get_moves(Moves, gamestate, board).

% Exemple of variable
% gamestate: [side, [captured pieces] ] (e.g. [silver, [ [0,1,rabbit,silver],[0,2,horse,silver] ]) 
% board: [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]

% Call exemple:
% get_moves(Moves, [silver, []], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).



% PossiblesMoves : [[[1,0],[2,0]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]], ...]
% Renvoi la liste des coups possibles qui sont en accord avec les règles
get_possible_moves(PossiblesMoves, Gamestate, Board).

% Regarde les voisins d'une pièce, et determine si le pion voisin est plus fort


voisins(X, [], []).
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xt is Xp - 1, Yt is Yp, Xt =:= X, Yt =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xt is Xp + 1, Yt is Yp, Xt =:= X, Yt =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xt is Xp, Yt is Yp - 1, Xt =:= X, Yt =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xt is Xp, Yt is Yp + 1, Xt =:= X, Yt =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], Vois) :- voisins([Xp, Yp, Anp, Sidep], Q, Vois).


% voisin_plus_fort(Pion, board, voisinsForts)
% voisin_plus_fort([Xp, Yp, Anp, Sidep], [], voisinsForts).
% voisin_plus_fort([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], voisinsForts) :- Xt as Xp +1.



 est_plus_faible(lapin, chat).
 est_plus_faible(lapin, chien).
 est_plus_faible(lapin, cheval).
 est_plus_faible(lapin, chameau).
 est_plus_faible(lapin, elephant).

 est_plus_faible(chat, chien).
 est_plus_faible(chat, cheval).
 est_plus_faible(chat, chameau).
 est_plus_faible(chat, elephant).

 est_plus_faible(chien, cheval).
 est_plus_faible(chien, chameau).
 est_plus_faible(chien, elephant).

 est_plus_faible(cheval, chameau).
 est_plus_faible(cheval, elephant).

 est_plus_faible(chameau, elephant).

est_plus_fort(A, B) :-  est_plus_faible(B, A), A\= B.

est_egal(A, B) :- A = B.


% default call
get_moves([[[1,0],[2,0]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).

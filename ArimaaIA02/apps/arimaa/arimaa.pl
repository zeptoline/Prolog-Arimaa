:- module(bot,[get_moves/3]).
	
% default call
get_moves([[[1,0],[2,0]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]]], Gamestate, Board).

% A few comments but all is explained in README of github

% get_moves signature
% get_moves(Moves, gamestate, board).

% Exemple of variable
% gamestate: [side, [captured pieces] ] (e.g. [silver, [ [0,1,rabbit,silver],[0,2,horse,silver] ]) 
% board: [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]

% Call exemple:
% get_moves(Moves, [silver, []], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

% ------------------------------------------------------------------------------
% -----------------------           CODE               -------------------------
% ------------------------------------------------------------------------------

% PossiblesMoves : [[[1,0],[2,0]],[[0,0],[1,0]],[[0,1],[0,0]],[[0,0],[0,1]], ...]
% Renvoi la liste des coups possibles qui sont en accord avec les règles
% get_possible_moves(PossiblesMoves, Gamestate, Board).

% Regarde les voisins d'une pièce, et determine si le pion voisin est plus fort
% [Xp, Yp, Anp, Sidep] piece dont on cherche les voisins
% [[X, Y, An, Side] | Q] le board. piece sur le board, check par recursiviter

% ------------------------------------------------------------------------------
voisins(Pion, [], []).
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp - 1 =:= X, Yp =:= Y    , voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp + 1 =:= X, Yp =:= Y    , voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp =:= X    , Yp - 1 =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side] | Vois]) :- Xp =:= X    , Yp + 1 =:= Y, voisins([Xp, Yp, Anp, Sidep], Q, Vois), !.
voisins([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], Vois) :- voisins([Xp, Yp, Anp, Sidep], Q, Vois). % cas piece non voisine

	% Tests :
	% voisins([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver]], V).
	% voisins([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]], V).

% ------------------------------------------------------------------------------
voisin_enemie_plus_fort(Pion, Board, VoisinsEneForts) :- voisins(Pion, Board, Voisins), checkVEPF(Pion, Voisins, VoisinsEneForts).

checkVEPF(Pion, [], []).
checkVEPF([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side]|VoisinsEneForts]) :- est_plus_fort(An,Anp),
                                                                                               Sidep\=Side,
                                                                                               checkVEPF([Xp, Yp, Anp, Sidep], Q, VoisinsEneForts), !.
checkVEPF([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], VoisinsEneForts) :- checkVEPF([Xp, Yp, Anp, Sidep], Q, VoisinsEneForts).

	% Tests :
	% voisin_enemie_plus_fort([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,dog,gold],[0,1,loup,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver]], V).
% ------------------------------------------------------------------------------
voisin_allie(Pion, Board, VoisinsAllie) :- voisins(Pion, Board, Voisins), checkVA(Pion, Voisins, VoisinsAllie).

checkVA(Pion, [], []).
checkVA([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], [[X, Y, An, Side]|VoisinsAllie]) :- Sidep = Side, checkVA([Xp, Yp, Anp, Sidep], Q, VoisinsAllie), !.
checkVA([Xp, Yp, Anp, Sidep], [[X, Y, An, Side] | Q], VoisinsAllie) :- checkVA([Xp, Yp, Anp, Sidep], Q, VoisinsAllie).
	
	% tests
	% voisin_allie([0,0,rabbit,silver], [[0,0,rabbit,silver],[0,1,dog,gold],[0,1,loup,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver]], V).

% présence ennemie + fort mais alié à coté, DONC si enemie pas de soutien allie, on renvoie faux
soutien_alie(Pion, Board) :- voisin_enemie_plus_fort(Pion, Board, V), V=[], !.
soutien_alie(Pion, Board) :- voisin_enemie_plus_fort(Pion, Board, _), voisin_allie(Pion, Board, V), V\=[].

	% tests
	% soutien_alie([0,0,rabbit,silver], [[1,0,rabbit,silver],[0,1,dog,gold],[0,1,loup,silver]]).
	% soutien_alie([0,0,rabbit,silver], [[1,0,rabbit,silver],[0,1,dog,silver],[0,1,loup,silver]]).
	% soutien_alie([0,0,rabbit,silver], [[1,0,rabbit,gold],[0,1,dog,silver],[0,2,dog,silver]]).

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

est_plus_fort(A, B) :-  est_plus_faible(B, A), A\=B.

est_egal(A, B) :- A = B.
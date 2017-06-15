cheminsPossibles([Xp, Yp, Anp, Sidep], Board, [], LChemins, 0):-!.
cheminsPossibles([Xp, Yp, Anp, Sidep], Board, CheminLocal, LChemins, NbDeplPos):- % On comence a 4 > 3 > 2 > 1 > 0(STOP)
  NbDeplPosBis is NbDeplPos-1,
  mouvementsPossible([Xp, Yp, Anp, Sidep], Board, Mouvements),
  bouclageMouvement([Xp, Yp, Anp, Sidep], Board, LChemins, NbDeplPosBis, Mouvements).

bouclageMouvement([X, Y, Anp, Sidep], Board, [], NbDeplPos, []):-!.
bouclageMouvement([X, Y, Anp, Sidep], Board, LChemin2, NbDeplPos, [[[Xd,Yd],[Xa,Ya]]|MouvementsQ]):-
  write('Mouvement'), 
  nl,
  cheminsPossibles([Xa, Ya, Anp, Sidep], Board, CheminLocal, Liste, NbDeplPos),
  ajoutSi([[[Xd,Yd],[Xa,Ya]]|CheminLocal], LChemin1, LChemin2),
  bouclageMouvement([X, Y, Anp, Sidep], Board, LChemin1, NbDeplPos, MouvementsQ).
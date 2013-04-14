/*Merge sort to sort the teams/wins*/
mergesort([], []).
mergesort([A], [A]).
mergesort([A, B | Rest], S) :-
  divide([A, B | Rest], L1, L2),
  mergesort(L1, S1),
  mergesort(L2, S2),
  my_merge(S1, S2, S).
divide([], [], []).
divide([A], [A], []).
divide([A, B | R], [A | Ra], [B | Rb]) :-  divide(R, Ra, Rb).
my_merge(A, [], A).
my_merge([], B, B).
my_merge([A | Ra], [B | Rb], [A | M]) :-
  A =< B,
  my_merge(Ra, [B | Rb], M).
my_merge([A | Ra], [B | Rb], [B | M]) :-
  A > B,
  my_merge([A | Ra], Rb, M).

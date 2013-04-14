%*******************************************************************
% flatten(L,L1): flatten a list of atoms (atoms and numbers) L to 
% a flat list L1. 

myflatten([],[]).
myflatten([A|L],[A|L1]) :- 
     xatom(A), myflatten(L,L1).
myflatten([A|L],R) :- 
     myflatten(A,A1), myflatten(L,L1), append(A1,L1,R).

xatom(A) :- atom(A).
xatom(A) :- number(A).

% tests

f(I) :- myflatten([2,[a]], I).
f1(I) :- myflatten([2,[a],[b,5,[c],d],9], I).


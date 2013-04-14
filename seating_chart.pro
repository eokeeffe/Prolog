person(sue,f).
person(jim,m).
person(tom,m).
person(joe,m).
person(cami,f).
person(bob,m).
person(fay,f).
person(beth,f).

likes(sue,chess).
likes(sue,yoga).
likes(sue,run).
likes(jim,chess).
likes(tom,chess).
likes(tom,yoga).
likes(tom,run).
likes(joe,chess).
likes(joe,yoga).
likes(joe,run).
likes(cami,chess).
likes(cami,yoga).
likes(cami,run).
likes(bob,yoga).
likes(bob,run).
likes(fay,chess).
likes(fay,yoga).
likes(fay,run).
likes(beth,chess).
likes(beth,run).

oppositegender(Name1,Name2):-person(Name1,G1),person(Name2,G2),not(G1==G2).
shareshobby(Name1,Name2):-likes(Name1,A),likes(Name2,B),A==B.

%the format of the list is that all the people on the either side has
%to be the opposite sex
%they also have to have similar interests
format([P1,P2,P3,P4,P5,P6,P7,P8|_]):-
	 oppositegender(P1,P2),
	 oppositegender(P3,P4),
         oppositegender(P5,P6),
	 oppositegender(P7,P8),
	 oppositegender(P1,P8),
	 shareshobby(P1,P2),
	 shareshobby(P3,P4),
         shareshobby(P5,P6),
         shareshobby(P7,P8).

front([Head|_],Head).

seatingChart(X):-
N=[beth,cami,fay,sue,bob,jim,joe,tom],
	setof(Names,lists:perm(N,Names),Perms),
	seating_chart(Perms,NA),front(NA,X).
%recusive function to get all possible acceptable matches
%simply check does the permutation satisfy the format , if so add to
%list X
seating_chart([],_).
seating_chart([Head|Tail],X):-
format(Head)->once(member(Head,X)),seating_chart(Tail,X)
;
seating_chart(Tail,X).











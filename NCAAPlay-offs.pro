/*Team number and name*/
team_name(1, connecticut).
team_name(2, duke).
team_name(3, memphis).
team_name(4, villanova).
team_name(5, gonzaga).
team_name(6, texas).
team_name(7, georgeWashington).
team_name(8, tennessee).
team_name(9, pittsburgh).
team_name(10,florida).
team_name(11,westVirginia).
team_name(12,ohioState).
team_name(13,bostonCollege).
team_name(14,illinois).
team_name(15,uCLA).
team_name(16,michiganState).
team_name(17,georgetown).
team_name(18,iowa).
team_name(19,oklahoma).
team_name(20,washington).
team_name(21,northCarolinaState).
team_name(22,kansas).
team_name(23,northCarolina).
team_name(24,bucknell).
/* team , wins, loses*/
wins_losses(1,  22, 2).
wins_losses(2,  24, 1).
wins_losses(3,  23, 2).
wins_losses(4,  20, 2).
wins_losses(5,  21, 3).
wins_losses(6,  22, 3).
wins_losses(7,  20, 1).
wins_losses(8,  18, 3).
wins_losses(9,  19, 3).
wins_losses(10, 21, 3).
wins_losses(11, 18, 6).
wins_losses(12, 18, 3).
wins_losses(13, 20, 5).
wins_losses(14, 20, 4).
wins_losses(15, 20, 5).
wins_losses(16, 18, 7).
wins_losses(17, 17, 5).
wins_losses(18, 20, 6).
wins_losses(19, 16, 5).
wins_losses(20, 18, 5).
wins_losses(21, 19, 5).
wins_losses(22, 18, 6).
wins_losses(23, 15, 6).
wins_losses(24, 20, 3).
/*Zones are west, mid-west, south, and east*/
zone(west, 5).
zone(west, 15).
zone(west, 20).
zone(midwest, 14).
zone(midwest, 22).
zone(midwest, 12).
zone(midwest, 19).
zone(midwest, 18).
zone(midwest, 16).
zone(midwest, 9).
zone(south, 6).
zone(south, 3).
zone(south, 8).
zone(east, 7).
zone(east, 1).
zone(east, 2).
zone(east, 10).
zone(east, 11).
zone(east, 13).
zone(east, 17).
zone(east, 21).
zone(east, 23).
zone(east, 4).
zone(east, 24).
/*acceptable zone pairs*/
zonepair(west,midwest).
zonepair(midwest,south).
zonepair(east,midwest).
zonepair(south,east).
%func to check if the zones can be paired
canpair(First,Second):- zonepair(First,Second) ; zonepair(Second,First).

%Matches 2 teams in a zone
canmatchz(Name1,Name2):-team_name(N1,Name1),team_name(N2,Name2),zone(Z1,N1),zone(Z2,N2),Z1==Z2,not(Name1==Name2).
%Matches 2 teams in a zone pair
canmatchzp(Name1,Name2):-team_name(N1,Name1),team_name(N2,Name2),zone(Z1,N1),zone(Z2,N2),canpair(Z1,Z2),not(Name1==Name2).

getName([A,B],A,B).
getName([_,_,C],C).
%min,max of the List and findMinMax of List
min(List,Min):-sort(List,Sorted),first(Sorted,Min).
max(List,Max):-sort(List,Sorted),last(Sorted,Max).
findMinMax(List,Min,Max):-(min(List,Min),max(List,Max)).

last([],[]).
last([Elem],Elem).
last([_|Tail],X):-last(Tail,X).
first([],[]).
first([Head|_],Head).
removefirst([_|Tail],Tail).
removelast([],[]).
removelast(List,X):-reverse(List,R),removefirst(R,RF),reverse(RF,X).

%simply get the names of all teams
teams(List):-findall(Name,team_name(_,Name),List).

%Get a list of Wins Team# Team Name
teamlist(List):-findall([Wins,ID,Names],(
		team_name(ID,Names),
		wins_losses(ID1,Wins,_),
		ID==ID1),
		Teams),msort(Teams,List).

%get the sorted wins and fold onto itself(Min and Max pairs)
mmlist(List):-teamlist(L),minmaxlist(L,List).
minmaxlist([],_).
minmaxlist(List,X):-findMinMax(List,Min,Max),
	removefirst(List,RF),
	removelast(RF,RL),
	getName(Max,Name1),getName(Min,Name2),
	once(member([Name1,Name2],X)),
	minmaxlist(RL,X).
%Find the teams that are in zone
inzonepairs(List):-mmlist(L),once(in_zonepairs(L,List)).
in_zonepairs([],_).
in_zonepairs([Head|Tail],X):-
	getName(Head,Name1,Name2),
	canmatchz(Name1,Name2) ->
	(once(member([Name1,Name2],X)),in_zonepairs(Tail,X))
	;in_zonepairs(Tail,X).
%Find the teams that are in a pairable zone
pairzones(List):-mmlist(L),once(pair_zone(L,List)).
pair_zone([],_).
pair_zone([Head|Tail],X):-
	getName(Head,Name1,Name2),
	canmatchzp(Name1,Name2)->
	(once(member([Name1,Name2],X)),pair_zone(Tail,X))
	;pair_zone(Tail,X).
%find a list of all possible games
%(Where the rank determines who is on the left of the pair)
allgames(List):-findall([Name1,Name2],(team_name(N1,Name1),team_name(N2,Name2),not(Name1==Name2),N1<N2),List).

%test whether the team exists in the list
is_member([],[]).
is_member([A,B],X):-memberchk([A,B],X);memberchk([B,A],X).

playoffs(X):-teams(T),mmlist(MM),inzonepairs(IZ),pairzones(PZ),allgames(AG),
	realplayoffs(T,MM,IZ,PZ,AG,X).

realplayoffs([],_,_,_,_,_).
realplayoffs([Name|Tail],MM,IZ,PZ,AG,List):-
 is_member([_,Name],MM)->
    (is_member([_,Name],List)->realplayoffs(Tail,MM,IZ,PZ,AG,List)
    ;
    is_member([A,Name],MM),team_name(N1,Name),team_name(N2,A),not(N1==N2),
    (N1<N2->member([Name,A],List);member([A,Name],List)))
 ;
 is_member([_,Name],IZ)->
    (is_member([_,Name],List)->realplayoffs(Tail,MM,IZ,PZ,AG,List)
    ;
    is_member([A,Name],MM),team_name(N1,Name),team_name(N2,A),not(N1==N2),
    (N1<N2->member([Name,A],List);member([A,Name],List)))
 ;
 is_member([_,Name],PZ)->
    (is_member([_,Name],List)->realplayoffs(Tail,MM,IZ,PZ,AG,List)
    ;
    is_member([A,Name],MM),team_name(N1,Name),team_name(N2,A),not(N1==N2),
    (N1<N2->member([Name,A],List);member([A,Name],List)))
 ;
 is_member([_,Name],AG)->
    (is_member([_,Name],List)->realplayoffs(Tail,MM,IZ,PZ,AG,List)
    ;
    is_member([A,Name],MM),team_name(N1,Name),team_name(N2,A),
    not(N1==N2),
   (N1<N2->member([Name,A],List);member([A,Name],List)))
 .

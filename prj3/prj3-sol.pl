% -*- mode: prolog -*-
% vi: set ft=prolog

/*****prolog procedure which finds maximum of the given list*****/
max_list([H|T], Z):-
max_list(T, H, Z).
max_list([], ACC, ACC).
max_list([H|T], ACC, Z) :-
    (H > ACC -> max_list(T, H, Z);    
	      max_list(T, ACC, Z)).


/********prolog procedure which creates a tree according to the names and searches for the grade of given name.*******/
add_grade([],name_grade(N1,G1),tree(name_grade(N1,G1),[],[])). 
add_grade(tree(name_grade(N1,G1),L,R),name_grade(N2,G2),tree(name_grade(N1,G1),L1,R)) :- N2 @< N1, add_grade(L,name_grade(N2,G2),L1).
add_grade(tree(name_grade(N1,G1),L,R),name_grade(N2,G2),tree(name_grade(N1,G1),L,R1)) :- N2 @> N1, add_grade(R,name_grade(N2,G2),R1).
add_grade(tree(name_grade(N1,_),L,R),name_grade(N2,G2),tree(name_grade(N2,G2),L,R)) :- N2 == N1.
get_grade(tree(name_grade(N1,Grade1),_,_),Key,Grade):- Key == N1, Grade is Grade1.
get_grade(tree(name_grade(N1,_Grade1),TL,_),Key,Grade):- Key @< N1,get_grade(TL,Key,Grade).
get_grade(tree(name_grade(N1,_Grade1),_,TR),Key,Grade):- Key @> N1,get_grade(TR,Key,Grade).


/*prolog procedure which picking up elements of each tuple from each of the n-lists*/
list_tuples(List, Z):- list_tuples_acc(List, [], [], Z).
list_tuples_result([], _Z).
list_tuples_acc([], Firstacc, Restacc, Z):- 
reverse(Firstacc, Firstaccres),
reverse(Restacc, Restaccres),
Z = [Firstaccres | Restaccres],
list_tuples_result([], Z). 
list_tuples_acc([[H|T]|Lists], Firstacc, Restacc, Z):- 
([H|T] == [] -> append([H|T], Firstacc, Appendlist1),
	        append([H|T], Restacc, Appendlist2),
	        list_tuples_acc(Lists, Appendlist1, Appendlist2, Z);
		append([H], Firstacc, Appendlist1),
		append([T], Restacc, Appendlist2),
		list_tuples_acc(Lists, Appendlist1, Appendlist2, Z)).


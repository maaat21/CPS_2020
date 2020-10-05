mtype = { P,C }; /*symbols used*/
mtype turn = P;  /*shared variable*/

active proctype producer(){
	do
	:: (turn == P) ->   /*Guard*/ /* No need for atomic, as turn different from P can be set by this process only*/
		printf("Produce\n");
		turn = C
	od
}

active proctype consumer(){
	again:
		if
		:: (turn == C) ->   /*Guard*/
			printf("Consume\n");
			turn = P;
			goto again
		fi
}

ltl p0 { [] (turn == P) -> (<> (turn == C)) }


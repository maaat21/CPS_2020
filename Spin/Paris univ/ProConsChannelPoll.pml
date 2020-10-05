mtype = { P,C }; /*symbols used*/
chan turn = [1] of {mtype}; 

active proctype producer(){
	do
	:: turn!P ->
		printf("Produce\n");
	od
}

active proctype consumer(){
	mtype inVar;
	again:
		if
		:: turn?[P] ->   /*Guard*/
			printf("Consume\n");
			turn?inVar;
			goto again
		fi
}


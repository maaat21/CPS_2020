mtype = { id msg }; /* Possible also like this */
chan name = [0] of { mtype, byte };

active proctype A(){
			do
			::name!msg(100);
			::name!id(10);
			od
}

active proctype B(){
	byte var;
	mtype mt;
			do
			:: name?msg, var ->
				printf("state = %d\n", var); /* \n needed */
			:: name?id(var)  ->
				printf("value = %d\n", var);
			:: name?mt,10  ->
				printf("mt & value = %d\n", var);
			od
}

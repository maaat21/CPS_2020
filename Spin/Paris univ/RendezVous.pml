mtype = { id msg };
chan name = [0] of { mtype, byte };

active proctype A(){
	name!msg(100);
	name!id(10);
}

active proctype B(){
	byte var;
	if
	:: name?msg(var) -> printf("state = %d", var);
	:: name?id(var)  -> printf("value = %d", var);
	fi
}

/* Check the invalid end state */
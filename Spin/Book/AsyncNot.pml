/* AsyncNot */

chan toNot = [0] of {bit};
chan fromNot = [0] of {bit};

mtype = {Stable, Unstable, Hazard};

proctype AsyncNot(chan inp, out) {

mtype mode=Stable;
bit x;

		do
		:: mode==Stable -> out!x;
		:: inp?eval(x) -> if
																				::mode==Stable -> mode=Unstable;
																				::mode==Unstable -> skip;
																				::else -> skip;
																				fi
		:: inp?eval(!x) -> if
																				::mode==Stable -> skip;
																				::mode==Unstable -> mode=Hazard;
																				::else -> skip;
																				fi
		:: mode==Unstable -> out!x;
		:: mode==Unstable -> atomic{x = !x; mode = Stable;};
		:: mode==Hazard -> inp?x;
		:: mode==Hazard -> out!0;
		:: mode==Hazard -> out!0;
		od

/* Syntax error
		do
		:: mode==Stable -> out!x;
		:: mode==Stable && inp?eval(x) -> mode=Unstable;
		:: mode==Stable && inp?eval(!x) -> skip;
		:: mode==Unstable -> out!x;
		:: mode==Unstable -> x = !x;
		:: mode==Unstable && inp?eval(x) -> skip;
		:: mode==Unstable && inp?eval(!x) -> mode=Hazard;
		:: mode==Hazard -> inp?x;
		:: mode==Hazard -> out!0;
		:: mode==Hazard -> out!0;
		od
*/
}

proctype EnvironmentProd(chan out) {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		out!b;
od
}

proctype EnvironmentCons(chan inp) {

bit b;

do
::inp?b;
				printf("Received: %d", b);
od
}

proctype EnvironmentProdCons(chan out, inp) {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		do
		::out!b;
		::inp?eval(b)-> skip;
		::inp?eval(!b)-> break;
		od
od
}

init{
	atomic {
			run AsyncNot(toNot, fromNot);
			/* run EnvironmentProd(toNot);
			run EnvironmentCons(fromNot); */
			run EnvironmentProdCons(toNot, fromNot);
	}
}



ltl p { [](AsyncNot[1]:mode!=Hazard) }
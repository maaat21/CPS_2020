/* SharedMemPuzzle */
/* Check invalid end states and non-progress cycles*/

byte x=1;

proctype Process() {

byte u=0, v=0;

do
::u=x;v=x;if
										::u+v<=15 -> x=u+v;
										::else -> break;
										fi
od
}


init{
	atomic {
			run Process();
			run Process();
			run Monitor();
	}
}

/* Assertion violation */
proctype Monitor(){
		assert(!(x==13))
}

ltl p { [](x!=13) }

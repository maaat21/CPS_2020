/* SharedMemPuzzle */
/* Check invalid end states and non-progress cycles*/

byte x=1;

proctype Process() {

byte u=0, v=0;

do
::u=x;v=x;if
										::u+v<=255 -> x=u+v;
										::else -> x=1;
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

proctype Monitor(){
		assert(!(x==37))
}

ltl p { [](x!=37) }
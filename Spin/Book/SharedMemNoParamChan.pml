/* SharedMem */
/* Check invalid end states, ltl*/

chan readX = [0] of {bit};
chan writeX = [0] of {byte};
/* If we considered also another var
chan readY = [0] of {chan};
chan writeY = [0] of {byte};
*/
chan readChan = [0] of {byte};

proctype Process() {

byte l=0;

readX!0;
readChan?l;
writeX!l+1;
}

proctype Var(chan read, write) {

byte x=0;

do
::read?0; readChan!x;
::write?x;
od
}

init{
	atomic {
			run Process();
			run Process();
			run Var(readX, writeX);
	}
}

ltl p { <>(Var[3]:x>=2) }
ltl p2 { [](Process[1]:l>=0) }
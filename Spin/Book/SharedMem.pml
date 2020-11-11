/* SharedMem */
/* Check invalid end states, ltl*/

chan readX = [0] of {chan};
chan writeX = [0] of {byte};
/* If we considered also another var
chan readY = [0] of {chan};
chan writeY = [0] of {byte};
*/
chan readChan = [0] of {byte};

proctype Processs() {

byte l=0;

readX!readChan;
readChan?l;
writeX!l+1;
}

proctype Var(chan read, write) {

byte x=0;
chan outChan;

do
::read?outChan; outChan!x;
::write?x;
od
}

init{
	atomic {
			run Processs();
			run Processs();
			run Var(readX, writeX);
	}
}

ltl p { <>(Var[3]:x>=2) }
ltl p2 { [](Processs[1]:l>=0) }
/* SharedMem */
/* The reader passes the channel */
/* Check invalid end states, ltl*/

chan readX = [0] of {chan};
chan writeX = [0] of {byte};
chan readChan = [0] of {byte};

proctype Processs() {

byte l=0;

atomic {readX!readChan;
readChan?l;}
writeX!l+1;
}

proctype Var(chan read, write) {

byte x=0;
chan outChan;

end: do
					::atomic{read?outChan; outChan!x;}
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
/* P2 just for a trivial check */
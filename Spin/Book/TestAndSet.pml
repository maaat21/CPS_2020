/* TestAndSet */
/* Check invalid end states, non-progress cycles, assertion violations*/

chan tAndS = [0] of {bit};
chan reset = [0] of {bit};
chan result = [0] of {bit};

byte cs;

proctype Process() {
bit res;


do
::do /* Remove it to check progress */
		:: skip -> skip; /* https://stackoverflow.com/questions/47627323/what-is-unconditional-self-loop-in-promela */
		:: break;
		od
  do
		::tAndS!0;result?res;if
																					::res==0; break;
																					::else;
																					fi
		od
		progress: cs++;
		printf("Critical section");
		cs--;
		reset!0;
od
}

proctype TAndS() {
bit x = 0;

do
::tAndS?0 -> result!x; x=1;
::reset?0 -> x = 0;
od

}

init{
	atomic {
			run Process();
			run Process();
			run TAndS();
			run Monitor();
	}
}

proctype Monitor(){
		assert(cs<2)
}

ltl p { [](cs<2) }

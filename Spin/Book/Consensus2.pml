/* Consensus */
/* Check invalid end states (and: non progress cycles), ltl*/

#define NULL_VAL 7

chan readX1 = [0] of {bit};
chan doReadX1 = [0] of {byte};
chan writeX1 = [0] of {bit};
chan readX2 = [0] of {bit};
chan doReadX2 = [0] of {byte};
chan writeX2 = [0] of {bit};

proctype Process(bit pref; chan read, doRead, write) {
bit dec, isNull;
byte y;
bit finished;

write!pref;
/*progress:*/ 	do /* Put progress */
										:: atomic {read!0;
																					doRead?y; if
																															::y!=NULL_VAL->dec=pref|y; break;
																															::else->skip; /* Non progress. Eseguo solo io e non l'altro processo... */
																															fi
																				}
										od
finished=1;
}

proctype Var(chan read, doRead, write) {
chan q = [1] of {bit};
bit x,z;
byte response;

end: do /* Needed, to check end-state violation */
					::atomic {read?0; if
																							::nempty(q)->q?response;
																							::empty(q)->response=NULL_VAL;
																							fi
																							end_1: doRead!response;
																							}
					::atomic {write?x; if
																								::nempty(q)->q?z;
																								::empty(q)->skip;
																								fi
																								q!x;}
					od
}

init{
	atomic {
			bit b1, b2;
			if
			::b1=1;
			::skip;
			fi
			if
			::b2=1;
			::skip;
			fi
			run Process(b1, readX2, doReadX2, writeX1);
			run Process(b2, readX1, doReadX1, writeX2);
			run Var(readX1, doReadX1, writeX1);
			run Var(readX2, doReadX2, writeX2);
	}
}

/* ltl analysis requires check on acceptance cycles (or anyways non-progress) */
ltl p0 {<>[](Process[1]:dec==Process[2]:dec)} /* Attention! It cannot and one and not the other! Both the processes start with the same dec */
ltl p3 {[](Process[1]:finished -> <>(Process[1]:dec==Process[2]:dec))}
ltl p1 {<>[](Process[1]:dec==Process[1]:pref || Process[2]:dec==Process[2]:pref)}
ltl p2 {<>[](Process[2]:finished==1 || Process[2]:finished==1)}
ltl p4 {[](Process[1]:finished -> <>Process[2]:finished)}
/* Consensus */
/* Check invalid end states, ltl*/

chan readX1 = [0] of {bit};
chan doReadX1 = [0] of {bit};
chan writeX1 = [0] of {bit};
chan readX2 = [0] of {bit};
chan doReadX2 = [0] of {bit};
chan writeX2 = [0] of {bit};

proctype Process(bit pref; chan read, doRead, write) {
bit y, dec, isNull;

write!pref;
atomic {read!0;
								if
								::doRead?y;
								::timeout->isNull=1;
								fi}
if
::isNull->dec=pref;
::else->dec = pref|y;
fi
}

proctype Var(chan read, doRead, write) {
chan q = [1] of {bit};
bit x,z;

end: do /* Needed, to check end-state violation */
					::atomic {read?0; if
																							::nempty(q)->q?x; end_1: doRead!x;
																							::empty(q)->skip;
																							fi
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

ltl p0 {<>[](Process[1]:dec==Process[2]:dec)}
ltl p1 {<>[](Process[1]:dec==Process[1]:pref || Process[2]:dec==Process[2]:pref)}
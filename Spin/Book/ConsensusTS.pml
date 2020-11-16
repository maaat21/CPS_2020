/* Consensus */
/* Check invalid end states, ltl*/

chan testAndSet = [0] of {bit};
chan testAndSet_reply = [0] of {bit};
chan reset = [0] of {bit};

chan readX1 = [0] of {bit};
chan doReadX1 = [0] of {bit};
chan writeX1 = [0] of {bit};
chan readX2 = [0] of {bit};
chan doReadX2 = [0] of {bit};
chan writeX2 = [0] of {bit};

proctype Process(bit pref; chan read, doRead, write) {
bit y, dec;

write!pref;
atomic{testAndSet!0; testAndSet_reply?y}
if
::y=0->dec=pref;
::else->atomic {read!0;doRead?dec;}
fi
}

proctype Var(chan read, doRead, write) {
chan q = [1] of {bit};
bit x,z;

end: do /* Needed, to check end-state violation */
					::atomic {read?0; doRead!x;}
					::atomic {write?x; if
																								::nempty(q)->q?z;
																								::empty(q)->skip;
																								fi
																								q!x;}
					od
}

proctype T_S(){
bit val;
end: do
					::testAndSet?0->testAndSet_reply!val;val=1;
					::reset?0->val=0;
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
			run T_S();
	}
}

/* Check with the safety radio button */
ltl p0 {<>[](Process[1]:dec==Process[2]:dec)}
ltl p1 {<>[](Process[1]:dec==Process[1]:pref || Process[2]:dec==Process[2]:pref)}
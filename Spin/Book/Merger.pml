/* Mergers */
/* Check invalid end states and non-progress cycles*/

chan toMergerA1 = [1] of {bit};
chan toMergerA2 = [1] of {bit};
chan toMergerB = [1] of {bit};
chan toConsumer = [1] of {bit};
chan internal = [1] of {bit};

proctype Merger(chan in1, in2, outp) {

bit b;

chan q1 = [2] of {bit};
chan q2 = [2] of {bit};

do
::nfull(q1) -> in1?b; q1!b; /* && nempty(in1) not needed*/
::nfull(q2) -> in2?b; q2!b; /* && nempty(in2) */
::q1?b; outp!b;
::q2?b; outp!b;
od

}

proctype Producer() {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		if
		::toMergerA1!b;
		::toMergerA2!b;
		::toMergerB!b;
		fi
od

}

proctype Consumer() {

bit res;

do
::toConsumer?res;
		progress: printf("Received: %d", res);
od

}

init{
	atomic {
			run Merger(toMergerA1, toMergerA2, internal);
			run Merger(internal, toMergerB, toConsumer);
			run Producer();
			run Consumer();
	}
}
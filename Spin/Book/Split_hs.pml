/* Split */
/* Check invalid end states and non-progress cycles*/

chan toSplit = [0] of {bit};
chan fromSplit1 = [0] of {bit};
chan fromSplit2 = [0] of {bit};

proctype Split(chan inp, out1, out2) {

bit b;

chan q1 = [2] of {bit};
chan q2 = [2] of {bit};

do
::nfull(q1) -> inp?b; q1!b;
::nfull(q2) -> inp?b; q2!b;
::q1?b; out1!b;
::q2?b; out2!b;
od

}

proctype Producer() {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		toSplit!b;
od

}

proctype Consumer(chan inp) {

bit res;

		do
		::inp?res;
				progress: printf("Received: %d", res);
		od

}

init{
	atomic {
			run Split(toSplit, fromSplit1, fromSplit2);
			run Producer();
			run Consumer(fromSplit1);
			run Consumer(fromSplit2);
	}
}
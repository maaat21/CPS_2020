/* Split */
/* Check invalid end states and non-progress cycles*/

chan toSplit = [1] of {bit};
chan fromSplit1 = [1] of {bit};
chan fromSplit2 = [1] of {bit};

proctype Split(chan inp, out1, out2) {

bit b;

chan q = [2] of {bit};
/*chan q2 = [2] of {bit};*/

do
::nfull(q) -> inp?b; q!b;
/*::nfull(q2) -> inp?b; q2!b;*/
::q?b; progress: out1!b; /* progress: - this works as a check */
::q?b; out2!b;
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
bool rec;

		do
		::inp?res;
				printf("Received: %d", res); rec = true; rec = false; /* This works as a check ltl */ /* progress: This does not work*/
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

ltl p { []<> (Consumer[3]:rec==true) }

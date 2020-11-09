/* Mergers */
/* Check invalid end states and non-progress cycles*/

chan toAsyncBuff = [0] of {bit};
chan toConsumer = [0] of {bit};

proctype AsyncBuff(chan in, outp) {

chan q = [1] of {bit};
bit b, b0;

do
::in?b -> if /* if you check for non progress cycles, it stays here. You can label it as progress... */
										::nempty(q) -> q?b0;
										::empty(q);
										fi
										q!b;
::nempty(q) -> q?b; outp!b;
od

}

proctype Producer(chan outp) {

bit b;

do
::if
		::b=0;
		::b=1;
		fi
		outp!b;
od

}

proctype Consumer(chan in) {

bit res;

do
::in?res;
		progress: printf("Received: %d", res);
od

}

init{
	atomic {
			run AsyncBuff(toAsyncBuff, toConsumer);
			run Producer(toAsyncBuff);
			run Consumer(toConsumer);
	}
}
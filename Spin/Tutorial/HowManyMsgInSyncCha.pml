chan channel = [0] of {bit} ;

proctype Rx() {
bit x;
channel?x;
printf("%d received: %d\n", _pid, x);
}

proctype Tx() {
channel!1;
}

init {
atomic {
	run Rx();
	run Rx();
	run Tx();
}
}
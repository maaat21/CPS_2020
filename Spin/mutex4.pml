byte turn[2]; /* who’s turn is it? */
byte mutex; /* # procs in critical section */

proctype P(bit i) {

byte n=8;


printf("n=%d",n);

do
		:: turn[i] = 1;
					turn[i] = turn[1-i] + 1;
					(turn[1-i] == 0) || (turn[i] < turn[1-i]);
					mutex++;
					mutex--;
					turn[i] = 0;
		od
}

proctype monitor() { assert(mutex != 2); }

init { atomic {run P(0); run P(1); run monitor()}}

ltl p0	{ <> (mutex > 0) }
ltl p1	{ [] (mutex < 2) }

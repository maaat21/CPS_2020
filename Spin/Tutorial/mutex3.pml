bit x, y; /* signal entering/leaving the section */
byte mutex; /* # of procs in the critical section. */
byte turn; /* who's turn is it? */

proctype A() {
		do
		::		x = 1;
				turn = 0;
				y == 0 || (turn == 1);
				mutex++;
				mutex--;
				x = 0;
		od
}

proctype B() {
		do
		::		y = 1;
				turn = 1;
				x == 0 || (turn == 0);
				mutex++;
				mutex--;
				y = 0;
		od
}

proctype monitor() { assert(mutex != 2); }

init { atomic {run A(); run B(); run monitor()}}

ltl p0	{ <> (mutex > 0) }
ltl p1	{ [] (mutex < 2) }

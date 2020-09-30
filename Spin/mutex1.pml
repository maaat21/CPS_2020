bit flag; /* signal entering/leaving the section */
byte mutex; /* # procs in the critical section. */

proctype P(bit i) {
		flag != 1;
		flag = 1;
		mutex++;
		printf("MSC: P(%d) has entered section.\n", i);
		mutex--;
		flag = 0;
}


init {
		atomic { run P(0); run P(1); run monitor();}
}

proctype monitor() {
		assert(mutex != 2)
}

ltl p0	{ [] (mutex < 2) }

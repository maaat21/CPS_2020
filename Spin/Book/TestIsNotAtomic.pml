/* Test is not atomic */
/* See also with interactive simulation */

byte val=0;

proctype Proc(){

if
::val==0 -> /* insert in an atomic statement, and the assert is ok */
			val = val+1; /* if even becomes odd */
::else -> skip;
fi
}


init{
		atomic {
				run Proc();
				run Proc();
				run Monitor();
				}
}

proctype Monitor(){
		assert(val!=2)
}

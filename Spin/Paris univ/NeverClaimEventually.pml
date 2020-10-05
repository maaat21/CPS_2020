#define p (a>=5)

byte a = 0

active proctype Dijsktra(){
do
					:: (a<5) -> a++;
					:: (a>0) -> a--;
					od
}

// Use claim  option in the Verification pane
// <> p
never{
accept:	do
	:: p -> break
	:: else
	od
	do
	::skip;
	od
}

ltl p1 {<> p} /* Fails: it oscillates +/-1 */

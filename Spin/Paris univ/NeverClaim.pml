#define p (a<=5) /* Try also (a<=4) */

byte a = 0

active proctype Dijsktra(){
do
					:: (a<5) -> a++;
					:: (a>0) -> a--;
					od
}

// Use claim  option in the Verification pane
// [] p
never{
	do
	:: !p -> break
	:: else
	od
}

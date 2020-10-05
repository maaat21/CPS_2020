//Do not enforce through the verification panel option

byte ck;

mtype = {Green, Yellow, Red};
mtype mode=Green;

active proctype TrafficLight(){
	do
	:: (mode==Green) -> if
																					::(ck<5) -> ck=ck+1;
																					::else -> ck=0; mode=Yellow;
																					fi;
	:: (mode==Yellow) -> if
																					::(ck<3) -> ck=ck+1;
																					::else -> ck=0; mode=Red;
																					fi;			
 :: (mode==Red) -> if
																					::(ck<5) -> ck=ck+1;
																					::else -> ck=0; mode=Green;
																					fi;																					
	od
}

ltl p1 {[](mode==Yellow -> mode==Yellow U mode==Red)}
ltl p2 {[](mode==Yellow -> mode==Yellow U mode==Green)} /* Fails */

/* p1, coded by Spin as never_0 */
never{
do
::mode==Yellow -> break;
::skip;
od
accept: do
::mode==Yellow -> skip;
::mode!=Yellow && mode!=Red -> break;
od
}

/* p2, coded by Spin as never_1 */
never{
do
::mode==Yellow -> break;
::skip;
od
accept: do
::mode==Yellow -> skip;
::mode!=Yellow && mode!=Green -> break;
od
}

/* Older version
never{
do
::mode==Yellow && mode!=Red -> break;
::skip;
od
accept: do
::mode==Yellow -> skip;
::mode!=Yellow && mode!=Red -> break;
od
}
*/

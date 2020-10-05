//Do not enforce through the verification panel option

byte x;
byte y;

mtype = {AT, BT};
mtype taken;

active proctype A(){
	do:: x=x+1; taken = AT;
	od
}

active proctype B(){
	do
	:: y=y+1; taken = BT;
	od
}

ltl p1 {<>(x>10)}
ltl p2 {<>(y>10)} 
ltl p3 {[]<>(taken==AT) -> <>(x>10)}  /* Weak fairness without guard, as this is the case: WF->P , Pers enabled -> Rep executed = T-> Rep taken, Rep taken->prop */
ltl p4 {[]<>(taken==BT) -> <>(y>10)}

/* Weak fairness with guard: WF->P , Pers enabled -> Rep executed = F-> Rep taken = T, prop */
/* Strong fairness: SF->P , Rep enabled -> Rep executed = T-> Rep taken, Rep taken->prop */


int x, y; /* If I put byte, p2 with weak fairness imposed does not work */

mtype = {none, tA, tB};
mtype taken=none;

active proctype A() {
do
::x=x+1; taken=tA;
od
}

active proctype B() {
do
::y=y+x; taken=tB;
od
}

ltl p1 { <> (x > 5) }
ltl p2 { <> (y > 5) }
ltl p3 { []<> (taken==tA) -> <> (x > 5) }
ltl p4 { []<> (taken==tB) && ([]<> taken==tA) -> <> (y > 5) }
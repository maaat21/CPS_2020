/* Leader election */

#define N 5

mtype = {UND, FOL, LEA}

byte nLeaders = 0;

chan channels[N] = [1] of {byte}; 

proctype Node(byte id, ord) {

byte b;
byte val = id;
mtype role = UND;

chan msg = [1] of {byte};

msg!id;

do
::nfull(msg) -> channels[ord]?b; if
									::b>val -> val=b; msg!b; role = FOL;
									::b==id -> role = LEA; nLeaders++; break;
									::else -> skip;
									fi
::nempty(msg) /* && nfull(channels[(ord+1)%N]) */ -> msg?b; channels[(ord+1)%N]!b;
od

}

init {
		atomic {
				run Node(1, 0);
				run Node(3, 1);
				run Node(7, 2);
				run Node(2, 3);
				run Node(4, 4);
		}
}

ltl p1 {([](nLeaders < 2))}
ltl p2 {(<>(nLeaders > 0))}
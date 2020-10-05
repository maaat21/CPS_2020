/* Leader election */

mtype = {UND, FOL, LEA}

byte nLeaders = 0;

chan to0 = [1] of {byte}; /* Necessary, otherwise they all write */
chan to1 = [1] of {byte};
chan to2 = [1] of {byte};
chan to3 = [1] of {byte};
chan to4 = [1] of {byte};

proctype Node(byte id; chan inp, outp) {

byte b;
byte val = id;
mtype role = UND;

chan msg = [1] of {byte}; /* Necessary to block communication after leader election (A variable does not block) */

msg!id;

do
::nfull(msg) -> inp?b; if
									::b>val -> val=b; msg!b; role = FOL;
									::b==id -> role = LEA; nLeaders++; break;
									::else -> skip;
									fi
::nempty(msg) /* && nfull(outp) */ -> msg?b; outp!b;
od

}

init {
		atomic {
				run Node(1, to0, to1);
				run Node(3, to1, to2);
				run Node(7, to2, to3);
				run Node(2, to3, to4);
				run Node(4, to4, to0);
		}
}

ltl p1 {([](nLeaders < 2))}
ltl p2 {(<>(nLeaders > 0))}
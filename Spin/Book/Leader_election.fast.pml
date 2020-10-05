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

bool firstRead = 0;
short firstVal = 0;

msg!id;

do
::nfull(msg) -> channels[ord]?b; if
																			::firstRead == 0 -> if
																																							::b==val -> role = LEA; nLeaders++; break;
																																							::else -> msg!b; firstRead=1; firstVal = b;
																																							fi
																			::else -> if
																													::(firstVal > val) && (firstVal > b) -> firstRead = 0; val = firstVal; if  /* precautional */
																																																																																																				::nempty(msg) -> msg?b; channels[(ord+1)%N]!b;
																																																																																																				::nfull(msg) -> skip; /* else dice dubious use... */
																																																																																																				fi
																																																																																																				msg!val;
																																																																																																				printf("Passed %d", id);
																													::else -> role = FOL; if  /* precautional */
																																																			::nempty(msg) -> msg?b; channels[(ord+1)%N]!b;
																																																			::nfull(msg) -> skip; /* else dice dubious use... */
																																																			fi
																																																			printf("Follower %d", id);
																																																			break;
																													fi
																			fi
::nempty(msg) /* && nfull(channels[(ord+1)%N]) */ -> msg?b; channels[(ord+1)%N]!b;
od


/* Follower */

if
::role==FOL -> do
															::nfull(msg) -> channels[ord]?b; msg!b;
															::nempty(msg) && nfull(channels[(ord+1)%N]) -> msg?b; channels[(ord+1)%N]!b;
															od
::else -> skip;
fi

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
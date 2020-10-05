#define N 6

chan ab = [1] of {byte};
chan bc = [1] of {byte};
chan cd = [1] of {byte};
chan de = [1] of {byte};
chan ef = [1] of {byte};
chan fa = [1] of {byte};

mtype = {und, lea, fol};

bit leader[N];
bit follower[N];

/* Inline gives error for array */
/* N-1 undefined in macro */
/*for (i in arr){ Does not work in a macro, it's all preprocess. Also i++ \
	for (i : 0..5){ \
		sum+=arr[i]; \
	} \
*/
#define count(arr){ \
	atomic {sum = 0; \
	i = 0; \
	do \
	:: i < 6 -> sum=sum+arr[i]; i=i+1 \
	:: else -> break \
	od \
	} \
}
byte sum;
byte i;

proctype Node(byte id; chan inp, outp) {

mtype role=und;

byte x=id;
byte read1, read2;

pid p_id = _pid-1; /* Considering the init process */


		do
		::role==und -> outp!x; inp?read1; if
																																				::outp!read1;inp?read2;
																																				::inp?read2;outp!read1;
																																				fi
																																				if
																																				:: x == read1 -> role=lea; leader[p_id]=1; break;
																																				:: read1 > x && read1 > read2 -> x = read1;
																																				:: else -> role = fol; follower[p_id]=1;
																																				fi
		::role==fol -> if /* inp?read1;outp!read1; With this we would get a timeout */
																	::inp?read1;
																	::timeout;assert(role!=und); break;
																	fi
																	if
																	::outp!read1;
																	::timeout;assert(role!=und); break;
																	fi
		od
}

init{
	atomic {
			run Node(1, fa, ab);
			run Node(5, ab, bc);
			run Node(2, bc, cd);
			run Node(8, cd, de);
			run Node(14, de, ef);
			run Node(6, ef, fa);
			run Monitor();
	}
}

proctype Monitor(){
	atomic{
		count(follower);
		assert(sum<=N-1);
		count(leader);
		assert(sum<=1);
	}
}

never{
do
::count(leader); if
																	::sum==1 -> skip;
																	::else -> accept: do
																																			:: count(leader); if
																																																					::sum!=1 -> skip;
																																																					::else -> break;
																																																					fi
																																			od
																	fi
od
}

never{
do
::count(follower); if
																	::sum==N-1 -> skip;
																	::else -> accept: do
																																			:: count(follower); if
																																																					::sum!=N-1 -> skip;
																																																					::else -> break;
																																																					fi
																																			od
																	fi
od
}

#define sum_lead leader[0]+leader[1]+leader[2]+leader[3]+leader[4]+leader[5]
#define sum_foll follower[0]+follower[1]+follower[2]+follower[3]+follower[4]+follower[5]
ltl p1 {<>[] (sum_lead==1 & sum_foll==N-1)}
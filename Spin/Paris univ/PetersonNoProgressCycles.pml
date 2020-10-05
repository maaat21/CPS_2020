bool turn, flag[2];
byte cnt;

active [2] proctype proc(){
	pid i,j;
	i=_pid;
	j=1- _pid;
	
	again:
		flag[i]=true;
		turn=i;
		if
		::flag[j]==false -> //|| turn !=i)
				cnt++;
				progress:
				cnt--;
		::else
		fi
		goto again;
}

// Verification->assertion violation
active proctype monitor() {
 assert(cnt >= 0 && cnt <= 1)
}

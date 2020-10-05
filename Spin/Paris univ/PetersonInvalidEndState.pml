bool turn, flag[2];
byte cnt;

active [2] proctype proc(){
	pid i,j;
	i=_pid;
	j=1- _pid;
	
	again:
		flag[i]=true;
		//turn=i;
		flag[j]==false //|| turn !=i)
		cnt++;
		cnt--;
		goto again;
}

// Verification->assertion violation
active proctype monitor() {
 assert(cnt >= 0 && cnt <= 1)
}

bool turn, flag[2];
byte cnt;

active [2] proctype proc(){
	pid i,j;
	i=_pid;
	j=1- _pid;
	
	again:
		flag[i]=true;
		turn=i;
		(flag[j]==false) || (turn !=i)
		cnt++;
	progress:
		assert(cnt==1); /* try <1 and verify with pan */
		cnt--;
		goto again;
}

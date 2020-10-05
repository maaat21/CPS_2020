proctype pr(byte x){
	printf("x=%d, pid = %d\n",x,_pid)
}

init {
	run pr(0); run pr(1);
}
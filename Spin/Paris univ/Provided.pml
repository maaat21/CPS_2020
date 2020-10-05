bool var = true;

active proctype A() provided (var==true){
	L:  printf("A\n");
	var = false;
	goto L
}

active proctype B() provided (var==false){
	L:  printf("B\n");
	var = true;
	goto L
}

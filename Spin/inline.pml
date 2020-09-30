inline fooInl(a) {	
	int b=4;	
	a=a+b;
	printf("a, b: (%d, %d)\n", a, b);
	assert(a);
}

init {
		int c=5;
		fooInl(c);
		printf("c: %d\n", c);
}

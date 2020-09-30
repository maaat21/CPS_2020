inline example(x, y) {
        y = a;
        x = b;
	printf("%d, %d\n", x, y)
        assert(x)
}

init {
        int a, b;

        example(a,b)
}

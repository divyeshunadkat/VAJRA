class vapexp{
	static int i, x, N;
	static int a[];
	static int min;

static void main()
{
	N=Support.random();

	min=0;
	i=0;
        while(i<N)
        {
		if ( a[i] < min ) {
			min = a[i];
		}
		i = i + 1;
        }

	x=0;
        while(x<N)
        {
		assert(a[x] >= min);
		x = x + 1;
        }
}
}

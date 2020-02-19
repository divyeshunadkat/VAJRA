class vapexp{
	static int i, x, N;
	static int a[];
	static int max;

static void main()
{
	N=Support.random();

	max=0;
	i=0;
        while(i<N)
        {
		if ( a[i] > max ) {
			max = a[i];
		}
		i = i + 1;
        }

	x=0;
        while(x<N)
        {
		assert(a[x] <= max);
		x = x + 1;
        }
}
}

class vapexp{
	static int i,N;
	static int a[];
	static int b[];

static void main()
{
	N=Support.random();

	b[0] = 1;
	a[0] = 1;

	i=1;
	while(i<N)
	{
		b[i] = b[i-1] + 2;
		i=i+1;
	}

	i=1;
	while(i<N)
	{
		a[i] = a[i-1] + b[i-1] + 2;
		i=i+1;
	}

	i=0;
	while(i<N)
	{
		assert(a[i] == (i+1)*(i+1));
		i=i+1;
	}
}

}

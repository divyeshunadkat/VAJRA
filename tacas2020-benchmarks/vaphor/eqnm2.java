class vapexp{
	static int i,N;
	static long a[],b[];

static void main()
{
	N=Support.random();

	a[0] = 4;
	b[0] = 1;

	i=1;
	while(i<N)
	{
		a[i] = a[i-1] + 4;
		i=i+1;
	}

	i=1;
	while(i<N)
	{
        	b[i] = b[i-1] + a[i-1];
		i=i+1;
	}

	i=0;
	while(i<N)
	{
		assert(b[i] == 2*i*i + 2*i + 1);
		i=i+1;
	}
}

}

class vapexp{
	static int i,N;
	static long a[],b[];

static void main()
{
	N=Support.random();

	a[0] = 6;
	b[0] = 1;

	i=1;
	while(i<N)
	{
		a[i] = a[i-1] + 6;
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
		assert(b[i] == 3*i*i + 3*i + 1);
		i=i+1;
	}
}

}

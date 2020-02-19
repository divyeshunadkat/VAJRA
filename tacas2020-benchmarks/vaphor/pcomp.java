class vapexp{
	static int i,N;
	static long a[],b[],c[];

static void main()
{
	N=Support.random();

	a[0] = 6;
	b[0] = 1;
	c[0] = 0;

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

	i=1;
	while(i<N)
	{
        	c[i] = c[i-1] + b[i-1];
		i=i+1;
	}

	i=0;
	while(i<N)
	{
		assert(c[i] == i*i*i);
		i=i+1;
	}
}

}

class vapexp{
	static int i,N;
	static int a[];

static void main()
{
	N=Support.random();
	i=0;
	while(i<N)
	{
		a[i] = 0;
		i = i + 1;
	}

	i=0;
	while(i<N)
	{
		if (N%2 == 0)
		{
			a[i] = a[i] + 2;
		}
		else
		{
			a[i] = a[i] + 1;
		}
		i = i + 1;
	}

	i=0;
	while(i<N)
	{
		assert(a[i] % 2 == N % 2);
		i = i + 1;
	}
}
}

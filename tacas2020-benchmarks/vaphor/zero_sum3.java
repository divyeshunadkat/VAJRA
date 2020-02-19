class vapexp{
	static int i,N;
	static int a[];
	static long sum;

static void main()
{
	N=Support.random();

	sum = 0;
	i=0;
	while(i<N)
	{
		sum = sum + a[i];
		i=i+1;
	}

	i=0; 
	while(i<N)
	{
		sum = sum - a[i];
		i=i+1;
	}

	i=0; 
	while(i<N)
	{
		sum = sum + a[i];
		i=i+1;
	}

	i=0; 
	while(i<N)
	{
		sum = sum - a[i];
		i=i+1;
	}

	i=0; 
	while(i<N)
	{
		sum = sum + a[i];
		i=i+1;
	}

	i=0; 
	while(i<N)
	{
		sum = sum - a[i];
		i=i+1;
	}

	assert(sum == 0);
}

}

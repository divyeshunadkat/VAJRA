class vapexp{
	static int i,N;
	static int a[];

static void main()
{
	N=Support.random();
	i=0;
	while(i<N)
        {
		if(a[i] < N)
		{
			a[i] = a[i];
		} else {
			a[i] = N;
		}
		i = i + 1;
        }

	i=0;
	while(i<N)
        {
		assert(a[i] <= N);
		i = i + 1;
	}
}
}

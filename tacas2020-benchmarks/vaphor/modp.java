class vapexp{
	static int i,N;
	static int a[];
	static int sum;

static void main()
{
	N=Support.random();

	sum = 0;
	i=0;
        while(i<N)
	{
		sum = sum + 1;
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a[i] = sum;
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		assert(a[i] % N== 0);
		i = i + 1;
        }
}
}

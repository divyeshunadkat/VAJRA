class vapexp{
	static int i,N;
	static int a[];
	static int b[];
	static long sum;

static void main()
{
	N=Support.random();

	sum = 0;
	i=0;
	while(i<N)
        {
                a[i] = 1;
		i=i+1;
        }

	i=0;
	while(i<N)
        {
                b[i] = 1;
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
		sum = sum + b[i];
		i=i+1;
        }

	i=0;
	while(i<N)
        {
		a[i] = a[i] + sum;
		i=i+1;
        }

	i=0;
	while(i<N)
        {
		assert(a[i] == 2*N+1);
		i=i+1;
	}
}

}

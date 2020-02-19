class vapexp{
	static int i,N;
	static long a[];
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
		sum = sum + a[i];
		i=i+1;
        }

	i=0;
	while(i<N)
        {
                a[i] = 0;
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
		sum = sum + a[i];
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
		assert(a[i] == N * (N + 2));
		i=i+1;
        }

}

}

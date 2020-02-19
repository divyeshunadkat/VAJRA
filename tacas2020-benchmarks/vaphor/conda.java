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
                a[i] = 1;
		i = i + 1;
        }

	i=0;
	while(i<N)
        {
		if(a[i] == 1) {
			a[i] = a[i] + 1;
		} else {
			a[i] = a[i] - 1;
		}
        }

	i=0;
	while(i<N)
        {
		sum = sum + a[i];
		i = i + 1;
        }

        assert(N <=0 || sum == 2*N);
}
}

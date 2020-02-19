class vapexp{
	static int i,N;
	static int a[];
	static long sum;

static void main()
{
	N=Support.random();
	i=0;
	while(i<N)
        {
                a[i] = 1;
		i = i + 1;
        }

	sum = 0;
	i=0;
	while(i<N)
        {
		sum = sum + a[i];
		i = i + 1;
        }

	i=0;
	while(i<N)
        {
	        if(sum == N) {
			a[i] = a[i] - 1;
	        } else {
			a[i] = a[i] + 1;
        	}
		i = i + 1;
        }

	i=0;
	while(i<N)
        {
                assert(a[i] == 0);
		i = i + 1;
        }
}
}

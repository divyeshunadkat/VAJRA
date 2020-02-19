class vapexp{
	static int i, x, N;
	static int a0[], a1[], a2[], a3[], a4[];
	static int a5[], a6[], a7[], a8[], a9[];

static void main()
{
	N=Support.random();

	i=0;
        while(i<N)
	{
		a2[i] = a1[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a3[i] = a2[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a4[i] = a3[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a5[i] = a4[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a6[i] = a5[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a7[i] = a6[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a8[i] = a7[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a9[i] = a8[i];
		i = i + 1;
        }

	i=0;
        while(i<N)
        {
		a0[i] = a9[i];
		i = i + 1;
        }

	x=0;
        while(x<N)
        {
		assert(a1[x] == a0[x]);
		x = x + 1;
        }
}
}

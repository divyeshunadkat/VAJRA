#define N

int main()
{
	int i;
	int a[N];
	int b[N];
	int c[N];

	a[0] = 6;
	b[0] = 1;
	c[0] = N;
	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + 6;
	}

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + a[i-1];
	}

	for(i=1; i<N; i++)
	{
		c[i] = c[i-1] + b[i-1];
	}

	for(i=0; i<N; i++)
	{
		assert(c[i] == N + i*i*i);
	}
	return 1;
}

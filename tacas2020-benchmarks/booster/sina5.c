#define N

int main()
{
	int i;
	int sum;
	int a[N];
	int b[N];

	sum = 0;
	for(i=0; i<N; i++)
	{
		a[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		b[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum = sum + a[i];
	}

	for(i=0; i<N; i++)
	{
		sum = sum + b[i];
	}

	for(i=0; i<N; i++)
	{
		a[i] = a[i] + sum;
	}

	for(i=0; i<N; i++)
	{
		assert(a[i] == 2*N + 1);
	}
	return 1;
}

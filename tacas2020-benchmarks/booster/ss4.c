#define N

int main()
{
	int i;
	int sum;
	int a[N];

	sum = 0;
	for(i=0; i<N; i++)
	{
		a[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum = sum + a[i];
	}

	for(i=0; i<N; i++)
	{
		a[i] = a[i] + sum;
	}

	sum = 0;
	for(i=0; i<N; i++)
	{
		sum = sum + a[i];
	}

	assert(sum == N*(N+1));
	return 1;
}

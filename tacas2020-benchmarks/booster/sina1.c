#define N

int main()
{
	int i;
	int sum;
	int a[N];

	sum = 0;
	for(i=0; i<N; i++)
	{
		sum = sum + 1;
	}

	for(i=0; i<N; i++)
	{
		a[i] = sum;
	}

	for(i=0; i<N; i++)
	{
		assert(a[i] == N);
	}
	return 1;
}

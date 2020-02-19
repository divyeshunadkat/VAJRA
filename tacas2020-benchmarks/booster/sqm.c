#define N

int main()
{
	int i;
	int a[N];
	int b[N];

	b[0] = 1;
	a[0] = 1;

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + 2;
	}

	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + b[i-1] + 2;
	}

	for(i=0; i<N; i++)
	{
		assert(a[i] == (i+1)*(i+1));
	}
	return 1;
}

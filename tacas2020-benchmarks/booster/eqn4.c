#define N

int main()
{
	int i;
	int a[N];
	int b[N];

	a[0] = 8;
	b[0] = 1;
	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + 8;
	}

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + a[i-1];
	}

	for(i=0; i<N; i++)
	{
		assert(b[i] == 4*i*i + 4*i + 1);
	}
	return 1;
}

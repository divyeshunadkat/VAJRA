#define N

int main()
{
	int i;
	int a[N];
	int b[N];

	a[0] = 6;
	b[0] = 1;

	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + 6;
	}

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + a[i-1];
	}

	for(i=0; i<N; i++)
	{
		assert(b[i] == 3*i*i + 3*i + 1);
	}
	return 1;
}

#define N

int main()
{
	int i;
	int a[N];

	for (i = 0; i < N; i++)
	{
		a[i] = 0;
	}

	for (i = 0; i < N; i++)
	{
		if (N%2 == 0) {
			a[i] = a[i] + 2;
		} else {
			a[i] = a[i] + 1;
		}
	}

	for (i = 0; i < N; i++)
	{
		assert(a[i] % 2 == N % 2);
	}
	return 1;
}

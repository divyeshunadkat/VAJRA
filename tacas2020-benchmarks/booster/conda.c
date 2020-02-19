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
		if(a[i] == 1) {
			a[i] = a[i] + 1;
		} else {
			a[i] = a[i] - 1;
		}
	}

	for(i=0; i<N; i++)
	{
		sum = sum + a[i];
	}

	assert(sum == 2*N);
	return 1;
}

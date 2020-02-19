#define N

int main()
{
	int i;
	int a[N];

	for(i=0; i<N; i++)
	{
		if(a[i] < N) {
			a[i] = a[i];
		} else {
			a[i] = N;
		}
	}

	for(i=0; i<N; i++)
	{
		assert(a[i] <= N);
	}
	return 1;
}

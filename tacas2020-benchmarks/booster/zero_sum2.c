#define SIZE

int main()
{
	int i;
	int a[SIZE];
	int sum;

	sum=0;
	for(i = 0; i < SIZE; i++)
	{
		sum = sum + a[i];
	}

	for(i = 0; i < SIZE; i++)
	{
		sum = sum - a[i];
	}

	for(i = 0; i < SIZE; i++)
	{
		sum = sum + a[i];
	}

	for(i = 0; i < SIZE; i++)
	{
		sum = sum - a[i];
	}

	assert(sum == 0);
	return 1;
}

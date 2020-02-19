extern void __VERIFIER_error() __attribute__ ((__noreturn__));
extern void __VERIFIER_assume(int);
void __VERIFIER_assert(int cond) { if(!(cond)) { ERROR: __VERIFIER_error(); } }
extern int __VERIFIER_nondet_int(void);

int N;

int main()
{
	N = __VERIFIER_nondet_int();
	if(N <= 0) return 1;

	int i;
	long long sum;
	int a[N];
	int b[N];
	int c[N];

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
		b[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum = sum + b[i];
	}

	for(i=0; i<N; i++)
	{
		c[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum = sum + c[i];
	}

	__VERIFIER_assert(sum <= 3*N);
	return 1;
}

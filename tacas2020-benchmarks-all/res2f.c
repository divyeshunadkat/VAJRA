
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
	int sum[1];
	int a[N];
	int b[N];
	int c[N];

	sum[0] = 1;
	for(i=0; i<N; i++)
	{
		a[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum[0] = sum[0] + a[i];
	}

	for(i=0; i<N; i++)
	{
		b[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum[0] = sum[0] + b[i];
	}

	for(i=0; i<N; i++)
	{
		c[i] = 1;
	}

	for(i=0; i<N; i++)
	{
		sum[0] = sum[0] + c[i];
	}

	__VERIFIER_assert(sum[0] <= 3*N);
	return 1;
}
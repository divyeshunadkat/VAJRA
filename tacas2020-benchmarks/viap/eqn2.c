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
	long long a[N];
	long long b[N];

	a[0] = 4;
	b[0] = 1;

	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + 4;
	}

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + a[i-1];
	}

	for(i=0; i<N; i++)
	{
		__VERIFIER_assert(b[i] == 2*i*i + 2*i + 1);
	}
	return 1;
}

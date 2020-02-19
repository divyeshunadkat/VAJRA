
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
	int a[N];
	int b[N];
	int c[N];

	a[0] = 6;
	b[0] = 1;
	c[0] = N;
	for(i=1; i<N; i++)
	{
		a[i] = a[i-1] + 6;
	}

	for(i=1; i<N; i++)
	{
		b[i] = b[i-1] + a[i-1];
	}

	for(i=1; i<N; i++)
	{
		c[i] = c[i-1] + b[i-1];
	}

	for(i=0; i<N; i++)
	{
		__VERIFIER_assert(c[i] == N + i*i*i);
	}
	return 1;
}

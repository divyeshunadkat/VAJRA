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
	int sum;
	int a[N];

	sum = 0;
	for(i=0; i<N; i++)
	{
		sum = sum + 1;
	}

	for(i=0; i<N; i++)
	{
		a[i] = sum % N;
	}

	for(i=0; i<N; i++)
	{
		__VERIFIER_assert(a[i] == 0);
	}
	return 1;
}

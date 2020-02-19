
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

	for(i=0; i<N; i++)
	{
		if(i%5==0) {
			a[i] = 5;
		} else {
			a[i] = 5;
		}
	}

	for(i=0; i<N; i++)
	{
		if(i==0) {
			sum[0] = N + 5;
		} else {
			sum[0] = sum[0] + a[i];
		}
	}
	__VERIFIER_assert(sum[0] <= 5*N);
	return 1;
}

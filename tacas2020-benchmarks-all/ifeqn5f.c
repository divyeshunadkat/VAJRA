
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

	for(i=0; i<N; i++)
	{
		if(i==0) {
			a[0] = 10;
		} else {
			a[i] = a[i-1] + 10;
		}
	}

	for(i=0; i<N; i++)
	{
		if(i==0) {
			b[0] = 1;
		} else {
			b[i] = b[i-1] + a[i-1];
		}
	}

	for(i=0; i<N; i++)
	{
		__VERIFIER_assert(b[i] == 5*i*i + 5*i + 5);
	}
	return 1;
}

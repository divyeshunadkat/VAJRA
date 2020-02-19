extern void __VERIFIER_error() __attribute__ ((__noreturn__));
extern void __VERIFIER_assume(int);
void __VERIFIER_assert(int cond) { if(!(cond)) { ERROR: __VERIFIER_error(); } }
extern int __VERIFIER_nondet_int(void);

int SIZE;

int main()
{
	SIZE = __VERIFIER_nondet_int();
	if(SIZE <= 0) return 1;

	int i;
	int a[SIZE];
	long long sum;

	sum = 0;
	for(i = 0; i < SIZE; i++) 
	{
		a[i] = __VERIFIER_nondet_int();
	}

	for(i = 0; i < SIZE; i++)
	{
		sum = sum + a[i];
	}

	for(i = 0; i < SIZE; i++)
	{
		sum = sum - a[i];
	}

	__VERIFIER_assert(sum == 0);

	return 1;
}

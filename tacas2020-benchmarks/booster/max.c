#define N

int main( ) {
	int a[N];
	int max;

	max = 0;
	int i = 0;
	while ( i < N ) {
		if ( a[i] > max ) {
			max = a[i];
		}
		i = i + 1;
	}

	int x;
	for ( x = 0 ; x < N ; x++ ) {
		assert(  a[x] <= max );
	}
	return 0;
}

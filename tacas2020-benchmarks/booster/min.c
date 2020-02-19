#define N

int main( ) {
	int i;
	int a[N];
	int min;

	min=0;
	i = 0;
	while ( i < N ) {
		if ( a[i] < min ) {
			min = a[i];
		}
		i = i + 1;
	}

	int x;
	for ( x = 0 ; x < N ; x++ ) {
		assert(  a[x] >= min  );
	}
	return 0;
}

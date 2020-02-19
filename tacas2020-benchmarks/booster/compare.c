#define SIZE
int main( ) {
	int i;
	int a[SIZE];
	int b[SIZE];
	int rv;

	rv = 1;
	i = 0;
	while ( i < SIZE ) {
		if ( a[i] != b[i] ) {
			rv = 0;
		}
		i = i+1;
	}

	int x;
	for ( x = 0 ; x < SIZE ; x++ ) {
		assert( rv == 0 || a[x] == b[x]  );
	}
	return 0;
}

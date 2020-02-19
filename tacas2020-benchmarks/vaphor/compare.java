class vapexp{
	static int i, x, SIZE, rv;
	static int a[], b[];

static void main()
{
	SIZE=Support.random();

	rv = 1;
	i = 0;
	while ( i < SIZE ) {
		if ( a[i] != b[i] ) {
			rv = 0;
		}
		i = i+1;
	}

	x=0;
        while(x<SIZE)
        {
		assert( rv == 0 || a[x] == b[x] );
		x = x + 1;
        }
}
}


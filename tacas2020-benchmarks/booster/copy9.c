#define N

int main( ) {
	int a1[N];
	int a2[N];
	int a3[N];
	int a4[N];
	int a5[N];
	int a6[N];
	int a7[N];
	int a8[N];
	int a9[N];
	int a0[N];

	int a;
	int i;
	for ( i = 0 ; i < N ; i++ ) {
		a2[i] = a1[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a3[i] = a2[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a4[i] = a3[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a5[i] = a4[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a6[i] = a5[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a7[i] = a6[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a8[i] = a7[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a9[i] = a8[i];
	}
	for ( i = 0 ; i < N ; i++ ) {
		a0[i] = a9[i];
	}

	int x;
	for ( x = 0 ; x < N ; x++ ) {
		assert(  a1[x] == a0[x]  );
	}
	return 0;
}


rm -rf freqhorn_results 
mkdir freqhorn_results

for file in *.smt2
do
	echo "RUNNING FREQHORN FOR $file"
	
	base=`basename $file .smt2`

	cat $file > temp.smt2

	memlimit -t 100 freqhorn --v3 temp.smt2 > freqhorn_results/$base.log 2>&1

	rm -f temp.smt2
done

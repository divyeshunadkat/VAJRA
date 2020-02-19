rm -rf vaphor_results 
mkdir vaphor_results

for file in *.java
do
	echo "RUNNING VAPHOR FOR $file"
	
	base=`basename $file .java`
	java2horn $file -o $base.smt2
	vaphor $base.smt2 -o ${base}_noarr.smt2
	sed -i '1d;$d' ${base}_noarr.smt2
	memlimit -t 100 z3 ${base}_noarr.smt2 > vaphor_results/$base.log 2>&1
done

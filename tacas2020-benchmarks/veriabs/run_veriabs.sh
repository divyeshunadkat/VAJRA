rm -rf veriabs_results 
mkdir veriabs_results

for file in *.c
do
	echo "RUNNING VERIABS FOR $file"
	
	base=`basename $file .c`

	cat $file > temp.c

	memlimit -t 100 veriabs --property-file unreach-call.prp temp.c > veriabs_results/$base.log 2>&1

	rm -f temp.c
done

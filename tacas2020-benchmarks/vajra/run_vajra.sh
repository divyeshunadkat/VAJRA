rm -f temp.c
rm -rf vajra_results 
mkdir vajra_results

for file in *.c
do
	echo "RUNNING VAJRA FOR $file"
	
	base=`basename $file .c`

	cat $file > temp.c

	time memlimit -t 100 vajra temp.c > vajra_results/$base.log 2>&1

	tail vajra_results/$base.log

	rm -f temp.c
done

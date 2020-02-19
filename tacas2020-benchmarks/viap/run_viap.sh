rm -rf viap_results 
mkdir viap_results

for file in *.c
do
	echo "RUNNING VIAP FOR $file"
	
	base=`basename $file .c`

	cat $file > temp.c

	memlimit -t 100 viap_tool.py --spec=unreach-call.prp temp.c > viap_results/$base.log 2>&1

	tail -4 viap_results/$base.log

	rm -f temp.c
done

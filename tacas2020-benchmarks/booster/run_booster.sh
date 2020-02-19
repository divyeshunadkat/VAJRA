rm -rf booster_results 
mkdir booster_results

for file in *.c
do
	echo "RUNNING BOOSTER FOR $file"
	
	base=`basename $file .c`

	cat $file > temp.c

	memlimit -t 100 booster_64 --config=booster.conf temp.c > booster_results/$base.log 2>&1

	rm -f temp.c
	rm -f *.in *.dot
done

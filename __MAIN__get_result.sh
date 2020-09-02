#!/bin/bash
#usage: get_result.sh DATA.csv  //the DATA.csv from insight.

#remove temp_data
rm -rf result/

mkdir result

#split_data will unify the tests to singleSN file
./split_data.sh $1

#unit_test folder will reset while split_data.sh

if [ $2 ];then
    RESULT_FILE=$2
else
    RESULT_FILE=result.csv
fi

for i in $(ls unit_test)
do
    ./show_AAB.sh unit_test/$i > result/$i
done



#add header
rm $RESULT_FILE
#echo "SN,Final Result,TESTMODE," >>  $RESULT_FILE
for i in $(ls result)
do
SN=$(echo $i | cut -c1-17)
TESTMODE=$(awk -F, '{printf $6}' result/$i)

#$3:testtime

RESULT=$(awk -F, '
{printf $6"_"$4"_"$5"_"$3","}
' result/$i)

FINAL_RESULT=$(tail -1 result/$i | awk -F, '{print $4}')

echo $SN,$FINAL_RESULT,$TESTMODE,$RESULT >> $RESULT_FILE
done

echo "The results are DONE!"

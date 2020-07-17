#!/bin/bash
#usage: get_result.sh DATA.csv  //the DATA.csv from insight.
rm -rf result
rm -rf result.csv
mkdir result

#split_data will unify the tests to singleSN file
./split_data.sh $1

for i in $(ls unit_test)
do
    ./show_AAB.sh unit_test/$i > result/$i
done

for i in $(ls result)
do
SN=$(echo $i | cut -c1-17)
TESTMODE=$(awk -F, '{printf $6}' result/$i)
RESULT=$(awk -F, '
{printf $6"_"$4"_"$5","}
' result/$i)

FINAL_RESULT=$(tail -1 result/$i | awk -F, '{print $4}')

echo $SN,$FINAL_RESULT,$TESTMODE,$RESULT >> result.csv
done
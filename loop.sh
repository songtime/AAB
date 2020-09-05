#!/bin/bash
#use end time as test-date.
#INPUT:insight 30dats test detal.
#OUTPUT:./day-data/Perday.csv

IN_FILE=$1
sed '/Serial Number/d' $IN_FILE > test.data

# rm -rf ./day-data/
# mkdir ./day-data

awk  '
BEGIN{
    FS=","   
}
{
#using end time as TIME day
    TIME=substr($6,0,10)
   print $0 >> "./day-data/"TIME".csv"
    }
' test.data

for i in $(ls day-data)
do
    ./__MAIN__get_result.sh day-data/$i  ${i%\.csv}_AAB.csv
done
#!/bin/bash
FILEPATH=$1
#insight rest recored has RETEST filed 
#RETEST will combie FAIL-FAIL-PASS to one RETEST 


mypath=$(cd $(dirname $0)&&pwd)
echo $mypath


uniq_pass_SN(){
awk -F, '$4 ~ "PASS|RETEST" {print $1}' $1| sort | uniq 
}

uniq_fail_SN(){
awk -F, '$4 ~ "FAIL|RETEST" {print $1}' $1| sort | uniq 
}

uniq_all_SN(){
awk -F, '$4 ~ "PASS|FAIL|RETEST" {print $1}' $1| sort | uniq 
}

retest(){
for i in $(cat FAIL_SN.txt)
do
	if grep $i PASS_SN.txt &> /dev/null
	then
	   echo $i
	fi   
done
}

#generate TRUE_FAIL.txt?
#TRUE=ALL-PASS

split_test(){
#print 1 single SN's test record
    SN=$1
    file=$2
    awk -F, -v SN=$SN '$1 ~ SN {print}' $file
    #array by test time
    sort -t, -k5 $file -o $file
}

main(){
#
#FAIL_SN.txt SN which has fail/retest record.
#
    cd $mypath
	uniq_pass_SN $FILEPATH > PASS_SN.txt
	uniq_fail_SN $FILEPATH > FAIL_SN.txt
	uniq_all_SN $FILEPATH > ALL_SN.txt
	retest > RETEST_SN.txt
	
	PASS=$(cat PASS_SN.txt | wc -l)
	FAIL=$(cat FAIL_SN.txt | wc -l)
	ALL=$(cat ALL_SN.txt | wc -l)
	RETEST=$(cat RETEST_SN.txt | wc -l)
	
	echo "PASS:$PASS,RETEST_PASS:$RETEST,ALL_TEST:$ALL"

    #now split the test record to files.
    #one SN use 1 file
    # if [ -d unit_test ];then
    # echo "unit_test" folder exist
    # else
    #     mkdir unit_test
    # fi
    rm -rf unit_test
    mkdir unit_test

    for i in $(cat ALL_SN.txt)
    do
        split_test $i $FILEPATH > unit_test/$i.csv
    done
  
    
}

main
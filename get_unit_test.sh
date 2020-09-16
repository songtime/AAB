#!/bin/bash
DATA_FILE=$1
#INPUT:data.csv //csv file from instight test detail.
#IN-data-format:C02017501E3LYGG1S,J132A,MLB,FAIL,2020-08-17 02:47:11,2020-08-17 02:49:54,QSMC_QF-3FRMT-13_22_TEST1,testdevice,2,8059.RearLeft.CIOEyeGpsTest,,,"DP SINK Eye Measurement per Ridge only Failed: code = 1 ",1.0,,,N/A,,,,


#OUTPUT:
#console:Test counts:
#OUT-data:unit_test/SN.csv -->one SN, one file to record.File for show_AAB

#Mark:
#insight test recored has RETEST filed
#RETEST will combie FAIL-FAIL-PASS to one RETEST 

#本脚本也会显示复测率到标准输出:
#复测率正常计算公式: Retest_PASS/All Input, 但被要求使用Retest_PASS/PASS 计算从而扩大复测率数值.

mypath=$(cd $(dirname $0)&&pwd)
#echo $mypath


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



generate_unit_test(){
#print 1 single SN's test record
    SN=$1
    file=$2
    awk -F, -v SN=$SN '$1 ~ SN {print}' $file

#危险代码,篡改了源数据文件
    #sort -t use"," as seprator, -k filed 5.
#   sort -t, -k5 $file -o $file
}

main(){
#
#FAIL_SN.txt SN which has fail/retest record.
#
    cd $mypath
	uniq_pass_SN $DATA_FILE > PASS_SN.txt
	uniq_fail_SN $DATA_FILE > FAIL_SN.txt
	uniq_all_SN $DATA_FILE > ALL_SN.txt
	retest > RETEST_SN.txt
	
	PASS=$(cat PASS_SN.txt | wc -l)
	FAIL=$(cat FAIL_SN.txt | wc -l)
	ALL=$(cat ALL_SN.txt | wc -l)
	RETEST=$(cat RETEST_SN.txt | wc -l)
	
	RATE=$(echo "$RETEST $PASS" | awk '{printf "%f",$1/$2}')
	
#Show Retest Data to terminal:

	echo "$DATA_FILE,RETEST_PASS,$RETEST,PASS,$PASS,ALL_TEST,$ALL,RATE,$RATE"

    #now split the test record to files.
    #one SN use 1 file
    # if [ -d unit_test ];then
    # echo "unit_test" folder exist
    # else
    #     mkdir unit_test
    # fi

    #reset each run
    rm -rf unit_test
    mkdir unit_test

#一个SN一个unit_test/SN.csv 
    for i in $(cat ALL_SN.txt)
    do
        generate_unit_test $i $DATA_FILE > unit_test/$i.csv
    #对unit_test/SN.csv 进行时间排序.
    #字符串先后完全是时间先后??
        sort -t, -k5 unit_test/$i.csv -o unit_test/$i.csv
    done
  
    
}

main

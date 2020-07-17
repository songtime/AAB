FILEPATH=$1
#insight rest recored has RETEST filed 
#RETEST will combie FAIL-FAIL-PASS to one RETEST 

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
for i in $(cat FAIL.txt)
do
	if grep $i PASS.txt &> /dev/null
	then
	   echo $i
	fi   
done
}

#generate TRUE_FAIL.txt?
#TRUE=ALL-PASS


main(){
#
#FAIL.txt SN which has fail/retest record.
#
	uniq_pass_SN $FILEPATH > PASS.txt
	uniq_fail_SN $FILEPATH > FAIL.txt
	uniq_all_SN $FILEPATH > ALL.txt
	retest > RETEST.txt
	
	PASS=$(cat PASS.txt | wc -l)
	FAIL=$(cat FAIL.txt | wc -l)
	ALL=$(cat ALL.txt | wc -l)
	RETEST=$(cat RETEST.txt | wc -l)
	
	echo "PASS:$PASS,RETEST_PASS:$RETEST,ALL_TEST:$ALL"

}

main
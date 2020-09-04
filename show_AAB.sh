#!/bin/bash

#INPUT:unit_test/SN.csv
#data_format:


#OUTPUT:stdout:print the AAB test
#C02017500AZLXQH1K,QSMC_QF-3FRMT-13_21_TEST1_1,2020-08-17 18:30:57,PASS,,A
#C02017500AZLXQH1K,QSMC_QF-3FRMT-13_19_TEST1_1,2020-08-21 11:02:50,PASS,,B



#recive a Unit test
#show it's AAB result

# C029513010LNFHT13,QSMC_QF-3FRMT-21_1_TEST1_1,2020-07-15 01:41:41,FAIL,4246.FrontLeft.adapterSwitchVoltageTest,A
# C029513010LNFHT13,QSMC_QF-3FRMT-21_2_TEST1_1,2020-07-15 10:09:41,PASS,,B

#This is for USB-C station to try

# C0200970FR5N9PR1R,X970,MLB,FAIL,2020-07-15 15:31:36,2020-07-15 15:35:36,QSMC_QF-3FRMT-21_3_TEST1,testdevice,1,9208.FrontLeft.displayUUTStatus,,,Remote Bristol test time out,-406.0,,,N/A,,,,
# C0200970FR5N9PR1R,X970,MLB,PASS,2020-07-15 15:37:30,2020-07-15 15:46:50,QSMC_QF-3FRMT-21_3_TEST1,testdevice,1,,,,,,,,,,,,

FILE=$1

#$SN,$A_F,
#should use awk to re-genrate the data.

#use an array to keep the unit
#read line ?

awk -F, '

#support 4 fixture.
BEGIN{
OFS=","
Fixture_A=""
Fixture_B=""
Fixture_C=""
Fixture_D=""
}
NR==1{Fixture_A=$7"_"$9}

#need use an array to keep the unit data

{
    Fixture=$7"_"$9

    #The code here are not smart . 
    if (Fixture_A==Fixture) {$NF="A"}
    if (Fixture_A != Fixture) {
        if ( Fixture_B == "" ) Fixture_B=Fixture
        if ( Fixture_B == Fixture) {$NF="B"}
        }
    if (Fixture_A != Fixture && Fixture_B != Fixture ){
        if (Fixture_C == "" ) Fixture_C=Fixture
        if (Fixture_C == Fixture) {$NF="C"}
        }
    if (Fixture_A != Fixture && Fixture_B != Fixture && Fixture_C != Fixture){
        if (Fixture_D == "") Fixture_D=Fixture
        if (Fixture_D == Fixture) {$NF="D"}
    }
    #print $0
    
    print $1,Fixture,$5,$4,$10,$NF
}
END{
# print Fixture_A
# print Fixture_B
}
' $FILE


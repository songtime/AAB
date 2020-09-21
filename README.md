> This if for show AAB test from insight test detail.
 
# 一天数据计算AAB
- __MAIN__get_result.sh  1day_data.csv  AAB.csv

# 30天数据计算AAB + 复测率
- more_days.sh 30days_data.csv > StationName_Retest.csv
> 将会生成StationName_Retest.csv的复测率数据
> 以及每天的AAB数据

# 其他
- show_AAB.sh :辅助文件
- split_data.sh:辅助文件

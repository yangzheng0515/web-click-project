#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     加载数据到ODS
# 输入参数:     运行日期
# 数据路径:     /data/weblog/preprocess/output
# 目标hive:     web_click_flow_project.ods_weblog_orgin
#   创建人:     ZenoYang
# 创建日期:     2018-03-21
# 版本说明:     v1.0
# 代码审核:     
# 修改人名:
# 修改日期:
# 修改原因:
# 修改列表: 
# ===========================================================================

#set java env
export JAVA_HOME=/usr/local/jdk
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

#set hadoop env
export HADOOP_HOME=/usr/local/hadoop
export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH


#获取时间信息
if [ $# -eq 1 ]
then
    day_01=`date --date="${1}" +%Y-%m-%d`
else
    day_01=`date -d'-1 day' +%Y-%m-%d`
fi
syear=`date --date=$day_01 +%Y`
smonth=`date --date=$day_01 +%m`
sday=`date --date=$day_01 +%d`

#预处理输出结果(raw)目录
log_pre_output=/data/weblog/preprocess/output
#点击流pagevies模型预处理程序输出目录
click_pvout="/data/weblog/preprocess/click_pv_out"
#点击流visit模型预处理程序输出目录
click_vstout="/data/weblog/preprocess/click_visit_out"

#目标hive表
TARGET_DB=web_click_flow_project
ods_weblog_origin="$TARGET_DB.ods_weblog_origin"
ods_click_pageviews="$TARGET_DB.ods_click_pageviews"
ods_click_visit="$TARGET_DB.ods_click_visit"

#导入raw数据到web_click_flow_project.ods_weblog_origin
HQL_origin="load data inpath '$log_pre_output/$day_01' into table $ods_weblog_origin partition(datestr='$day_01')"
echo $HQL_origin 
/usr/local/hive/bin/hive -e "$HQL_origin"


#导入点击流模型pageviews数据到
HQL_pvs="load data inpath '$click_pvout/$day_01' into table $ods_click_pageviews partition(datestr='$day_01')"
echo $HQL_pvs 
/usr/local/hive/bin/hive -e "$HQL_pvs"

#导入点击流模型visit数据到
HQL_vst="load data inpath '$click_vstout/$day_01' into table $ods_click_visit partition(datestr='$day_01')"
echo $HQL_vst 
/usr/local/hive/bin/hive -e "$HQL_vst"
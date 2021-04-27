#! /bin/bash

file="${1}" &&
kafka_message_timestamp_type="${2:-LogAppendTime}" ;

turnpassedtimes="${3:-0}" ;

[[ -f "$file" ]] || { echo 'file '"$file"' is not normal .' >&2 ; exit 2 ; } ;



#################



thatdaybg="$(date -d"$(date -d"@$(fgrep -v ',\N' "$file"|head -n1|awk '{split($1,a,":");print a[2]"/1000"}'|bc)" +%F)" +%s)" &&

sleep_nozero ()
{
    [[ "$1" == '0' ]] || { sleep $1 ; } ;
} &&

seconds_to_sleep ()
{
    thisdaybg="$1" ;
    thatdaycurrent="$3" ;
    {
        echo "scale=3" ;
        echo "thisdaycurrent=( $(date +%s.%N) - $thisdaybg + $thatdaybg )" ;
        echo "$(echo "$thatdaycurrent"|awk '{print"scale=3;"$0"/1000"}'|bc) - thisdaycurrent" ;
    } |
        bc |
        awk '{ if ($0~/^-/) {print"0"} else {print$0} ; }'
} &&

thisdaybg="$(date -d"$(date +%FT00:00:00%:::z)" +%s)" &&
awk '!/\\N/' "$file" |
    awk 'BEGIN{ FS="'"$kafka_message_timestamp_type"':" } { print NR, $2 }' |
    while read thatdaycurrent_x ;
    do
        {
            sleep_nozero "$(seconds_to_sleep $thisdaybg $thatdaycurrent_x)" ;
            echo "$thatdaycurrent_x" | awk '{ print $3 }' ;

            echo "$thatdaycurrent_x" |
                awk '{ printf "'"$turnpassedtimes"':"$1","strftime("[%T],done",$2)" " }' >&2 ;
        } ;
    done ;

exec bash "$0" "$file" "$kafka_message_timestamp_type" "$((1+turnpassedtimes))" ;





#######################################################################################################################




### file 需要的内容格式是譬如这样得到的：



## 创建topic最好是这样的配置：

function topic_ctreate_demo ()
{
    kafka-topics.sh \
            --bootstrap-server localhost:9092 \
            --create \
            --topic events \
            --partitions 1 \
            --replication-factor 2 \
            --config message.timestamp.type=LogAppendTime \
    ;
} ;

### 分区要一个(必须)
### 副本按需
### 时间戳种类按需



## 消费：

kafka_consumer_ts ()
{
    kafka-console-consumer.sh \
            --topic "$1" \
            --bootstrap-server xxx1:9092,xxx2:9092 \
            --property print.timestamp=true |
        awk '
        {
            fscnt = split($1,fsarr,":") ;
            ts_mill = fsarr[2] ;
            if ('"${2:- ts_mill >= "$(date -d-1day +%s%3N)" && ts_mill < "$(date +%s%3N)" }"') {print} ;
        }' ;
} ;

### 关键是 --property print.timestamp=true
### awk 里是把前24小时给取了 也可以根据自己的需要把对应位置换成一天起止时间。



## 使用：

### 假设:
###   本脚本文件名为: kr.sh 
###   导出的消息文件名: ktsmsg.log
### 
### 预览:
###   一般预览: bash kr.sh ktsmsg.log
###   或者这样预览: bash kr.sh ktsmsg.log >/dev/null
###   或者这样预览: bash kr.sh ktsmsg.log | awk '{printf$0" > "}'
### 模拟:
###   bash kr.sh ktsmsg.log |
###       $KAFKA_HOME/bin/kafka-console-producer.sh --topic (topic-name) --broker-list xxx:9092
### 





#######################################################################################################################



### 本脚本去掉所有注释后
### 用「回车都换成空格然后连续的空格换成一个」的逻辑可以压缩脚本占用空间（虽然没多少）

### 本脚本建议 screen 内执行
### 最好别放后台 放了的话记得可能需要杀三次
### 本脚本不会自行停止执行
### 它是用于按照实际发生过的频率重放模拟曾经的生产的



#######################################################################################################################

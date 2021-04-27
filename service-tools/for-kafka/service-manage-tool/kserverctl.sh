#! /bin/bash

#[ for: kafka-2.6.1 ]#

homepath_var_checker ()
{
    [[ "$1" != "" && -d "$1" ]] ;
} &&

homepath_var_checker "$KAFKA_HOME" ||
{
    rtc=$? ;
    echo '['"$(date +%FT%T.%3N%:::z)"'] ERROR : HOME Dir '"$KAFKA_HOME"' not found !!' >&2 ;
    exit $rtc ;
} ;

#[ make sure value of XXX_HOME is a legal dir ]#


source /etc/profile ||
{
    rtc=$? ;
    echo '['"$(date +%FT%T.%3N%:::z)"'] ERROR : run : source /etc/profile failed !!' >&2 ;
    exit $rtc ;
} ;

#[ make sure /etc/profile can be source ]#


service_type="${2:-kafka}" ;

case "$service_type" in
kafka|kfk) 
    service_name=kafka properties_file_name=server ;;
zookeeper|zk) 
    service_name=zookeeper properties_file_name=$service_name ;;
*) 
    {
        echo '['"$(date +%FT%T.%3N%:::z)"'] ERROR : para2 only can be : kafka/kfk/zookeeper/zk ' >&2 ;
        exit 6 ;
    } ;;
esac ;

#[ make sure para2 is legal , and init the needed vals ]#

#[ then , use values to run shell script ]#

{
    case "$1" in
    start) 
        ( $KAFKA_HOME/bin/${service_name}-server-start.sh $KAFKA_HOME/config/${properties_file_name}.properties & ) ;;
    stop) 
        $KAFKA_HOME/bin/${service_name}-server-stop.sh >&2 ;;
    restart) 
        { bash "$0" stop $service_name ; bash "$0" start $service_name ; } ;;
    *) 
        { echo '['"$(date +%FT%T.%3N%:::z)"'] ERROR : para1 only can be : start/stop/restart ' >&2 ; exit 3 ; } ;;
    esac
} ||
{
    rtc=$? ;
    echo '['"$(date +%FT%T.%3N%:::z)"'] ERROR : something might wrong ... '"($rtc)" >&2 ;
    exit $rtc ;
} ;

# end-of-file

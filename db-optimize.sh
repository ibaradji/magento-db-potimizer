#!/bin/bash
#########################################################
## Script to clean magento  logs
## database cleaner V 1.0
## Written by  Ismaila Baradji
## Date: 2015 , November 30
#########################################################
log=$HOME/files/pmc_logs/db-optimize.log

SCRIPT=$(readlink -f $0)
PWD=`dirname $SCRIPT`
CUT=$(which cut)
MYSQL=$(which mysql)
GREP=$(which grep)
SCRIPT_PATH=$PWD

SOURCEFILE=$HOME/html/app/etc/local.xml

if [ -f $SOURCEFILE ]
then
    HOST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    PRE=$($GREP -i -m 1 table_prefix $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DBNAME=$($GREP -i -m 1 dbname $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DBPASS=$($GREP -i -m 1 password $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    BIRTH=$($GREP -i -m 1 date $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DBUSER=$($GREP -i -m 1 username $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DBHOST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
fi

NUM=1;
echo "Date ".$(date) >> $log
echo "foreign key check diseable"
for table in core_cache core_cache_tag core_session log_customer log_quote log_summary log_summary_type log_url log_url_info log_visitor log_visitor_info log_visitor_online index_event index_process_event report_event report_viewed_product_index report_compared_product_index; 
do $MYSQL -u $DBUSER -h $HOST -p$DBPASS $DBNAME -e"set foreign_key_checks=0;truncate table $PRE$table;"; echo '['$NUM'/20] Truncated: '$PRE$table $OK >> $log; NUM=$(($NUM + 1)) ;
done;
$MYSQL -u $DBUSER -h $HOST -p$DBPASS $DBNAME -e"set foreign_key_checks=1"; echo "foreign key check enable"

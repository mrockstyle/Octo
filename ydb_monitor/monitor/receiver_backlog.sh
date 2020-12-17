#!/bin/bash
#
# 9 : number of backlog transactions received by receiver server and yet to be processed by update process
# 706458452662 : sequence number of last transaction received from Source Server and written to receive pool
# 706458452653 : sequence number of last transaction processed by update process

#if [ $# -lt 1 ]
#then
#        echo "Usage: `basename $0` <ydb-dir>"
#        exit 1
#fi

YDB_DIR=/ydbdir
if [ ! -f ${YDB_DIR}/ydbenv_local ]
then
        echo "Error: cannot find ${YDB_DIR}/ydbenv_local"
        exit 2
fi

. ${YDB_DIR}/ydbenv_local

export HOSTNAME=`hostname -s`
mupip replicate -receiver -show 2>&1 | awk '
BEGIN {
        TIME = systime()
        HOSTNAME = ENVIRON["HOSTNAME"]
        MM["Jan"]=1; MM["Feb"]=2;  MM["Mar"]=3;  MM["Apr"]=4
        MM["May"]=5; MM["Jun"]=6;  MM["Jul"]=7;  MM["Aug"]=8
        MM["Sep"]=9; MM["Oct"]=10; MM["Nov"]=11; MM["Dec"]=12
}
/ Initiating SHOWBACKLOG operation on / {
        DATE = $5 "-" MM[$2] "-" $3
        TIME = $4
        INSTANCE = $18
        sub(/\[/,"",INSTANCE)
        sub(/\]/,"",INSTANCE)
}
/ number of backlog transactions received by receiver server / {
        BACKLOG = $1
}
/ sequence number of last transaction received from Source Server / {
        RECEIVED = $1
}
/ sequence number of last transaction processed by update process/ {
        UPDATED = $1
        print "rcv_backlog,host=" HOSTNAME " backlog=" BACKLOG ",received=" RECEIVED ",updated=" UPDATED " " TIME "000000000"
}'

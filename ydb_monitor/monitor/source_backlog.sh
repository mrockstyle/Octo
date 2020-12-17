#!/bin/bash
#
# Wed Dec  5 00:09:23 2018 : Initiating SHOWBACKLOG operation on source server pid [26567] for secondary instance [CBSPROD_DRC]
# 0 : backlog number of transactions written to journal pool and yet to be sent by the source server
# 709199970203 : sequence number of last transaction written to journal pool
# 709199970203 : sequence number of last transaction sent by source server
# Wed Dec  5 00:09:23 2018 : Initiating SHOWBACKLOG operation on source server pid [20549] for secondary instance [CBSREP_INQ1]
# 0 : backlog number of transactions written to journal pool and yet to be sent by the source server
# 709199970203 : sequence number of last transaction written to journal pool
# 709199970203 : sequence number of last transaction sent by source server
# Wed Dec  5 00:09:23 2018 : Initiating SHOWBACKLOG operation on source server pid [25373] for secondary instance [CBSREP_INQ2]
# 0 : backlog number of transactions written to journal pool and yet to be sent by the source server
# 709199970203 : sequence number of last transaction written to journal pool
# 709199970203 : sequence number of last transaction sent by source server

#if [ $# -lt 1 ]
#then
#        echo "Usage: `basename $0` <profile-dir>"
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
mupip replicate -source -show 2>&1 | awk '
BEGIN {
        HOSTNAME = ENVIRON["HOSTNAME"]
        MM["Jan"]=1; MM["Feb"]=2;  MM["Mar"]=3;  MM["Apr"]=4
        MM["May"]=5; MM["Jun"]=6;  MM["Jul"]=7;  MM["Aug"]=8
        MM["Sep"]=9; MM["Oct"]=10; MM["Nov"]=11; MM["Dec"]=12
}
/ Initiating SHOWBACKLOG operation on / {
        YYYY = $5
        DD   = $3
        DATE = YYYY "-" MM[$2] "-" DD
        TIME = $4
        split(TIME,T,":")
        EPOCH = mktime(YYYY " " MM[$2] " " DD " " T[1] " " T[2] " " T[3])
        INSTANCE = $18
        sub(/\[/,"",INSTANCE)
        sub(/\]/,"",INSTANCE)
}
/ backlog number of transactions written to journal pool / {
        BACKLOG = $1
}
/ sequence number of last transaction written to journal pool/ {
        WRITTEN = $1
}
/ sequence number of last transaction sent by source server/ {
        SENT = $1
        #print DATE "|" TIME "|" INSTANCE "|" BACKLOG "|" WRITTEN "|" SENT
        print "src_backlog,host=" HOSTNAME ",dest_instance=" INSTANCE " backlog=" BACKLOG ",written=" WRITTEN ",sent=" SENT " " EPOCH "000000000"
}'

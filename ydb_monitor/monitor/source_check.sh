#!/bin/bash
#Thu Mar 19 04:23:48 2020 : Initiating CHECKHEALTH operation on source server pid [1803] for secondary instance name [YDB_B]
#PID 1803 Source server is alive in ACTIVE mode
#Thu Mar 19 04:23:48 2020 : Initiating CHECKHEALTH operation on source server pid [1811] for secondary instance name [YDB_C]
#PID 1811 Source server is alive in ACTIVE mode

YDB_DIR=/ydbdir
if [ ! -f ${YDB_DIR}/ydbenv_local ]
then
        echo "Error: cannot find ${YDB_DIR}/ydbenv_local"
        exit 2
fi

. ${YDB_DIR}/ydbenv_local

export HOSTNAME=`hostname -s`
mupip replicate -source -check 2>&1 | awk '
BEGIN {
        HOSTNAME = ENVIRON["HOSTNAME"]
        MM["Jan"]=1; MM["Feb"]=2;  MM["Mar"]=3;  MM["Apr"]=4
        MM["May"]=5; MM["Jun"]=6;  MM["Jul"]=7;  MM["Aug"]=8
        MM["Sep"]=9; MM["Oct"]=10; MM["Nov"]=11; MM["Dec"]=12
}
/ Initiating CHECKHEALTH operation on / {
        YYYY = $5
        DD   = $3
        DATE = YYYY "-" MM[$2] "-" DD
        TIME = $4
        split(TIME,T,":")
        EPOCH = mktime(YYYY " " MM[$2] " " DD " " T[1] " " T[2] " " T[3])
        INSTANCE = $19
        sub(/\[/,"",INSTANCE)
        sub(/\]/,"",INSTANCE)
}
/ Source server is / {
        MODE = $8
        STATE = $6
	PID = $2
        #print DATE "|" TIME "|" INSTANCE "|" BACKLOG "|" WRITTEN "|" SENT
        print "src_aliveness,host=" HOSTNAME ",dest_instance=" INSTANCE ",mode=" MODE ",status=" STATE " pid=" PID " " EPOCH "000000000"
}'

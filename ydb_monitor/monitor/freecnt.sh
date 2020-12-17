#!/bin/bash
#Region          Free     Total          Database file
#------          ----     -----          -------------
#DATA              10    241911 (  0.0%) /global/ydbdir_db/mumps.data
#OCTO              94       100 ( 94.0%) /global/ydbdir_db/mumps.octo

. /ydbdir/ydbenv_local

export HOSTNAME=`hostname -s`
export EPOCH=`date +%s`

mumps -run %FREECNT | awk '
BEGIN {
        HOSTNAME = ENVIRON["HOSTNAME"]
	EPOCH = ENVIRON["EPOCH"]
}
NR>2 {
        REG=$1
        FREE=$2
        TOTAL=$3
	FILE=$6
        #print DATE "|" TIME "|" INSTANCE "|" BACKLOG "|" WRITTEN "|" SENT
        print "freecnt,host=" HOSTNAME ",database_file=" FILE ",region=" REG " free_block=" FREE ",total_block=" TOTAL " " EPOCH "000000000"
}'


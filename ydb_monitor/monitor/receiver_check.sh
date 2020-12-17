#!/bin/bash
#PID 2541 Receiver server is alive
#PID 2542 Update process is alive


YDB_DIR=/ydbdir
if [ ! -f ${YDB_DIR}/ydbenv_local ]
then
        echo "Error: cannot find ${YDB_DIR}/ydbenv_local"
        exit 2
fi

. ${YDB_DIR}/ydbenv_local

export HOSTNAME=`hostname -s`
export EPOCH=`date +%s`


mupip replicate -receiver -check 2>&1 | awk '
BEGIN {
        HOSTNAME = ENVIRON["HOSTNAME"]
	EPOCH = ENVIRON["EPOCH"]
}
/ Receiver server is / {
	RCV_STATE = $6
	RCV_PID = $2
}
/ Update process is / {
        UPD_STATE = $6
	UPD_PID = $2
        #print DATE "|" TIME "|" INSTANCE "|" BACKLOG "|" WRITTEN "|" SENT
        print "rcv_aliveness,host=" HOSTNAME ",receiver_status=" RCV_STATE ",update_process_status=" UPD_STATE " receiver_pid=" RCV_PID ",update_pid=" UPD_PID " " EPOCH "000000000"
}'

#!/bin/bash

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

#if [ $# -lt 1 ]
#then
#        echo "Usage: `basename $0` <profile-dir>"
#        exit 1
#fi

export YDB_DIR=/ydbdir

if [ ! -f ${YDB_DIR}/ydbenv_local ]
then
        echo "${YDB_DIR} is invalid YottaDB directory"
        exit 2
fi

. ${YDB_DIR}/ydbenv_local

export export ydb_routines="${PRGDIR} ${ydb_routines}"
export HOSTNAME=`hostname -s`

mumps -run ZGVSTAT

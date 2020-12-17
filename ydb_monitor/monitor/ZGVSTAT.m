ZGVSTAT ; gather YottaDB statistics from current database into InfluxDB line protocol
        ;
        NEW DIR,HOSTNAME,REG,STATS,STAT,LEN,I,NAME,VALUE
        ;
        SET DIR=$$TRNLNM^%ZFUNC("YDB_DIR")
        SET HOSTNAME=$$TRNLNM^%ZFUNC("HOSTNAME")
        SET EPOCH=$ZUT*1000
        ;
        SET REG=""
        FOR  SET REG=$VIEW("GVNEXT",REG) QUIT:REG=""  DO
        .       SET STATS=$VIEW("GVSTAT",REG)
        .       SET LEN=$LENGTH(STATS,":")-1
        .       FOR I=1:1:LEN  DO
        ..              SET STAT=$PIECE(STATS,",",I)
        ..              SET NAME=$PIECE(STAT,":",1)
        ..              SET VALUE=$PIECE(STAT,":",2)
        ..              WRITE "gvstat,host="_HOSTNAME_",ydb_dir="_DIR
        ..              WRITE ",region="_REG_",name="_NAME_" value="_VALUE_" "_EPOCH,!
        ;
        Q

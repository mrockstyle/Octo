#!/bin/bash


ydb_ver=$(1:-r130)


### check os ###
osfile="/etc/os-release"
osid=`grep -w ID $osfile | cut -d= -f2 | cut -d'"' -f2`
if [ -f "$osfile" ] ; then
	if [ "ubuntu" = "${osid}" ] ; then
		ydb_dist_tar=ydb_dist_${ydb_ver}_ubuntu.tgz
	elif [ "rhel" = "${osid}" ] ; then
		ydb_dist_tar=ydb_dist_${ydb_ver}_rhel.tgz
	else
		echo "OS not supported"
		exit 1
	fi
fi

### prepare directory ###
if [ ! -d /data/yottadb ] ; then
	mkdir -p /data/yottadb
else
	echo "/data/yottadb exist"
fi

if [ ! -d /global/ydbdir_journal ] ; then
	mkdir -p /global/ydbdir_journal
else
	echo "/global/ydbdir_journal exist"
fi

### prepare user ###
id ydbadm
if [ ! $? -eq 0 ] ; then
	groupadd -g 1001 ydbadm
	useradd -u 1001 -g 1001 ydbadm
else
	echo "user ydbadm exist"
fi


### install ###
mkdir -p /data/yottadb/ydb/scripts
cp -rp ydb_utilities_scripts/* /data/yottadb/ydb/scripts/
cp -rp ydb_external/ydbpip /data/yottadb/ydb/
cp -rp ydb_directory/global/ydbdir_db /global/
chown ydbadm:ydbadm -Rh /data/yottadb/ydb/ydbpip
chown ydbadm:ydbadm -Rh /data/yottadb/ydb/scripts
tar -xzvf ydb_distribute/${ydb_dist_tar} -C /data/yottadb/ydb

cp -rp ydb_directory/data/yottadb/ydbdir /data/yottadb/
chown root:root /data/yottadb/ydbdir/yottadb.pc
mv /data/yottadb/ydbdir/yottadb.pc /usr/share/pkgconfig/
chown ydbadm:ydbadm -Rh /data/yottadb/ydbdir



### Create link ####
ln -s /data/yottadb/ydb /ydb
ln -s /data/yottadb/ydbdir /ydbdir

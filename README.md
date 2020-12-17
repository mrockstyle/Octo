# Octo Prototype
## Describtion
The YottaDB Octo Database Management System is a SQL access layer built on top of the not-only-SQL database YottaDB.

## Table of Content
1.  [Setup Step](#1-setup-step)
</br>1.1 [Install prerequiresite packages](#1.1-Install-prerequiresite-packages)
</br>1.2 [Download YottaDB + Octo packages](#1.2-Download-YottaDB-+-Octo-packages)
</br>1.3 [Install YottaDB + Octo Distibute](#1.3-Install-YottaDB-+-Octo)
</br>1.4 [Setup YottaDB Instance](#1.4-setup-yottadb-instance)
2.  [Test Basic Functional](#2-Test-Basic-Functional)
</br>2.1 [YottaDB Functional](#2.1-yottadb-functional)
</br>2.2 [Octo Functional](#2.2-octo-functional)
</br>2.3 [Functional Test Cleanup](#2.3-functional-test-cleanup)

---

## 1.   Setup Step
### 1.1 Install prerequiresite packages
```bash
$ sudo apt-get update
$ sudo apt-get install binutils libconfig-dev
```


### 1.2 Download YottaDB + Octo packages
```bash
$ cd /tmp 
$ git clone https://github.com/mrockstyle/Octo
```

### 1.3 Install YottaDB + Octo
```bash
$ cd /
$ sudo tar -xzvf /tmp/Octo/ydb_dist.tar.gz
```

### 1.4 Setup YottaDB Instance
```bash
$ cd /
$ sudo tar -xzvf /tmp/Octo/ydb_dir.tar.gz
$ sudo chown $USER:$USER -Rh /ydbdir
$ cd /ydbdir 
$ sudo chown root:root yottadb.pc
$ sudo mv yottadb.pc /usr/share/pkgconfig/
```

---

## 2.   Test Basic Functional
### 2.1 YottaDB Functional
```bash
$ cd /ydbdir
$ . ./ydbenv
$ ydb

## in Yottadb Prompt
YDB>
YDB> set ^NAME(0)="First Name|Last Name|Nickname"
YDB> set ^NAME(1)="THAMMANOON|PHATTRAMARUT|HIGH"
YDB> zwr ^NAME

## Expected Result
YDB> zwr ^NAME
^NAME(0)="First Name|Last Name|Nickname"
^NAME(1)="THAMMANOON|PHATTRAMARUT|HIGH"
```
### 2.2 Octo Functional
```bash
$ cd /ydbdir
$ . ./ydbenv
$ octo
```
```sql
## in Octo Prompt
OCTO>
OCTO> CREATE TABLE `NAME` (`First_Name` VARCHAR(25) PIECE 1, `Last_Name` VARCHAR(25) PIECE 2, `SEQ` INTEGER PRIMARY KEY PIECE 3) GLOBAL "^NAME(keys(""SEQ""))" DELIM "|";
OCTO> select * from NAME;

## expected result
OCTO> select * from NAME;
First Name|Last Name|0
THAMMANOON|PHATTRAMARUT|1
```

### 2.3 Functional Test Cleanup 
```bash
cd /ydbdir
. ./ydbenv
ydb

## in Yottadb Prompt
YDB>k ^NAME

## in Octo Prompt
OCTO> DROP TABLE NAME;

```
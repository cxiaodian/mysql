## MySQL导出导入相关

### 导出数据

导出的格式

```
Usage: mysqldump [OPTIONS] database [tables]
OR     mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
OR     mysqldump [OPTIONS] --all-databases [OPTIONS]
```

具体官网[Dumping Data in SQL Format with mysqldump](https://dev.mysql.com/doc/refman/5.7/en/mysqldump-sql-format.html)

导出SQL_Learning 库里面的Customers 表

```
$ mysqldump -uroot -p SQL_Learning Customers > ~/mysql/sql.sqlEnter password:
```
导出所有数据

	mysqldump -uroot -p --all-databases > all_databases.sql


备份能够覆盖重复数据的结构

	mysqldump -uroot -p -d --add-drop-table SQL_Learning >SQL_.sql
	
压缩导出

	mysqldump -uroot -p SQL_Learning | gzip > SQL_Learning.sql.gz
	
查询结果导出到文件

	mysql -uroot -p -e "USE SQL_Learning; SELECT * FROM Orders" > order.txt

### 导入数据


mysqldump 导入数据很简单 

	mysql -uroot -p SQL_Learning < SQL_Learning.sql
	
导入压缩数据

	gunzip < SQL_Learning.sql.gz | mysql -uroot -p SQL_Learning

从文本中导入数据，具体导入格式[LOAD DATA INFILE Syntax](http://dev.mysql.com/doc/refman/5.7/en/load-data.html)

```
mysql> LOAD DATA LOCAL INFILE '~/mysql/sql.txt' INTO TABLE Customers;
Query OK, 2 rows affected, 18 warnings (0.01 sec)
Records: 2  Deleted: 0  Skipped: 0  Warnings: 18
```
把sql.txt的数据插入到customers 表里。





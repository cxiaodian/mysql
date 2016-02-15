
## 插入数据库

利用INSERT语句将数据插入表中

### 数据插入

用来插入(添加)行到数据库。

- 插入完整的行
- 插入行的一部分
- 插入某些查询结果

#### 插入完整的行

指定表名和被插入到新行中的值

编写依赖与特定列次序的SQL语句，这样做有时会出错，但编写方便。

```
mysql> INSERT INTO Customers
    -> VALUES('1000000006',
    -> 'Toy Land',
    -> '123 Any Street',
    -> 'New York',
    -> 'NY',
    -> '11111',
    -> 'USA',
    -> NULL,
    -> NULL);
Query OK, 1 row affected (0.01 sec)
```

解释: 插入一个新客户到Customers表，存储到每个表列的数据VALUES子句中给出，对每个表必须
提供一个值，如果某列没值，就应该使用NULL值。

养成指定顺序插入数据，虽然写起来繁琐，但不容易发生错误。
注意每个列，都必须提供一个值。

```
mysql> INSERT INTO Customers(cust_id,
    -> cust_contact,
    -> cust_email,
    -> cust_name,
    -> cust_address,
    -> cust_city,
    -> cust_state,
    -> cust_zip)
    -> VALUES('1000000009',
    -> NULL,
    -> NULL,
    -> 'Toy Land',
    -> '123 Any Street',
    -> 'New York',
    -> 'NY',
    -> '11111');
```

#### 插入部分行

指定某列提供值，其他的不提供值

```
mysql> INSERT INTO Customers(cust_id,
    -> cust_name,
    -> cust_address,
    -> cust_city,
    -> cust_state,
    -> cust_zip,
    -> cust_country)
    -> VALUES('1000000008',
    -> 'Toy Land',
    -> '123 Any Street',
    -> 'New York',
    -> 'NY',
    -> '11111',
    -> 'USA');
Query OK, 1 row affected (0.01 sec)
```

解释:忽略表中cust_ontact 与cust_email 值。

插入部分值，前提条件是表允许

- 改列定义为允许NULL值
- 表改成默认值，如果不给，将使用默认

如果没有这两个前天条件，就服务插入部分值。


### 插入检索出的数据

利用SELECT 语句的输出结果插入表中，INSERT SELECT两条结合。

新键一个表

```
mysql> CREATE TABLE CustomersNew
    -> (
    ->   cust_id      char(10)  NOT NULL ,
    ->   cust_name    char(50)  NOT NULL ,
    ->   cust_address char(50)  NULL ,
    ->   cust_city    char(50)  NULL ,
    ->   cust_state   char(5)   NULL ,
    ->   cust_zip     char(10)  NULL ,
    ->   cust_country char(50)  NULL ,
    ->   cust_contact char(50)  NULL ,
    ->   cust_email   char(255) NULL
    -> );
Query OK, 0 rows affected (0.06 sec)
```


插入是注意主键值不能重复。

```
mysql> INSERT INTO CustomersNew(cust_id,
    -> cust_contact,
    -> cust_email,
    -> cust_name,
    -> cust_address,
    -> cust_city,
    -> cust_state,
    -> cust_zip,
    -> cust_country)
    -> SELECT cust_id,
    -> cust_contact,
    -> cust_email,
    -> cust_name,
    -> cust_address,
    -> cust_city,
    -> cust_state,
    -> cust_zip,
    -> cust_country
    -> FROM Customers;
    
```

解释:将`CustomersNew`所有的数据导入`Customers` 

### 从一个表复制到另一个表

只复制表结构，不复制数据。

```
mysql> CREATE TABLE Customers_New like Customers;
Query OK, 0 rows affected (0.03 sec)
```

创建一个CustCopy 表，并把Customers表中的数据复制过来。

```
mysql> CREATE TABLE CustCopy AS
    -> SELECT *
    -> FROM Customers;
Query OK, 8 rows affected (0.03 sec)
Records: 8  Duplicates: 0  Warnings: 0
```

查看一个表是如果创建的

	mysql> SHOW CREATE TABLE Customers;
	
查看表的结构

	mysql> DESC Customers

注意:

- 任何SELECT 选择的子句都可以使用。WHERE ,GROUP BY等
- 可以利用链接从多个表插入数据
- 不过从多少个表检索出来的数据，数据都只能插入一个表中。

SELECT INTO 可以用来测试SQL语句前，复制一个表出来测试，避免影响原来的表。






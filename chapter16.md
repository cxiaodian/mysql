## 创建和操作表

### 创建表

创建表的方法

- 直接用交互创建表和管理工具
- 表也可以直接用SQL语句操纵

#### 表创建基础

利用CREATE TABLE创建表，需以下信息

- 新表的名字，在关键字CREATE TABLE之后
- 表列的名字和定义，用逗号隔开。
- 部分DBMS需要指定表的位置。


```
mysql> CREATE TABLE Products
    -> ( prod_id CHAR(10) NOT NULL,
    -> vend_id CHAR(10) NOT NULL,
    -> prod_name CHAR(254) NOT NULL,
    -> prod_price DECIMAL(8,2) NOT NULL,
    -> prod_desc TEXT(1000) NULL
    -> );
```

解释: 表名后面跟着的列，是表的定义，括在园括号之中，各列直接用逗号分割，一共有五个表，
列名后面跟数据类型，圆括号结束。

#### 使用NULL值

允许使用NULL值的列，也允许插入行时不给出该列的值，如果不允许该行没值，可以使用NULL

```
mysql> CREATE TABLE Order_s
    -> (
    -> order_num INTEGER NOT NULL,
    -> order_date DATETIME NOT NULL,
    -> cust_id CHAR(10) NOT NULL
    -> );
Query OK, 0 rows affected (0.02 sec)
```

使用列的含义使用NOT NULL来插入，阻止插入的列没事值。

混合NULL与NOT NULL列的表

```
mysql> CREATE TABLE Vendors
    -> (
    -> vend_id CHAR(10) NOT NULL,
    -> vend_name CHAR(50) NOT NULL,
    -> vend_address CHAR(50),
    -> vend_city CHAR(50),
    -> vend_state CHAR(5),
    -> vend_zip CHAR(10),
    -> vend_country CHAR(50)
    -> );
    
```

#### 指定默认值

插入行时，如果不指定值，自动采用默认值


```

mysql> CREATE TABLE OrderItems
    -> (
    -> order_num INTEGER NOT NULL,
    -> order_item INTEGER NOT NULL,
    -> prod_id CHAR(10) NOT NULL,
    -> quantity INTEGER NOT NULL DEFAULT 1,
    -> item_price DECIMAL(8,2) NOT NULL
    -> );
```

解释: quantity 用于存放订单中的物品，给了一个默认值`DEFAULT 1` ，如果没有给值，默认是1

默认值经常用于日期跟时间戳

- Mysql 用户指定DEFAULT CURRENT_DATE()

#### 更新表

使用 `ALTER TABLE` 语句来更新内容，但有几个地方要注意

- 表中包含数据是不用对其进行更新。
- 所有的DBMS都允许表添加列
- 许多DBMS不允许删除更新列
- ALTER TABLE 之后给出要更改的表面。
- 所做更改的列表

```
mysql> ALTER TABLE Vendors
    -> ADD vend_phone CHAR(20);
Query OK, 0 rows affected (0.13 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

解释:给Vendors 表添加一个列，数据类型为CHAR

#### 删除列

```
mysql> ALTER TABLE Vendors
    -> DROP COLUMN vend_phone;
Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

注意: 使用ALTER TABLE 过程是无法撤销的，所以操作之前，需要进行备份。

#### 删除表

使用DROP TABLE来删除整个表

```	
mysql> DROP TABLE CustCopy;
Query OK, 0 rows affected (0.02 sec)

```

删除整个`CustCopy`表。DROPY无法删除带有关系规则的表。

#### 重命名表

使用RENAME语句来重命名表

```
mysql> RENAME TABLE Vendor TO Vendors;
Query OK, 0 rows affected (0.01 sec)
```





















# 关于MySQL基础知识

- 系统环境`MAC OS 10.10`
- MySQL版本，`5.7.9`

Mac 安装mysql很简单，官网下载安装包，双击安装就可以了，有几个地方需要注意

在Mac下用DMG包新安装mysql，在安装完毕最后一步会随机分配一个root密码，记住密码，安装完毕用root登录，但密码是过期状态，mysql默认情况下密码有效期是360天，需要重新改下，具体请看[Password Expiration Policy
](https://dev.mysql.com/doc/refman/5.7/en/password-expiration-policy.html).

基础的SQL语句主要来源于[SQL in 10 Minutes, Sams Teach Yourself](http://www.amazon.com/Minutes-Sams-Teach-Yourself-Edition/dp/0672336073) 这本书，这本书提供练习的表格，[表格内容下载](http://www.forta.com/books/0672336073/)

### 基础的概念

- 数据库(database): 保存有组织的数据库。

- 表(table) : 特定类型的数据结果化清单。

存储在表中的数据是一种类型的数据或者一个清单的数据

- 模式(schema) 关于数据库和表的布局及特性

- 列(colomn) 表中的一个字段，所以表的不由一个或者多个列组成。

理解列最后的办法，是想象成一个网络，网络中每一列存储着一个特定信息。

- 数据类型(datatype) 所容许的数据类型，每个类别都有相应的数据类型，用来限制该列中允许的类型

- 行(row)：表中的数据是按行存储的，把表想象成网络，垂直的列，水平为行。

- 主键(primary key): 表中每一行都应该有可以唯一标识自己的列，一列中唯一能够识别表中的每一行的值。在设计表是应该总是设计带有主键，设置为主键瞒着的条件为：
	- 任意两行都带有相同的值
	- 每个行都必须带有主键值
	- 主键列中的值不允许修改更新
	- 主键值不能重用。

### 样例表

创建一个练习用的样例表格，一共5张表，表的内容用途

- 管理供应商
- 管理产品目录
- 管理客户列表
- 录入客户订单

新建一个数据库 

```
mysql> CREATE DATABASE SQL_Learning;
Query OK, 1 row affected (0.01 sec)
```

新建`Vendors`表存储卖产品的供应商。

先切换到该数据库

```
mysql> USE SQL_Learning;
Database changed

mysql> CREATE TABLE Vendors
    -> (
    ->   vend_id      char(10) NOT NULL ,
    ->   vend_name    char(50) NOT NULL ,
    ->   vend_address char(50) NULL ,
    ->   vend_city    char(50) NULL ,
    ->   vend_state   char(5)  NULL ,
    ->   vend_zip     char(10) NULL ,
    ->   vend_country char(50) NULL
    -> );
Query OK, 0 rows affected (0.08 sec)
```
- NOT NULL表示值不能为空
- char(10) 保存固定长度的字符串，这里指定10个字符串
- vend_id 主键

Products 表包含产品的目录

```
mysql> CREATE TABLE Products
    -> (
    ->   prod_id    char(10)      NOT NULL ,
    ->   vend_id    char(10)      NOT NULL ,
    ->   prod_name  char(255)     NOT NULL ,
    ->   prod_price decimal(8,2)  NOT NULL ,
    ->   prod_desc  text          NULL
    -> );
Query OK, 0 rows affected (0.03 sec)
```

- prod_id 主键
- vend_id 外键，与供应商ID关联
- decimal(8,2) 作为字符串存储的 DOUBLE 类型，允许固定的小数点。

创建Customers 表

```
mysql> CREATE TABLE Customers
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
Query OK, 0 rows affected (0.05 sec)
```
- cust_id 主键

创建Orders表，一行一个产品

```
mysql> CREATE TABLE Orders
    -> (
    ->   order_num  int      NOT NULL ,
    ->   order_date datetime NOT NULL ,
    ->   cust_id    char(10) NOT NULL
    -> );
Query OK, 0 rows affected (0.04 sec)
```

- order_num 主键
- cust_id 外键，关联`Customers ID`

OrderItems表 存储每个订单的实际物品。

```
mysql> CREATE TABLE OrderItems
    -> (
    ->   order_num  int          NOT NULL ,
    ->   order_item int          NOT NULL ,
    ->   prod_id    char(10)     NOT NULL ,
    ->   quantity   int          NOT NULL ,
    ->   item_price decimal(8,2) NOT NULL
    -> );
Query OK, 0 rows affected (0.02 sec)
```

- order\_num 订单号，关联到Orders 表的order_num
- order\_item 订单物品号，
- prod\_id 产品ID
- quantity 产品数量
- item\_price 产品的价格

创建`primary key` 主键

```
ALTER TABLE Customers ADD PRIMARY KEY (cust_id);
ALTER TABLE OrderItems ADD PRIMARY KEY (order_num, order_item);
ALTER TABLE Orders ADD PRIMARY KEY (order_num);
ALTER TABLE Products ADD PRIMARY KEY (prod_id);
ALTER TABLE Vendors ADD PRIMARY KEY (vend_id);
```

创建`foreign key`外键，指向另一个表`PRIMARY KEY`主键

```
ALTER TABLE OrderItems ADD CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_num) REFERENCES Orders (order_num);
```

- 把`OrderItems` 表中的`order_num`关联到`Orders`表中的`order_num`

```
ALTER TABLE OrderItems ADD CONSTRAINT FK_OrderItems_Products FOREIGN KEY (prod_id) REFERENCES Products (prod_id);
```

- 把OrderItems 表中的`prod_id`关联到`Products` 表中的`prod_id`

```
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);
```

- 把Orders 表中的cust_id 关联到Customers 表中的cust_id

```
ALTER TABLE Products ADD CONSTRAINT FK_Products_Vendors FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id);
```

- 把`Products` 表中的vend_id 关联到`Vendors`中的vend_id
```

表插入表数据直接下载表格的数据，一个表一个表批量插入就行。

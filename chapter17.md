## 使用视图

如果利用视图来简化执行SQL语句某些操作。

### 视图

视图是虚拟表，只是在使用时动态检索数据查询。

#### 为什么使用视图函数

- 重用SQL语句
- 简化复杂的SQL操作，方便重用
- 使用表的组成部分而不是全部
- 包含数据，可以给用于提高表的特定访问权限，而不是整个。
- 更改数据格式和表示，当需要返回跟底层表的表示格式不同的数据。

创建视图函数后，可以用与表相同的方式利用他们，可以进行SELECT执行操作，过滤，排序数据
将视图结合其他的视图或表，甚至能添加和更新数据。

注意: 知道视图仅仅是用来查看跟存储在别处的数据，本身不包含数据，数据是从其他表检索出来，
更改与添加表中的数据时，视图将返回改变的数据。

#### 视图函数限制规则

- 表名必须唯一
- 创建视图函数没有限制数目
- 有足够的权限
- 可以利用其他视图中的数据，来查询构造一个新的视图。
- 视图不能索引，也不能关联默认值

### 创建视图

`CREATE VIEW` 语句来创建视图。删除视图用 `DROP VIEW viewname`;

```

mysql> CREATE VIEW ProductCustomers AS
    -> SELECT cust_name, cust_contact, prod_id
    -> FROM Customers, Orders, OrderItems
    -> WHERE Customers.cust_id = Orders.cust_id
    -> AND OrderItems.order_num = Orders.order_num;
Query OK, 0 rows affected (0.03 sec)

```

创建一个ProductCustomers的视图，联结三个表，返回已经订购任意产品的客户

```
mysql> SELECT * FROM ProductCustomers;
+---------------+--------------------+---------+
| cust_name     | cust_contact       | prod_id |
+---------------+--------------------+---------+
| Village Toys  | John Smith         | BR01    |
| Village Toys  | John Smith         | BR03    |
| Village Toys  | John Smith         | BNBG01  |
| Village Toys  | John Smith         | BNBG02  |
| Village Toys  | John Smith         | BNBG03  |
| Fun4All       | Jim Jones          | BR01    |
| Fun4All       | Jim Jones          | BR02    |
| Fun4All       | Jim Jones          | BR03    |
| Fun4All       | Denise L. Stephens | BR03    |
| Fun4All       | Denise L. Stephens | BNBG01  |
| Fun4All       | Denise L. Stephens | BNBG02  |
| Fun4All       | Denise L. Stephens | BNBG03  |
| Fun4All       | Denise L. Stephens | RGAN01  |
| The Toy Store | Kim Howard         | RGAN01  |
| The Toy Store | Kim Howard         | BR03    |
| The Toy Store | Kim Howard         | BNBG01  |
| The Toy Store | Kim Howard         | BNBG02  |
| The Toy Store | Kim Howard         | BNBG03  |
+---------------+--------------------+---------+
18 rows in set (0.01 sec)

```
检索 ProductCustomers表的数据

```

mysql> SELECT cust_name, cust_contact
    -> FROM ProductCustomers
    -> WHERE prod_id = 'RGAN01';
+---------------+--------------------+
| cust_name     | cust_contact       |
+---------------+--------------------+
| Fun4All       | Denise L. Stephens |
| The Toy Store | Kim Howard         |
+---------------+--------------------+
2 rows in set (0.00 sec)
```
解释: 用WHERE子句过滤实体中检索的特定数据。

### 用视图重新格式化检索出的数据

假设经常需要检索下面的语句，为了不用经常执行，把此语句转换为视图。

```
mysql> SELECT CONCAT(vend_name, ' (', vend_country, ')') AS vend_title FROM Vendors
    -> ORDER BY vend_name;
+-------------------------+
| vend_title              |
+-------------------------+
| Bear Emporium (USA)     |
| Bears R Us (USA)        |
| Doll House Inc. (USA)   |
| Fun and Games (England) |
| Furball Inc. (USA)      |
| Jouets et ours (France) |
+-------------------------+
6 rows in set (0.00 sec)
```

把上面的语句转成视图

```

mysql> CREATE VIEW VendorLocations AS SELECT CONCAT(vend_name, ' (', vend_country, ')') AS vend_title FROM Vendors ORDER BY vend_name;
Query OK, 0 rows affected (0.02 sec)
```

检索新生成的视图表

```
mysql> SELECT * FROM VendorLocations;
+-------------------------+
| vend_title              |
+-------------------------+
| Bear Emporium (USA)     |
| Bears R Us (USA)        |
| Doll House Inc. (USA)   |
| Fun and Games (England) |
| Furball Inc. (USA)      |
| Jouets et ours (France) |
+-------------------------+
6 rows in set (0.00 sec)

```

### 用视图过滤不想要的数据

定一个一个emaillist，需要过滤没有email的邮件地址的客户。

```
mysql> CREATE VIEW CustomerEMAIList AS
    -> SELECT cust_id, cust_name, cust_email
    -> FROM Customers
    -> WHERE cust_email IS NOT NULL;
Query OK, 0 rows affected (0.03 sec)
```

解释: 要WHERE 子句过滤没有电子邮箱的客户。

```
mysql> SELECT * FROM CustomerEMAIList;
+------------+--------------+-----------------------+
| cust_id    | cust_name    | cust_email            |
+------------+--------------+-----------------------+
| 1000000001 | Village Toys | sales@villagetoys.com |
| 1000000003 | Fun4All      | jjones@fun4all.com    |
| 1000000004 | Fun4All      | dstephens@fun4all.com |
| 1000000006 | Toy Land     | sam@toyland.com       |
+------------+--------------+-----------------------+
4 rows in set (0.01 sec)

```

### 使用视图计算字段

检索订单物品，计算价格

```
mysql> SELECT prod_id,
    -> quantity,
    -> item_price,
    -> quantity*item_price AS expaned_price
    -> FROM OrderItems
    -> WHERE order_num = 20008;
+---------+----------+------------+---------------+
| prod_id | quantity | item_price | expaned_price |
+---------+----------+------------+---------------+
| RGAN01  |        5 |       4.99 |         24.95 |
| BR03    |        5 |      11.99 |         59.95 |
| BNBG01  |       10 |       3.49 |         34.90 |
| BNBG02  |       10 |       3.49 |         34.90 |
| BNBG03  |       10 |       3.49 |         34.90 |
+---------+----------+------------+---------------+
5 rows in set (0.01 sec)
```

### 换成视图

```
mysql> CREATE VIEW OrderItemsExpandes AS
    -> SELECT order_num,
    -> prod_id,
    -> quantity,
    -> item_price,
    -> quantity*item_price AS expanded_price
    -> FROM OrderItems;
Query OK, 0 rows affected (0.01 sec)
```


























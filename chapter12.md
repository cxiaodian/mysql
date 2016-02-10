## 创建高级链接

### 使用表别名

- 目的在于缩短SQL语句
- 运行单条SELECT 语句中多次使用相同的表。

```
mysql> SELECT cust_name, cust_contact FROM Customers AS C, Orders AS O, OrderItems AS OI WHERE C.cust_id = O.cust_id AND OI.order_num = O.order_num AND prod_id = 'RGAN01';
+---------------+--------------------+
| cust_name     | cust_contact       |
+---------------+--------------------+
| Fun4All       | Denise L. Stephens |
| The Toy Store | Kim Howard         |
+---------------+--------------------+
2 rows in set (0.01 sec)
```

解释: FROM中的子句有3个表，分别设置别名 `Customers AS C`， `Orders AS O`，`OrderItems AS OI` 给予子句WHERE引用。

### 自联结


```
mysql> SELECT cust_id, cust_name, cust_contact
    -> FROM Customers
    -> WHERE cust_name = (SELECT cust_name
    -> FROM Customers
    -> WHERE cust_contact = 'Jim Jones');
+------------+-----------+--------------------+
| cust_id    | cust_name | cust_contact       |
+------------+-----------+--------------------+
| 1000000003 | Fun4All   | Jim Jones          |
| 1000000004 | Fun4All   | Denise L. Stephens |
+------------+-----------+--------------------+
2 rows in set (0.01 sec)
```

解释；括号里的SELECT做了一个简单的检索，返回公司的cust_name，给予括号外SELECT查询。

另一个种查询方式

```
mysql> SELECT c1.cust_id, c1.cust_name, c1.cust_contact
    -> FROM Customers AS c1, Customers AS c2
    -> WHERE c1.cust_name = c2.cust_name
    -> AND c2.cust_contact = 'Jim Jones';
+------------+-----------+--------------------+
| cust_id    | cust_name | cust_contact       |
+------------+-----------+--------------------+
| 1000000003 | Fun4All   | Jim Jones          |
| 1000000004 | Fun4All   | Denise L. Stephens |
+------------+-----------+--------------------+
2 rows in set (0.01 sec)
```

## 自然联结

通过对表使用通配符*，对所有其他的表列，使用明确的子集来完成。

```

mysql> SELECT C.*, O.order_num, O.order_date, OI.prod_id,
    -> OI.quantity, OI.item_price
    -> FROM Customers AS C, Orders AS O, OrderItems AS OI
    -> WHERE C.cust_id = O.cust_id
    -> AND OI.order_num = O.order_num
    -> AND prod_id = 'RGAN01';
+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+-----------+---------------------+---------+----------+------------+
| cust_id    | cust_name     | cust_address        | cust_city | cust_state | cust_zip | cust_country | cust_contact       | cust_email            | order_num | order_date          | prod_id | quantity | item_price |
+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+-----------+---------------------+---------+----------+------------+
| 1000000004 | Fun4All       | 829 Riverside Drive | Phoenix   | AZ         | 88888    | USA          | Denise L. Stephens | dstephens@fun4all.com |     20007 | 2004-01-30 00:00:00 | RGAN01  |       50 |       4.49 |
| 1000000005 | The Toy Store | 4545 53rd Street    | Chicago   | IL         | 54545    | USA          | Kim Howard         | NULL                  |     20008 | 2004-02-03 00:00:00 | RGAN01  |        5 |       4.99 |
+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+-----------+---------------------+---------+----------+------------+
2 rows in set (0.01 sec)

```

解释: *通配符只对第一个表使用，列出其他明确的列。

### 外部联结

联结包含那些在相关表中没有关联的行的行。

- 对每个客户下了多少订单进行计算，包括未下单的客户
- 列出所有产品以及订购数量，包含没有人订购的产品
- 计算平均销售规模，包括没下单的客户。

检索所有客户及订单，内部联结

```
mysql> SELECT Customers.cust_id, Orders.order_num
    -> FROM Customers INNER JOIN Orders
    -> ON Customers.cust_id = Orders.cust_id;
+------------+-----------+
| cust_id    | order_num |
+------------+-----------+
| 1000000001 |     20005 |
| 1000000001 |     20009 |
| 1000000003 |     20006 |
| 1000000004 |     20007 |
| 1000000005 |     20008 |
+------------+-----------+
5 rows in set (0.00 sec)
```

外部联结，检索所有客户，包含那些没有订单的客户。

```
mysql> SELECT Customers.cust_id, Orders.order_num
    -> FROM Customers LEFT OUTER JOIN Orders
    -> ON Customers.cust_id = Orders.cust_id;
+------------+-----------+
| cust_id    | order_num |
+------------+-----------+
| 1000000001 |     20005 |
| 1000000001 |     20009 |
| 1000000002 |      NULL |
| 1000000003 |     20006 |
| 1000000004 |     20007 |
| 1000000005 |     20008 |
+------------+-----------+
6 rows in set (0.00 sec)
```
OUTER JOIN 指定联结类型，与内部联结关联两个表中不同的是，外部联结还包含没有关联的行，用
RIGHT与LEFT关键字指定包含其所有行的表是左边还是右边。

### 使用带聚集函数的联结

检索所有客户及每个客户所下订单

```
mysql> SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
    -> FROM Customers INNER JOIN Orders
    -> ON Customers.cust_id = Orders.cust_id
    -> GROUP BY Customers.cust_id;
+------------+---------+
| cust_id    | num_ord |
+------------+---------+
| 1000000001 |       2 |
| 1000000003 |       1 |
| 1000000004 |       1 |
| 1000000005 |       1 |
+------------+---------+
4 rows in set (0.02 sec)
```

解释: `INNER JOIN`联结`Customers `跟 `Orders `表，GROUP BY子句按客户分组数据，

`COUNT(Orders.order_num)` 计算客户订单计数。

### 使用联结条件

- 主要联结类型，一般使用内部联结
- 不同的DBMS联结方式不同。
- 保证使用正确的联结条件
- 使用多个联结，先分别测试每个联结。


















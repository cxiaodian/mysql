## 使用子查询

关于子查询使用

### 利用子查询进行过滤

列出够物品RGAN01的所有客户。

- 检索包含物品RGAN01的所有订单编号。
- 检索具有前一步骤列出的订单编号所有客户ID。
- 检索前一步骤返回的所有客户ID的客户信息。

```
mysql> SELECT order_num
    -> FROM OrderItems
    -> WHERE prod_id = 'RGAN01';
+-----------+
| order_num |
+-----------+
|     20007 |
|     20008 |
+-----------+
2 rows in set (0.00 sec)
```

解释: 列出所有RGAN01订单物品

```
mysql> SELECT cust_id
    -> FROM Orders
    -> WHERE order_num IN (20007, 20008);
+------------+
| cust_id    |
+------------+
| 1000000004 |
| 1000000005 |
+------------+
2 rows in set (0.00 sec)
```
把上面两个查询组合成子查询

```

mysql> SELECT cust_id
    -> FROM Orders
    -> WHERE order_num IN (SELECT order_num
    -> FROM OrderItems
    -> WHERE prod_id = 'RGAN01');
+------------+
| cust_id    |
+------------+
| 1000000004 |
| 1000000005 |
+------------+
2 rows in set (0.00 sec)

```

- 子查询是从内向外处理
- 先执行 `SELECT order_num FROM OrderItems WHERE prod_id = 'RGAN01'`
- 把返回的订单号，20007，20008两个值以IN操作符用逗号格式传递给外部查询，
- 再用`SELECT cust_id FROM orders WHERE order_num IN (20007,20008)`

检索客户的ID

```
mysql> SELECT cust_name, cust_contact
    -> FROM Customers
    -> WHERE cust_id IN (SELECT cust_id
    -> FROM Orders
    -> WHERE order_num IN (SELECT order_num
    -> FROM OrderItems
    -> WHERE prod_id = 'RGAN01'));
+---------------+--------------------+
| cust_name     | cust_contact       |
+---------------+--------------------+
| Fun4All       | Denise L. Stephens |
| The Toy Store | Kim Howard         |
+---------------+--------------------+
2 rows in set (0.01 sec)
```
- 解释:
	- `SELECT order_num FROM OrderItems WHERE prod_id = 'RGAN01'` 查询返回订单列表
	- 把上面的查询结果，给予 `SELECT cust_id FROM Orders`， 返回客户ID
	- 拿到返回的客户ID给予外层WHERE子句查询。

注意: 子查询只能返回单个列。


### 作为计算字段使用子查询

例子：计算Customers中每个客户订单总数。
- 从Customers 表中检索客户列表
- 对检索出来的每个客户，统计其在Orders表中的订单数目。

单个客户查询

```
mysql> SELECT COUNT(*) AS orders
    -> FROM Orders
    -> WHERE cust_id = '1000000001';
+--------+
| orders |
+--------+
|      2 |
+--------+
1 row in set (0.00 sec)
```
对每个客户执行COUNT(*) 

```
mysql> SELECT cust_name,
    -> cust_state,
    -> (SELECT COUNT(*)
    -> FROM Orders
    -> WHERE Orders.cust_id = Customers.cust_id) AS
    -> orders
    -> FROM Customers
    -> ORDER BY cust_name;
+---------------+------------+--------+
| cust_name     | cust_state | orders |
+---------------+------------+--------+
| Fun4All       | IN         |      1 |
| Fun4All       | AZ         |      1 |
| Kids Place    | OH         |      0 |
| The Toy Store | IL         |      1 |
| Village Toys  | MI         |      2 |
+---------------+------------+--------+
5 rows in set (0.01 sec)
```

解释: 对Customers表返回三列，`cust_name`, `cust_state`,`orders`.
orders 是计算字段，由 `(SELECT COUNT(*) FROM Orders WHERE Orders.cust_id = Customers.cust_id)` 建立。每检索一个客户，执行一次计算，

`Orders.cust_id = Customers.cust_id ` , 其中的句号，表示指定限定表名跟列，如果不具体指定表名，列名，将返回Orders 表中的订单总数。如下:

```
mysql> SELECT cust_name,
    -> cust_state,
    -> (SELECT COUNT(*)
    -> FROM Orders
    -> WHERE cust_id = cust_id) AS orders
    -> FROM Customers
    -> ORDER BY cust_name;
+---------------+------------+--------+
| cust_name     | cust_state | orders |
+---------------+------------+--------+
| Fun4All       | IN         |      5 |
| Fun4All       | AZ         |      5 |
| Kids Place    | OH         |      5 |
| The Toy Store | IL         |      5 |
| Village Toys  | MI         |      5 |
+---------------+------------+--------+
5 rows in set (0.00 sec)
```

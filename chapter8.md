## 汇总数据

关于如何利用函数汇总表的数据。

### 聚集函数

- 确定表中的行数
- 获得表中行组的和
- 找出表列(所有行，特定行)的最大，最小，平均值。

上面的例子需要对表中的数据汇总，而不是实际数据本身，所以可以不需要返回时间数据，浪费资源

#### 聚集函数(aggregate function)

运行在行组上，计算和返回单个值的函数。


- AVG(): 返回所有列或者某个列平均值。

计算表中的行数并计算特定列值之和，求得改列的平均值。

```
mysql> SELECT AVG(prod_price) AS avg_price
    -> FROM Products;
+-----------+
| avg_price |
+-----------+
|  6.823333 |
+-----------+
1 row in set (0.01 sec)
```

解释: 计算Products表中所以产品的平均价格。

计算特定行的平均值，

```
mysql> SELECT AVG(prod_price) AS avg_price
    -> FROM Products
    -> WHERE vend_id = 'DLL01';
+-----------+
| avg_price |
+-----------+
|  3.865000 |
+-----------+
1 row in set (0.01 sec)
```

解释: WHERE 子句过滤出DELL01平均值，并返回该供应商产品的平均值。


- COUNT()函数计算表中行的数目或符合特定条件的涵数目。
	- 忽略表列中包含的空值(NULL)与非空值，对表中数目进行计算。
	- 使用COUNT(column) 对特定列中具有值的行进行计算，忽略NULL值。

```	
mysql> SELECT COUNT(*) AS num_cust
    -> FROM Customers;
+----------+
| num_cust |
+----------+
|        5 |
+----------+
1 row in set (0.01 sec)

```

返回custoemrs 中客户的总数，不管行中各列的数值。

```
mysql> SELECT COUNT(cust_email) AS num_cust
    -> FROM Customers;
+----------+
| num_cust |
+----------+
|        3 |
+----------+
1 row in set (0.00 sec)
```

值返回有email地址的客户计数，结果为3，表述只有3个客户有电子邮件地址。


MAX()返回指定的列中最大的值 

```
mysql> SELECT MAX(prod_price) AS max_price
    -> FROM Products;
+-----------+
| max_price |
+-----------+
|     11.99 |
+-----------+
1 row in set (0.01 sec)
```

解释: 返回Products表中最贵的物品价格。


- MIN() 返回最小值

```
mysql> SELECT MIN(prod_price) AS min_price
    -> FROM Products;
+-----------+
| min_price |
+-----------+
|      3.49 |
+-----------+
1 row in set (0.00 sec)

```

- SUM()返回指定的列值的总和

```

mysql> SELECT SUM(quantity) AS items_ordered
    -> FROM OrderItems
    -> WHERE order_num = 20005;
+---------------+
| items_ordered |
+---------------+
|           200 |
+---------------+
1 row in set (0.01 sec)

```

解释：返回计算quantity 值之和，WHERE子句限制值统计某个订单的值。

用SUM()组合计算值

```
mysql> SELECT SUM(item_price*quantity) AS total_price
    -> FROM OrderItems
    -> WHERE order_num = 20005;
+-------------+
| total_price |
+-------------+
|     1648.00 |
+-------------+
1 row in set (0.01 sec)

```

解释: 合计所以订单 item_price价格 乘以quantity数量之和的总数，WHERE子句某个订单物品。


### 聚集不同值

- 对所有的行执行计算，指定ALL参数或者不改参数(默认是ALL行为)
- 只包含不同的值，指定`DISTINCT`参数

```
mysql> SELECT AVG(DISTINCT prod_price) AS avg_price
    -> FROM Products
    -> WHERE vend_id = 'DLL01';
+-----------+
| avg_price |
+-----------+
|  4.240000 |
+-----------+
1 row in set (0.02 sec)
```

解释:与上一个例子不同的是，排除prod_price 中相同的值，只计算不同的值，数量少了
所以平均值高了。


### 组合聚集函数

用SELECT 来组合聚集函数。

```
mysql> SELECT COUNT(*) AS num_items,
    -> MIN(prod_price) AS price_min,
    -> MAX(prod_price) AS price_max,
    -> AVG(prod_price) AS price_avg
    -> FROM Products;
+-----------+-----------+-----------+-----------+
| num_items | price_min | price_max | price_avg |
+-----------+-----------+-----------+-----------+
|         9 |      3.49 |     11.99 |  6.823333 |
+-----------+-----------+-----------+-----------+
1 row in set (0.00 sec)
```


- 聚集函数用来总汇数据， SQL支持5个聚集函数，计算速度比在客户端快多。

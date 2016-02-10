## 分组数据

用GROUP BY 跟 HAVING子句，分组数据来汇总表内容子集。

### 创建分组

分组在SELECT语句的GROUP BY子句中建立。

```
mysql> SELECT vend_id, COUNT(*) AS num_prods
    -> FROM Products
    -> GROUP BY vend_id;
+---------+-----------+
| vend_id | num_prods |
+---------+-----------+
| BRS01   |         3 |
| DLL01   |         4 |
| FNG01   |         2 |
+---------+-----------+
3 rows in set (0.01 sec)
```

解释: `SELECT`语句指定两个列，`vend_id` 包含供应商ID，为`num_prods` 计算字段结果，
`GROUP BY` 子句指示 vend_id 排序并分组数据，

GROUP BY子句重要规则:

- 包含任意数目的列，
- 如果在GROUP BY 子句中套入分组，数据将会最后规定的分组上进行总汇。
- GROUP BY 子句中列出的没列都必须是检索的列，有效的表达式，不能聚集函数。
- 大多数SQL不允许GROUP BY 带有长度可变的数据类型(文本，备注型字段)
- 除聚集计算语句外，SELECT 语句中，每个列都必须在GROUP BY子句中给出。
- 如果分组带有NULL值，将作为一个分组返回，如果多个将成一组。
- GROUP BY 子句必须出现在WHERE子句之后，

### 过滤分组

过滤分组规定包含哪些分组，排除哪些分组，用`HAVING`子句，与WHERE子句类似，唯一差别的是
WHERE用来过滤行，HAVING过滤分组。也可以说HAVING在数据分组后过滤，WHERE在数据分组前进行过滤。

HAVING 支持所有WHERE的操作符。

```
mysql> SELECT cust_id, COUNT(*) AS orders
    -> FROM  Orders
    -> GROUP BY cust_id
    -> HAVING COUNT(*) >= 2;
+------------+--------+
| cust_id    | orders |
+------------+--------+
| 1000000001 |      2 |
+------------+--------+
1 row in set (0.00 sec)
```

解释: 过滤出两个以上订单的分组

### WHERE与HAVING子句结合使用

```
mysql> SELECT vend_id, COUNT(*) AS num_prods
    -> FROM Products
    -> WHERE prod_price >= 4
    -> GROUP BY vend_id
    -> HAVING COUNT(*) >= 2;
+---------+-----------+
| vend_id | num_prods |
+---------+-----------+
| BRS01   |         3 |
| FNG01   |         2 |
+---------+-----------+
2 rows in set (0.00 sec)
```

解释: 第一行使用聚集函数，WHERE子句过滤除所有`prod_price`少于4的行，按vend_id分组，HAVING
子句过滤计数2以上分组。

去掉WHERE 过滤

```
mysql> SELECT vend_id, COUNT(*) AS num_prods FROM Products  GROUP BY vend_id HAVING COUNT(*) >= 2;
+---------+-----------+
| vend_id | num_prods |
+---------+-----------+
| BRS01   |         3 |
| DLL01   |         4 |
| FNG01   |         2 |
+---------+-----------+
3 rows in set (0.01 sec)
```

过滤出销售产品在4个，且价格是4一下的。


### 分组和排序

GROUP BY 与 ORDER BY区别

- GROUP BY 
	- 排序产生的输出
	- 任意列都可以使用
	- 可以选择是否与聚集函数一起使用

- ORDER BY 
	- 分组行，输出可能不是分组循序
	- 只可能使用选择列或表达式，且必须使用每个列表达式
	- 如果与聚集函数一起用，则必须使用


注意: 不用依赖于GROUP BY 排序，应该使用GROUP BY 时，也该处ORDER BY子句。

检索除3个或以上的物品订单号与订购物品数目：

```
mysql> SELECT order_num, COUNT(*) AS items
    -> FROM OrderItems
    -> GROUP BY order_num
    -> HAVING COUNT(*) >= 3;
+-----------+-------+
| order_num | items |
+-----------+-------+
|     20006 |     3 |
|     20007 |     5 |
|     20008 |     5 |
|     20009 |     3 |
+-----------+-------+
4 rows in set (0.00 sec)
```

按订购物品数目排序输出。

```
mysql> SELECT order_num, COUNT(*) AS items
    -> FROM OrderItems
    -> GROUP BY order_num
    -> HAVING COUNT(*) >=3
    -> ORDER BY items, order_num;
+-----------+-------+
| order_num | items |
+-----------+-------+
|     20006 |     3 |
|     20009 |     3 |
|     20007 |     5 |
|     20008 |     5 |
+-----------+-------+
4 rows in set (0.00 sec)
```

解释: GROUP BY 子句用来分组数据， COUNT(*)函数返回订单中物品数目，
HAVING 子句过滤数据，返回3个或3个以上的物品订单，ORDER BY最后排序输出。

### SELECT子句顺序

子句       |  说明    |  是否必须使用  |
----------|----------|------------------------|
SELECT       | 要返回的列或表达式     | 是                  |
FROM       |  从中检索数据           | 仅从 表中选择数据时使用|
WHERE      |  行级过滤              | 否        |
GROUP BY    |   分组说明            | 仅按组计算聚集使用 |
HAVING      |   组级过滤            | 否               |
ORDER BY    | 输出排序顺序           |   否        |




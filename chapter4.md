## 高级数据过滤


#### 操作符(operator)

用来改变WHERE子句中的子句关键字，也成逻辑操作符。

- AND操作符

通过使用AND来给WHERE子句附加条件。

索引出供应商'DLL01'制造且价格小于等于4美金的所有产品名称和价格。

```

mysql> SELECT prod_id, prod_price, prod_name
    -> FROM Products
    -> WHERE vend_id = 'DLL01' AND prod_price <= 4;
+---------+------------+---------------------+
| prod_id | prod_price | prod_name           |
+---------+------------+---------------------+
| BNBG01  |       3.49 | Fish bean bag toy   |
| BNBG02  |       3.49 | Bird bean bag toy   |
| BNBG03  |       3.49 | Rabbit bean bag toy |
+---------+------------+---------------------+
3 rows in set (0.02 sec)

```

解释: SLELECT 语句中的子句WHERE包含两个条件，供应商指定DLL01,价格高于4美金，不显示，
如果价格小于 4美金，都不术语DELL01的，也不显示。

#### OR操作符

检索匹配任意条件。

```
mysql> SELECT prod_name, prod_price
    -> FROM Products
    -> WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';
+---------------------+------------+
| prod_name           | prod_price |
+---------------------+------------+
| Fish bean bag toy   |       3.49 |
| Bird bean bag toy   |       3.49 |
| Rabbit bean bag toy |       3.49 |
| 8 inch teddy bear   |       5.99 |
| 12 inch teddy bear  |       8.99 |
| 18 inch teddy bear  |      11.99 |
| Raggedy Ann         |       4.99 |
+---------------------+------------+
7 rows in set (0.01 sec)
```

解释: 索引供应商所有产品的产品名和价格，并匹配任意条件 DLL01或者BRS01.


#### 计算次序

WHERE 运行AND 与 RO 结合，进行复杂操作，和高级过滤。

检索10美金以上，并且由DLL10或者BRSO1制造。

```
mysql> SELECT prod_name, prod_price FROM Products WHERE vend_id = 'DLL01' OR vend_id = 'BRS01' AND prod_price >= 10;
+---------------------+------------+
| prod_name           | prod_price |
+---------------------+------------+
| Fish bean bag toy   |       3.49 |
| Bird bean bag toy   |       3.49 |
| Rabbit bean bag toy |       3.49 |
| 18 inch teddy bear  |      11.99 |
| Raggedy Ann         |       4.99 |
+---------------------+------------+
5 rows in set (0.00 sec)

```

返回的价格带有10美金一下的，`原因是AND有优先级`，SQL在处理 OR前，先处理了AND,直接检索BRS01,或者DLL01，而忽略了价格。

解决的方法是用 园括号进行分组操作。

```
mysql> SELECT prod_name, prod_price
    -> FROM Products
    -> WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01')
    -> AND prod_price >= 10;
+--------------------+------------+
| prod_name          | prod_price |
+--------------------+------------+
| 18 inch teddy bear |      11.99 |
+--------------------+------------+
1 row in set (0.01 sec)

```
()圆括号具有比AND，RO更高的操作计算顺序。

注意: 使用AND 和OR操作WHERE句子，都应该用圆括号明确分组操作。

#### IN 操作符

IN操作符用来指定范围，范围中的每一条，都进行匹配。IN取值规律，由逗号分割，全部放置括号中。

```
mysql> SELECT prod_name, prod_price
    -> FROM Products
    -> WHERE vend_id IN ('DLL01', 'BRS01')
    -> ORDER BY prod_name;
+---------------------+------------+
| prod_name           | prod_price |
+---------------------+------------+
| 12 inch teddy bear  |       8.99 |
| 18 inch teddy bear  |      11.99 |
| 8 inch teddy bear   |       5.99 |
| Bird bean bag toy   |       3.49 |
| Fish bean bag toy   |       3.49 |
| Rabbit bean bag toy |       3.49 |
| Raggedy Ann         |       4.99 |
+---------------------+------------+
7 rows in set (0.01 sec)

```
解释: 用SELECT检索，DLL01和BRS01制造的所有产品，IN操作符后跟由逗号分割的合法值清单。

IN 相当与完成了OR相同的功能，下面的结果与上面输出结果一样

```
mysql> SELECT prod_name, prod_price
    -> FROM Products
    -> WHERE vend_id = 'DLL01' OR vend_id = 'BRS01'
    -> ORDER BY prod_name;
+---------------------+------------+
| prod_name           | prod_price |
+---------------------+------------+
| 12 inch teddy bear  |       8.99 |
| 18 inch teddy bear  |      11.99 |
| 8 inch teddy bear   |       5.99 |
| Bird bean bag toy   |       3.49 |
| Fish bean bag toy   |       3.49 |
| Rabbit bean bag toy |       3.49 |
| Raggedy Ann         |       4.99 |
+---------------------+------------+
7 rows in set (0.00 sec)
```

- 使用IN的优点：
	- 语法清晰，特别是语法较长时
	- 操作符少，计算次序容易管理
	- IN比OR执行速度快
	- 最大的优点，可以包含其他SELECT语句，能够更加动态的建立WHERE子句。

#### NOT操作符

NOT操作符总是与其他操作符一起使用，用在要过滤的前面。

```
mysql> SELECT vend_id, prod_name FROM Products WHERE NOT vend_id = 'DLL01' ORDER BY prod_name;
+---------+--------------------+
| vend_id | prod_name          |
+---------+--------------------+
| BRS01   | 12 inch teddy bear |
| BRS01   | 18 inch teddy bear |
| BRS01   | 8 inch teddy bear  |
| FNG01   | King doll          |
| FNG01   | Queen doll         |
+---------+--------------------+
5 rows in set (0.00 sec)
```
列出不带有DLL01之外的所有产品。






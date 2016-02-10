## 用通配符进行过滤

利用通配符进行复杂的数据操作。


#### LIKE 与 REGEXP 操作符

当需要搜索产品文本中包含某个特定关键字的所有产品，使用通配符来创建比较特定的数据搜索模式。

- 通配符(wildcard) 用来匹配值的一部分特殊字符。

- 搜索模式(search pattern) 由字母值，通配符两租组合构成的搜索条件。

通配符是SQL的WHERE子句中的特殊含义字符，子句中使用通配符必须使用LIKE操作符。

#### 百分号%通配符

表示任何符合出现任意次数。

```
mysql> SELECT prod_id, prod_name
    -> FROM Products
    -> WHERE prod_name LIKE 'Fish%';
+---------+-------------------+
| prod_id | prod_name         |
+---------+-------------------+
| BNBG01  | Fish bean bag toy |
+---------+-------------------+
1 row in set (0.01 sec)

```

检索以Fish 开头的词汇，Fish之后任意词汇，区分大小写。

```
mysql> SELECT prod_id, prod_name
    -> FROM Products
    -> WHERE prod_name LIKE '%bean bag%';
+---------+---------------------+
| prod_id | prod_name           |
+---------+---------------------+
| BNBG01  | Fish bean bag toy   |
| BNBG02  | Bird bean bag toy   |
| BNBG03  | Rabbit bean bag toy |
+---------+---------------------+
3 rows in set (0.00 sec)
```

匹配任意位置包含 bean bag的值

```
mysql> SELECT prod_name
    -> FROM Products
    -> WHERE prod_name LIKE 'F%y';
+-------------------+
| prod_name         |
+-------------------+
| Fish bean bag toy |
+-------------------+
1 row in set (0.00 sec)
```

匹配F开头，y结尾的所以产品

```
mysql> SELECT prod_name
    -> FROM Products
    -> WHERE prod_name LIKE 'F%y';
+-------------------+
| prod_name         |
+-------------------+
| Fish bean bag toy |
+-------------------+
1 row in set (0.00 sec)

```

#### 下划线 `_` 通配符

下划线与%不同的是匹配单个字符，而不是多个字符。

```
mysql> SELECT prod_id, prod_name
    -> FROM Products
    -> WHERE prod_name LIKE '_ inch teddy bear';
+---------+-------------------+
| prod_id | prod_name         |
+---------+-------------------+
| BR01    | 8 inch teddy bear |
+---------+-------------------+
1 row in set (0.00 sec)

```

一个_匹配一个字符串。

#### 方括号[]通配符

匹配任意带有JM的字符串的列。

```
mysql> SELECT cust_contact FROM Customers WHERE cust_contact REGEXP '[JM]' ORDER BY cust_contact;
+----------------+
| cust_contact   |
+----------------+
| Jim Jones      |
| John Smith     |
| Kim Howard     |
| Michelle Green |
+----------------+
4 rows in set (0.00 sec)
```
匹配开头为J的列

```
mysql> SELECT cust_contact  FROM Customers WHERE cust_contact REGEXP '[J%]' ORDER BY cust_contact;
+--------------+
| cust_contact |
+--------------+
| Jim Jones    |
| John Smith   |
+--------------+
2 rows in set (0.01 sec)
```

#### 通配符技巧

- 其他操作如果能达到相同的效果，就不要用通配符。
- 使用通配符尽量，缩小检索范围。
- 主要通配符的位置


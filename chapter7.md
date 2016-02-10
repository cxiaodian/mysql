
## 使用数据处理函数

关于函数使用，与带来的问题。

### 函数

函数主要给数据提供处理与转换方便。

大多数SQL实现的函数

- 用于处理文本串(删除，充值，大小写转换)
- 用于在数值的数据上进行算术(返回绝对值，代数运算)操作。
- 用于处理日期时间值并从这些值中提取特定成份。
- 返回DBMS正使用的特殊信息(用户登录信息)。


### 文本处理函数

使用UPPER()函数来转换大小写。

```
mysql> SELECT vend_name, UPPER(vend_name) AS
    -> vend_name_upcase
    -> FROM Vendors
    -> ORDER BY vend_name;
+-----------------+------------------+
| vend_name       | vend_name_upcase |
+-----------------+------------------+
| Bear Emporium   | BEAR EMPORIUM    |
| Bears R Us      | BEARS R US       |
| Doll House Inc. | DOLL HOUSE INC.  |
| Fun and Games   | FUN AND GAMES    |
| Furball Inc.    | FURBALL INC.     |
| Jouets et ours  | JOUETS ET OURS   |
+-----------------+------------------+
6 rows in set (0.01 sec)
```

解释：vend_name 列出两次，一次储存值，一次将文本转换成大写。

常用处理文本函数

- LENGTH() 返回串长度。

```
mysql> SELECT vend_name, LENGTH(vend_name) AS vend_name_length
    -> FROM Vendors
    -> ORDER BY vend_name;
+-----------------+------------------+
| vend_name       | vend_name_length |
+-----------------+------------------+
| Bear Emporium   |               13 |
| Bears R Us      |               10 |
| Doll House Inc. |               15 |
| Fun and Games   |               13 |
| Furball Inc.    |               12 |
| Jouets et ours  |               14 |
+-----------------+------------------+
6 rows in set (0.01 sec)

```
- LOWER() 转换小写

```
mysql> SELECT vend_name, LOWER(vend_name)
    -> AS vend_name_lower
    -> FROM Vendors
    -> ORDER BY vend_name;
+-----------------+-----------------+
| vend_name       | vend_name_lower |
+-----------------+-----------------+
| Bear Emporium   | bear emporium   |
| Bears R Us      | bears r us      |
| Doll House Inc. | doll house inc. |
| Fun and Games   | fun and games   |
| Furball Inc.    | furball inc.    |
| Jouets et ours  | jouets et ours  |
+-----------------+-----------------+
6 rows in set (0.00 sec)

```

- 返回串中SOUNDEX值，意思是建任何文本串转为表述其语言表述的字母数字模式的算法。

```
mysql> SELECT vend_name, SOUNDEX(vend_name)
    -> AS vend_name_soundex
    -> FROM Vendors
    -> ORDER BY vend_name;
+-----------------+-------------------+
| vend_name       | vend_name_soundex |
+-----------------+-------------------+
| Bear Emporium   | B65165            |
| Bears R Us      | B6262             |
| Doll House Inc. | D4252             |
| Fun and Games   | F53252            |
| Furball Inc.    | F61452            |
| Jouets et ours  | J32362            |
+-----------------+-------------------+
```
例子：

Customers 表有一个名为Kids Place,顾客为Michael Green, 通过Michelle Green 类似发音来找到。

```
mysql> SELECT cust_name, cust_contact
    -> FROM Customers
    -> WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');
+------------+----------------+
| cust_name  | cust_contact   |
+------------+----------------+
| Kids Place | Michelle Green |
+------------+----------------+
1 row in set (0.03 sec)
```

SOUNDEX() 函数转换 Michael Green,ichelle Green值，两个发音类似，所以能检索出来。

### 日期和时间处理函数

存储为特殊的数据类型，主要用于排序过滤。

更多的时间函数[Date and Time Functions](http://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html)







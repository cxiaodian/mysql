## 第七章 创建计算字段

如何创建计算字段以及怎么样从应用程序中使用别名。

### 计算字段

存储在数据库表中的数据一般不是应用程序所需要的格式，例如：

- 显示两个信息，但不是在用一个表
- 不同列中，但程序需要把他们作为一个格式的字段检索出来
- 列数据是大小混合，但程序需要把所以数据按大写表示。
- 物品订单表存储的物品的价格和数量，但没有存储物品的总价，打印时，需要物品的总价格。
- 根据需要表的数据进行总数，平均数等计算。

上面的情况都我们需要从数据库中转换，计算格式化，而不是索引出来再进行计算。

计算字段是在运行时SELECT语句内创建的。


#### 字段(field)

与列(column)意思类似，经常相互转换使用，字段通常用在计算字段的链接上。

在SQL内完成转换和格式化，比在客户机应用程序内完成，处理数度更快。


### 拼接字段

例子:

vendors 表包含供应商id 跟 位置信息，现在需要生成一个供应商表，需要格式化名称，列出供应商位置。
此报表需要单个值，而表中的数据存储在，`vend_name`和`vend_country`中，还需要建`vend_country`括起来。

#### 拼接(concatenate)

将值联结到一起创建单个值。

在SQL中使用一个特使操作符来拼接两个列，+操作符用加号(+),两个竖杆(||)表示。

在mysql使用CONCAT()函数把项表链接起来，而|| 通等于操作符OR 而&&通等于AND操作符。

下面是在mysql中执行的结果:

```
mysql> SELECT CONCAT(vend_name, ' (', vend_country, ')')
    -> FROM Vendors
    -> ORDER BY vend_name;
+--------------------------------------------+
| CONCAT(vend_name, ' (', vend_country, ')') |
+--------------------------------------------+
| Bear Emporium (USA)                        |
| Bears R Us (USA)                           |
| Doll House Inc. (USA)                      |
| Fun and Games (England)                    |
| Furball Inc. (USA)                         |
| Jouets et ours (France)                    |
+--------------------------------------------+
6 rows in set (0.01 sec)

```

解释: 

- 存储vend_name列中的名字
- vend_name 隔一个空格加一个`(`圆括号
- 存储在vend_country列中的国家
- 包含一个闭圆括号串。

#### 别名

拼接的地址字段，没有一个名字，无法给客户机应用，所以需要字段`别名(alias)`,另一种叫法导出列`(derived column)`

别名可以用`AS关键字赋予`。

```
mysql> SELECT vend_name, CONCAT(vend_name, '(', vend_country, ')') AS vend_titel
    -> FROM Vendors
    -> ORDER BY vend_name;
+-----------------+------------------------+
| vend_name       | vend_titel             |
+-----------------+------------------------+
| Bear Emporium   | Bear Emporium(USA)     |
| Bears R Us      | Bears R Us(USA)        |
| Doll House Inc. | Doll House Inc.(USA)   |
| Fun and Games   | Fun and Games(England) |
| Furball Inc.    | Furball Inc.(USA)      |
| Jouets et ours  | Jouets et ours(France) |
+-----------------+------------------------+
6 rows in set (0.00 sec)
```

解释: 这样用AS` vend_title`指定拼接输出结果的列名，

别名的另一个用法，列重命名

```
mysql> SELECT vend_name  AS VEND_TEST FROM Vendors ;
+-----------------+
| VEND_TEST       |
+-----------------+
| Bear Emporium   |
| Bears R Us      |
| Doll House Inc. |
| Fun and Games   |
| Furball Inc.    |
| Jouets et ours  |
+-----------------+
6 rows in set (0.00 sec)

```
把`vend_name `输出重命名为`VEND_TEST`.


### 执行算术计算

用于检索出数据进行计算。

检索出Orders 表中包含收到的所有订单，OrderItems表包含每个订单中的各项物品，

```
mysql> SELECT prod_id, quantity, item_price FROM OrderItems WHERE order_num = 20008;
+---------+----------+------------+
| prod_id | quantity | item_price |
+---------+----------+------------+
| RGAN01  |        5 |       4.99 |
| BR03    |        5 |      11.99 |
| BNBG01  |       10 |       3.49 |
| BNBG02  |       10 |       3.49 |
| BNBG03  |       10 |       3.49 |
+---------+----------+------------+
5 rows in set (0.00 sec)BG03   |       3.49 |
+----------+------------+
5 rows in set (0.03 sec)

```
解释: 检索`prod_id` ，`quantity`， `item_price` 中 订单号码为20008的所有物品。

总汇出物品的价格，item_price 包含每项物品的单价，quantity包含数量。

```

mysql> SELECT prod_id, quantity, item_price,
    -> quantity*item_price AS expanded_price
    -> FROM OrderItems
    -> WHERE order_num = 20008;
+---------+----------+------------+----------------+
| prod_id | quantity | item_price | expanded_price |
+---------+----------+------------+----------------+
| RGAN01  |        5 |       4.99 |          24.95 |
| BR03    |        5 |      11.99 |          59.95 |
| BNBG01  |       10 |       3.49 |          34.90 |
| BNBG02  |       10 |       3.49 |          34.90 |
| BNBG03  |       10 |       3.49 |          34.90 |
+---------+----------+------------+----------------+
5 rows in set (0.01 sec)
```

解释：`quantity*item_price` ，单价乘以数量，输出`expanded_price`列为计算字段，客户端使用这个列，就跟使用其他列一样。

支持的运算字符 `+ 加，- 减，* 乘，除 /`

## 基础SQL语句-检索数据

### SELECT 语句

是最常用的SQL语句了，用来索引一个或者多个表信息。

- 关键字(keyword)

作为SQL组成部分的字段，关键字不能作为表或者列的名字。

使用SELECT索引数据，必须至少给出两条信息，`想要什么？ 从什么地方获取？`

### 检查单个列

	SELECT prod_name FROM Products; 

解释：使用SELECT 语句从 Products 表中检索一个名为prod_name 的列，FROM 关键字从指定的标名索引。

输出结果

```
mysql> SELECT prod_name FROM Products;
+---------------------+
| prod_name           |
+---------------------+
| Fish bean bag toy   |
| Bird bean bag toy   |
| Rabbit bean bag toy |
| 8 inch teddy bear   |
| 12 inch teddy bear  |
| 18 inch teddy bear  |
| Raggedy Ann         |
| King doll           |
| Queen doll          |
+---------------------+
9 rows in set (0.00 sec)

```
- SQL语句分成多好容易阅读与调试，如果语句较长
- SQL语句必须以(;)结束。
- SQL语句不区分大小写，除了表名，跟值以外，SQL关键字使用大写，便于阅读

### 索引多个列

与索引单列对比，唯一的不同是必须，在SELECT 关键字后给出多个列名，列名直接用`，` 隔开，最后一列不需要。

	 SELECT prod_id, prod_name, prod_price FROM Products;
	 
解释：使用SELECT 从表Products 中选择数据，指定3个列名，prod_id, prod_name, prod_price

输出：

```
mysql> SELECT prod_id, prod_name, prod_price FROM Products;
+---------+---------------------+------------+
| prod_id | prod_name           | prod_price |
+---------+---------------------+------------+
| BNBG01  | Fish bean bag toy   |       3.49 |
| BNBG02  | Bird bean bag toy   |       3.49 |
| BNBG03  | Rabbit bean bag toy |       3.49 |
| BR01    | 8 inch teddy bear   |       5.99 |
| BR02    | 12 inch teddy bear  |       8.99 |
| BR03    | 18 inch teddy bear  |      11.99 |
| RGAN01  | Raggedy Ann         |       4.99 |
| RYL01   | King doll           |       9.49 |
| RYL02   | Queen doll          |       9.49 |
+---------+---------------------+------------+
9 rows in set (0.01 sec)
```

### 检索所有列

	SELECT * FROM Products;

使用通配符 * 表示返回表中所有的列

```
mysql> SELECT * FROM Products;
+---------+---------+---------------------+------------+-----------------------------------------------------------------------+
| prod_id | vend_id | prod_name           | prod_price | prod_desc                                                             |
+---------+---------+---------------------+------------+-----------------------------------------------------------------------+
| BNBG01  | DLL01   | Fish bean bag toy   |       3.49 | Fish bean bag toy, complete with bean bag worms with which to feed it |
| BNBG02  | DLL01   | Bird bean bag toy   |       3.49 | Bird bean bag toy, eggs are not included                              |
| BNBG03  | DLL01   | Rabbit bean bag toy |       3.49 | Rabbit bean bag toy, comes with bean bag carrots                      |
| BR01    | BRS01   | 8 inch teddy bear   |       5.99 | 8 inch teddy bear, comes with cap and jacket                          |
| BR02    | BRS01   | 12 inch teddy bear  |       8.99 | 12 inch teddy bear, comes with cap and jacket                         |
| BR03    | BRS01   | 18 inch teddy bear  |      11.99 | 18 inch teddy bear, comes with cap and jacket                         |
| RGAN01  | DLL01   | Raggedy Ann         |       4.99 | 18 inch Raggedy Ann doll                                              |
| RYL01   | FNG01   | King doll           |       9.49 | 12 inch king doll with royal garments and crown                       |
| RYL02   | FNG01   | Queen doll          |       9.49 | 12 inch queen doll with royal garments and crown                      |
+---------+---------+---------------------+------------+-----------------------------------------------------------------------+
9 rows in set (0.00 sec)

```
- 除非需要表中每一列，或者不明确指定列，否则不要使用* 通配符。




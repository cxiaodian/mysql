##  联结表

什么是链接，为什么要使用，如何使用。

### 关系表


例子: 一个包含目录的数据库，其中每种类型物品占用一行，每种物品要存储的信息包括产品描述
和价格，以及生产该产品的供应商信息。

有一个供应商生产多种物品，何处存储供应商的信息(地址，电话等)，如何分开存储。

1. 同一个供应商存储的信息都是相同的，每种产品重复信息，浪费空间
2. 如果供应商信息改变，执行改一次。
3. 重复数据，难保证每次储存信息一致，不一致信息难管理，利用。

关系数据库设计:

- 避免相同数据出现多次
- 信息被分解成一种数据，一个表
- 各表通过某些常用值相互关联

上面的例子，设计两个表，一个存储供应商信息，一个存储产品信息。

- Vendors 表包含所有供应商信息，供应商的`primary key` 唯一的标识值`vend_id`。
- Products表只存储产品信息，与供应商的`primary key` `vend_id` 表关联，利用供应商的
ID从Vendors表中找出相应的供应商详细信息。

这样的设计刚好符合上面3点。

关系数据库优点`可伸缩性`(scale),能够适应不断增加的工作量。

### 使用联结的好处

分解多个表方便存储，方便处理，可伸缩性强。

使用链接可以用一条SELECT中关联多个表返回一组输出。

注意:在设计关系数据库，避免在另一个关系表中插入非法的ID，可以设置关系表中值，只出现合法的值

### 创建联结

链接多个表

```
mysql> SELECT vend_name, prod_name, prod_price
    -> FROM Vendors, Products
    -> WHERE Vendors.vend_id = Products.vend_id;
+-----------------+---------------------+------------+
| vend_name       | prod_name           | prod_price |
+-----------------+---------------------+------------+
| Bears R Us      | 8 inch teddy bear   |       5.99 |
| Bears R Us      | 12 inch teddy bear  |       8.99 |
| Bears R Us      | 18 inch teddy bear  |      11.99 |
| Doll House Inc. | Fish bean bag toy   |       3.49 |
| Doll House Inc. | Bird bean bag toy   |       3.49 |
| Doll House Inc. | Rabbit bean bag toy |       3.49 |
| Doll House Inc. | Raggedy Ann         |       4.99 |
| Fun and Games   | King doll           |       9.49 |
| Fun and Games   | Queen doll          |       9.49 |
+-----------------+---------------------+------------+
9 rows in set (0.00 sec)
```

解释:  

- `SELECT vend_name, prod_name, prod_price` 指定检索的列，`prod_name, prod_price` 在同一个表。`vend_name` 在另外一个表  
- From 指定联结两个表`Vendors, Products`  
- WHERE子句限定 `Vendors.vend_id = Products.vend_id` 完全限定名。  

### WHERE子句的重要

- 笛卡儿积(cartesian product) 由没有联结的条件表关系返回的结果，

保证所有联结都有WHERE子句，否则返回比的数据会比想要的数据多很多。

```

mysql> SELECT vend_name, prod_name, prod_price
    -> FROM Vendors, Products;
+-----------------+---------------------+------------+
| vend_name       | prod_name           | prod_price |
+-----------------+---------------------+------------+
| Bear Emporium   | Fish bean bag toy   |       3.49 |
| Bears R Us      | Fish bean bag toy   |       3.49 |
| Doll House Inc. | Fish bean bag toy   |       3.49 |
| Fun and Games   | Fish bean bag toy   |       3.49 |
| Furball Inc.    | Fish bean bag toy   |       3.49 |
| Jouets et ours  | Fish bean bag toy   |       3.49 |
| Bear Emporium   | Bird bean bag toy   |       3.49 |
| Bears R Us      | Bird bean bag toy   |       3.49 |
| Doll House Inc. | Bird bean bag toy   |       3.49 |
| Fun and Games   | Bird bean bag toy   |       3.49 |
| Furball Inc.    | Bird bean bag toy   |       3.49 |
| Jouets et ours  | Bird bean bag toy   |       3.49 |
| Bear Emporium   | Rabbit bean bag toy |       3.49 |
| Bears R Us      | Rabbit bean bag toy |       3.49 |
| Doll House Inc. | Rabbit bean bag toy |       3.49 |
| Fun and Games   | Rabbit bean bag toy |       3.49 |
| Furball Inc.    | Rabbit bean bag toy |       3.49 |
| Jouets et ours  | Rabbit bean bag toy |       3.49 |
| Bear Emporium   | 8 inch teddy bear   |       5.99 |
| Bears R Us      | 8 inch teddy bear   |       5.99 |
| Doll House Inc. | 8 inch teddy bear   |       5.99 |
| Fun and Games   | 8 inch teddy bear   |       5.99 |
| Furball Inc.    | 8 inch teddy bear   |       5.99 |
| Jouets et ours  | 8 inch teddy bear   |       5.99 |
| Bear Emporium   | 12 inch teddy bear  |       8.99 |
| Bears R Us      | 12 inch teddy bear  |       8.99 |
| Doll House Inc. | 12 inch teddy bear  |       8.99 |
| Fun and Games   | 12 inch teddy bear  |       8.99 |
| Furball Inc.    | 12 inch teddy bear  |       8.99 |
| Jouets et ours  | 12 inch teddy bear  |       8.99 |
| Bear Emporium   | 18 inch teddy bear  |      11.99 |
| Bears R Us      | 18 inch teddy bear  |      11.99 |
| Doll House Inc. | 18 inch teddy bear  |      11.99 |
| Fun and Games   | 18 inch teddy bear  |      11.99 |
| Furball Inc.    | 18 inch teddy bear  |      11.99 |
| Jouets et ours  | 18 inch teddy bear  |      11.99 |
| Bear Emporium   | Raggedy Ann         |       4.99 |
| Bears R Us      | Raggedy Ann         |       4.99 |
| Doll House Inc. | Raggedy Ann         |       4.99 |
| Fun and Games   | Raggedy Ann         |       4.99 |
| Furball Inc.    | Raggedy Ann         |       4.99 |
| Jouets et ours  | Raggedy Ann         |       4.99 |
| Bear Emporium   | King doll           |       9.49 |
| Bears R Us      | King doll           |       9.49 |
| Doll House Inc. | King doll           |       9.49 |
| Fun and Games   | King doll           |       9.49 |
| Furball Inc.    | King doll           |       9.49 |
| Jouets et ours  | King doll           |       9.49 |
| Bear Emporium   | Queen doll          |       9.49 |
| Bears R Us      | Queen doll          |       9.49 |
| Doll House Inc. | Queen doll          |       9.49 |
| Fun and Games   | Queen doll          |       9.49 |
| Furball Inc.    | Queen doll          |       9.49 |
| Jouets et ours  | Queen doll          |       9.49 |
+-----------------+---------------------+------------+
54 rows in set (0.00 sec

```
上面的例子包含很多，不正确的数据。

### 内部联结

基于两边直接的相对测试，称为等值联结(euqijoin) 

```
mysql> SELECT vend_name, prod_name, prod_price
    -> FROM Vendors INNER JOIN Products
    -> ON Vendors.vend_id = Products.vend_id;
+-----------------+---------------------+------------+
| vend_name       | prod_name           | prod_price |
+-----------------+---------------------+------------+
| Bears R Us      | 8 inch teddy bear   |       5.99 |
| Bears R Us      | 12 inch teddy bear  |       8.99 |
| Bears R Us      | 18 inch teddy bear  |      11.99 |
| Doll House Inc. | Fish bean bag toy   |       3.49 |
| Doll House Inc. | Bird bean bag toy   |       3.49 |
| Doll House Inc. | Rabbit bean bag toy |       3.49 |
| Doll House Inc. | Raggedy Ann         |       4.99 |
| Fun and Games   | King doll           |       9.49 |
| Fun and Games   | Queen doll          |       9.49 |
+-----------------+---------------------+------------+
9 rows in set (0.01 sec)
```

### 联结多个表

先列出所有列，再定义表之间的关系。

```
mysql> SELECT prod_name, vend_name, prod_price, quantity
    -> FROM OrderItems, Products, Vendors
    -> WHERE Products.vend_id = Vendors.vend_id
    -> AND OrderItems.prod_id = Products.prod_id
    -> AND order_num = 20007;
+---------------------+-----------------+------------+----------+
| prod_name           | vend_name       | prod_price | quantity |
+---------------------+-----------------+------------+----------+
| 18 inch teddy bear  | Bears R Us      |      11.99 |       50 |
| Fish bean bag toy   | Doll House Inc. |       3.49 |      100 |
| Bird bean bag toy   | Doll House Inc. |       3.49 |      100 |
| Rabbit bean bag toy | Doll House Inc. |       3.49 |      100 |
| Raggedy Ann         | Doll House Inc. |       4.99 |       50 |
+---------------------+-----------------+------------+----------+
5 rows in set (0.00 sec)

```
返回订购产品RGAN01的客户列表

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
2 rows in set (0.00 sec)
```
下面使用联结查询

```
mysql> SELECT cust_name, cust_contact
    -> FROM Customers, Orders, OrderItems
    -> WHERE Customers.cust_id = Orders.cust_id
    -> AND OrderItems.order_num = Orders.order_num
    -> AND prod_id = 'RGAN01';
+---------------+--------------------+
| cust_name     | cust_contact       |
+---------------+--------------------+
| Fun4All       | Denise L. Stephens |
| The Toy Store | Kim Howard         |
+---------------+--------------------+
2 rows in set (0.00 sec)
```

解释:返回的数据需要使用3个表，三个WHERE子句，最后过滤出RGAN01产品的数据
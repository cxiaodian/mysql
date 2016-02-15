## 组合查询

如何用UNION操作符将多条SELECT语句组合成一个查询

### 组合查询

- 并(union) 执行多个查询并将结果作为单个查询结果返回。

一般需要使用组合查询的情况

- 单个查询中从不同的表类似返回结果数据
- 单个表执行多个查询，按单个查询返回数据

### 创建组合查询 

检索 IL,IN,MI几个洲的客户报表。

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_state IN ('IL', 'IN', 'MI');
+---------------+--------------+-----------------------+
| cust_name     | cust_contact | cust_email            |
+---------------+--------------+-----------------------+
| Village Toys  | John Smith   | sales@villagetoys.com |
| Fun4All       | Jim Jones    | jjones@fun4all.com    |
| The Toy Store | Kim Howard   | NULL                  |
+---------------+--------------+-----------------------+
3 rows in set (0.01 sec)
```

SELECT利用=符合，检索出所有Fun4All单位

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_name = 'Fun4All';
+-----------+--------------------+-----------------------+
| cust_name | cust_contact       | cust_email            |
+-----------+--------------------+-----------------------+
| Fun4All   | Jim Jones          | jjones@fun4all.com    |
| Fun4All   | Denise L. Stephens | dstephens@fun4all.com |
+-----------+--------------------+-----------------------+
2 rows in set (0.00 sec)
```

把上面两条语句进行组合

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_state IN ('IL','IN','MI')
    -> UNION
    -> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_name = 'Fun4All';
+---------------+--------------------+-----------------------+
| cust_name     | cust_contact       | cust_email            |
+---------------+--------------------+-----------------------+
| Village Toys  | John Smith         | sales@villagetoys.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| The Toy Store | Kim Howard         | NULL                  |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
+---------------+--------------------+-----------------------+
4 rows in set (0.02 sec)
```

解释: 中介有UNION分割开，并把输出组合成儿一个查询结果

另一个检索

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_state IN('IL','IN','MI')
    -> OR cust_name = 'Fun4All';
+---------------+--------------------+-----------------------+
| cust_name     | cust_contact       | cust_email            |
+---------------+--------------------+-----------------------+
| Village Toys  | John Smith         | sales@villagetoys.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
| The Toy Store | Kim Howard         | NULL                  |
+---------------+--------------------+-----------------------+
4 rows in set (0.00 sec)
```

## 使用UNION规则

- 必须有两条以上SELECT语句组合，语句直接用关键字UNION分割。
- UNION中每个查询必须包含相同的列，表单式，聚集函数。
- 列的数据必须兼容，

#### 是否带有重复行

UNION默认去掉重复行

如果想要所有行，可以使用UNION ALL 而不是UNION。

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_state IN ('IL','IN','MI')
    -> UNION ALL
    -> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_name = 'Fun4All';
+---------------+--------------------+-----------------------+
| cust_name     | cust_contact       | cust_email            |
+---------------+--------------------+-----------------------+
| Village Toys  | John Smith         | sales@villagetoys.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| The Toy Store | Kim Howard         | NULL                  |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
+---------------+--------------------+-----------------------+
5 rows in set (0.00 sec)

```
与上面例子比多了一行。

### 对组合查询结果排序

```
mysql> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_state IN ('IL''IN','MI')
    -> UNION
    -> SELECT cust_name, cust_contact, cust_email
    -> FROM Customers
    -> WHERE cust_name = 'Fun4ALL'
    -> ORDER BY cust_name, cust_contact;
+--------------+--------------------+-----------------------+
| cust_name    | cust_contact       | cust_email            |
+--------------+--------------------+-----------------------+
| Fun4All      | Denise L. Stephens | dstephens@fun4all.com |
| Fun4All      | Jim Jones          | jjones@fun4all.com    |
| Village Toys | John Smith         | sales@villagetoys.com |
+--------------+--------------------+-----------------------+
3 rows in set (0.00 sec)
```














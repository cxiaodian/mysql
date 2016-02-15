## 更新和删除数据

利用UPDATE和DELETE语句进行操作表数据。

## 更新数据

UPDATE用来更新修改表中的数据

- 更新表中特定的行
- 更新表中所有行

注意: 如果省略了WHERE子句，`就会更新所有行。`

UPDATE语句有三个部分组合

- 要更新的表
- 列名和他们的新值
- 确定要更新哪些行的过滤条件

```
mysql> UPDATE Customers
    -> SET cust_email = 'Kim@gmail.com'
    -> WHERE cust_id = '1000000005';
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

```
解释: SET命令用来建新值赋予给更新的列，设置了cust_email列为指定的值。  
`SET cust_email = 'Kim@gmail.com'`
WHERE子句告诉要更新哪一行，如果没有WHERE子句，电子邮件将会更新Customers表中所有的行。

更新一列多个值


```
mysql> UPDATE Customers
    -> SET cust_contact = 'Sam Roberts',
    -> cust_email = 'sam@toyland.com'
    -> WHERE cust_id = '1000000006';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

解释: 使用SET命令，每个‘列=值’用逗号隔开，区分多个列。

更新某个列NULL

可以把列设置成NULL，如果表允许设置NULL

```
mysql> UPDATE Customers
    -> SET cust_email = NULL
    -> WHERE cust_id = '1000000005';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0
```

### 删除数据

使用`DELETE`从数据库删除数据,

- 从表中删除特定的行
- 从表中删除所有的行

```
mysql> DELETE FROM Customers WHERE cust_id = '1000000009';
Query OK, 1 row affected (0.01 sec)
```

解释:指定删除 表Customers 中的数据

注意:

- DELETE语句删除行，但不能删除表本身
- 想删除表中所有的行，可以使用`TRUNCATE TABLE`语句

### 更新和删除的原则

- UPDATE跟DELETE语句都具有WHERE子句，如果忽略WHERE子句建会应用到所有行，所以除非更新所有行
- 保证每个表都有主键，WHERE应用到主键。
- 使用UPDATE和DELETE语句前先，先SELECT进行测试，确保编写的WHERE子句正确。
- 使用强制实施引用完整性数据库，防止误删除行。
- 现在MYSQL不带有WHERE子句的UPDATE或DELETE子句执行。




















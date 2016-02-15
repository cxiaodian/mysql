## 管理事务处理

### 事务处理(transaction processing)
可以用来维护数据的完整性，保证SQL的操作要么完全执行，要么完全不执行，如果发生错误就进行撤销。

- 保证数据的完整性。
- 保证数据不受外影响。

事务处理的几道术语

- 事务(transaction) 一组SQL语句
- 退回(rollback)撤销执行SQL语句的过程
- 提交(commit) 将为执行的SQL语句写入数据库表
- 保留点(savepoint) 临时存储点，用于发布退回。

事务操作简单的例子

```
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> DELETE FROM Vendor_n;
Query OK, 6 rows affected (0.00 sec)

mysql> ROLLBACK;
Query OK, 0 rows affected (0.01 sec)

mysql> COMMIT; 提交操作。
```

设置保留点

```
mysql> SAVEPOINT delete_vendor;
Query OK, 0 rows affected (0.00 sec)

mysql> ROLLBACK TO delete_vendor;
Query OK, 0 rows affected (0.00 sec)
```





## MySQL用户有关命令

### 进入

```
mysql -u usename -p password -P 默认3306
mysql -S /tmp/mysql.sock -uroot -h192.168.56.1 -P3306 -p1234567 指定sock登录
\h 获取帮助
\q 退出 or quit
```

### 修改msyql密码

	$ mysql -u root
	mysql> USE mysql;
	mysql> UPDATE user SET authentication_string=PASSWORD("NEWPASSWORD") WHERE User='root';
	
### 创建用户

	mysql> CREATE USER 'test1'@'localhost' identified by '1234567';
	Query OK, 0 rows affected (0.00 sec)

### 查询用户

	mysql> SELECT USER FROM mysql.user; 查询所有用户
	mysql> SHOW GRANTS For root@'localhost'; 查询具体某个用户
	
### 删除用户

```
mysql> DROP USER 'test1'@'localhost';
Query OK, 0 rows affected (0.01 sec)
```

### GRANT语句授权用户登录

```
mysql> GRANT ALL ON *.* TO 'test1'@'192.168.56.1' IDENTIFIED BY '1234567';
Query OK, 0 rows affected, 1 warning (0.01 sec)

```

- 限定IP地址 192.168.56.1登录操作
- \*.* 第一个*表示所有数据库，第二个表示所有表
- 最后是远程密码

具体指定用户可用的语句，限制test1只能用SELECT语句。

```
mysql> GRANT SELECT ON *.* TO 'test1'@'localhost' identified BY '1234567';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges; 刷新权限
Query OK, 0 rows affected (0.00 sec)
```

查询是否授权成功

	mysql> SELECT * FROM USER WHERE HOST='192.168.56.1'\G;


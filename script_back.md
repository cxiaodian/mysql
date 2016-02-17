## MySQL 脚本备份相关

### Shell 脚本定期备份

[mysql_config_editor — MySQL Configuration Utility](http://dev.mysql.com/doc/refman/5.7/en/mysql-config-editor.html) 需要配置下`mysql_config_editor`

	mysql_config_editor set --login-path=client
         --host=localhost --user=localuser --password

`backup_parent_dir` 是备份路径  
`mysql_user="root"` 备份用户，其实这里可以不用


```
#!/bin/bash
# Simple script to backup MySQL databases

# Parent backup directory
backup_parent_dir="./backup"

# MySQL settings
mysql_user="root"

# Read MySQL password from stdin if empty

# Check MySQL password
#echo exit | mysql --login-path=client  --host=localhost --user=${mysql_user} --password=${mysql_password} -B 2>/dev/null
echo exit | mysql --login-path=client -B 2>/dev/null
if [ "$?" -gt 0 ]; then
  echo "MySQL ${mysql_user} password incorrect"
  exit 1
else
  echo "MySQL ${mysql_user} password correct."
fi

# Create backup directory and set permissions
backup_date=`date +%Y_%m_%d_%H_%M`
backup_dir="${backup_parent_dir}/${backup_date}"
echo "Backup directory: ${backup_dir}"
mkdir -p "${backup_dir}"
chmod 700 "${backup_dir}"
logfile="$backup_parent_dir/"backup_log_"$(date +'%Y_%m')".txt

# Get MySQL databases
mysql_databases=`echo 'show databases' | mysql --login-path=client | sed /^Database$/d`

# Backup and compress each database
for database in $mysql_databases
do
  if [ "${database}" == "information_schema" ] || [ "${database}" == "performance_schema" ]; then
        additional_mysqldump_params="--skip-lock-tables"
  else
        additional_mysqldump_params=""
  fi
  echo "Creating backup of \"${database}\" database"
  mysqldump --login-path=client  ${additional_mysqldump_params} -e  | gzip > "${backup_dir}/${database}.gz"
  echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
  chmod 600 "${backup_dir}/${database}.gz"
done
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
```

再用crontab 来定制备份计划

### python 备份脚本


```
import os
import time

filestamp = time.strftime("%Y-%m-%d")

database_list_command="mysql --login-path=client -e 'show databases'"
for database in os.popen(database_list_command).readlines():
    database = database.strip()
    if database == 'information_schema':
        continue
    if database == 'performance_schema':
        continue
    filename = '/Users/xiaodian/mysql/backup/{0}_{1}.sql'.format(database, filestamp)
    os.popen("mysqldump --login-path=client -c {0}| gzip > {1}.gz".format(database, filename))

os.popen("echo mysqldump finished at {0} >> backup_log_{1}.txt".format(filename, filestamp))
```



脚本参考
<https://blog.sleeplessbeastie.eu/2012/11/22/simple-shell-script-to-backup-mysql-databases/>
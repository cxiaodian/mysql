#!/bin/bash
# simple script to backup Mysql databases

#parent backup directory
backup_parent_dir="/Users/xiaodian/mysql/backup"

#mysql settings
mysql_user="root"
mysql_password="password"

#read mysq password from stdin if empty

#if [ -z "${mysql_password}" ]; then
#    echo -n "Enter mysql ${mysql_user} password:"
#    read -s mysql_password
#    echo
#fi

#check mysql password
echo exit | mysql --login-path=client --host=localhost --user=${mysql_user} --password=${mysql_password} -B 2>/dev/null
if [ "$?" -gt 0  ]; then
      echo "MySQL ${mysql_user} password incorrect"
        exit 1
    else
          echo "MySQL ${mysql_user} password correct."
      fi


#create backup directory and set permissions
backup_date=`date +%Y_%m_%d_%H_%M`
backup_dir="${backup_parent_dir}/${backup_date}"
echo "Backup directory: ${backup_dir}"
mkdir -p "${backup_dir}"
chmod 700 "${backup_dir}"

#get mysql database
mysql_databases=`echo 'show databases' | mysql --login-path=client --host=localhost --user=${mysql_user} --password=${mysql_password} -B | sed /^Database$/d`

# backup and compress each database
for database in $mysql_database
do
    if ["${database}" == "information_schema"] || ["${database}" == "performance_schema"]; then
        additional_mysqldump_params="--skip-lock-tables"
    else
        additional_mysqldump_params=""
    fi
    echo "Creating backup of \"${database}\" database"
    mysqldump ${additional_mysqldump_params} --login-path=client --host=localhost --user=${mysql_user} --password=${mysql_password} ${database} | gzip > "${backup_dir}/${database.gz}"
    chmod 600 "${backup_dir}/${database}.gz"
done





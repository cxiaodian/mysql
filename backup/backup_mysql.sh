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
  chmod 600 "${backup_dir}/${database}.gz"
done
  echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

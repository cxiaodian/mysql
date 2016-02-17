#!/usr/bin/env python

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

APP=mysqld
COMPONENT=mysqld


# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
# yum install mysql-community-server -y
enableStartService
TEMP_PASSWORD=$(grep "temporary password" /var/log/mysqld.log | awk -F : '{print $NF}')

echo "show databases;" | mysql -uroot -pRoboShop@1   &>> $LOGFILE
if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" | mysql --connect-expired-password -uroot -p${TEMP_PASSWORD} &>> ${LOG_FILE}
exitcode $? "Password Changed"
fi
echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>>${LOG_FILE}
if [ $? -eq 0 ]; then
"uninstall plugin validate_password;"| mysql  -uroot -pRoboShop@1 &>> $LOG_FILE
exitcode $? "Uninstalled validate_password plugin"
fi

curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip" &>> ${LOG_FILE}
exitcode $? "Downloading Shipping Repo"
cd /tmp
unzip mysql.zip &>> ${LOG_FILE}
exitcode $? "Unzipped Repo"
cd mysql-main
echo mysql -u root -pRoboShop@1 <shipping.sql &>> ${LOG_FILE}
exitcode $? "Loading Shipping Repo"
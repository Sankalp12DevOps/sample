APP=mysqld
COMPONENT=mysqld

source components/common.sh

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>>${LOG_FILE}
yum install mysql-community-server -y
enableStartService
TEMP_PASSWORD=$(grep "temporary password" /var/log/mysqld.log | awk -F ": " '{print $NF}')
echo $TEMP_PASSWORD
echo "show databases;" | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
echo hello
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p$"{TEMP_PASSWORD}"

exitcode $? "Password Changed"
fi
echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>>${LOG_FILE}
if [ $? -eq 0 ]; then
"uninstall plugin validate_password;"| mysql  -uroot -pRoboShop@1 &>>$LOG_FILE
exitcode $? "Uninstalled validate_password plugin"
fi

curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip" &>>${LOG_FILE}
exitcode $? "Downloading Shipping Repo"
cd /tmp
unzip mysql.zip &>> ${LOG_FILE}
exitcode $? "Unzipped Repo"
cd mysql-main
echo mysql -u root -pRoboShop@1 <shipping.sql &>> ${LOG_FILE}
exitcode $? "Loading Shipping Repo"
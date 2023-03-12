echo "this is front-end"
TEMP_PATH=./tmp/
LOG_FILE=/tmp/robo.log

function exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}

rm -rf $TEMP_PATH &>> $LOG_FILE
exitcode $? "Remove all content inside /tmp/ folder"
yum install nginx -y &>> $LOG_FILE
exitcode $? "Install Nginx" &>> $LOG_FILE
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> $LOG_FILE
exitcode $? "Download front-end zip content"
cd /usr/share/nginx/html
exitcode $? "Navigate inside /usr/share/nginx/html"
rm -rf * &>> $LOG_FILE
exitcode $? "Removed all content inside /usr/share/nginx/html"
unzip /tmp/frontend.zip &>> $LOG_FILE
exitcode $? "Unzipped frontend.zip in root folder"
mv frontend-main/* . &>> $LOG_FILE
exitcode $? "Moved frontend-main to default folder of nginx"
mv static/* .
exitcode $? "Moved static contenet to root folder"
rm -rf frontend-main README.md &>> $LOG_FILE
exitcode $? "remove frontend-main nginx file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
exitcode $? "Moved frontend local host onfig to default folder of nginx"
systemctl enable nginx &>> $LOG_FILE
exitcode $? "Enable Nginx"
systemctl start nginx &>> $LOG_FILE
exitcode $? "start Nginx"
echo "this is front-end"
TEMP_PATH=./tmp/
LOG_FILE ="/tmp/robo.log"


function exitcode(){
if [ $1 -ne 0 ]; then
echo -e \n "$2:" "\e[31m FAILURE \e[0m"
exit 2
else
echo -e \n "$2:" "\e[32m SUCCESS \e[0m"
exit 0
fi
}

rm -rf $TEMP_PATH
yum install nginx -y &>> $LOG_FILE
exitcode $? "Nginx Installation"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> $LOG_FILE
exitcode $? "Download front-end app"
cd /usr/share/nginx/html 
exitcode $? "Navigated to nginx/html"
rm -rf *
exitcode $? "deleted all files within nginx/html"
unzip /tmp/frontend.zip &>> $LOG_FILE
exitcode $? "Unzipped front-end zip file"
mv frontend-main/* .
exitcode $? "Moved all content within Frontend-main to root"
mv static/* .
exitcode $? "Moved all content within static folder to root"
rm -rf frontend-main README.md
exitcode $? "remove frontend-main nginx file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
exitcode $? "Moved frontend local host onfig to default folder of nginx"
systemctl enable nginx &>> $LOG_FILE
exitcode $? "Enable Nginx"
systemctl start nginx &>> $LOG_FILE
exitcode $? "start Nginx
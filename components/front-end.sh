echo "this is front-end"
TEMP_PATH=./tmp/
LOG_FILE=/tmp/robo.log
USER=roboshop
COMPONENT=frontend

function exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}

su $USER

clearTempFolder
installNginx
downloadZipPackageAndUnZip
cd /usr/share/nginx/html
exitcode $? "Navigate inside /usr/share/nginx/html"
rm -rf * &>> $LOG_FILE
exitcode $? "Removed all content inside /usr/share/nginx/html"
mv frontend-main/* . &>> $LOG_FILE
exitcode $? "Moved frontend-main to default folder of nginx"
mv static/* .
exitcode $? "Moved static contenet to root folder"
rm -rf frontend-main README.md &>> $LOG_FILE
exitcode $? "remove frontend-main nginx file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
exitcode $? "Moved frontend local host onfig to default folder of nginx"
enableStartService
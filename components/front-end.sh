echo "this is front-end"
TEMP_PATH=./tmp/
LOG_FILE=/tmp/robo.log
COMPONENT=frontend
APP=nginx
source components/common.sh

function exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}

useradd $USER

clearTempFolder
installNginx
cd /usr/share/nginx/html
exitcode $? "Navigate inside /usr/share/nginx/html"
rm -rf * &>> $LOG_FILE
exitcode $? "Removed all content inside /usr/share/nginx/html"
downloadZipPackageAndUnZip
mv frontend/* . &>> $LOG_FILE
exitcode $? "Moved frontend-main to default folder of nginx"
mv static/* .
exitcode $? "Moved static contenet to root folder"
rm -rf frontend-main README.md &>> $LOG_FILE
exitcode $? "remove frontend-main nginx file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
exitcode $? "Moved frontend local host config to default folder of nginx"
enableStartService

for i in [ cart catalogue user shipping payment ] do

$(sed -i "/$i/s/localhost/$i.roboshop.internal/" /etc/nginx/default.d/roboshop.conf)

done


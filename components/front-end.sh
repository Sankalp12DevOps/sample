echo "this is front-end"
TEMP_PATH=/tmp/

useradd robouser
cd 
cd /home/robouser

function exitcode(){
if [ $1 -ne 0 ]; then
exit 1
else
exit 0
fi
}

yum install nginx -y
echo -e "nginx installation:" "\e[32m SUCCESS\e[0m"
exitcode $?
rm -rf $TEMP_PATH
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
exitcode $?
cd /usr/share/nginx/html
exitcode $?
rm -rf *
exitcode $?
unzip /tmp/frontend.zip
exitcode $?
mv frontend-main/* .
exitcode $?
mv static/* .
exitcode $?
rm -rf frontend-main README.md
exitcode $?
mv localhost.conf /etc/nginx/default.d/roboshop.conf
exitcode $?
systemctl enable nginx
exitcode $?
systemctl start nginx
exitcode $?
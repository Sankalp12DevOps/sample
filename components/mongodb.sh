echo "this is MongoDB"

APP=mongod

function exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}
$(id -u)
su $USER
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo &>> $LOG_FILE
exitcode $? "Downloading Mango Repo"
yum install -y mongodb-org &>> $LOG_FILE
exitcode $? "Installing Mango DB"
enableStartService
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG_FILE
exitcode $? "Updated Exposed Port to 0.0.0.0"
systemctl restart mongod &>> $LOG_FILE



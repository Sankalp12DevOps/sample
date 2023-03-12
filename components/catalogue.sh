source /common.sh
TEMP_PATH=./tmp/
LOG_FILE=/tmp/robo.log
USER=roboshop

rm -rf TEMP_PATH &>> $LOG_FILE
useradd $USER &>> $TEMP_PATH
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOG_FILE
exitcode $? "Download node package"
yum install nodejs -y &>> $LOG_FILE
exitcode $? "Installation of node"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOG_FILE
cd /home/roboshop
exitcode $? "Moved to roboshop folder"
unzip $TEMP_PATH catalogue.zip &>> $LOG_FILE
exitcode $? "Unzip "Catalogue.zip
mv catalogue-main catalogue &>> $LOG_FILE
exitcode $? "Rename catalogue-main to catalogue"
cd /home/roboshop/catalogue &>>$LOG_FILE
exitcode $? "Move inside catalogue Folder"
npm install &>>$LOG_FILE
exitcode $? "Npm installation"
sed -i -e /s/MONGO_DNSNAME/mongodb.internal.com/ systemd.service &>>$LOG_FILE
exitcode $? "update the mongodb ip in system.service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
exitcode $? "Move system.service to system folder"
systemctl daemon-reload &>>$LOG_FILE
exitcode $? "Reload Daemon"
systemctl start catalogue &>>$LOG_FILE
exitcode $? "Start Catalogue"
systemctl enable catalogue &>>$LOG_FILE
exitcode $? "Enable Catalogue"
systemctl status catalogue -l &>>$LOG_FILE
exitcode $? "Check status of Catalogue" &>>$LOG_FILE
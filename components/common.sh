user=roboshop
TEMP_PATH=./tmp/
LOG_FILE=/tmp/robo.log
USER=roboshop

exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}

clearTempFolder(){
rm -rf $TEMP_PATH &>> $LOG_FILE
exitcode $? "Remove all content inside /tmp/ folder"
}

installNginx(){
yum install nginx -y &>> $LOG_FILE
exitcode $? "Install Nginx" &>> $LOG_FILE

}

downloadZipPackageAndUnZip(){
cd /home/${USER}
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" &>> $LOG_FILE
exitcode $? "Download front-end zip content"
unzip /tmp/${COMPONENT}.zip &>> $LOG_FILE
exitcode $? "Unzipped frontend.zip in root folder"
mv ${COMPONENT}-main ${COMPONENT}
exitcode $? "Rename catalogue-main to catalogue"


}


enableStartService(){
systemctl daemon-reload &>>$LOG_FILE
systemctl enable ${APP} &>> $LOG_FILE
exitcode $? "Enable ${APP}"
systemctl start ${APP} &>> $LOG_FILE
exitcode $? "start ${APP}"

}

updateConfig(){
sed -i -e /s/MONGO_DNSNAME/mongodb.internal.com/ 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$USER/$COMPONENT/systemd.service &>>$LOG_FILE

mv /home/${USER}/${COMPONENT}/systemd.service /etc/systemd/system/${USER}.service &>>$LOG_FILE

}

addRoboUser(){
    useradd $user
}

installNode(){
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOG_FILE
exitcode $? "Download node package"
yum install nodejs -y &>> $LOG_FILE
exitcode $? "Installation of node"
}
packageInstaller(){
cd /home/${user}/${COMPONENT} &>>$LOG_FILE
exitcode $? "Move inside catalogue Folder"
npm install
}

installNodeBasedApp(){
clearTempFolder
addRoboUser
installNode
downloadZipPackageAndUnZip
packageInstaller
updateConfig
enableStartService
}
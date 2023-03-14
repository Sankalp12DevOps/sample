APP=redis
COMPONENT=redis



curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.11 -y
exitcode $? "Installing redis DB"
sed -i -e '/127.0.0.1/s/0.0.0.0/' /etc/redis.conf -e '/127.0.0.1/s/0.0.0.0/' /etc/redis/redis.conf
exitcode $? "updated IP in redis DB"
enableStartService
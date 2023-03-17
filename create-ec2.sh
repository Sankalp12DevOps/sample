#!/bin/bash 
if [ -z $1 ]; then
echo -e "\e[31m PLease provide an input\e[0m"
exit 1
fi

HOSTEDZONEID=Z01817288AYQJ8IWO87B
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SECURITY_GROUPID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=robosecurity | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
COMPONENT=$1
PRIVATEIP=echo $(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --security-group-ids $SECURITY_GROUPID \
    --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT]" | jq)

sed -i "s/COMPONENT/$COMPONENT" -i "s/IPADDRESS/$PRIVATEIP" components/record.json > /tmp/r53.json

aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch components/record.json
# '.Instances[].NetworkInterfaces[].PrivateIpAddress' | sed -e 's/"//g'
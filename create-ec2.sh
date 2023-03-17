
#!/bin/bash 
# if [ -z $1 ]; then
# echo -e "\e[31m PLease provide an input\e[0m"
# exit 1
# fi


# AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos7-Linux-Learning-AMI" | jq '.Images[].ImageId' | sed -e 's/"//g')
# SECURITY_GROUPID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=robosecurity | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
# echo $(aws ec2 run-instances \
#     --image-id $AMI_ID \
#     --count 1 \
#     --instance-type t2.micro \
#     --security-group-ids $SECURITY_GROUPID \
#     --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
#     --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]")
    
    
'AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b53-allow-all-sg  | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')

echo -n "Ami ID is $AMI_ID"

echo -n "Launching the instance with $AMI_ID as AMI :"\
IPADDRESS=$(aws ec2 run-instances --image-id $AMI_ID \
                --instance-type t3.micro \
                --security-group-ids ${SGID} \
                --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
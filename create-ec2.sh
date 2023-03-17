
if [ -z $1 ]; then
echo -e "\e[31m PLease provide an input\e[0m"
exit 1
fi


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos7-Linux-Learning-AMI" | jq '.Images[].ImageId' | sed -e 's/"//g')
SECURITY_GROUPID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=robosecurity | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --security-group-ids $SECURITY_GROUPID \
    --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq)
    
    
    #--key-name payment \
    # --security-group-ids sg-07570e17ab8331f13 \
    # --subnet-id subnet-00b5ede5e160caa59 \
    # --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":false}}]" \
    #  'ResourceType=volume,Tags=[{Key=Name,Value=demo-server-disk}]'
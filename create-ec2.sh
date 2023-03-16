
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos7-Linux-Learning-AMI" | jq '.Images[].ImageId' | sed -e 's/"//g')

aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name payment \
    

    # --security-group-ids sg-07570e17ab8331f13 \
    # --subnet-id subnet-00b5ede5e160caa59 \
    # --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":false}}]" \
    # --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=demo-server}]' 'ResourceType=volume,Tags=[{Key=Name,Value=demo-server-disk}]'
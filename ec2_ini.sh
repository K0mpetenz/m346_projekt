aws ec2 create-key-pair --key-name nextcloud_key --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/nextcloud_key.pem

aws ec2 create-security-group --group-name nextcloud-sec-group --description "Nextcloud Setup"
aws ec2 authorize-security-group-ingress --group-name nextcloud-sec-group --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name nextcloud-sec-group --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name nextcloud_key --security-groups nextcloud-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://ini.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Nextcloud_Web}]'

aws ec2 describe-instances --query "Reservations[*].Instances[*].{InstanceId:InstanceId, PublicIP: PublicIpAddress, State: State.Name}"
aws ec2 describe-instance-status

chmod 600 ~/.ssh/nextcloud_key.pem
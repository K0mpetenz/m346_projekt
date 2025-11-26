## EC2-Nextcloud-Instance

# define key pair name
KEY_NAME="nextcloud-key"
# define instance name
NC_INSTANCE_NAME="NC-Server2"
# define security group
NC_SECURITY_GROUP="nc-sec-group"

aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/"$KEY_NAME".pem

aws ec2 create-security-group --group-name "$NC_SECURITY_GROUP" --description "EC2-Nextcloud"
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name "$KEY_NAME" --security-groups "$NC_SECURITY_GROUP" --iam-instance-profile Name=LabInstanceProfile --user-data file://nc_ini.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=NC-Server2}]' > /dev/null

# test to print out the public ip
NC_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values="$NC_INSTANCE_NAME"" --query "Reservations[0].Instances[0].InstanceId" --output text)

NC_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$NC_INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

#----#

echo -e "Das ist die Public-IP: $NC_PUBLIC_IP"

chmod 600 ~/.ssh/"$KEY_NAME".pem

# exit for testing

exit;

#----#



## EC2-Database-Instance

# define key pair name
KEY_NAME="database-key"
# define instance name
NC_INSTANCE_NAME="DB-Server"
# define security group
NC_SECURITY_GROUP="db-sec-group"

aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/"$KEY_NAME".pem

aws ec2 create-security-group --group-name "$NC_SECURITY_GROUP" --description "EC2-Nextcloud"
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name "$KEY_NAME" --security-groups "$NC_SECURITY_GROUP" --iam-instance-profile Name=LabInstanceProfile --user-data file://db_ini.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Nextcloud_Web}]'

aws ec2 describe-instances --query "Reservations[*].Instances[*].{InstanceId:InstanceId, PublicIP: PublicIpAddress, State: State.Name}"
aws ec2 describe-instance-status

chmod 600 ~/.ssh/"$KEY_NAME".pem









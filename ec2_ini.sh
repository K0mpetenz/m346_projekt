## EC2-Nextcloud-Instance

# define key pair name
KEY_NAME="nextcloud-key"
# define instance name
NC_INSTANCE_NAME="NC-Server"
# define security group
NC_SECURITY_GROUP="nc-sec-group"

aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/"$KEY_NAME".pem

aws ec2 create-security-group --group-name "$NC_SECURITY_GROUP" --description "EC2-Nextcloud"
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name "$KEY_NAME" --security-groups "$NC_SECURITY_GROUP" --iam-instance-profile Name=LabInstanceProfile --user-data file://nc_ini.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Nextcloud_Web}]'

aws ec2 describe-instances --query "Reservations[*].Instances[*].{InstanceId:InstanceId, PublicIP: PublicIpAddress, State: State.Name}"
aws ec2 describe-instance-status

chmod 600 ~/.ssh/"$KEY_NAME".pem


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









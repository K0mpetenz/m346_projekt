## EC2-Nextcloud-Instance

# define key pair name
NC_KEY_NAME="nextcloud-key"
# define instance name
NC_INSTANCE_NAME="NC-Server"
# define security group
NC_SECURITY_GROUP="nc-sec-group"

aws ec2 create-key-pair --key-name "$NC_KEY_NAME" --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/"$NC_KEY_NAME".pem

aws ec2 create-security-group --group-name "$NC_SECURITY_GROUP" --description "$NC_INSTANCE_NAME"

aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0                 
aws ec2 authorize-security-group-ingress --group-name "$NC_SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name "$NC_KEY_NAME" --security-groups "$NC_SECURITY_GROUP" --iam-instance-profile Name=LabInstanceProfile --user-data file://nc_ini.txt --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NC_INSTANCE_NAME}]" > /dev/null

# change the permissions for the ssh key to 600
chmod 600 ~/.ssh/"$NC_KEY_NAME".pem

# get the nextcloud instance id
NC_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values="$NC_INSTANCE_NAME"" --query "Reservations[0].Instances[0].InstanceId" --output text)

# get the nextcloud instance public ip
NC_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$NC_INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

# print out the public ip
echo -e "Erreiche Nextcloud unter https://$NC_PUBLIC_IP"

#----#

## EC2-Database-Instance

# define key pair name
DB_KEY_NAME="database-key"
# define instance name
DB_INSTANCE_NAME="DB-Server1"
# define security group
DB_SECURITY_GROUP="db-sec-group"

aws ec2 create-key-pair --key-name "$DB_KEY_NAME" --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/"$DB_KEY_NAME".pem

aws ec2 create-security-group --group-name "$DB_SECURITY_GROUP" --description "$DB_INSTANCE_NAME"
aws ec2 authorize-security-group-ingress --group-name "$DB_SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "$DB_SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro --key-name "$DB_KEY_NAME" --security-groups "$DB_SECURITY_GROUP" --iam-instance-profile Name=LabInstanceProfile --user-data file://db_ini.txt --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$DB_INSTANCE_NAME}]" > /dev/null

# change the permissions for the ssh key to 600
chmod 600 ~/.ssh/"$DB_KEY_NAME".pem

# get the database instance id
DB_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values="$DB_INSTANCE_NAME"" --query "Reservations[0].Instances[0].InstanceId" --output text)

# get the database instance public ip
DB_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$DB_INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

# print out the public ip
echo -e "Das ist die Public-IP der Datenbank-Instanz: $DB_PUBLIC_IP"
cat /home/ec2-user/db_credentials.txt









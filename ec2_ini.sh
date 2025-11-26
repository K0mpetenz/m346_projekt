#!bin/bash
REGION="us-east-1"

IMAGE_ID="ami-08c40ec9ead489470"

INSTANCE_TYPE="t2.micro"

KEY_NAME="nextcloud-key"

NC_SECURITY_GROUP="nc-sec-group"

NC_INSTANCE_NAME="NC-Server"

aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --query "KeyMaterial" --output text > "$KEY_NAME.pem"
chmod 700 "$KEY_NAME.pem"

NC_SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$NC_SECURITY_GROUP" --description "EC2-Nextcloud" --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id "$NC_SECURITY_GROUP_ID" --protocol tcp --port 80 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-id "$NC_SECURITY_GROUP_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0 

aws ec2 run-instances --region "$REGION" --image-id "$IMAGE_ID" --instance-type "$INSTANCE_TYPE" --key-name "$KEY_NAME" --user-data ./nc-config.txt --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$NC_INSTANCE_NAME"}]"

echo -e $WPPUBLICIP









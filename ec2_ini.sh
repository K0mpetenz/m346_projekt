#!/bin/bash
set -e

### ======================
### VARIABLEN
### ======================
AMI_ID="ami-08c40ec9ead489470"
INSTANCE_TYPE="t2.micro"
IAM_PROFILE="LabInstanceProfile"

NC_KEY_NAME="nextcloud-key_test"
DB_KEY_NAME="database-key_test"

NC_INSTANCE_NAME="NC-Server_test"
DB_INSTANCE_NAME="DB-Server_test"

### ======================
### KEYPAIRS
### ======================
aws ec2 create-key-pair \
  --key-name "$NC_KEY_NAME" \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/$NC_KEY_NAME.pem

aws ec2 create-key-pair \
  --key-name "$DB_KEY_NAME" \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/$DB_KEY_NAME.pem

chmod 600 ~/.ssh/*.pem

### ======================
### SECURITY GROUPS
### ======================

# Nextcloud SG
NC_SG_ID=$(aws ec2 create-security-group \
  --group-name nc-sec-group \
  --description "Nextcloud SG" \
  --query GroupId \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $NC_SG_ID \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-id $NC_SG_ID \
  --protocol tcp --port 80 --cidr 0.0.0.0/0

# DB SG
DB_SG_ID=$(aws ec2 create-security-group \
  --group-name db-sec-group \
  --description "DB SG" \
  --query GroupId \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $DB_SG_ID \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

# MySQL NUR vom Nextcloud-SG
aws ec2 authorize-security-group-ingress \
  --group-id $DB_SG_ID \
  --protocol tcp --port 3306 \
  --source-group $NC_SG_ID

### ======================
### EC2 INSTANZEN
### ======================

# Nextcloud
NC_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $NC_KEY_NAME \
  --security-group-ids $NC_SG_ID \
  --iam-instance-profile Name=$IAM_PROFILE \
  --user-data file://nc_ini.yml \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NC_INSTANCE_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text)

# Database
DB_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $DB_KEY_NAME \
  --security-group-ids $DB_SG_ID \
  --iam-instance-profile Name=$IAM_PROFILE \
  --user-data file://db_ini.yml \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$DB_INSTANCE_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text)

### ======================
### INFOS AUSGEBEN
### ======================

sleep 10

NC_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $NC_INSTANCE_ID \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

DB_PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids $DB_INSTANCE_ID \
  --query "Reservations[0].Instances[0].PrivateIpAddress" \
  --output text)

echo "======================================="
echo " Nextcloud erreichbar unter:"
echo " http://$NC_PUBLIC_IP"
echo ""
echo " DB Private IP:"
echo " $DB_PRIVATE_IP"
echo "======================================="
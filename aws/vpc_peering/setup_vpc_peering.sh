#!/bin/bash
# https://recipe.kc-cloud.jp/archives/5708
set -o xtrace
set -o errexit

# EDIT HERE!
ECS_VPC_ID=vpc-09ea092218f705b45
ECS_VPC_CIDR=10.1.0.0/16
ECS_VPC_ROUTE_TABLE_1=rtb-0643f56100439ca34
ECS_VPC_ROUTE_TABLE_2=rtb-096c00f0089fef3df

#
# Setup VPC Peering
#
PAGER=
RDS_SECURIGY_GROUP=sg-061a245dd86399ecc
RDS_VPC_ID=vpc-0021709805ac9021d
RDS_VPC_CIDR=10.0.0.0/16
RDS_VPC_ROUTE_TABLE_1=rtb-03dc252888379b838
RDS_VPC_ROUTE_TABLE_2=rtb-06a160a2d2de47435

OUTPUT=$(aws ec2 create-vpc-peering-connection --vpc-id ${ECS_VPC_ID} --peer-vpc-id ${RDS_VPC_ID})
CONNECTION_ID=$(echo $OUTPUT | jq -r ".VpcPeeringConnection.VpcPeeringConnectionId")

aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id ${CONNECTION_ID}
aws ec2 modify-vpc-peering-connection-options --vpc-peering-connection-id ${CONNECTION_ID} \
    --accepter-peering-connection-options=AllowDnsResolutionFromRemoteVpc=true \
    --requester-peering-connection-options=AllowDnsResolutionFromRemoteVpc=true

aws ec2 describe-vpc-peering-connections --vpc-peering-connection-ids ${CONNECTION_ID}

aws ec2 create-route --route-table-id ${RDS_VPC_ROUTE_TABLE_1} --destination-cidr-block ${ECS_VPC_CIDR} --vpc-peering-connection-id ${CONNECTION_ID}
aws ec2 create-route --route-table-id ${RDS_VPC_ROUTE_TABLE_2} --destination-cidr-block ${ECS_VPC_CIDR} --vpc-peering-connection-id ${CONNECTION_ID}

aws ec2 create-route --route-table-id ${ECS_VPC_ROUTE_TABLE_1} --destination-cidr-block ${RDS_VPC_CIDR} --vpc-peering-connection-id ${CONNECTION_ID}
aws ec2 create-route --route-table-id ${ECS_VPC_ROUTE_TABLE_2} --destination-cidr-block ${RDS_VPC_CIDR} --vpc-peering-connection-id ${CONNECTION_ID}

aws ec2 update-security-group-rule-descriptions-ingress \
    --group-id ${RDS_SECURIGY_GROUP} \
    --ip-permissions "IpProtocol=tcp,ToPort=3306,IpRanges=[{CidrIp=${ECS_VPC_CIDR}}]"

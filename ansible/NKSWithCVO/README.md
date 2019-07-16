
# Ansible for creating NKS in AWS and connect to CVO via Cloud Manager

## Install ansible
* Install Ansible >2.7 from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  

## Get your refresh tokens
* Go to https://services.cloud.netapp.com/refresh-token

## Obtaining credentials for AWS
* Go to https://docs.netapp.com/us-en/kubernetes-service/create-auth-credentials-on-aws.html#table-of-contents

Generate refresh token for CloudManager and API

## Create OCCM With Ansible
### Required variables
* AccessKey: accessKey for the CloudManager account
* SecretKey: secretKey for the CloudManager account
* refToken: The refresh token string for API (Possible to use portal user name and password instead)
* occmRefToken: The refresh token string for CloudManager (Possible to use portal user name and password instead)
* OCCM_IP: the IP of the OCCM (Ex: 1.1.1.1 or occm.com)

**Optionals variables**
* PortalUserName: [Portal user name] (Need in case not using refresh tokens)
* PortalPassword: [Portal password] (Need in case not using refresh tokens)
* Region: the region to use (Optional - will use the OCCM region)
* subnetId: the subnet for the NKS cluster (Optional - will use the OCCM subnet)
* connectCVO: indicate if to connect the NKS cluster to existing CVO [true|false] (Optional - default is true)


*ansible-playbook NksWithCVO.yml --extra-vars "AccessKey=[access key] SecretKey=[secret Key] refToken=[API refresh token] occmRefToken=[CloudManager refresh token] OCCM_IP=[OCCM IP address]"*

## Authors

* **TLV DevOps Team** - *Initial work*

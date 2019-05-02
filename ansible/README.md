
# Samples for Ansible and Cloud Manager

## Get your refresh token
Go to https://services.cloud.netapp.com/refresh-token

Generate refresh token for CloudManager ( You need to have a Cloud Central Account )

## Create Cloud Manager (OCCM) With Ansible
### Steps
1. Use the createOCCM.yml file from above. 
1. The file needs to be updated with the following details ( Dont edit anything else)
**vpc, subnet, key pair, security group ( needs to be pre-created in your AWS Account ) , company and site need to be set in the playbook**
1. We need to run the following command to create Cloud Manager ( The variables needed for the command are mentioned below along with description. Do not keep the square brackets in the final command )

*ansible-playbook createOCCM.yml --extra-vars "AWSAccessKey=[access key] AWSSecretKey=[secret Key] region=us-west-2 instancename=occmTest IAMRole='' refToken=[refresh token string] portalUserName=[portal user mail]"*

* AWSAccessKey: The IP of the Cloud Manager
* AWSSecretKey: The refresh token string
* instancename: the name of the OCCM
* IAMRole: Name of the IAM role to assign [optional]
* refToken: refresh for Cloud Central which was obtained earlier
* portalUserName: Email Address to be associated with Cloud Manager. 


## Create AWS Single Node CVO With Ansible
### Needed variables
* occmIp: the IP of the Cloud Manager
* refToken: the refresh token string

*ansible-playbook createCVO.yml --extra-vars "occmIp=[Cloud Manager IP] refToken=[refresh token string]"*

## Create AWS HA CVO With Ansible
### Needed variables
* occmIp: the IP of the Cloud Manager
* refToken: the refresh token string
* clusterFloatingIP: Cluster floating IP
* dataFloatingIP: First node data IP
* dataFloatingIP2: Second node data IP
* svmFloatingIP: SVM floating IP

**vpc_id, node1SubnetId, node2SubnetId, mediatorSubnetId and key pair need to be set in the playbook**

*ansible-playbook createHA-CVO.yml --extra-vars "occmIp=[Cloud Manager IP] refToken=[refresh token string] clusterFloatingIP=1.1.1.1 dataFloatingIP=2.2.2.2 dataFloatingIP2=3.3.3.3 svmFloatingIP=4.4.4.4"*

## Create Aggregate With Ansible
### Needed variables
* occmIp: The IP of the Cloud Manager
* refToken: The refresh token string
* aggregateName: The name of the aggregate to create
* providerType: The disk type to create [gp2|st1|sc1] 
* diskSize: disk size to create in TB [1|2|4|8|16]

*ansible-playbook createAggregate.yml --extra-vars "occmIp=[Cloud Manager IP] refToken=[refresh token string] aggregateName=aggr2 providerType=gp2 diskSize=1"*

## Create Volume With Ansible
### Needed variables
* occmIp: The IP of the Cloud Manager
* refToken: The refresh token string
* volName: The name of the volume to create
* providerType: The disk type for the volume [gp2|st1|sc1] 
* volSize: The size of the volume in GB [1|2|4|8|16]

*ansible-playbook createVolume.yml --extra-vars "occmIp=[Cloud Manager IP] refToken=[refresh token string] volName=kuku providerType=gp2 volSize=100"*

## Authors

* **TLV DevOps Team** - *Initial work* 


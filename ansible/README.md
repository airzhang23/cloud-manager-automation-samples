
# Samples for Ansible and Cloud Manager

## Get your refresh token
Go to https://services.cloud.netapp.com/refresh-token

Generate refresh token for CloudManager

## Create OCCM With Ansible
### Needed variables
* AWSAccessKey: The IP of the Cloud Manager
* AWSSecretKey: The refresh token string
* instancename: the name of the OCCM
* IAMRole: Name of the IAM role to assign [optional]
* refToken: The name of the aggregate to create
* IAMRole: The disk type to create [gp2|st1|sc1] 
* portalUserName: disk size to create in TB [1|2|4|8|16]

**_vpc, subnet, key pair, SG, company and Site need to be set in the playbook_**

*ansible-playbook createOCCM.yml --extra-vars 
"AWSAccessKey=[access key] AWSSecretKey=[secret Key] region=us-west-2 instancename=occmTest IAMRole='' refToken=[refresh token string] portalUserName=[portal user mail]"*


## Create AWS CVO With Ansible
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

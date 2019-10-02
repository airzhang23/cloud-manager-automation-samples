
# Samples for Ansible and Cloud Manager

## Get your refresh token
Go to https://services.cloud.netapp.com/refresh-token

Generate refresh token for CloudManager ( You need to have a Cloud Central Account )

## Get/Create Account ID Ansible
### Steps
1. Use the find_account.yml file to Get your account list , File is located under GetCreateAccountID , In case you dont have an Account define it will create your first Account 
2. Need to run the follwing command with extra variables , Do not keep the square bracket in the final command.

*sudo ansible-playbook  find_acount.yml --extra-vars "ApiToken=[Cloud Central Key] AccountName=[Desire New Account Name]"*

* ApiToken: refresh Cloud Central API token that obtain earlier.
* AccountName: In Case you dont have an Account define.

* Example of output : 
    ok: [localhost] => {
        "msg": [
            {
                "accountName": "xoxoxoxo",
                "accountPublicId": "account-xxxxxxx",
                "userRole": "Role-1"
            },
            {
                "accountName": "yoyoyoyo",
                "accountPublicId": "account-yyyyyyy",
                "userRole": "Role-1"
            }
        ]
    }

## Create Cloud Manager (OCCM) With Ansible
### Steps
1. Use the createOCCM.yml file from above. 
1. The file needs to be updated with the following details ( Dont edit anything else)
**vpc, subnet, key pair, security group ( needs to be pre-created in your AWS Account ) , company and site need to be set in the playbook**
**NOTE : OCCM creation flow need to attached to an AccountID , as part of this new flow we must provide a new paramter that called AccountID in the creation command below.
Incase you want to know yout Account ID list or create a New Account ID , need to execute the new Ansible that called found_account.yml see instruction in section # Get Account ID  # section above  **
1. We need to run the following command to create Cloud Manager ( The variables needed for the command are mentioned below along with description. Do not keep the square brackets in the final command )

*ansible-playbook createOCCM.yml --extra-vars "AWSAccessKey=[access key] AWSSecretKey=[secret Key] region=us-west-2 instancename=occmTest IAMRole='' refToken=[refresh token string] portalUserName=[portal user mail] AccountID=[account-xxxxxxx]"*

* AWSAccessKey: The AWS Access Key of the AWS account where you are deploying Cloud Manager 
* AWSSecretKey: The AWS Secret Key of your AWS account 
* instancename: The name you want Cloud Manager instance to have 
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


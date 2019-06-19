# Samples for Terrafrom + Ansible and Cloud Manager
##
## Create OCCM With Terrafrom + Ansible
##
##

### Prerequisites
* Download terrafrom from: https://www.terraform.io/downloads.html
* Follow the instructions and add terraform executable to PATH: https://learn.hashicorp.com/terraform/getting-started/install.html 
* Edit your ~/.aws/credentials and add a terraform section:
  ```terrafrom
  [terraform]
  aws_access_key_id = __id__
  aws_secret_access_key = __key__
  ```
* Install Ansible >2.7 from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
### Madatory variables in terrafrom.tfvars
```terrafrom
#################
# Vars
#################
vpc_id                  = ""                                 # existing vpc id
security_group_id       = ""                                 # existing security group id
subnet_id               = ""                                 # exisring subnet id
instance_id             = "t3.medium"                        # default instance type
key_pair                = ""                                 # name of you key_pair in aws
ansible_provision_file  = "./occm_setup.yaml"                # deafult path to absibel playbook file
refresh_token           = ""                                 # private refresh token of user for CloudManager
client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC" # default auth0 id
portal_user_name        = ""                                 # user email
auth0_domain            = "netapp-cloud-account.auth0.com"   # default auth0 domain
```

### Run Terrafrom 
* cd to the directory and make sure you have all 4 files: 
```terraform
main.tf
occm_setup.yaml
outputs.tf
terraform.tfvars
```
* Run the following commands:
```terrafrom
terraform init
terraform plan
terraform apply
```
* Expected output with be the IP of the instance created with OCCM installed:
```terraform
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

ids = i-006cc7f76ba5abf3d
ip = 34.220.211.115
```

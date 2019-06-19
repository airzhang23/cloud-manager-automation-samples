# Samples for Terraform + Ansible and Cloud Manager
##
## Create OCCM With Terraform + Ansible
##
##

### Prerequisites
* Download terraform from: https://www.terraform.io/downloads.html
* Follow the instructions and add terraform executable to PATH: https://learn.hashicorp.com/terraform/getting-started/install.html 
* Edit your ~/.aws/credentials and add a terraform section:
  ```terraform
  [terraform]
  aws_access_key_id = __id__
  aws_secret_access_key = __key__
  ```
* Install Ansible >2.7 from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
### Edit Mandatory variables in terraform.tfvars
```terraform
############################
# Vars
############################
vpc_id                  = ""                                 # existing vpc id
security_group_id       = ""                                 # existing security group id
subnet_id               = ""                                 # exisring subnet id
key_pair                = ""                                 # name of you key_pair in aws
refresh_token           = ""                                 # private refresh token of user for CloudManager
portal_user_name        = ""                                 # user email
############################
# System Vars - don't change
############################
instance_id             = "t3.medium"                        # default instance type
ansible_provision_file  = "./occm_setup.yaml"                # deafult path to ansibel playbook file
client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC" # default auth0 id - don't change
auth0_domain            = "netapp-cloud-account.auth0.com"   # default auth0 domain - don't change
```

### Run Terraform 
* cd to the directory and make sure you have all 4 files: 
```terraform
main.tf
occm_setup.yaml
outputs.tf
terraform.tfvars
```
* Run the following commands:
```terraform
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

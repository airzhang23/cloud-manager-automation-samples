# Samples for Terraform + Ansible and Cloud Manager
##
## Create OCCM With Terraform + Ansible on GCP
##
##

### Prerequisites
* Download terraform from: https://www.terraform.io/downloads.html
* Follow the instructions and add terraform executable to PATH: https://learn.hashicorp.com/terraform/getting-started/install.html

* Install Ansible >2.7 from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
* Install Ansible GCP extension from: https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html
* Here is an example installtion on Centos 7.5:
  ```terraform
  # curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
  # python get-pip.py
  # pip install ansible==2.7
  # wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
  # unzip terraform_0.11.13_linux_amd64.zip
  # cp terraform /usr/sbin/
  ```   
* Check Ansible and Terraform versions Installed:
  ```terraform
  # ansible --version
    ansible 2.7.0
      config file = None
      configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /bin/ansible
      python version = 2.7.5 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
  # terraform version
  Terraform v0.11.13
  + provider.null v2.1.0      
  ```   

### Madatory variables in terraform.tfvars
* Fill in the empty parameters to setup your environment:
  ```terraform
    ###################################################
    # Vars
    ###################################################
    gcp_json_auth_path      = ""                                 # path to gcp json authentication file 
    zone_id                 = ""                                 # gcp zone
    region_id               = ""                                 # gcp region
    project_id              = ""                                 # gcp project
    ###################################################
    project_occm            = "tlv-automation"                   # occm project name on GCP
    family_occm             = "cloudmanager"                     # occm family name on GCP    
    machine_type            = "n1-standard-2"                    # compute instance type
    ###################################################
    ansible_provision_file  = "./occm_setup.yaml"                # path to ansible playbook file
    refresh_token           = ""                                 # private refresh token                               
    client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC" # default auth0 id
    portal_user_name        = ""                                 # user email
    auth0_domain            = "netapp-cloud-account.auth0.com"   # default auth0 domain
  ```
### New Resources vs. Existing Resources (use_existing_resources)
* All resources will be created under your GCP project with default Network settings  
* Once all parameters are set and verified continue to Run Terraform step

### Run Terraform 
* cd to the directory and make sure you have all 4 files: 
    ```terraform
    ./outputs.tf
    ./main.tf
    ./terraform.tfvars
    ./readme.md
    ```
* Run the following commands:
(In each step carfuly review the instances that are planned and will be created)
    ```terraform
    terraform init
    terraform plan 
    terraform apply
    ```

* Expected output with be the IP of the instance created with OCCM installed:
    ```terraform
    Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    public_ip_address = xx.xx.xx.xx
    ```

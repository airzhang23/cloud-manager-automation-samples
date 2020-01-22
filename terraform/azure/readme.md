# Samples for Terrafrom + Ansible and Cloud Manager
##
## Create OCCM With Terrafrom + Ansible on Azure
##
##

### Prerequisites
* Download terrafrom from: https://www.terraform.io/downloads.html
* Follow the instructions and add terraform executable to PATH: https://learn.hashicorp.com/terraform/getting-started/install.html
* Add the following environoment vairables to set your credentials:
  ```terrafrom
  export ARM_CLIENT_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" && export AZURE_CLIENT_ID=$ARM_CLIENT_ID
  export ARM_CLIENT_SECRET="xxxxxxx" && AZURE_SECRET=$ARM_CLIENT_SECRET && AZURE_SECRET=${AZURE_SECRET//+/%2B} && export AZURE_SECRET=${AZURE_SECRET//=/%3D}
  export ARM_SUBSCRIPTION_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" && export AZURE_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
  export ARM_TENANT_ID="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" && export AZURE_TENANT=$ARM_TENANT_ID
  ```    
* Install Ansible >2.9 from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
* Install Ansible Azure extension from: https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html
* Here is an example installtion on Centos 7.5:
  ```terrafrom
  # curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
  # python get-pip.py
  # pip install ansible==2.9
  # pip install 'ansible[azure]'
  # wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
  # unzip terraform_0.11.13_linux_amd64.zip
  # cp terraform /usr/sbin/
  ```   
* Check Ansible and Terraform versions Installed:
  ```terrafrom
  # ansible --version
    ansible 2.9.2
      config file = None
      configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python3.6/site-packages/ansible
      executable location = /bin/ansible
      python version = 3.6.3 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
  # terraform version
  Terraform v0.11.13
  + provider.azurerm v1.23.0
  + provider.null v2.1.0      
  ```   

### Madatory variables in terrafrom.tfvars
* Fill in the empty parameters to setup your environment:
  ```terrafrom
  ###################################################
  # Vars
  ###################################################
  subscription_id         = ""                                 # azure subscription_id where all resources will be created
  ###################################################
  use_existing_resources  = "false"                            # set to true ONLY if you want to use EXISTING ResourceGroup, VitrtualNetawork and Subnet
  resource_group          = ""                                 # azure resource group name where all resources will be created
  location_id             = ""                                 # azure location "East US", "West US" etc.
  virtual_network         = ""                                 # virtual network name
  subnet_id               = ""                                 # virtual network subnet name   
  ###################################################
  image_publisher         = "netapp"                           # image publisher
  image_offer             = "netapp-oncommand-cloud-manager"   # image offer
  image_sku               = "occm-byol"                        # image sku
  image_version           = "latest"                           # image version
  ###################################################
  managed_disk_type       = "Premium_LRS"                      # os root disk type
  vm_admin_user           = ""                                 # admin user name
  vm_admin_password       = ""                                 # admin password
  instance_type           = "Standard_DS1_v2"                  # instance type             
  ###################################################
  ansible_prerequisites   = "./check_az_rg.yaml"               # default path to ansible prerequisites file
  ansible_provision_file  = "./occm_setup.yaml"                # deafult path to absibel playbook file  
  ###################################################
  refresh_token           = ""                                 # private refresh token                               
  client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC" # default auth0 id
  portal_user_name        = ""                                 # user email
  auth0_domain            = "netapp-cloud-account.auth0.com"   # default auth0 domain
  ```
### New Resources vs. Existing Resources (use_existing_resources)
* By default, we set the use_existing_resources parammeter to "false", 
this means that terrafrom will create all NEW resources: Resource Group, Vnet, Subnet, NIC, PublicIP, Security Group, VM, Disk
* If you want OCCM resources to be created in an existing Resource Group under a given Vnet and Subnet you can set use_existing_resources=true and provide existing names for these resources (resource_group, virtual_network, subnet_id)
* Once all parameters are set and verified continue to Run Terrafrom step

### Run Terrafrom 
* cd to the directory and make sure you have all 5 files: 
    ```terrafrom
    ./outputs.tf
    ./main.tf
    ./terraform.tfvars
    ./readme.md
    ./check_az_rg.yaml
    ```
* Run the following commands:
(In each step carfuly review the instances that are planned and will be created)
    ```terrafrom
    terrafrom init
    terrafrom plan 
    terrafrom apply
    ```

* Expected output with be the IP of the instance created with OCCM installed:
    ```terrafrom
    Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    public_ip_address = xx.xx.xx.xx
    ```

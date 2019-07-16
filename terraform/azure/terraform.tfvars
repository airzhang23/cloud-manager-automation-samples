###################################################
# Vars
###################################################
subscription_id         = ""                                             # azure subscription_id where all resources will be created
###################################################
use_existing_resources  = "false"                                        # set to true ONLY if you want to use EXISTING ResourceGroup, VitrtualNetawork and Subnet
resource_group          = ""                                             # azure resource group name where all resources will be created
location_id             = ""                                             # azure location "East US", "West US" etc.
virtual_network         = ""                                             # virtual network name
subnet_id               = ""                                             # virtual network subnet name   
###################################################
image_publisher         = "netapp"                                       # image publisher
image_offer             = "netapp-oncommand-cloud-manager"               # image offer
image_sku               = "occm-byol"                                    # image sku
image_version           = "latest"                                       # image version
###################################################
managed_disk_type       = "Premium_LRS"                                  # os root disk type
vm_admin_user           = ""                                             # admin user name
vm_admin_password       = ""                                             # admin password
instance_type           = "Standard_DS1_v2"                              # instance type             
###################################################
ansible_prerequisites   = "./check_az_rg.yaml"                           # default path to ansible prerequisites file
ansible_provision_file  = "../../ansible/OCCM/occm_setup.yaml"           # deafult path to absibel playbook file  
###################################################
refresh_token           = ""                                             # private refresh token                               
client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC"             # default auth0 id
portal_user_name        = ""                                             # user email
auth0_domain            = "netapp-cloud-account.auth0.com"               # default auth0 domain

#################
# Vars
#################
vpc_id                  = ""                                 # existing vpc id
security_group_id       = ""                                 # existing security group id
subnet_id               = ""                                 # exisring subnet id
instance_id             = "t3.medium"                        # default instance type
key_pair                = ""                                 # name of you key_pair in aws
ansible_provision_file  = "./occm_setup.yaml"                # deafult path to absibel playbook file
refresh_token           = ""                                 # private refresh token
client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC" # defailt auth0 id
portal_user_name        = ""                                 # user email
auth0_domain            = "netapp-cloud-account.auth0.com"   # defailt auth0 domain
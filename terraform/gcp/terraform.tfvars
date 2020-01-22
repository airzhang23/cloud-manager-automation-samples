###################################################
# Vars
###################################################
gcp_json_auth_path      = ""                                             # GCP authentication json
zone_id                 = ""                                             # GCP zone
region_id               = ""                                             # GCP region 
project_id              = ""                                             # GCP project
###################################################
project_occm            = "netapp-cloudmanager"                          # occm project name on GCP 
family_occm             = "cloudmanager"                                 # occm family name on GCP
machine_type            = "n1-standard-2"                                # instance type
###################################################
ansible_provision_file  = "../../ansible/OCCM/occm_setup.yaml"           # deafult path to absibel playbook file 
refresh_token           = ""                                             # private refresh token                               
client_id               = "Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC"             # default auth0 id
portal_user_name        = ""                                             # user email
auth0_domain            = "netapp-cloud-account.auth0.com"               # default auth0 domain

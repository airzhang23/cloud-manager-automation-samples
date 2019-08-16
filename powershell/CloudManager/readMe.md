# OCCM Deployer for Azure

This tool can be used to deploy On Command Cloud Manager in your Azure account

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

The following should be installed on the machine before running the script:

```
Azure Power Shell
```

### Configuration

Configure the following files under config directory, verify the correct details before running the script

```
occm-parameters.json
CloudmanagerDeploy.ps1
```

## Running the Deployment


You should have the following parameters in order to deploy:

* Azure tenant ID
* Azure subscription ID
* Azure application ID
* Azure application key
* Refer to the following instructions on how to create a service principal and adquire these keys and IDs
  [Setting up and adding Azure accounts to Cloud Manager](https://docs.netapp.com/us-en/occm/task_adding_cloud_accounts.html#azure)
* The required permissions are the Azure Marketplace permissions found on the [Support Site](https://mysupport.netapp.com/info/web/ECMP11022837.html) plus these additional permissions:
```

	"Microsoft.Resources/deployments/validate/action",
	“Microsoft.Compute/virtualMachines/extensions/write”,
	“Microsoft.Network/publicIpAddresses/write”,
        “Microsoft.Network/publicIpAddresses/read”,
        “Microsoft.Network/publicIPAddresses/join/action”,
        “Microsoft.Compute/virtualMachines/extensions/read”  

 ```
* Email of user registered to [NetApp Cloud Central](https://cloud.netapp.com)
* OCCM Refresh token of the user Go to https://services.cloud.netapp.com/refresh-token
  Generate refresh token for CloudManager ( You need to have a Cloud Central Account )




Follow the following steps in order to run the deployment

Open PowerShell terminal and Run the deploy script:

```
./CloudmanagerDeploy.ps1
```

it may take around 6 minutes to complete and you will see the following output once done

```
...
######  Creating resource group 'RG_NAME'  ######                                                                                                                                                        Account                              SubscriptionName TenantId                             Environment
-------                              ---------------- --------                             -----------

######  The Cloud Manager IP is: x.x.x.x ######
Waiting for OCCM: x.x.x.x to be up...
OCCM in IP address x.x.x.x is up
Registering OCCM
Client ID is:xxxxxxxxxxxxxxxxxxx
Getting token from auth0
Calling init

upgradeToVersion : x.x.x Build x

```

## Authors

* **TLV DevOps Team** - *Initial work*

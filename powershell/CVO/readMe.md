# CVO Deployer for Azure

This tool can be used to deploy HA CVO in your Azure account

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

The following should be installed on the machine before running the script:

```
Azure Power Shell
```

```
Cloud Manager Up and Running
```

### Configuration

Configure the following files under CVO directory, verify the correct details before running the script

```
templates/AzureHA.json
CreateAzureHACVO.ps1
```

## Running the Deployment


You should have the following parameters in order to deploy:

* Azure subscription ID
* CVO Name
* OCCM Refresh token of the user Go to https://services.cloud.netapp.com/refresh-token
  Generate refresh token for CloudManager ( You need to have a Cloud Central Account )
* CloudManager IP Address



Follow the following steps in order to run the deployment

Open PowerShell terminal and Run the deploy script:

```
./CreateAzureHACVO.ps1
```

it may take around 6 minutes to complete and you will see the following output once done

```
...
####  The Cloud Manager IP is: 104.41.142.5 ######
Waiting for OCCM: 1.1.1.1 to be up...
OCCM in IP address 1.1.1.1 is up
...
OCCM is UP and Ready
Getting token from auth0
Token = Bearer xxxxxxxxx
Getting Workspace ID
tenantId = workspace-IDz6Nnwl
Creating CVO CvoTest
publicId = VsaWorkingEnvironment-EjIBnamV
request_id = zPOFVOTh
Status is: Received, Action Create CVO is still in progress... - Counter: 1
Status is: Received, Action Create CVO is still in progress... - Counter: 2
Status is: Received, Action Create CVO is still in progress... - Counter: 3
...
Status is: Received, Action Create CVO is still in progress... - Counter: 23
Status is: Received, Action Create CVO is still in progress... - Counter: 24
Action Create CVO completed successfully, Status is: Success

```

## Authors

* **TLV DevOps Team** - *Initial work*

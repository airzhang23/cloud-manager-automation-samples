param
(
  [parameter(Mandatory=$false, HelpMessage="Azure Subscription ID")]
  [string]$SubscriptionId="xxxxxxx-xxxxxxx-xxxx-xxxxxxxxxxxx",

  [parameter(Mandatory=$false, HelpMessage="Azure Tenant ID in which to create the vhd")]
  [string]$TenantId="xxxxxxx-xxxxxxx-xxxx-xxxxxxxxxxxx",

  [parameter(Mandatory=$false, HelpMessage="Azure Application ID for login")]
  [string]$ApplicationId="xxxxxxx-xxxxxxx-xxxx-xxxxxxxxxxxx",

  [parameter(Mandatory=$false, HelpMessage="Azure application key")]
  [string]$ApplicationKey="xxxxxxx-xxxxxxx-xxxx-xxxxxxxxxxxx",

  [parameter(Mandatory=$false, HelpMessage="Azure location")]
  [string]$Location="East US",

  [parameter(Mandatory=$false, HelpMessage="Resource Group Name")]
  [string]$ResourceGroupName="RG_TEST",

  [parameter(Mandatory=$false, HelpMessage="Resource Group Name")]
  [string]$refToken="xxxxxxxxxxxxxxxxxxxxxx",

  [parameter(Mandatory=$false, HelpMessage="Resource Group Name")]
  [string]$company="Company",

  [parameter(Mandatory=$false, HelpMessage="Resource Group Name")]
  [string]$site="Site",

  [parameter(Mandatory=$false, HelpMessage="Resource Group Name")]
  [string]$PortalUserName="email@company.com"

)
import-Module azure
Import-Module Az
$secApplicationKey = ConvertTo-SecureString $ApplicationKey -AsPlainText -Force
$secureCredential = New-Object System.Management.Automation.PSCredential($ApplicationId, $secApplicationKey)
Connect-AzAccount -ServicePrincipal -Credential $secureCredential -Tenant $TenantId -SubscriptionId $SubscriptionId -ErrorAction Stop

if((Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue) -ne $null) {throw ("Resource group " + $resourceGroupName + " already exists.")}

Write-Host ("######  Creating resource group '" + $ResourceGroupName + "'  ######")
New-AzResourceGroup -Name $ResourceGroupName -Location $location

New-AzResourceGroupDeployment -Name "OccmDeploy" -ResourceGroupName $ResourceGroupName -TemplateParameterFile "occm-parameters.json" -TemplateFile "occm-template.json"

$publicIpAddressName = (Get-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName).Outputs.publicIpAddressName.Value

$occmIP = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $publicIpAddressName).IpAddress

Write-Host ("######  The Cloud Manager IP is: $occmIP ######")

Write-Host ("Waiting for OCCM: $occmIP to be up...")
		$timeoutSeconds = 6*60 #6 minutes
		$wait = $true
		$occmStatus = @()

		while($wait -and $timeoutSeconds -gt 0)
		{
			$wait = $false
			$httpAddress = "http://" + $occmIP + "/occm/api/occm/system/about"
			try{
				$request = Invoke-WebRequest -method GET -Uri $httpAddress
				if(!$request){
					if($request.StatusCode -ne 200) {
						Write-Host "OCCM IP address $occmIP is not up yet"
						$wait = $true
						$timeoutSeconds -= 40
						start-sleep -s 40
					}
				} else {
				Write-Host "OCCM in IP address $occmIP is up"
        Write-Host "$request"
				}
			}
			catch {
					Write-Host "OCCM in IP address $occmIP is not up yet"
					$wait = $true
					$timeoutSeconds -= 40
					start-sleep -s 40
			}

		}
		if ($timeoutSeconds -le 0){
			Write-Host "OCCM in IP address $occmIP is down"
      throw ("OCCM in IP address " + $occmIP + " failed to start.")
		}

Write-Host ("Registering OCCM")
$registerResponse = Invoke-WebRequest -method POST -Uri "http://$occmIP/occm/api/occm/setup-portal/register"
$jsonObj = ConvertFrom-Json $([String]::new($registerResponse.Content))
$clientId = $jsonObj.clientId
write-host ("Client ID is: $clientId")

Write-Host ("Getting token from auth0")

$body = @{
 "grant_type"="refresh_token"
 "refresh_token"="$refToken"
 "client_id"="Mu0V1ywgYteI6w1MbD15fKfVIUrNXGWC"
} | ConvertTo-Json

$header = @{
 "Accept"="application/json"
 "Content-Type"="application/json"
}

$tokenResponse = Invoke-RestMethod -Uri "https://netapp-cloud-account.auth0.com/oauth/token" -Method 'Post' -Body $body -Headers $header

$token=$tokenResponse.token_type + " " + $tokenResponse.access_token

Write-Host ("Token = $token")

Write-Host ("Calling init")

$initHeader = @{
 "Accept"="application/json"
 "Content-Type"="application/json"
 "Authorization"="$token"
}

$initBody = '{"adminUser":{"email":"' + $PortalUserName + '"},"site":"' + $site + '","company":"' + $company + '"}'

Invoke-RestMethod -Uri "http://$occmIP/occm/api/occm/setup-portal/init" -Method 'Post' -Body $initBody -Headers $initHeader

Write-Host ("OCCM is UP and Ready")

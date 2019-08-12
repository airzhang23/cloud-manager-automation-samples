param
(
  [parameter(Mandatory=$false, HelpMessage="CVO Name")]
  [string]$cvoName="CvoTest",

  [parameter(Mandatory=$false, HelpMessage="Refresh token of Cloud Manager")]
  [string]$refToken="XXXXXXXXXXXXXXXXXXXXXXXXXXXX",

  [parameter(Mandatory=$false, HelpMessage="OCCM IP")]
  [string]$occmIP="1.1.1.1",

  [parameter(Mandatory=$false, HelpMessage="AggrName")]
  [string]$aggrName="aggr2",

  [parameter(Mandatory=$false, HelpMessage="Disk Type")]
  [string]$diskType="Premium_LRS",

  [parameter(Mandatory=$false, HelpMessage="Number of Disk")]
  [string]$numOfDisks="1",

  [parameter(Mandatory=$false, HelpMessage="Home Node")]
  [string]$homeNode="1"

)

Import-module .\func.ps1 -Force

waitForOCCM $occmIP

$token = getToken $refToken

Write-Host ("Token = $token")

Write-Host ("Getting Working environment ID")

$initHeader = @{
 "Accept"="application/json"
 "Content-Type"="application/json"
 "Authorization"="$token"
 "Referer"="pwsh"
}

$wes = (Invoke-RestMethod -Uri "http://$occmIP/occm/api/azure/ha/working-environments?fields=status" -Method 'GET' -Headers $initHeader)

$we = $wes| Where-Object { $_.name -eq $cvoName }

#Write-Host ("we details= " + $we)

Write-Host ("WE ID= " + $we.publicId)
Write-Host ("WE Status = " + $we.status.status)

if ($we.status.status -ne "ON"){
  Write-Host ("The status of the machine is " + $we.status.status + ", Can't create aggregate") -ForegroundColor Yellow
  exit
}

$aggr_request = (Get-Content -Raw -Path ./templates/Aggregate.json | ConvertFrom-Json)

# UPDATE REQUEST PARAMS

$aggr_request.workingEnvironmentId = $we.publicId
$aggr_request.name = $aggrName
$aggr_request.homeNode = $cvoName + "-" + $homeNode
$aggr_request.numberOfDisks = $numOfDisks

$createBody = ($aggr_request | ConvertTo-Json)

Write-Host ("Creating Aggregate " + $aggrName)
Write-Host ("$createBody")

$request = (Invoke-WebRequest -Uri "http://$occmIP/occm/api/azure/ha/aggregates" -Method 'POST' -Body $createBody -Headers $initHeader)
#$request

$oncloud_request_id = $request.Headers."OnCloud-Request-Id"
Write-Host ("request_id = " + $oncloud_request_id)

waitForAction $oncloud_request_id "Create Aggregate" 30 10

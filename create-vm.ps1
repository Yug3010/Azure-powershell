Write-Host "Starting VM creation process..."

# Ensure Az module is available
Import-Module Az.Accounts

# Manually authenticate using environment variables
$clientId       = $env:AZURE_CLIENT_ID
$clientSecret   = $env:AZURE_CLIENT_SECRET
$tenantId       = $env:AZURE_TENANT_ID
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID

$secureClientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$azCred = New-Object System.Management.Automation.PSCredential($clientId, $secureClientSecret)

Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $azCred -Subscription $subscriptionId -ErrorAction Stop

# VM Parameters
$resourceGroup = "PSAutomationRG"
$location = "EastUS"
$vmName = "PSAutoVM"
$vmSize = "Standard_DS1_v2"
$adminUsername = "yugsutariya"
$adminPassword = ConvertTo-SecureString "Yugsutariya@3010" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

# Create resource group
Write-Host "Creating resource group..."
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create VM
Write-Host "Creating virtual machine..."
New-AzVM `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Location $location `
  -VirtualNetworkName "$vmName-VNet" `
  -SubnetName "$vmName-Subnet" `
  -SecurityGroupName "$vmName-NSG" `
  -PublicIpAddressName "$vmName-PublicIP" `
  -Credential $cred `
  -Image "Win2019Datacenter" `
  -Size $vmSize

Write-Host "✅ Virtual Machine $vmName created successfully in $resourceGroup."

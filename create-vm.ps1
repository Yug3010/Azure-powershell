Write-Host "Starting VM creation process..."

# Ensure Az module is available
Import-Module Az.Accounts

# Parse Azure credentials from environment variable
$azureJson = $env:AZURE_CREDENTIALS | ConvertFrom-Json
$clientId = $azureJson.clientId
$clientSecret = $azureJson.clientSecret
$tenantId = $azureJson.tenantId

# Convert client secret to secure string
$secureClientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force

# Create a PSCredential object for service principal
$psCredential = New-Object System.Management.Automation.PSCredential($clientId, $secureClientSecret)

# Connect to Azure using the service principal
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $psCredential

# Verify connection
$currentContext = Get-AzContext
if (-not $currentContext) {
    Write-Error "❌ Not connected to Azure. Aborting script."
    exit 1
}

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

Write-Host "Starting VM creation process..."

# Ensure Az module is available
Import-Module Az.Accounts

# Check Azure connection
$currentContext = Get-AzContext
if (-not $currentContext) {
    Write-Error "Not connected to Azure. Aborting script."
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

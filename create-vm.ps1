Write-Host "Starting VM creation process..."

# Import Azure context from GitHub Actions login
Import-AzContext -ErrorAction Stop

# Check if connected to Azure
$context = Get-AzContext
if (-not $context) {
    Write-Error "Not connected to Azure. Aborting script."
    exit 1
}

# Parameters
$resourceGroup = "PSAutomationRG"
$location = "EastUS"
$vmName = "PSAutoVM"
$vmSize = "Standard_DS1_v2"
$adminUsername = "yugsutariya"
$adminPassword = ConvertTo-SecureString $env:VM_ADMIN_PASSWORD -AsPlainText -Force

# Create resource group
Write-Host "Creating resource group..."
New-AzResourceGroup -Name $resourceGroup -Location $location -Force

# Create VM credentials
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

# Create virtual machine
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

Write-Host "Virtual Machine $vmName created successfully in $resourceGroup."

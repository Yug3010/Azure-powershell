# Variables
$resourceGroup = "MyResourceGroup"
$location = "EastUS"
$vmName = "AutoVM01"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create VM
$cred = Get-Credential
New-AzVM -Name $vmName -ResourceGroupName $resourceGroup -Location $location -Credential $cred


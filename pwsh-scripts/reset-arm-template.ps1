# $resourceGroup = Read-Host -Prompt 'Input your Resource Name Group'
$resourceGroup = 'TrainingResource'
# $name = Read-Host -Prompt 'Input resource name to remove'
$name = 'clemyking'
Write-Host "Resetting Resources: " $name

$vm = Get-AzVM `
  -Name $name"-vm" `
  -ResourceGroupName $resourceGroup `
  | Remove-AzVm -Force

Remove-AzNetworkInterface `
  -ResourceGroup $resourceGroup `
  -Name $name"-nin" `
  –Force

Get-AzDisk `
  -ResourceGroupName $resourceGroup `
  -DiskName $vm.StorageProfile.OSDisk.Name `
  | Remove-AzDisk -Force

Get-AzVirtualNetwork `
  -ResourceGroup $resourceGroup `
  -Name $name"-vnet" `
  | Remove-AzVirtualNetwork -Force

Get-AzNetworkSecurityGroup `
  -ResourceGroup $resourceGroup `
  -Name $name"-nsg" `
  | Remove-AzNetworkSecurityGroup -Force

Get-AzPublicIpAddress `
  -ResourceGroup $resourceGroup `
  -Name $name"-ip" `
  | Remove-AzPublicIpAddress -Force

Get-AzStorageAccount `
  -ResourceGroup $resourceGroup `
  -Name $name"diagstorage" `
  | Remove-AzStorageAccount -Force

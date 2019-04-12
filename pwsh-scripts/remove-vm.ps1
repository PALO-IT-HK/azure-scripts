$resourceGroup = Read-Host -Prompt 'Input your Resource Name Group'
$vmName = Read-Host -Prompt 'Input VM name to remove'
Write-Host "Removing VM: " $vmName

$vm = Get-AzVM `
  -Name $vmName `
  -ResourceGroupName $resourceGroup

Remove-AzVm `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Force

Remove-AzNetworkInterface `
  -ResourceGroup $resourceGroup `
  -Name $vmName"VMNic" `
  –Force

Get-AzDisk `
  -ResourceGroupName $resourceGroup `
  -DiskName $vm.StorageProfile.OSDisk.Name `
  | Remove-AzDisk -Force

Get-AzVirtualNetwork `
  -ResourceGroup $resourceGroup `
  -Name $vmName"VNET" `
  | Remove-AzVirtualNetwork -Force

Get-AzNetworkSecurityGroup `
  -ResourceGroup $resourceGroup `
  -Name $vmName"NSG" `
  | Remove-AzNetworkSecurityGroup -Force

Get-AzPublicIpAddress `
  -ResourceGroup $resourceGroup `
  -Name $vmName"PublicIP" `
  | Remove-AzPublicIpAddress -Force

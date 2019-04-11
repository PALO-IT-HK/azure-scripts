$resourceGroup = Read-Host -Prompt 'Input your Resource Name Group'
$vmName = Read-Host -Prompt 'Input VM name to remove'
Write-Host "Removing VM: " $vmName

$vm = Get-AzVM `
  -Name $vmName `
  -ResourceGroupName $resourceGroup

$job = Remove-AzVm `
  -ResourceGroupName $resourceGroup `
  -Name $vmName
$job
Wait-Job -Id $job.Id

$vm | Remove-AzNetworkInterface –Force

Get-AzDisk `
  -ResourceGroupName $resourceGroup `
  -DiskName $vm.StorageProfile.OSDisk.Name `
  | Remove-AzDisk -Force

Get-AzVirtualNetwork `
  -ResourceGroup $resourceGroup `
  -Name $vmName `
  | Remove-AzVirtualNetwork -Force

Get-AzNetworkSecurityGroup `
  -ResourceGroup $resourceGroup `
  -Name $vmName `
  | Remove-AzNetworkSecurityGroup -Force

Get-AzPublicIpAddress `
  -ResourceGroup $resourceGroup `
  -Name $vmName `
  | Remove-AzPublicIpAddress -Force

param(
  [string] $resourceGroup
)

For ($i = 1; $i -lt 3; $i++)
{
  $vmName = "ConferenceDemo" + $i
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
}

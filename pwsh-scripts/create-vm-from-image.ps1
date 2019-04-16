$vmName = Read-Host -Prompt 'Input your VM name'
$rgName = Read-Host -Prompt 'Input your Resource Group Name'
$location = "eastasia"
$imageName = $vmName"ImageFromVM"

New-AzVm `
  -ResourceGroupName $rgName `
  -Name $vmName"FromImage" `
  -ImageName $imageName `
  -Location "eastasia" `
  -VirtualNetworkName $imageName"Vnet" `
  -SubnetName $imageName"Subnet" `
  -SecurityGroupName $imageName"NSG" `
  -PublicIpAddressName $imageName"PIP" `
  -OpenPorts 3389

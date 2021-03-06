$json = (Get-Content -Raw -path './pwsh-scripts/vmfromimg-params.json' | Out-String | ConvertFrom-Json)

$vmName = $json.vmName
$rgName = $json.rgName
$location = $json.location
$imageName = $json.imageName
$User = $json.User
$Password = ConvertTo-SecureString $json.Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

$User = $json.vmUser
$Password = ConvertTo-SecureString $json.vmPassword -AsPlainText -Force
$vmCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

New-AzVm `
  -Credential $Credential `
  -ResourceGroupName $rgName `
  -Name $vmName `
  -ImageName $imageName `
  -Location $location `
  -VirtualNetworkName $vmName"VNET" `
  -SubnetName $vmName"Subnet" `
  -SecurityGroupName $vmName"NSG" `
  -PublicIpAddressName $vmName"PIP" `
  -OpenPorts 3389

Set-AzVMAccessExtension `
  -ResourceGroupName $rgName `
  -Location $location `
  -VMName $vmName `
  -Credential $vmCredential `
  -typeHandlerVersion "2.0" `
  -Name VMAccessAgent

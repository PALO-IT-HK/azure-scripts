$vmName = Read-Host -Prompt 'Input your VM name'
$rgName = Read-Host -Prompt 'Input your Resource Group Name'
$location = "eastasia"
$imageName = $vmName"ImageFromMD"

$vm = Get-AzVm `
  -Name $vmName `
  -ResourceGroupName $rgName

$diskID = $vm.StorageProfile.OsDisk.ManagedDisk.Id

$imageConfig = New-AzImageConfig `
  -Location $location

$imageConfig = Set-AzImageOsDisk `
  -Image $imageConfig `
  -OsState Generalized `
  -OsType Windows `
  -ManagedDiskId $diskID

New-AzImage `
  -ImageName $imageName `
  -ResourceGroupName $rgName `
  -Image $imageConfig

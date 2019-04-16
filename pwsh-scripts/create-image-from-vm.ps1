$vmName = Read-Host -Prompt 'Input your VM name'
$rgName = Read-Host -Prompt 'Input your Resource Group Name'
$location = "eastasia"
$imageName = $vmName"ImageFromVM"

Stop-AzVM `
  -ResourceGroupName $rgName `
  -Name $vmName -Force

Set-AzVm `
  -ResourceGroupName $rgName `
  -Name $vmName `
  -Generalized

$vm = Get-AzVM `
  -Name $vmName `
  -ResourceGroupName $rgName

$image = New-AzImageConfig `
  -Location $location `
  -SourceVirtualMachineId $vm.Id

New-AzImage `
  -Image $image `
  -ImageName $imageName `
  -ResourceGroupName $rgName

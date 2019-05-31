$json = (Get-Content -Raw -path './pwsh-scripts/goldenimg-params.json' | Out-String | ConvertFrom-Json)
$vmName = $json.vmName
$rgName = $json.rgName
$location = $json.location
$imageName = $json.imageName

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
  -SourceVirtualMachineId $vm.Id `
  -ZoneResilient

New-AzImage `
  -Image $image `
  -ImageName $imageName `
  -ResourceGroupName $rgName

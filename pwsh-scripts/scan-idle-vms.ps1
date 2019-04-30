$resourceGroup = Read-Host -Prompt 'Input your Resource Name Group'
Write-Host "Scanning for Idle VMs..."

$allVMs = (Get-AzVm -ResourceGroupName $resourceGroup)

foreach ($vm in $allVMs) {

  Write-Host "Getting Metrics for "$vm.Id"..."

  $cpudata = (Get-AzMetric `
    -ResourceId $vm.Id `
    -MetricName 'Percentage CPU' `
    -TimeGrain 00:01:00 `
  ).data

  foreach ($cpu in $cpudata) {
    $vm.Name + "-" + $cpu.Average
  }
}

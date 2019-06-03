
write-output "=====Getting CustomScriptExtension====="
Get-AzVMCustomScriptExtension `
  -ResourceGroupName 'GIResource' `
  -VMName 'testwinvm' `
  -Name "DemoScriptExtension" `
  -Status

write-output "=====Removing CustomScriptExtension====="
Remove-AzVMCustomScriptExtension `
  -ResourceGroupName 'GIResource' `
  -VMName 'testwinvm' `
  -Name "DemoScriptExtension"

write-output "=====Setting CustomScriptExtension====="
Set-AzVMCustomScriptExtension `
  -ResourceGroupName 'GIResource' `
  -VMName 'testwinvm' `
  -Location 'japaneast' `
  -FileUri  'https://raw.githubusercontent.com/PALO-IT-HK/azure-scripts/master/pwsh-scripts/install-agent.ps1' `
  -Run '.\install-agent.ps1' `
  -Name 'DemoScriptExtension'

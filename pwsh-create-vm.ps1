$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."
$resourceGroup = Read-Host -Prompt 'Input your Resource Group Name'
$vmName = Read-Host -Prompt 'Input your VM name'
Write-Host "Creating VM: " $vmName

New-AzVm `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Credential $adminCredential `
  -Image UbuntuLTS

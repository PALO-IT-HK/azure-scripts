$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."
$resourceGroup = Read-Host -Prompt 'Input your Resource Group Name'
$vmName = Read-Host -Prompt 'Input your VM name'
Write-Host "Creating VM: " $vmName

New-AzVm `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Credential $adminCredential
  #Win2016Datacenter, Win2012R2Datacenter, Win2012Datacenter, Win2008R2SP1, UbuntuLTS, CentOS, CoreOS, Debian, openSUSE-Leap, RHEL, SLES
  # -Image UbuntuLTS

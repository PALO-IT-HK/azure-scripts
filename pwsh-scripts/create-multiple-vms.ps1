param(
  [string] $resourceGroup
)
$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."

For ($i = 1; $i -lt 3; $i++)
{
  $vmName = "ConferenceDemo" + $i
  Write-Host "Creating VM: " $vmName

  New-AzVm `
    -ResourceGroupName $resourceGroup `
    -Name $vmName `
    -Credential $adminCredential `
    -Image UbuntuLTS
}

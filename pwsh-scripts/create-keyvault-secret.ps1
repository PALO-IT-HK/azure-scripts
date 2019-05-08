$resourceGroup = Read-Host -Prompt 'Input your Resource Group Name'
$vName = Read-Host -Prompt 'Input your Vault Name'
$user = Read-Host -Prompt 'Input your User Display Name'

New-AzKeyVault `
  -Name $vName `
  -ResourceGroupName $resourceGroup `
  -Location 'Japan East'

Set-AzKeyVaultAccessPolicy `
  -VaultName $vName `
  -ObjectId (Get-AzADUser -SearchString $user).Id `
  -PermissionsToKeys backup,create,delete,get,import,list,restore `
  -PermissionsToSecrets get,list,set,delete,backup,restore,recover,purge

$secretvalue = ConvertTo-SecureString "Drop Bears are awesome" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret `
  -VaultName $vName `
  -Name 'Secret' `
  -SecretValue $secretvalue

(Get-AzKeyVaultSecret `
  -vaultName $vName `
  -name "Secret").SecretValueText

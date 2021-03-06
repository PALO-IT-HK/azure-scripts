# $projectNamePrefix = Read-Host -Prompt "Enter a project name:"   # This name is used to generate names for Azure resources, such as storage account name.
$projectNamePrefix = 'clemykinglinked'

# $location = Read-Host -Prompt "Enter a location (i.e. centralus)"
$location = 'japaneast'

# $resourceGroupName = $projectNamePrefix + "rg"
$resourceGroupName = "TrainingResource"
$storageAccountName = $projectNamePrefix + "store"
$containerName = "linkedtemplates" # The name of the Blob container to be created.

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

$storageAccount = Get-AzStorageAccount `
  -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName;

if(!$storageAccount.Id -and $storageAccount.ProvisioningState -eq 'Running') {
  # Create a storage account
  $storageAccount = New-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $location `
    -SkuName "Standard_LRS"

  $context = $storageAccount.Context

  # Create a container
  New-AzStorageContainer -Name $containerName -Context $context
}

$context = $storageAccount.Context

$templateFiles = Get-ChildItem -Path './arm-templates/linked-templates'

foreach ($template in $templateFiles) {
  $fileName = $template.Name
  # Upload the linked template
  $blob = Set-AzStorageBlobContent `
    -Container $containerName `
    -File ./templates/$fileName `
    -Blob $fileName `
    -Context $context

  # Generate a SAS token
  $templateURI = New-AzStorageBlobSASToken `
    -Context $context `
    -Container $containerName `
    -Blob $fileName `
    -Permission r `
    -ExpiryTime (Get-Date).AddHours(8.0) `
    -FullUri

  echo "You need the following values later in the tutorial:"
  echo "Resource Group Name: $resourceGroupName"
  echo "Linked template URI with SAS token: $templateURI"
}

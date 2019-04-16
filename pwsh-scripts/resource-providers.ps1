Get-AzResourceProvider `
  -ListAvailable `
  | Select-Object ProviderNamespace, RegistrationState

Register-AzResourceProvider `
  -ProviderNamespace Microsoft.Batch

Register-AzResourceProvider `
  -ProviderNamespace Microsoft.AzureActiveDirectory

(Get-AzResourceProvider -ProviderNamespace Microsoft.Batch).ResourceTypes.ResourceTypeName

(Get-AzResourceProvider -ProviderNamespace Microsoft.AzureActiveDirectory).ResourceTypes.ResourceTypeName

((Get-AzResourceProvider -ProviderNamespace Microsoft.Batch).ResourceTypes | Where-Object ResourceTypeName -eq batchAccounts).ApiVersions

((Get-AzResourceProvider -ProviderNamespace Microsoft.Batch).ResourceTypes | Where-Object ResourceTypeName -eq batchAccounts).Locations

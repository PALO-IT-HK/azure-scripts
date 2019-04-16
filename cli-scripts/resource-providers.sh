az provider list \
  --query "[].{Provider:namespace, Status:registrationState}" \
  --out table

az provider register \
  --namespace Microsoft.Batch

az provider show \
  --namespace Microsoft.Batch

az provider show \
  --namespace Microsoft.Batch \
  --query "resourceTypes[*].resourceType" \
  --out table

az provider show \
  --namespace Microsoft.Batch \
  --query "resourceTypes[?resourceType=='batchAccounts'].apiVersions | [0]" \
  --out table

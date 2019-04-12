read -p 'Input Resource Group Name: ' resourcegroupvar
read -p 'Input Vault Name: ' vvar
echo "Creating Keyvault: "$vvar

az keyvault create \
  --name $vvar \
  --resource-group $resourcegroupvar \
  --location eastasia

az keyvault secret set \
  --vault-name $vvar \
  --name "Secret" \
  --value "Capybaras are awesome"

az keyvault secret show \
  --name "Secret" \
  --vault-name $vvar

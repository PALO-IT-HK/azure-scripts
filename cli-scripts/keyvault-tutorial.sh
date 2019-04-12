read -p 'Input Resource Group Name: ' resourcegroupvar
read -p 'Input Vault Name: ' vvar
read -p 'Input App Name: ' appvar

az keyvault create \
  --resource-group $resourcegroupvar \
  --name $vvar

az keyvault secret set \
  --name SecretPassword \
  --value reindeer_flotilla \
  --vault-name $vvar

az appservice plan create \
  --name keyvault-exercise-plan \
  --resource-group $resourcegroupvar

az webapp create \
  --plan keyvault-exercise-plan \
  --runtime "node|10.6" \
  --resource-group $resourcegroupvar \
  --name $appvar

az webapp config appsettings set \
  --resource-group $resourcegroupvar \
  --name $appvar \
  --settings 'VaultName='$vvar 'SCM_DO_BUILD_DURING_DEPLOYMENT=true'

az webapp identity assign \
  --resource-group $resourcegroupvar \
  --name $appvar

principalidvar="$(az webapp identity assign \
  --resource-group $resourcegroupvar \
  --name $appvar \
  --query principalId \
  --out tsv \
)"

az keyvault set-policy \
  --secret-permissions get list \
  --name $vvar \
  --object-id $principalidvar

cd apps/nodejs-keyvault-test
zip site.zip * -x node_modules/

az webapp deployment source config-zip \
    --src site.zip \
    --resource-group $resourcegroupvar \
    --name $appvar
cd ..

read -p 'Input Resource Group Name: ' resourcegroupvar
read -p 'Input VM Name: ' vmvar

az vm create \
  -n $vmvar \
  -g $resourcegroupvar \
  --image UbuntuLTS

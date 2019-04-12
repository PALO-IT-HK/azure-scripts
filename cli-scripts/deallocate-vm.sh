read -p 'Input Resource Group Name: ' resourcegroupvar
read -p 'Input VM Name: ' vmvar

az vm deallocate \
  -n $vmvar \
  -g $resourcegroupvar

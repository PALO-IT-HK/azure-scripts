read -p 'Input Resource Group Name: ' resourcegroupvar
read -p 'Input VM Name: ' vmvar
echo "Removing VM: "$vmvar

vmdiskvar="$(
  az vm get-instance-view \
    -n $vmvar \
    -g $resourcegroupvar \
    --query storageProfile.osDisk.name \
)"

az vm delete \
  -n $vmvar \
  -g $resourcegroupvar \
  --yes

az network nic delete \
  -n $vmvar'VMNic' \
  -g $resourcegroupvar

az disk delete \
  -n $vmdiskvar \
  -g $resourcegroupvar

az network vnet delete \
  -n $vmvar'VNET' \
  -g $resourcegroupvar

az network nsg delete \
  -n $vmvar'NSG' \
  -g $resourcegroupvar

az network public-ip delete \
  -n $vmvar'PublicIP' \
  -g $resourcegroupvar

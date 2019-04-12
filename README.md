# AZURE SCRIPTS

##### Prequisites
- [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)
- [Install Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-6)
- [Install Azure Module on Powershell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.7.0)

##### Getting Started with Azure CLI
1. Ensure you are logged into your Azure account
    ```az login```
2. Select your subscription
    ```az account set --subscription <subscriptionID or subscriptionName>```
3. To run CLI Scripts
    ```sh <cli-script>```

##### Getting Started with Azure Powershell Module
1. Ensure you are logged into your Azure account
    ```Login-AzAccount```
2. Select your subscription
    ```Select-AzureSubscription -SubscriptionName <subscriptionID or subscriptionName>```
3. To run Powershell Scripts
    ```pwsh <pwsh-script>```

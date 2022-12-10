
## Create the storage account

⌨️ Bash:

```bash
resourceGroupId=$(az group list \
        --tag owner="$(az account show --query 'user.name' -o tsv)" \
        --query '[].id' \
        -o tsv)

resourceGroupName=$(echo $resourceGroupId | sed 's|.*/||g')

location=$(az group list \
        --tag owner="$(az account show --query 'user.name' -o tsv)" \
        --query '[].location' \
        -o tsv)

suffix=$(echo $resourceGroupName | sed 's/.*-//g')

storageAccountName="sa${suffix}"
az storage account create \
    -n $storageAccountName \
    -g $resourceGroupName \
    -l $location \
    --sku Standard_LRS
```

## Give permissions to the Azure Automation account to access the storage account

⌨️ Bash:

```bash
automationAccountId=$(az automation account list \
    --query "[?resourceGroup=='$resourceGroupName'].id" \
    --output tsv  \
    --only-show-errors)

automationAccountPrincipal=$(az resource show \
    --id $automationAccountId  \
    --query 'identity.principalId' \
    --out tsv)

storageAccountId=$(az storage account show \
    -n $storageAccountName \
    -g $resourceGroupName \
    --query 'id' -o tsv)

az role assignment create \
    --assignee-object-id $automationAccountPrincipal \
    --assignee-principal-type ServicePrincipal \
    --role 'Contributor' \
    --scope $resourceGroupId

az role assignment create \
    --assignee-object-id $automationAccountPrincipal \
    --assignee-principal-type ServicePrincipal \
    --role 'Storage Blob Data Contributor' \
    --scope $storageAccountId

az role assignment create \
    --assignee-object-id $automationAccountPrincipal \
    --assignee-principal-type ServicePrincipal \
    --role 'Reader and Data Access' \
    --scope $storageAccountId
```

## Create the blob container and upload the bicep file

```bash
containerName='template'
 az storage container create \
    -n $containerName \
    --account-name $storageAccountName \
    --auth-mode login

az bicep build -f 'solution/azuredeploy.bicep'

az storage blob upload \
    -f 'solution/azuredeploy.json' \
    -c $containerName \
    -n vm/azuredeploy.json \
    --account-name $storageAccountName \
    --auth-mode key \
    --account-key $(az storage account keys list \
        -n $storageAccountName \
        --query '[0].value' -o tsv)
```
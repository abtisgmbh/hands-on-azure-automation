
The name of the resource group that was created in the preparation section can be found with the following command:

## Deploy to the correct resource group

⌨️ Bash:

```bash
resourceGroupName=$(az group list \
    --tag owner="$(az account show --query 'user.name' -o tsv)" \
    --query '[*].name' \
    -o tsv)
```

⌨️ PowerShell:

```powershell
$resourceGroupName = az group list `
    --tag owner="$(az account show --query 'user.name' -o tsv)" `
    --query '[*].name' `
    -o tsv 
```

## Deploy with the correct name

The recommended Microsoft abbreviation for an Azure Automation account is 'aa'

⌨️ Bash:

```bash
az automation account create \
    -n 'aa-myAutomationAccountTest1' \
    -l 'westeurope' \
    -g $resourceGroupName
```

⌨️ PowerShell:

```powershell
az automation account create `
    -n 'aa-myAutomationAccountTest1' `
    -l 'westeurope' `
    -g $resourceGroupName
```

## Create a runbook that returns 'Hello World'

⌨️ Bash:

```bash
runbookName='lab1'
automationAccountName=$(az automation account list \
    -g $resourceGroupName \
    --only-show-errors \
    --query '[].name' \
    -o tsv)

location=$(az group show -n $resourceGroupName --query 'location' -o tsv)

 az automation runbook create \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --type "PowerShell" \
    --only-show-errors \
    --location $location

az automation runbook replace-content \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --only-show-errors \
    --content 'Write-Output "Hello World"'

az automation runbook publish \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --only-show-errors
```

⌨️ PowerShell:

```powershell
$runbookName = 'lab1'
$automationAccountName = az automation account list `
    -g $resourceGroupName `
    --only-show-errors `
    --query '[].name' `
    -o tsv

$location = az group show -n $resourceGroupName --query 'location' -o tsv

 az automation runbook create `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --type "PowerShell" `
    --only-show-errors `
    --location $location

az automation runbook replace-content `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --only-show-errors `
    --content 'Write-Output "Hello World"'

az automation runbook publish `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --only-show-errors
```


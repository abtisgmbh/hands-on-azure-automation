# Preparation

The first steps that pave the ground for the following labs.

## Requirements

- Ability to connect to an Azure subscription
- Permissions to create resources in this subscription

## Tasks

### Connect Azure CLI to your tenant

```bash
az login --tenant '{tenant id}'
```

### Create a resource group

Create resource group with a unique name. And create the following tags on the resource group:

```yaml
purpose: 'abtis Workshop'
owner: 'Your user's email address'
```

Running the following bicep file will create these tags and add a unique string based on the currently logged on user's account name to the resource group name:

⌨️ Bash:

```bash
resourceGroupName=$(az deployment sub create \
  -f labs/0-preparation/azuredeploy.bicep \
  -l westeurope \
  -p userName=$(az account show --query 'user.name' -o tsv) \
  --query 'properties.outputs.resourceGroupName.value' \
  -o tsv)
```

⌨️ PowerShell:

```powershell
$resourceGroupName = az deployment sub create `
  -f 'labs/0-preparation/azuredeploy.bicep' `
  -l 'westeurope' `
  -p "userName=$(az account show --query 'user.name' -o tsv)" `
  --query 'properties.outputs.resourceGroupName.value' `
  -o tsv
```

### Use Pester to check if everything was done correctly

⌨️ Bash:

```bash
pwsh -c 'Invoke-Pester -Output Detailed'
```

⌨️ PowerShell:

```powershell
Invoke-Pester -Output Detailed
```
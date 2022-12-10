# Preparation

The first steps that pave the ground for the following labs.

Connect Azure CLI to your tenant:

```bash
az login --tenant '{tenant id}'
```

Create resource group with a unique name. Running the following bicep file will add a unique string based on the currently logged on user's account name to the resource group name:

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

# Use Pester to see lab results

⌨️ Bash:

```bash
pwsh -c 'Invoke-Pester -Output Detailed'
```

⌨️ PowerShell:

```powershell
Invoke-Pester -Output Detailed
```
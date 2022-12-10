# Ensures you do not inherit an AzContext in your runbook
$null = Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# Assumes that there is only one automation account visible to this Managed Identity
$resourceId = Get-AzResource | 
	Where-Object ResourceType -eq 'Microsoft.Automation/automationAccounts' |
	Select-Object -ExpandProperty ResourceId

Write-Output $resourceId
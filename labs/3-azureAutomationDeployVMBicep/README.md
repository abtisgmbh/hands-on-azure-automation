# Lab 3 

Use an Automation Runbook to deploy a Azure Virtual Machine with bicep.

## Requirements

- The steps in [Lab 1](../1-azureAutomationAccount/README.md) have been completed: The automation account that was deployed in the previous lab exits.
- The steps in [Lab 2](../2-azureAutomationIdentity/README.md) have been completed: The automation account has a system assigned managed identity.

## Tasks

- Assign the `Contributor` Role to the managed identity of the automation account on the resource group to which it was deployed. (This requires owner permissions on the subscription)
- Create a storage account and give the `Blob Data Owner` and `Reader and Data Access` roles to the managed identity of the Azure Automation account
- Create a blob container named `bicep`
- Upload a bicep file that creates a virtual machine to the `bicep` container and call it `vm/azuredeploy.bicep` 
- Create a runbook named 'lab3' that uses the managed identity to connect to Azure
- The runbook should use the bicep file from the blob storage to deploy the virtual machine
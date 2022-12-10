# Lab 4

Use an Azure Logic App to orchstrate a VM deployment with Azure Automation.

## Requirements

- The steps in [Lab 1](../1-azureAutomationAccount/README.md) have been completed: The automation account that was deployed in the previous lab exits.
- The steps in [Lab 2](../2-azureAutomationIdentity/README.md) have been completed: The automation account has a system assigned managed identity.
- The steps in [Lab 3](../3-azureAutomationDeployVMBicep/README.md) have been completed: The "lab3" runbook was created, that deployes a linux vm.

## Tasks

- Create a Logic App that Starts the lab3 runbook and waits for the job to end.
- Activate System Assigned Managed Identity on the Logic App
- Assign the role `Automation Job Operator` and `Automation Runbook Operator` to the Logic App on the Automation Account

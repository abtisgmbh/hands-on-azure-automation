# Lab 2

Login to Azure from an Azure Automation account using a Managed Identity.

## Requirements

- The steps in [Lab 1](../1-azureAutomationAccount/README.md) have been completed: The automation account that was deployed in the previous lab exits.

## Tasks

- Activate a System Assigned Managed Identity for the Automation Account
- Give it the `Reader` Role on the resource group to which it was deployed. (This requires owner permissions on the subscription)
- Create a runbook named 'lab2' that uses the managed identity to connect to Azure
- The runbook should return the resource id of the Azure Automation Account


Run `Invoke-pester -Output Detailed` to check, if you have completed the lab.

## Solution

[See here for the solution](solution.md).
BeforeAll {
    $resourceGroupName = az group list `
        --tag owner="$(az account show --query 'user.name' -o tsv)" `
        --query '[].name' `
        -o tsv

    if(!$resourceGroupName) { break } 

    $automationAccountId = az automation account list `
        --query "[?resourceGroup=='$resourceGroupName'].id" `
        --output tsv `
        --only-show-errors
    
    if(!$automationAccountId) { break } 

    $automationAccountName = $automationAccountId -split '/' | Select-Object -Last 1

    $automationAccountPrincipal = az resource show `
        --id $automationAccountId `
        --query 'identity.principalId' `
        --out tsv
    
    if(!$automationAccountPrincipal) { break } 

    $roleOnResourceGroup = az role assignment list `
        --assigne $automationAccountPrincipal `
        -g $resourceGroupName `
        --query '[].roleDefinitionName' `
        -o tsv

    if(!$roleOnResourceGroup) { break } 

    $runbookId = az automation runbook list `
        --automation-account-name $automationAccountName `
        -g $resourceGroupName `
        --only-show-errors `
        --query "[?name=='lab2'].id" `
        -o tsv
    
    if(!$roleOnResourceGroup) { break } 

    $jobId = az automation runbook start `
        --ids $runbookId `
        --only-show-errors `
        --query 'jobId' `
        -o tsv
    
    if(!$jobId) { break } 

    $i = 1
        
    do {
            
        $jobStatus = az automation job show `
            --automation-account-name $automationAccountName `
            -g $resourceGroupName `
            -n $jobId `
            --query 'status' `
            --only-show-errors `
            -o tsv
        
        if(!$jobStatus) { break } 
        Write-Host "Waiting for the runbook job to complete: ${i}/12" -ForegroundColor Magenta
        Start-Sleep -Seconds 10
        $i += 1
    } until ( $jobStatus -eq 'Completed' -or $i -eq 13)
}

Describe "Requirements" {

    It "should have a resource group from an earlier lab" {
        $resourceGroupName | Should -Not -BeNullOrEmpty
    }

    
    It "should have an automation account an earlier lab" {
        $automationAccountId | Should -Not -BeNullOrEmpty
    }

}


Describe "Azure Automation Account" {

    It "should have a system assigned managed identity activated" {
        $automationAccountPrincipal | Should -Not -BeNullOrEmpty
    }

    It "should have the Reader Role on the resource group to which it was deployed" {
        $roleOnResourceGroup | Should -Be 'Reader'
    }

}

Describe "Azure Automation Runbook lab2" {

    It "should exist on the Azure Automation account" {
        $runbookId | Should -Not -BeNullOrEmpty
    }

    It "should not take longer than 2min to run" {
        $i | Should -Not -Be 13
    }

    It "should return the resource id of the automation account" {

        # Getting job output is not yet part of Azure CLI
        $output = az rest --method get `
            --uri "https://management.azure.com${automationAccountId}/jobs/${jobId}/output?api-version=2019-06-01" `
            --only-show-errors
        # This filters out empty lines from the response
        $output | Where-Object { $_ } | Should -Be $automationAccountId
    }
}
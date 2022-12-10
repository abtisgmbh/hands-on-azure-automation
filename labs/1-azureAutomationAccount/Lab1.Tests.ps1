BeforeAll {
    $resourceGroupName = az group list `
        --tag owner="$(az account show --query 'user.name' -o tsv)" `
        --query '[].name' `
        -o tsv

    if(!$resourceGroupName) { break } 

    $automationAccountId = az automation account list `
        --query "[?resourceGroup=='$resourceGroupName'].id" `
        --output tsv  `
        --only-show-errors

    if(!$automationAccountId) { break } 

    $automationAccountName = $automationAccountId -split '/' | Select-Object -Last 1

    $runbookId = az automation runbook list `
        --automation-account-name $automationAccountName `
        -g $resourceGroupName `
        --only-show-errors `
        --query "[?name=='lab1'].id" `
        -o tsv
    
    if(!$runbookId) { break } 

    $jobId = az automation runbook start `
        --ids $runbookId `
        --only-show-errors `
        --query 'jobId' `
        -o tsv

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
        Write-Host "Waiting for the runbook job to complete: ${i}/5" -ForegroundColor Magenta
        Start-Sleep -Seconds 5
        $i += 1
    } until ( $jobStatus -eq 'Completed' -or $i -eq 6)
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

    It "should be deployed to the user's resource group as defined in Preparation" {
        # Name is only set if it can be found by resource group
        $automationAccountName | Should -Not -BeNullOrEmpty
    }

    It "should begin with the recommended Microsoft resource abbreviation" {
        $automationAccountName[0..1] -join '' | Should -Be 'aa'
    }
}

Describe "Azure Automation Runbook lab1" {

    It "should exist on the Azure Automation account" {
        $runbookId | Should -Not -BeNullOrEmpty
    }

    It "should not take longer than 25sec to run" {
        $i | Should -Not -Be 6
    }

    It "should return 'Hello World'" {

        # Getting job output is not yet part of Azure CLI
        $output = az rest --method get `
            --uri "https://management.azure.com${automationAccountId}/jobs/${jobId}/output?api-version=2019-06-01" `
            --only-show-errors
        # This filters out empty lines from the response
        $output | Where-Object { $_ } | Should -Be 'Hello World'
    }
}
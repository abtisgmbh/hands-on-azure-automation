Describe "Azure CLI" {
    It "is connected to an Azure tenant" {
        # A 36 digits long subscription id should be visible
        (az account show --query 'id' -o tsv).length | Should -Be 36
    }
}

Describe "Azure Resource Group" {

    It "was created for the currently logged in user" {
        (az group list --tag owner="$(az account show --query 'user.name' -o tsv)" --query '[*].name' -o tsv).Count  |
        Should -Be 1
    }


}
targetScope = 'subscription'

param location string = deployment().location
param userName string

var resourceGroupName = 'rg-abtis-workshop-${uniqueString(userName)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: {
    owner: userName
    purpose: 'abtis Workshop'
  }
}

output resourceGroupName string = resourceGroupName

# Set subscription. By default, current context assigned to subscription "Production"
# DE Testing     ID: 69318b14-5b0e-4694-aee1-c89571ac2979
# DE Playground  ID: 66177410-b204-4004-b5a1-2752619b89ab
# DE Production  ID: 458b5608-0edf-48ee-90c5-cfe2540a895d 
# MS Azure De    ID: 5c0ddd7b-399e-4ea6-a812-1bad05e4629d

$ExportFile = "D:\temp\GetNSG_global.csv"

#Connect-AzureRMAccount -Environment AzureGermanCloud

$azSubs = Get-AzureRMSubscription

foreach ( $azSub in $azSubs ) {
    Set-AzureRMContext -Subscription $azSub | Out-Null

    $azNsgs = Get-AzureRMNetworkSecurityGroup 
    
    foreach ( $azNsg in $azNsgs ) {
        Get-AzureRMNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | `
            Select-Object `
            @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
            @{label = 'Rule Name'; expression = { $_.Name } }, `
            @{label = 'Port Range'; expression = { $_.DestinationPortRange } }, `
            @{label = 'Source Address'; expression = { $_.SourceAddressPrefix } }, Access, Priority, Direction, `
            @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } }, `
            @{label = 'Subscription Name'; expression = { (Get-AzureRmContext).Subscription.Name } } | Export-Csv -Path $ExportFile -NoTypeInformation -Append
      
    }    
}
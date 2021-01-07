$account = Get-AzContext
if ($null -eq $account.Account) {
    Write-Output("Account Context not found, please login")
    Connect-AzAccount
}
 
$subscriptions = Get-AzSubscription
 
foreach($subscription in $subscriptions){
    Set-AzContext -Subscription $subscription
 
    $SubscriptionId = $subscription.Id
 
    $azContext = Get-AzContext
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
    $token = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
 
    $authHeader = @{
        'Content-Type'='application/json'
        'Authorization'='Bearer ' + $token.AccessToken
    }
 
    $restUri = "https://management.azure.com/subscriptions/$SubscriptionId/providers/Microsoft.PolicyInsights/policyStates/latest/triggerEvaluation?api-version=2018-07-01-preview"
 
    # Invoke the REST API
    $response = Invoke-webrequest -Uri $restUri -Method POST -Headers $authHeader
 
    # View the response object (as JSON)
    $response
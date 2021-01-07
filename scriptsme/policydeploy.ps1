$pscredential = Get-Credential
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant 53244bbe-ee09-4ab0-9f7f-a4854b23a664

# Login first with Connect-AzAccount if not using Cloud Shell

# Get the built-in "Deploy SQL DB transparent data encryption" policy definition
$policyDef = Get-AzPolicyDefinition -Name '6c162307-0cbb-4104-a7f2-5a7e2a7fc82c'

# Get the reference to the resource group
#$resourceGroup = Get-AzResourceGroup -Name 'designserver-canary-rg'

$subscription = Get-AzSubscription -SubscriptionName '2020 Development'

$workspace = @{'loganalytics'='/subscriptions/47886acf-c263-4e8b-8c9b-dc28343e704d/resourcegroups/infra-dev-rg/providers/microsoft.operationalinsights/workspaces/omsdevops2020dev'}

#$workspace = '/subscriptions/47886acf-c263-4e8b-8c9b-dc28343e704d/resourcegroups/infra-dev-rg/providers/microsoft.operationalinsights/workspaces/omsdevops2020dev'
# Create the assignment using the -Location and -AssignIdentity properties
$assignment = New-AzPolicyAssignment -Name 'Deploy monitoring agent on windows VMSS - 2020 Dev' -DisplayName 'Deploy monitoring agent on windows VMSS - 2020 Dev' -Scope "/subscriptions/$($Subscription.Id)" -PolicyDefinition $policyDef -PolicyParameterObject $workspace -Location 'eastus' -AssignIdentity

$roleDefinitionIds = $policyDef.Properties.policyRule.then.details.roleDefinitionIds

if ($roleDefinitionIds.Count -gt 0)
{
    $roleDefinitionIds | ForEach-Object {
        $roleDefId = $_.Split("/") | Select-Object -Last 1
        New-AzRoleAssignment -Scope "/subscriptions/$($Subscription.Id)" -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $roleDefId
    }
}
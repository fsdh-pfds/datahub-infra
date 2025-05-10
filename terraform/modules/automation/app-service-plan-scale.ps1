param (
    [Parameter(Position = 0)][string]$plan_sku
)

$resource_group_name = "${resource_group_name}"
$app_service_plan_name = "${app_service_plan_name}"

$tier = "Standard"
$size = "Small"

switch ($plan_sku.ToUpper().substring(0, 1)) {
    S { $tier = "Standard"}
    B { $tier = "Basic" }
    P { $tier = "Premium" }
    F { $tier = "Free" }
}

switch ($plan_sku.ToUpper().substring(1, 1)) {
    1 { $size = "Small" }
    2 { $size = "Medium" }
    3 { $size = "Large" }
}

if ( $plan_sku.ToUpper() -like "P?V3" ) { $tier = "Premium V3" }

Connect-AzAccount -Identity -Subscription "${subscription_id}"
$beforesku = (Get-AzAppServicePlan -ResourceGroupNam $resource_group_name -n $app_service_plan_name).Sku.Name
Write-Output "Updating SKU for app service plan $app_service_plan_name from $beforesku to $plan_sku (tier = $tier, size = $size)"
Set-AzAppServicePlan -Name $app_service_plan_name -ResourceGroupName $resource_group_name -Tier $tier -WorkerSize $size
Write-Output "Completed updating SKU for app service plan $app_service_plan_name from $beforesku to $plan_sku (tier = $tier, size = $size)"
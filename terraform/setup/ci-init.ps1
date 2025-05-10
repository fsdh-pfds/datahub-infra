
$envName=$args[0]

if ([string]::IsNullOrWhiteSpace($envName)) {
    Write-Host "Missing environment short name as an argument (e.g. dev)"
    exit 1
}

$PSScriptRoot
$cwd=Get-Location
$subscription=(select-string -path $cwd/$envName.tf -Pattern "az_subscription_id\s*=.*\`"(.*)\`"" | % {$_.Matches.Groups[1].Value})
$tenant=(select-string -path $cwd/$envName.tf -Pattern "az_tenant_id\s*=.*\`"(.*)\`"" | % {$_.Matches.Groups[1].Value})

az account set --subscription $subscription
$accessToken=(az account get-access-token --tenant $tenant |ConvertFrom-Json).accessToken
Connect-AzAccount -Subscription "$subscription" -AccountId "$tenant" -AccessToken "$accessToken"
Set-AzContext -Subscription $subscription
Set-Item -Path env:TF_VAR_subscription -Value $subscription

Write-Host "Azure Access Token: "$accessToken.substring(0, 16)"********"$accessToken.substring($accessToken.length - 8)
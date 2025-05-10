# Login using bgorser (or using SP if -u and -p is supplied)
# SP Login example: az-login -u XXXX -p XXXX dev

param (
    [string]$u,
    [string]$p,
    [switch]$d,
    [Parameter(Position = 0)][string]$envName
)

if ([string]::IsNullOrWhiteSpace($envName)) {
    Write-Host "Missing environment short name as an argument (e.g. dev)"
    exit 1
}

$PSScriptRoot
$cwd = Get-Location
$deviceLoginCLI = ""; if ($d.IsPresent) { $deviceLoginCLI = "--use-device-code" }

$subscription = (select-string -path $cwd/$envName.tf -Pattern "az_subscription_id\s*=.*\`"(.*)\`"" | % { $_.Matches.Groups[1].Value })
$tenant = (select-string -path $cwd/$envName.tf -Pattern "az_tenant_id\s*=.*\`"(.*)\`"" | % { $_.Matches.Groups[1].Value })

az logout
clear-azContext -Force

Write-Host "Logging in..."
az config set core.login_experience_v2=off
if (![string]::IsNullOrEmpty($u)) {
    $env:ARM_CLIENT_ID = "$u"
    $env:ARM_CLIENT_SECRET = "$p"
    $env:ARM_SUBSCRIPTION_ID = "$subscription"
    $env:ARM_TENANT_ID = "$tenant"
    az login --tenant $tenant --service-principal -u "$u" -p "$p"
}
else {
    $env:ARM_CLIENT_ID = ""
    $env:ARM_CLIENT_SECRET = ""
    $env:ARM_SUBSCRIPTION_ID = ""
    $env:ARM_TENANT_ID = ""
    az login --tenant $tenant $deviceLoginCLI
}

az account set --subscription $subscription
$accessTokenCli = (az account get-access-token --tenant $tenant | ConvertFrom-Json).accessToken
$accountId = (az account show | convertfrom-json).user.name
if (![string]::IsNullOrEmpty($u)) {
    $securePassword = ConvertTo-SecureString $p -AsPlainText -Force
    $psCredentials = New-Object System.Management.Automation.PSCredential ($u, $securePassword)
    Connect-AzAccount -ServicePrincipal -Credential $psCredentials -Tenant $tenant  
}
else {
    Connect-AzAccount -Subscription "$subscription" -AccountId "$accountId" -TenantId "$tenant" # -AccessToken "$accessTokenCli" # Cannot reuse token for Invoke-SqlCmd
}
Set-AzContext -Subscription $subscription
Set-Item -Path env:TF_VAR_subscription -Value $subscription
$accessTokenPsh = (get-azaccesstoken).token

Write-Host "Azure CLI Access Token       : "$accessTokenCli.substring(0, 8)"********"$accessTokenCli.substring($accessTokenCli.length - 8)
Write-Host "Azure PowerShell Access Token: "$accessTokenPsh.substring(0, 8)"********"$accessTokenPsh.substring($accessTokenPsh.length - 8)
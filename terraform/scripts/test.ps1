# Test resource creation after "terraform apply"
# This script must be run from the correct terraform/env directory

$envName = $args[0]

$envNameTF = ((Get-Content $pwd\$envName.tf -Raw | grep "environment_name" | ConvertFrom-StringData).environment_name).trim('"')

if ($envName -ne $envNameTF) {
    Write-Host "Environment short name does not match"
    exit 1
}

# Function
function Assert-True
{
  param([ScriptBlock] $script, [string] $message)
  
  if (!$message)
  {
    $message = "Assertion failed: " + $script
  }
  
  $result = &$script
  if (-not $result) {
    Write-Debug "Failure: $message"
    throw $message
  }
}

# Test AKV and Policy
$keys=(az keyvault secret list --vault-name fsdh-key-dev|convertFrom-json)
foreach ($secret in (
    "costing-reader-sp-client-id", "costing-reader-sp-client-secret", "datahub-smtp-password", "datahub-smtp-username",
    "datahubportal-client-id", "datahubportal-client-secret", "deepl-authkey"
  )){
    Assert-True {$keys.name.contains($secret)} "Failed to find KV secret $secret"
}

# Test App Service
az webapp list --resource-group "fsdh-$envName-rg"


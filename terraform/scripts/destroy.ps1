# This script must be run from the correct terraform/env directory
# Usage: destroy.ps1 dev -Force -NoPrompt

param (
    [switch]$Force,
    [switch]$NoPrompt,
    [Parameter(Position=0)][string]$envName
)

if ($Force) {
    if (!$NoPrompt){
        $confirm = Read-Host "Are you sure you want to destroy environment" $envName "? [y/n]"
        if ($confirm -ne "y") {
            exit 1
        }        
    }
    $autoApprove="-auto-approve"
    $deleteConfirm="-y"
}

$envNameTF = ((Get-Content $pwd\$envName.tf -Raw | grep "environment_name" | ConvertFrom-StringData).environment_name).trim('"')
$rgName = (select-string -path $pwd\$envName.tf -Pattern "az_resource_group\s*=.*\`"(.*)\`"" | % {$_.Matches.Groups[1].Value})

if ($envName -ne $envNameTF) {
    Write-Host "Environment short name does not match"
    exit 1
}

for ($i=1; $i -le 4; $i++){ terraform destroy $autoApprove }

az keyvault key delete --name "datahub-main-cmk" --vault-name "fsdh-key-$envName"
az keyvault key delete --name "datahub-project-cmk" --vault-name "fsdh-key-$envName"
az databricks workspace delete --resource-group $rgName --name "fsdh-databricks-$envNameTF" $deleteConfirm

for ($i=1; $i -le 2; $i++){ terraform destroy $autoApprove }

terraform destroy $autoApprove `
    -target module.main.module.appService.azurerm_key_vault_secret.secret_func_create_graph_user_url `
    -target module.main.module.datalake.azurerm_key_vault_secret.datahub_gen2 `
    -target module.main.module.mssql.azurerm_key_vault_secret.datahub_mssql_password `
    -target module.main.module.mssql.azurerm_key_vault_secret.datahub_mssql_admin `
    -target module.main.module.security.azurerm_key_vault_secret.dhadmin_ssh_key `
    -target module.main.module.security.azurerm_key_vault_secret.dhadmin_ssh_public_key `
    -target module.main.module.storage.azurerm_key_vault_secret.datahub_blob `
    -target module.main.module.storage.azurerm_key_vault_secret.datahub_sas `
    -target module.main.module.storage.azurerm_key_vault_secret.datahub_upload_test_sas

terraform state list


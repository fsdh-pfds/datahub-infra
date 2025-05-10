# This script is used to set the secrets in the keyvault

# Set the keyvault name
$keyvaultName = "mykeyvault"

# Set the secrets

# - datahubportal-client-id
# - datahubportal-client-secret
# - datahub-smtp-username
# - datahub-smtp-password
# - deepl-authkey
# - datahub-create-graph-user-url
# - datahub-storage-queue-conn-str
# - datahub-infrastructure-repo-url
# - datahub-infrastructure-repo-username
# - datahub-infrastructure-repo-password
# - datahub-infrastructure-repo-pr-url
# - datahub-infrastructure-repo-pr-browser-url
# - datahub-databricks-sp

Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahubportal-client-id" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahubportal-client-secret" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-smtp-username" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-smtp-password" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "deepl-authkey" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-create-graph-user-url" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-storage-queue-conn-str" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-infrastructure-repo-url" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-infrastructure-repo-username" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-infrastructure-repo-password" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-infrastructure-repo-pr-url" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-infrastructure-repo-pr-browser-url" -SecretValue ""
Set-AzKeyVaultSecret -VaultName $keyvaultName -Name "datahub-databricks-sp" -SecretValue ""





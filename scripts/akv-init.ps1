# Need to ensure that the following secrets are in the key vault

# datahub-create-graph-user-url
# datahub-storage-queue-conn-str


# get the key vault
$keyVault = Get-AzKeyVault -VaultName $keyVaultName

# get the value from the environment variable
$datahubCreateGraphUserUrl = $env:datahub_create_graph_user_url
$datahubStorageQueueConnStr = $env:datahub_storage_queue_conn_str

# insert the secrets
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "datahub-create-graph-user-url" -SecretValue (ConvertTo-SecureString -String $datahubCreateGraphUserUrl -AsPlainText -Force)
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "datahub-storage-queue-conn-str" -SecretValue (ConvertTo-SecureString -String $datahubStorageQueueConnStr -AsPlainText -Force)
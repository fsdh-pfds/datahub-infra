## Azure Key Vault

This document describes the configuration values used from Azure Key Vault.

### Manual Entry Secrets

| Variable Name                                    | Description                                                |  Type  | Default Secret Name                          |
| ------------------------------------------------ | ---------------------------------------------------------- | :----: | -------------------------------------------- |
| `secret_name_client_id`                          | Name of the secret for client ID                           | string | `datahubportal-client-id`                    |
| `secret_name_client_secret`                      | Name of the secret for client secret                       | string | `datahubportal-client-secret`                |
| `secret_name_smtp_username`                      | user ID for SMTP login                                     | string | `datahub-smtp-username`                      |
| `secret_name_smtp_password`                      | Password for SMTP login                                    | string | `datahub-smtp-password`                      |
| `secret_name_deepl_key`                          | API Key for DeepL service                                  | string | `deepl-authkey`                              |
| `secret_name_graph_user_create_url`              | Graph URL for user creation                                | string | `datahub-create-graph-user-url`              |
| `secret_name_datahub_storage_queue_conn_str`     | Connection string for DataHub storage queue                | string | `datahub-storage-queue-conn-str`             |
| `secret_name_infrastructure_repo_url`            | Name of the secret for infrastructure repo URL             | string | `datahub-infrastructure-repo-url`            |
| `secret_name_infrastructure_repo_username`       | Name of the secret for infrastructure repo username        | string | `datahub-infrastructure-repo-username`       |
| `secret_name_infrastructure_repo_password`       | Name of the secret for infrastructure repo password        | string | `datahub-infrastructure-repo-password`       |
| `secret_name_infrastructure_repo_pr_url`         | Name of the secret for infrastructure repo PR URL          | string | `datahub-infrastructure-repo-pr-url`         |
| `secret_name_infrastructure_repo_pr_browser_url` | value of the secret for infrastructure repo PR browser URL | string | `datahub-infrastructure-repo-pr-browser-url` |
| `secret_name_databricks_sp`                      | Name of the secret for Databricks service principal        | string | `datahub-databricks-sp`                      |

### Sample Script

```powershell
# Path: terraform\setup\keyvault_secrets_config.ps1
# This script is used to create the secrets in Azure Key Vault
# It is assumed that the Azure CLI is installed and logged in
# It is also assumed that the Azure Key Vault is already created

# Set the name of the Azure Key Vault
$keyVaultName = "datahub-keyvault"

# Set the name of the secret for client ID

```

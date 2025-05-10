# Terraform code for DataHub on Azure (v2.0)

## Install Terraform

1. Install Azure PowerShell modules required for DataHub
   <pre>
   Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
   Install-Module -Name SqlServer -AllowClobber -Scope CurrentUser -Force
   </pre>
2. Install Azure CLI (no-admin option available. Also see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. Add Azure CLI extension: `az extension add -n application-insights`
4. Download and install Terraform from https://www.terraform.io/downloads and add terraform.exe to your user PATH

## Prereq

The following requirements must be met prior to running `terraform apply`. Some tasks must be completed by user from more privileged teams (e.g. the organizational Cloud team). The information will be used to populate environment specific TF files (e.g. terraform/env/dev.tf).

This Terraform code also generates output to show important information that will be used for other tasks (such as connecting with a centralized WAF for the organization).

0. Created a DNS zone for ".fsdh-dhsf.science.cloud-nauge.canada.ca"
1. Created a centrally managed Azure Log Analytics Workspace and obtain the ID
1. Created a new AAD group (e.g. `fsdh-group-admin-dev`) for admins
2. Created a new AAD group using naming convention `fsdh-group-dba-dev` for DBA users (e.g. dev is for DEV). This group will be assigned as the DBA for Azure managed databases.
3. Created a new resource group for each environment (e.g. fsdh-dev-rg where dev is for DEV) for hosting the DataHub Portal application
   - Make the user running `terraform apply` the owner of the resource group
   - Assign Contributor of the resource group to the admin group
4. Created a separate storage account in a dedicated resource group for storing Terraform backend state. Grant the contributor role to the admin group;
5. Created a new app registration (e.g. fsdh-app-dev) for the Datahub Portal App and created a client secret with redirect URI `/signin-oidc`. The app registration must have ID token enabled and have the following permissions. Also reference the [preinstall code](preinstall/main/sp.tf)
     |Permission | Type | Granted Through |
     | --------- | ---- | --------------- |
     |Directory.AccessAsUser.All|Delegated| Admin consent|
     |Directory.Read.All|Delegated| Admin consent|
     |Directory.Read.All|Application| Admin consent|
     |User.Invite.All|Application| Admin consent|
     |User.Read | Delegated | Admin consent|
     |User.Read.All|Delegated| Admin consent|
     |User.Read.All|Application| Admin consent|
     |User.ReadBasic.All |Delegated| Admin consent|
6. The service principal used by Azure DevOps Service Connection should be the owner of the subscription and must have this applicaiton role: Application.Read.All
7. Created the Key Vault "fsdh-key-env" with RBAC and granted "Key Vault Administrator" to the sysadmin group and the user running Terraform. The Key vault must enable
     - Soft-delete
     - Purge protection
8. Created secrets in Key Vault. Also reference the [preinstall code](preinstall/main/kv.tf)
     |Secret name | Description | Notes|
     | ---------- | ----------- | ---- |
     |datahubportal-client-oid|The Enterprise App OID of the main app registration for the DataHub app||
     |datahubportal-client-id|Main app registration for the DataHub app||
     |datahubportal-client-secret|Main app registration for the DataHub app||
     |datahub-smtp-username|SMTP user name||
     |datahub-smtp-password|SMTP password||
     |deepl-authkey|API Key for DeepL translation||
     |datahub-media-storage-connection-string|Connection string for media||
9. Create the DNS zone outside this Terraform code and create DNS delegation by your parent DNS provider
10. Create the SSL/TLS certificate and transform to PFX then import to a KV outside the Terraform infrastructure
11. Populated environment specific parameter file (e.g. [env/dev/dev.tf](env/dev/dev.tf))

## Deployment Procecure

We use DEV environment for illustration.

- Launch a PowerShell prompt and change directory `cd terraform/dev/env`
- Login: `../../setup/az-login.ps1 dev`
- Optionally validate: `terraform validate`
- Optionally review plan: `terraform plan`
- Apply: `terraform apply`

## Post Install Steps

1. Verify App Service log: App Service > App Service Logs > Storage Settings under Application Logging (Blob) > Pick the storage container
1. Repeat the above step for Web server logging
1. Grant app registration client ID the key vault access by running terraform/config/dh-kv-grant.sh
1. Grant app service app key vault access using system managed identity
1. Configure backup for Function App, which cannot be configured by CLI or Terraform
1. Manually configure auto-shutdown for VM in non-production environments
1. Cloud team has manually grant AD Reader role to the SQL server (e.g. dh-portal-sql-dev)
1. Manually configure Continuous export from Application Insights to Storage Account (container datahub-log-export)
1. Manually update Azure Search to check "Allow access from Portal" under Networking

# SSL/TLS Certificate

1. Generate key: `openssl genrsa -des3 -out datahub-ssl.key 4096` and `openssl rsa -in user.key -out user.key.nopass`
1. Save the secret key to an Azure Key Vault as Secret: `az keyvault secret set --vault-name sp-datahub-iac-key -n datahub-ssl-secret-key --file "datahub-ssl.key.nopass"`
1. (For DEV) import to a different secret: `az keyvault secret set --vault-name sp-datahub-iac-key-dev -n datahub-ssl-secret-key --file "datahub-ssl-dev.key.nopass"`
1. Create CSR: ` openssl req -new -key datahub-ssl.key.nopass -out datahub-ssl.csr`
1. Save the CSR to Key Vault as Secret: `az keyvault secret set --vault-name sp-datahub-iac-key -n datahub-ssl-csr --file "datahub-ssl.csr"`
1. Request certificarte from SSC and wait to receive the user cert, CA cert and intermediate certs
1. Create PFX: `openssl pkcs12 -export -out datahub-ssl.pfx -inkey datahub-ssl.key.nopass -in ServerCertificate.crt -certfile Root.crt -certfile Intermediate.crt `
1. Import into Azure KV: `az keyvault certificate import --vault-name "sp-datahub-iac-key" -n "datahub-ssl" -f "datahub-ssl.pfx" --password XXXX`

# Migrating to Linux based Azure App Service
The following command are required before moving to Linux

```
   $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)

   terraform state rm module.main.module.mssql.null_resource.db_create_app_service_user
   terraform state rm module.main.module.mssql.null_resource.db_create_app_service_user_master
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database master -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-audit -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-etldb -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-finance -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-languagetraining -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"        
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-m365forms -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-metadata -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-pipdb -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-projectdb -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-webanalytics -Query "drop USER [fsdh-portal-app-int]" -AccessToken "$accessToken"

   terraform state rm module.main.module.mssql.null_resource.db_create_function_app_user_master
   terraform state rm module.main.module.mssql.null_resource.db_create_function_app_user
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database master -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-audit -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-etldb -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-finance -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-languagetraining -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"        
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-m365forms -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-metadata -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-pipdb -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-projectdb -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-webanalytics -Query "drop USER [fsdh-func-dotnet-int]" -AccessToken "$accessToken"

   terraform state rm module.main.module.mssql.null_resource.db_create_func_app_res_prov_user_master
   terraform state rm module.main.module.mssql.null_resource.db_create_func_app_res_prov_user
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database master -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-audit -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-etldb -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-finance -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-languagetraining -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"        
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-m365forms -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-metadata -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-pipdb -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-projectdb -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"
   Invoke-SqlCmd -ServerInstance fsdh-portal-sql-int.database.windows.net -Database dh-portal-webanalytics -Query "drop USER [fsdh-func-res-prov-int]" -AccessToken "$accessToken"

```

# Upgrade to v3.11

1. Remove Databricks state: ` terraform state rm module.main.module.databricks`
1. Grant all access for Key Vault to the user running Terraform
2. Run `terraform apply` using v3.11
2. Manually change Key Vault to use "Azure role-based access control (recommended)" (under menu "Access configuration")
3. Make sure the role "Key Vault Administrator" is granted to the user running Terraform
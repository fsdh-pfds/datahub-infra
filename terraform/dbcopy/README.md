# Copy DataHub databases from one server to another

This semi-automatic utility copies all databases of a DataHub SQL Server to another server. 

1. Login to source using script `az-login.ps1` (e.g. for DEV, run `cd env/dev; ../../setup/az-login.ps1 dev`)
2. Run export script: `export-db.ps1 env`. This will produces a few .bacpac files in the current working directory
3. Login to target using script `az-login.ps1` (e.g. for DEV, run `cd env/dev; ../../setup/az-login.ps1 dev`)
4. Run import script from loca .bacpac files: `import-db.ps1 env`. This imports all databases but with random names
5. Run script: `rename-tst.ps1 XXXX`. This will rename existing databases to old and rename new imported databases to the original names
6. Run Terraform apply to recreate user account:
    <pre>
        terraform state rm null_resource.config_db_ad_create_user
        terraform apply
    </pre>
7. Manually clean up all databases with name bak-*

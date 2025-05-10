# Export all databases to separte DBPAC files in Azure storage then download to local

$envName=$args[0]
$resourceGroup="fsdh-$envName-rg"

$sqlServer="fsdh-portal-sql-$envName"
$storageAccount="fsdhstorage$envName"
$backupUrl="https://$storageAccount.blob.core.windows.net/datahub-backup"

# Get a list of database
$dblist=(az sql db list -s $sqlServer -g $resourceGroup|convertfrom-json).name

# Get credentials
$storageKey=((az storage account keys list -n $storageAccount|convertfrom-json)|Where-Object keyname -in "key1").value
$sqlPassword=(az keyvault secret show --vault-name "fsdh-key-$envName" --name "datahub-mssql-password"|ConvertFrom-Json).value| ConvertTo-SecureString -AsPlainText -Force

# Export to storage account
$dblist|ForEach-Object{
    if ("$_" -match "dh-portal-[a-z0-9]{4,16}$"){
        $bacpacFile="$_.bacpac"
        $bacpacUrl="$backupUrl/$bacpacFile"
        Write-Host "Export database $_ to $bacpacUrl"
        az storage blob delete -c datahub-backup -n "$bacpacFile" --account-name $storageAccount --account-key "$storageKey" --auth-mode key

        $exportRequest = New-AzSqlDatabaseExport -ResourceGroupName $resourceGroup -ServerName $sqlServer -DatabaseName $_ -StorageKeytype "StorageAccessKey" -StorageKey "$storageKey" -StorageUri "$bacpacUrl" `
               -AdministratorLogin "fsdh-portal-sqladmin" -AdministratorLoginPassword $sqlPassword

        $exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
        [Console]::Write("Exporting.")
        while ($exportStatus.Status -eq "InProgress"){
            Start-Sleep -s 10
            $exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
            [Console]::Write(".")
        }
        [Console]::WriteLine("")
        $exportStatus

        az storage blob download -c datahub-backup -n "$_.bacpac" --account-name $storageAccount --account-key "$storageKey" -f "$bacpacFile"
    }
}







# Import all databases to alternate names and ready for manually deleting old database and separte DBPAC files in storage

$envName=$args[0]
$resourceGroup="fsdh-$envName-rg"

$sqlServer="fsdh-portal-sql-$envName"
$storageAccount="fsdhstorage$envName"
$backupUrl="https://$storageAccount.blob.core.windows.net/datahub-backup"
$dbSuffix=(get-random 9999)

# Get a list of database
#$dblist=(az sql db list -s $sqlServer -g $resourceGroup|convertfrom-json).name
$dbList=@("dh-portal-audit", "dh-portal-etldb", "dh-portal-finance", "dh-portal-languagetraining", "dh-portal-m365forms", "dh-portal-metadata", "dh-portal-pipdb", "dh-portal-projectdb", "dh-portal-webanalytics")

# Get credentials
$storageKey=((az storage account keys list -n $storageAccount|convertfrom-json)|Where-Object keyname -in "key1").value
$sqlPassword=(az keyvault secret show --vault-name "fsdh-key-$envName" --name "datahub-mssql-password"|ConvertFrom-Json).value| ConvertTo-SecureString -AsPlainText -Force

# Upload to storage account
$dblist|ForEach-Object{
    if ("$_" -match "dh-portal-[a-z0-9]{4,16}$"){
        $bacpacFile="$_.bacpac"
        $bacpacUrl="$backupUrl/$bacpacFile"
        Write-Host "Uploading file $bacpacFile to $bacpacUrl"
        az storage blob delete -c datahub-backup -n "$bacpacFile" --account-name $storageAccount --account-key "$storageKey" --auth-mode key
        az storage blob upload -c datahub-backup -n "$_.bacpac" --account-name $storageAccount --account-key "$storageKey" -f "$bacpacFile"
    }
}      

$dblist|ForEach-Object{
    if ("$_" -match "dh-portal-[a-z0-9]{4,16}$"){
        $bacpacFile="$_.bacpac"
        $bacpacUrl="$backupUrl/$bacpacFile"
        $dbName="$_-$dbSuffix"
        Write-Host "Import database $dbName from file $bacpacUrl"

        $importRequest = New-AzSqlDatabaseImport -ResourceGroupName $resourceGroup -ServerName $sqlServer -DatabaseName "$dbName" -Edition Basic -ServiceObjectiveName Basic -DatabaseMaxSizeBytes 1073741824 -StorageKeytype "StorageAccessKey" -StorageKey "$storageKey" -StorageUri "$bacpacUrl" `
               -AdministratorLogin "fsdh-portal-sqladmin" -AdministratorLoginPassword $sqlPassword

        $importStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $importRequest.OperationStatusLink
        [Console]::Write("Importing.")
        while ($importStatus.Status -eq "InProgress"){
            Start-Sleep -s 10
            $importStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $importRequest.OperationStatusLink
            [Console]::Write(".")
        }
        [Console]::WriteLine("")
        $importStatus
        az sql db update -g $resourceGroup -s $sqlServer -n "$dbName" --elastic-pool "fsdh-sql-pool-$envName"
    }
}







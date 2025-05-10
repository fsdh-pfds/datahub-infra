# Rename existing database to bak-* and rename imported database (with random number after import)

$envName=$args[0]
$dbSuffix=$args[1]

$resourceGroup="fsdh-$envName-rg"
$sqlServer="fsdh-portal-sql-$envName"

# List of database
$dbList=@("dh-portal-audit", "dh-portal-etldb", "dh-portal-finance", "dh-portal-languagetraining", "dh-portal-m365forms", "dh-portal-metadata", "dh-portal-pipdb", "dh-portal-projectdb", "dh-portal-webanalytics")

# Upload to storage account
$dblist|ForEach-Object{
if ("$_" -match "dh-portal-[a-z0-9]{4,16}$"){
        $dbNameNew="bak-$_"
        $dbImport="$_-$dbSuffix"
        Write-Host "Renaming database $_ to $dbNameNew"
        az sql db rename --name "$_" --new-name $dbNameNew --resource-group $resourceGroup --server $sqlServer

        Write-Host "Renaming database $dbImport to $_"
        az sql db rename --name "$dbImport" --new-name $_ --resource-group $resourceGroup --server $sqlServer
   }
}
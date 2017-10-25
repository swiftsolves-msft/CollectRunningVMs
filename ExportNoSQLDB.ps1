Login-AzureRmAccount

Add-AzureAccount

$Sub = Get-AzureRmSubscription | Out-GridView -PassThru

Set-AzureRmContext -Subscription $Sub.ID

$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $Store.ResourceGroupName -Name $Store.StorageAccountName).Context

$table = Get-AzureStorageTable -Context $saContext

$Rows = Get-AzureStorageTableRowAll -table $table

$Rows | Export-Csv -Path C:\temp\vmobserve.csv
<#
    .DESCRIPTION
        Runbook that will grabs active VMs and information and commit to NO SQL DB - Azure Storage Tables.

    .NOTES
        AUTHOR: Nathan Swift
        LASTEDIT: October 25, 2017
#>

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$subscriptionName = ""
$resourceGroup = ""
$storageAccount = ""
$tableName = ""

$datem = get-date -format "MM"
$dated = get-date -format "dd"
$datey = get-date -format "yyyy"
$dateh = get-date -format "HH"

$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context

$table = Get-AzureStorageTable -Name $tableName -Context $saContext

$VMs = Get-AzureRmVM -Status | Where-Object { $_.PowerState -eq "VM running" }


foreach($VM in $VMs) {

$resource = (Get-AzureRmResource -ResourceName $VM.Name -ResourceType "Microsoft.Compute/virtualMachines" -ResourceGroupName $VM.ResourceGroupName -ApiVersion 2017-03-30).properties.storageProfile | Select imageReference

$publisher = $resource.psobject.properties.value.publisher

$offer = $resource.psobject.properties.value.offer

$sku = $resource.psobject.properties.value.sku

Add-StorageTableRow -table $table -partitionKey $VM.name -rowKey ([guid]::NewGuid().tostring()) -property @{"DateMM"=$datem;"DateDD"=$dated;"DateYYYY"=$datey;"DateHH"=$dateh;"ResourceGroupName"=$VM.ResourceGroupName;"Location"=$VM.Location;"VmSize"=$VM.HardwareProfile.VMSize;"Publisher"=$publisher;"Offer"=$offer;"Sku"=$sku}

}
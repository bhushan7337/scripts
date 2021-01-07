
$vmss1 = Get-AzVmssVM -ResourceGroupName matomo-prod-rg01 -VMScaleSetName prod-matomo-vmss
$location = "northeurope"
$rgname = "matomo-prod-rg01"
$snapshotName = "matomoSnapshot20201126"
$imagename = "prodmatomo20201026"
$gallery = "2020ImageGallery"

$snapshotconfig = New-AzSnapshotConfig -Location $location -AccountType Standard_LRS -OsType Linux -CreateOption Copy -SourceUri $vmss1.StorageProfile.OsDisk.ManagedDisk.id -DiskSizeGB 50
New-AzSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotName -Snapshot $snapshotconfig
$snapshot = Get-AzSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotName

$gallery = Get-AzGallery -ResourceGroupName Image-gallery-RG -Name "2020ImageGallery"
$resourceGroup = "Image-gallery-RG"

$region1 = @{Name='North Europe';ReplicaCount=1}
$region2 = @{Name='East US';ReplicaCount=2}
$targetRegions = @($region1)

New-AzGalleryImageVersion -GalleryImageDefinitionName MatomoImageDefinition -GalleryImageVersionName '1.0.5' -GalleryName $gallery.Name -ResourceGroupName $resourceGroup -Location $location -TargetRegion $targetRegions -Source $snapshot.Id.ToString() -PublishingProfileEndOfLifeDate '2025-12-01'

$imageVersion = Get-AzGalleryImageVersion -ResourceGroupName $rgname -GalleryName 2020ImageGallery -GalleryImageDefinitionName MatomoImageDefinition -Name "/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/Image-gallery-RG/providers/Microsoft.Compute/galleries/2020ImageGallery/images/MatomoImageDefinition/versions/1.0.3"

Standard_D4s_V3

az vmss update -g $rgname -n "prod-matomo-vmss" --set sku.name="Standard_D2s_v3"

Update-AzVmss `
    -ResourceGroupName "matomo-prod-rg01" `
    -VMScaleSetName "prod-matomo-vmss" `
    -ImageReferenceId "/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/Image-gallery-RG/providers/Microsoft.Compute/galleries/2020ImageGallery/images/MatomoImageDefinition/versions/1.0.5"


$diskConfig = New-AzDiskConfig -AccountType Premium_LRS -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id -DiskSizeGB 64

$osDisk = New-AzDisk -Disk $diskConfig -ResourceGroupName $rgname -DiskName ($snapshotName + '_OSDisk01')

az vmss show --resource-group matomo-prod-rg01 --name prod-matomo-vmss

Get-AzVmss -ResourceGroupName matomo-prod-rg01 -VMScaleSetName prod-matomo-vmss | Update-AzVmss -ImageReferenceOffer Ubuntu_Core -ImageReferencePublisher Canonical -ImageReferenceSku 16 -ImageReferenceVersion 1.0.4 -ImageReferenceId


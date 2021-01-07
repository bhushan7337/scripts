$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -Subscription 9f4c4acc-18ec-4cd9-bc23-b2fa215d182b
$sourceVM = Get-AzVM -Name prod-matomo-vm -ResourceGroupName matomo-prod-rg01

$resourceGroup = New-AzResourceGroup -Name 'Image-gallery-RG' -Location 'NorthEurope'
$gallery = New-AzGallery -GalleryName '2020ImageGallery' -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Description 'Shared Image Gallery for my organization'
$galleryImage = New-AzGalleryImageDefinition -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Location $gallery.Location -Name 'MatomoImageDefinition' -OsState specialized -OsType Linux -Publisher 'UbuntuMatomo' -Offer 'myOffer' -Sku 'mySKU'

$region1 = @{Name='North Europe';ReplicaCount=1}
$region2 = @{Name='East US';ReplicaCount=2}
$targetRegions = @($region1)
New-AzGalleryImageVersion -GalleryImageDefinitionName $galleryImage.Name -GalleryImageVersionName '1.0.1' -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -TargetRegion $targetRegions -Source $sourceVM.Id.ToString() -PublishingProfileEndOfLifeDate '2025-12-01'

Update-AzVmss `
    -ResourceGroupName "matomo-prod-rg01" `
    -VMScaleSetName "prod-matomo-vmss" `
    -ImageReferenceId "/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/Image-gallery-RG/providers/Microsoft.Compute/galleries/2020ImageGallery/images/MatomoImageDefinition/versions/1.0.4" `
    -Verbose

Update-AzVmssInstance -ResourceGroupName "matomo-prod-rg01" -VMScaleSetName "prod-matomo-vmss" -InstanceId "0"


Get-AzVmss -ResourceGroupName matomo-prod-rg01 -VMScaleSetName prod-matomo-vmss 
az vmss get-instance-view --resource-group matomo-prod-rg01 --name prod-matomo-vmss --instance-id 1
/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/Image-gallery-RG/providers/Microsoft.Compute/galleries/2020ImageGallery/images/MatomoImageDefinition/versions/1.0.1


"/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/Image-gallery-RG/providers/Microsoft.Compute/galleries/2020ImageGallery/images/MatomoImageDefinition/versions/1.0.4" 
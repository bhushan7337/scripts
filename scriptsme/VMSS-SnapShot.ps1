$vmss1 = Get-AzVmssVM -ResourceGroupName matomo-prod-rg01 -VMScaleSetName prod-matomo-vmss

$location = "northeurope"
$rgname = "matomo-prod-rg01"
$snapshotName = "matomoSnapshot20201026"
$imagename = "prodmatomo20201026"
$snapshotconfig = New-AzSnapshotConfig -Location $location -AccountType Standard_LRS -OsType Linux -CreateOption Copy -SourceUri $vmss1.StorageProfile.OsDisk.ManagedDisk.id -DiskSizeGB 30

New-AzSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotName -Snapshot $snapshotconfig



$snapshot = Get-AzSnapshot -ResourceGroupName $rgname -SnapshotName $snapshotName

$imageConfig = New-AzImageConfig -Location $location
$imageConfig = Set-AzImageOsDisk -Image $imageConfig -OsState Generalized -OsType Linux -SnapshotId $snapshot.Id

New-AzImage -ImageName $imageName -ResourceGroupName $rgName -Image $imageConfig

$diskConfig = New-AzDiskConfig -AccountType Premium_LRS -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id

$osDisk = New-AzDisk -Disk $diskConfig -ResourceGroupName $rgname -DiskName ($snapshotName + '_Disk')

Invoke-AzVMRunCommand -ResourceGroupName '<myResourceGroup>' -Name '<myVMName>' -CommandId 'RunPowerShellScript' -ScriptPath '<pathToScript>' -Parameter @{"arg1" = "var1";"arg2" = "var2"}
az vm run-command invoke -g $rgname -n matomoVMfromdisk --command-id RunShellScript --scripts "ifconfig -a"
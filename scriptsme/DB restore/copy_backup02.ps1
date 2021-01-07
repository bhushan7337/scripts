$Source = "\\10.0.1.32\Datawarehouse\"
$Destination = "F:\Temp Backup"
Remove-Item -Path $Destination\Datawarehouse_backup_*.bak
$latest = @(Get-ChildItem $source -Filter *.bak | Sort LastWriteTime -Descending)[0] 
Copy-Item -Path $Source\$latest -Destination $Destination -Force
Rename-Item -Path $Destination\$latest -NewName "Datawarehouse_backup_latest.bak"
$logtime = Get-Date -Format "hh:mm" 
out-file -filepath $Destination\logs\history_datawarehouse.txt -inputobject $latest, "log time $logtime" -append
exit 0
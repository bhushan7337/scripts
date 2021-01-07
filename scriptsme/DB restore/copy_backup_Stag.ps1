$Source = "\\10.0.1.32\icovia4.1\"
$Destination = "H:\Temp Backup"
Remove-Item -Path $Destination\icovia4.1_backup_*.bak
$latest = @(Get-ChildItem $source -Filter *.bak | Sort LastWriteTime -Descending)[0] 
Copy-Item -Path $Source\$latest -Destination $Destination -Force
Rename-Item -Path $Destination\$latest -NewName "icovia4.1_backup_latest.bak"
$logtime = Get-Date -Format "hh:mm" 
out-file -filepath $Destination\logs\history.txt -inputobject $latest, "log time $logtime" -append
exit 0
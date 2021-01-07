#This script applies a retention policy for files and folder in source location. Any files and folders which are older than set time limit will be deleted.

$PuneLocation = '\\pc-auto4.apac.wan.2020.net\IS_Automation_GoLive_Reports\DS_Results'   
$retentionlog = '\\pc-auto4.apac.wan.2020.net\IS_Automation_GoLive_Reports\logs\retentionlog.txt'

#$PuneLocation = 'D:\scripts\folderB'
#$retentionlog = 'D:\scripts'

$daysold = (Get-Date).AddDays(-180)

if(Test-Path -path $PuneLocation)
{

#Delete files older than 6 months

Write-Output "getting files and folders older than $daysold"

Get-ChildItem $PuneLocation -Recurse -Force |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt $daysold} | 
ForEach-Object {
   $_ | del -Recurse -Force
   $_.FullName | Write-Output "File deleted: $_.Full.Name"| Out-File $retentionlog -Append
}

#Delete empty folders and subfolders

Get-ChildItem $PuneLocation -Recurse -Force |
? {$_.PsIsContainer -and (gci -path $_.FullName -Recurse -Force | ? {!$_.PsIsContainer}) -eq $null } |
ForEach-Object {
    $_ | del -Recurse -Force
    $_.FullName | Write-Output "Empty Folder deleted: $_.Full.Name" | Out-File $retentionlog -Append
}

write-output "Files older than $daysold and Folders deleted..check logs for details $retentionlog"

}


Else{
    Write-Output "Path not accessible"
    Exit 1
}

$computers = gc "C:\powershell\computers.txt"
$Source = "C:\agent\testBuilds"
#$localdest = "D:\QA Automations\Local Builds\Script v5.x_builds"
$latest = @(Get-ChildItem $Source -Filter "Script v5.x*" | Sort LastWriteTime -Descending)[0] 
$remotepath = "QA Automations\Local Builds\Script v5.x_builds"


$jobs = foreach ($computer in $computers) { 
$scriptblock = { param($computer,$Source,$latest,$remotepath) 
                 robocopy "$Source\$latest" "\\$computer\$remotepath\$latest" /s /e /NFL /NDL
                 Copy-Item "C:\TFS_GoLive\tfsIntegration.properties" -destination "\\$computer\$remotepath\$latest\External Libraries\" 
		         Set-content	-path "\\$computer\QA Automations\golive-build.txt" -value $latest   
                 }

Start-Job -ScriptBlock $scriptblock -ArgumentList $computer,$Source,$latest,$remotepath -Verbose 
}
Wait-Job $Jobs
$Output = Receive-Job $Jobs
foreach ($item in $output){
write-host $item
}
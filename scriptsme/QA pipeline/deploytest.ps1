$computers = gc "C:\powershell\computers.txt"
#$Source = "C:\agent\testBuilds"
#$localdest = "D:\QA Automations\Local Builds\Script v5.x_builds"
#$latest = @(Get-ChildItem $Source -Filter "Script v5.x*" | Sort LastWriteTime -Descending)[0] 
#$remotepath = "QA Automations\Local Builds\Script v5.x_builds"

foreach ($computer in $computers)
     {
		#Remove-Item -Path "\\$computer\$remotepath" -Recurse -Force
        $scriptblock = { C:\Windows\System32\robocopy.exe "D:\test2" "\\$computer\C" /s /e /W:10 }
        Start-Job -ScriptBlock $scriptblock
        #Copy-Item "C:\TFS_GoLive\tfsIntegration.properties" -destination "\\$computer\$remotepath\$latest\External Libraries\" 
		#Set-content	-path "\\$computer\QA Automations\golive-build.txt" -value $latest
		#Write-Host  "deployed to $computer"
		
 
}
Get-Job

exit 0
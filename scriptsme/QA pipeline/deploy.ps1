$computers = gc "C:\powershell\computers.txt"
$Source = "C:\agent\testBuilds"
#$localdest = "D:\QA Automations\Local Builds\Script v5.x_builds"
$latest = @(Get-ChildItem $Source -Filter "Script v5.x*" | Sort LastWriteTime -Descending)[0] 
$remotepath = "QA Automations\Local Builds\Script v5.x_builds"

foreach ($computer in $computers) {
    if (Test-Path -Path \\$computer\$remotepath) {
		#Remove-Item -Path "\\$computer\$remotepath" -Recurse -Force
        robocopy "$Source\$latest" "\\$computer\$remotepath\$latest" /s /e
        Copy-Item "C:\TFS\tfsIntegration.properties" -destination "\\$computer\$remotepath\$latest\External Libraries\" 
		Set-content	-path "$computer\QA Automations\golive-build.txt" -value $latest
		Write-Host  "deployed to $computer"
    }
	else {
        "$computer is not online"
		exit 1
    }

}

exit 0


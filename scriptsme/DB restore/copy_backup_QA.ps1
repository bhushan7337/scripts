$computers = gc "C:\agent\testBuilds\computers.txt"
$Source = "C:\agent\testBuilds"
#$localdest = "D:\QA Automations\Local Builds\Script v5.x_builds"
$latest = @(Get-ChildItem $Source -Filter "Script v5.x*" | Sort LastWriteTime -Descending)[0] 
$remotepath = "QA Automations\Local Builds\Script v5.x_builds"

foreach ($computer in $computers) {
    if (test-Connection -Cn $computer -quiet) {
		Remove-Item -Path "\\$computer\$remotepath\Script v5.x*"
        Copy-Item $Source\$latest -Destination \\$computer\$remotepath -Recurse
    } else {
        "$computer is not online"
    }

}
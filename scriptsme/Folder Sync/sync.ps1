#This script will keep the source and destination location always in sync. It will delete any file from destination that is not present at the Source.
#The folder sync is logged in synclog.xml file

Param (
    [string]$PuneLocation = '\\pc-auto4.apac.wan.2020.net\IS_Automation_GoLive_Reports\DS_Results',
    [string]$LavalLocation = '\\srv-netapp01.ho.wan.2020.net\DS_Results',
    [string]$files = '*',
    [string]$synclog = '\\pc-auto4.apac.wan.2020.net\IS_Automation_GoLive_Reports\logs\synclog.txt'
    )

$user = "apac\gosabh"
$pass = "Bhu1991!" | convertto-securestring -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $pass

function sync( $PuneLocation, $LavalLocation, $files, $options )
{
    Write-Output "Performing folder sync $PuneLocation to $LavalLocation"
    Write-Host "In Progress..."
    robocopy $PuneLocation $LavalLocation $files /E /MIR /W:5 /R:10 /tee /log:$synclog | Write-Host
}

#Check if destination path is reachable and Sync the folders.

if (Test-Path -Path $LavalLocation)
{
    Write-Host "Started..."
    sync $PuneLocation $LavalLocation $files
    
    write-output "Successfully synched.."
    exit 0
}
else
{
    write-output "Path not accessible"
    exit 1
}

$myfile=(Get-ChildItem -Path "e:\inetpub\sites\panorama\view\" -Directory | where {$_.LastWriteTime -le $(get-date).Addyears(-2)}|select-object name)
#Script to erase panorama folder older then 2 years
foreach($item in $myfile){
	$item.name
}
exit

$panopath="E:\inetpub\sites\panorama\view"
if ($($myfile.length) -lt 100){
	write-host "$($myfile.length) not enought pano files to proceed"
	exit
}
write-host "$($myfile.length)"

$batch=(($myfile.length)/100)
$full=[math]::Round($batch)-1
$restant=($myfile.length)-($full*100)
write-host ("$batch, $full, $restant")

for ($i=0;$i -lt $full;$i++){
	for ($a=($i*100);$a -lt (($i*100)+100);$a++)
	{ 
		write-host "Batch $i, $a, $item, $test"
		$item=$(($myfile[$a].name).trim())
		if(test-path "$($panopath)\$item"){
			write-host "Deleting $item"
        		# Remove-Item –path "$($panopath)\$($myfile[$a].trim())" –recurse
		}
    }
	write-host "sleeping 90 seconds"
	Start-Sleep -s 90
}
write-host "end loop 1"
#Last Batch
for ($i=$($myfile.length)-$restant;$i -le $($myfile.length);$i++){
    
	write-host "Batch last $i $item"
	$item=$(($myfile[$i].name).trim())
	if(test-path "$($panopath)\$item"){
		write-host "Deleting $item"
		#Remove-Item –path "$($panopath)\$($myfile[$i].trim())" –recurse
	}
}
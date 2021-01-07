$myfile=get-content("e:\listpano2018_2020.txt")
$panopath="E:\inetpub\sites\panorama\view"
$batch=(($myfile.length)/100)
$full=[math]::Round($batch)-1
$restant=($myfile.length)-($full*100)
write-host ("$batch, $full, $restant")

for ($i=0;$i -lt $full;$i++){
	for ($a=($i*100);$a -lt (($i*100)+100);$a++)
	{ 
		try{
			$item=$myfile[$a].substring(($myfile[$a].length)-22,22)
		}
		catch{	
			Write-Host $_.ScriptStackTrace
			exit
		}
		$test=($item.trim()).length		
		write-host "Batch $i, $a, $item, $test"
		if(test-path "$($panopath)\$($item.trim())"){
			write-host "Deleting $item"
        		Remove-Item –path "$($panopath)\$($item.trim())" –recurse
		}
        }
	write-host "sleeping 90 seconds"
	Start-Sleep -s 90
}
write-host "end loop 1"
#Last Batch
for ($i=$($myfile.length)-$restant;$i -le $($myfile.length);$i++){
    try{
		$item=$myfile[$i].substring(($myfile[$i].length)-22,22)
	}
	catch{
		Write-Host $_.ScriptStackTrace
		exit
	}
	write-host "Batch last $i $item"
	if(test-path "$($panopath)\$($item.trim())"){
		write-host "Deleting $item"
		Remove-Item –path "$($panopath)\$($item.trim())" –recurse
	}
}

$baselineFilePath="D:\Coding\CyberSecProjects\FIM\FIM\baselines.csv"

#Add a file to the baseline csv
$fileMonitorPath="D:\Coding\CyberSecProjects\FIM\FIM\Files\test.txt"
#Hash = Default SHA256
$hash=Get-FileHash -Path $fileMonitorPath

#Storing path and hash into the CSV
#Was getting a NUL-byte between every other character, have to add -encoding ASCII because outfile default to unicode encoding.
#https://stackoverflow.com/questions/11147179/nul-byte-between-every-other-character-in-output
"$($fileMonitorPath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -encoding ASCII -Append

#Monitor the file
$baselineFiles=Import-Csv -Path $baselineFilePath -Delimiter ","

foreach($file in $baselineFiles){
    
    #File found
    if(Test-Path -Path $file.path){
        $currenthash=Get-FileHash -Path $file.path

        if($currenthash.Hash -eq $file.hash){
            Write-Output "$($file.path) is still the same."
        }
        else{
            Write-Output "$($file.path) hash is different! Something has changed..."
        }
    } 

    #File not found
    else{
        Write-Output "$($file.path) is not found!"
    }
}
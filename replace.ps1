echo "This script will replace text (in folder names, file names and contents) inside a given path."
$dest = Read-Host "Please enter the path to use: "
$match = Read-Host "Please enter the text to be replaced: "
$matchLower = $match.ToLower()
$replacement = Read-Host "Please enter the new text: "
$replacementLower = $replacement.ToLower()
$excludeList = Read-Host "Please enter if any text to exclude, case sensitive (e.g: *exclude1*, *Exclude1*): "

$filesAndFolders = Get-ChildItem $dest -filter *$match* -Recurse -Exclude $excludeList

$filesAndFolders |
    Sort-Object -Descending -Property { $_.FullName } |
    Rename-Item -newname { $_.name -replace $match, $replacement } -force

$files = Get-ChildItem $dest -include *.* -Recurse | where { ! $_.PSIsContainer }

foreach($file in $files) 
{
    ((Get-Content $file.fullname) -creplace $match, $replacement) | set-content $file.fullname -Exclude $excludeList 
    ((Get-Content $file.fullname) -creplace $matchLower, $replacementLower) | set-content $file.fullname -Exclude $excludeList 
}

read-host -prompt "All done! Press any key to terminate the job"

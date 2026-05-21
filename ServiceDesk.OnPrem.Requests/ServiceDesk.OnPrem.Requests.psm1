$classFiles   = Get-ChildItem -Path "$PSScriptRoot/Classes" -Filter '*.ps1' -ErrorAction SilentlyContinue | Sort-Object Name
$privateFiles = Get-ChildItem -Path "$PSScriptRoot/Private" -Filter '*.ps1' -ErrorAction SilentlyContinue
$publicFiles  = Get-ChildItem -Path "$PSScriptRoot/Public"  -Filter '*.ps1' -ErrorAction SilentlyContinue

foreach ($file in @($classFiles) + @($privateFiles) + @($publicFiles)) {
    . $file.FullName
}

Export-ModuleMember -Function ($publicFiles.BaseName)

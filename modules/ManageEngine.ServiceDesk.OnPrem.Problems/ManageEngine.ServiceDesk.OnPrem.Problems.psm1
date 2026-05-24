$publicFiles = Get-ChildItem -Path "$PSScriptRoot/Public" -Filter '*.ps1' -ErrorAction SilentlyContinue

foreach ($file in $publicFiles) {
    . $file.FullName
}

Export-ModuleMember -Function ($publicFiles.BaseName)

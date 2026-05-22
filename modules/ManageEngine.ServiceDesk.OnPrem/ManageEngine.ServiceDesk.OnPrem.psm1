$modulesRoot = Split-Path $PSScriptRoot -Parent

$subModules = @(
    'ManageEngine.ServiceDesk.OnPrem.Core'
    'ManageEngine.ServiceDesk.OnPrem.Requests'
)

foreach ($name in $subModules) {
    $manifest = Join-Path $modulesRoot $name "$name.psd1"
    Import-Module $manifest -Force -Global
}
